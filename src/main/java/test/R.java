package test;

import java.util.HashMap;

/**
 * 返回数据封装
 */
public class R extends HashMap<String, Object> {

	public R() {
		put("code", 200);
		put("msg", "操作成功");
	}

	public static R error() {
		return error(500, "操作失败");
	}

	public static R error(String msg) {
		return error(500, msg);
	}

	public static R error(int code, String msg) {
		R r = new R();
		r.put("code", code);
		r.put("msg", msg);
		return r;
	}

	public static R ok(Object msg) {
		R r = new R();
		r.put("msg", msg);
		return r;
	}

	public static R ok() {
		return new R();
	}

	@Override
	public R put(String key, Object value) {
		super.put(key, value);
		return this;
	}
}
