package test;

import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * @author heyi
 * @version V1.0
 * @ClassName CpuInfo
 * @Description
 * @date 2023/5/9 12:48
 */
@Controller
public class CpuInfoController {

    @Value("${cpuInfo.s-tui.json}")
    String sTuiJson;

    @RequestMapping("/getInfo")
    @ResponseBody
    public Object cpuInfo() {
        String errorMsg = "";
        String[] cmdStrings = new String[] {"sh", "-c", sTuiJson};
        Process p = null;
        try {
            p = Runtime.getRuntime().exec(cmdStrings);
            int status = p.waitFor();
            if (status != 0) {
                return R.error(String.format("runShellCommand: %s, status: %s", sTuiJson, status));
            }
            BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
            StringBuffer sbf = new StringBuffer();
            String line;
            while ((line = reader.readLine()) != null) {
                sbf.append(line);
            }
            JSONObject obj = JSONObject.parseObject(sbf.toString());
            return R.ok().put("data", obj);
        } catch (Exception e) {
            errorMsg = e.getMessage();
        } finally {
            if (p != null) {
                p.destroy();
            }
        }
        return R.error(errorMsg);
    }
}
