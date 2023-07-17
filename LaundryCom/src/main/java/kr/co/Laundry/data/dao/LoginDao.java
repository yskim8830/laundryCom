package kr.co.Laundry.data.dao;

import java.util.Map;

import kr.co.Laundry.data.dto.LoginDto;

public interface LoginDao {
	
	/** 사용자 로그인 체크*/
	public String checkLogin(Map<String, Object> paramMap);
	
	/** 사용자 로그인 */
	public LoginDto selectLogin(Map<String, Object> paramMap);

}
