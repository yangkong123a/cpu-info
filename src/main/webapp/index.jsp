<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String path=request.getContextPath(); %>
<!DOCTYPE html>
<html lang="zh-CN" style="height: 100%">
<head>
    <meta charset="utf-8">
    <script type="text/javascript" src="<%=path%>/static/jquery.min.js"></script>
    <script type="text/javascript" src="<%=path%>/static/echarts.min.js"></script>
    <style>
        #json span { display: block;font-size: 2rem;word-break: break-all; }
    </style>
</head>
<body style="height: 100%; margin: 0">
<div id="Frequency_container" style="height: 600px;"></div>
<div id="Temp_container" style="height: 600px;"></div>
<%--<div id="Util_container" style="height: 600px;"></div>--%>
<div id="json">
    <span id="Frequency"></span><br><br>
    <span id="Temp"></span><br><br>
    <span id="Util"></span>
</div>
<script type="text/javascript">
    var FrequencyChart, TempChart, UtilChart;
    var FrequencyOption = getDefaultConfig(3, '频率：GHz');
    var TempOption = getDefaultConfig(100, '温度：°C');
    var UtilOption = getDefaultConfig(100, '使用率：%');

    $(function () {
        FrequencyChart = echarts.init(document.getElementById('Frequency_container'), null, {
            renderer: 'canvas',
            useDirtyRect: false
        });
        TempChart = echarts.init(document.getElementById('Temp_container'), null, {
            renderer: 'canvas',
            useDirtyRect: false
        });
        /*UtilChart = echarts.init(document.getElementById('Util_container'), null, {
            renderer: 'canvas',
            useDirtyRect: false
        });*/
        window.addEventListener('resize', FrequencyChart.resize);
        window.addEventListener('resize', TempChart.resize);
        getInfo();
        setInterval(function(){
            getInfo();
        }, 3000);
    });

    function getInfo() {
        $.ajax({
            cache: false,
            type: 'POST',
            url: '<%=path%>/getInfo?t_='+new Date().getTime(),
            success: function(res){
                console.log(res)
                var data = res.data;
                $('#Frequency').text(JSON.stringify(data.Frequency));
                $('#Temp').text(JSON.stringify(data.Temp));
                $('#Util').text(JSON.stringify(data.Util));

                setConfigData(data.Frequency, FrequencyChart, FrequencyOption, 1000);
                setConfigData(data.Temp, TempChart, TempOption);
                //setConfigData(data.Util, UtilChart, UtilOption);
            },
            error: function (data) {
                alert("请求异常！");
            }
        });
    }

    function setConfigData(data, chat, option, num) {
        var temp_xAxis=[], temp_data=[];
        for (let item of Object.keys(data)) {
            temp_xAxis.push(item);
            if (typeof num === 'number') {
                temp_data.push((data[item]/num).toFixed(1));
            }else {
                temp_data.push(data[item]);
            }
        }
        option.xAxis.data = temp_xAxis;
        option.series[0].data = temp_data;
        chat.setOption(option);
    }

    function getDefaultConfig(yMax, text) {
        var config = {
            title: {
                text: text,
            },
            xAxis: {
                type: 'category',
                data: [],
                axisLabel: {
                    fontSize: '1.5rem',
                },
            },
            yAxis: {
                type: 'value',
                max: yMax, // 坐标轴刻度最大值
                axisLabel: {
                    fontSize: '1rem',
                },
            },
            series: [
                {
                    data: [],
                    type: 'bar',
                    showBackground: true,
                    backgroundStyle: {
                        color: 'rgba(180, 180, 180, 0.2)'
                    },
                    itemStyle: {
                        normal: {
                            label: {
                                show: true, //开启显示数值
                                position: 'top', //数值在上方显示
                                textStyle: {  //数值样式
                                    color: 'black',   //字体颜色
                                    fontSize: '2rem'  //字体大小
                                }
                            }
                        }
                    }
                }
            ]
        };
        return config;
    }
</script>
</body>
</html>
