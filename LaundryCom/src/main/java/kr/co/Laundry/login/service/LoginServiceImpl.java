package kr.co.Laundry.login.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.Laundry.common.comnUtils.AESCryptoHelper;
import kr.co.Laundry.common.comnUtils.ComnUtil;
import kr.co.Laundry.data.dao.LoginDao;
import kr.co.Laundry.data.dto.LoginDto;

@Service
public class LoginServiceImpl implements LoginService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	@Autowired
	private LoginDao loginDao;
	
	/** 사용자 로그인 */
	public Map<String, String> loginProc(Map<String, Object> paramMap, HttpSession session) throws Exception {

		Map<String, String> resultMap = new HashMap<String, String>();

		String result;
		String resultMsg;
		
		String password = paramMap.get("pwd").toString();
		//AES 방식 암호화
		password = AESCryptoHelper.encode( ComnUtil.AES_KEY, password);
		paramMap.put("pwd", password);
		
		LoginDto lgnInfoModel = loginDao.selectLogin(paramMap);
		
		if (lgnInfoModel != null) {
			
			result = "SUCCESS";
			resultMsg = "사용자 로그인 정보가 일치 합니다.";
			session.setAttribute("seq",lgnInfoModel.getSeq());			// 시퀀스
			session.setAttribute("id",lgnInfoModel.getId());			// ID
			session.setAttribute("name",lgnInfoModel.getName());		// 이름
			session.setAttribute("grpId",lgnInfoModel.getGrp_id());		// 그룹ID
			
		} else {
			result = "FALSE";
			resultMsg = "사용자 로그인 정보가 일치하지 않습니다.";
		}
		

		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		
		return resultMap;
	}
}
