package kr.co.Laundry.login.service;

import java.util.Map;

import javax.servlet.http.HttpSession;

public interface LoginService {
	/** 사용자 로그인 */
	public Map<String, String> loginProc(Map<String, Object> paramMap, HttpSession session) throws Exception;
}
