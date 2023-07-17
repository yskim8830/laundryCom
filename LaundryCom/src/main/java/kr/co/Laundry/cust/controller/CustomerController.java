package kr.co.Laundry.cust.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.Laundry.cust.service.CustomerService;
import kr.co.Laundry.data.dto.CustomerDto;

@Controller
@RequestMapping("/customer/")
public class CustomerController {

	@Autowired
	CustomerService customerService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	/**
	 * 고객 조회
	 */
	@RequestMapping("custList.do")
	@ResponseBody
	public Map<String, Object> custList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".custList");
		logger.info("   - paramMap : " + paramMap);
		
		List<CustomerDto> listModel = customerService.getCust(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("listModel", listModel);
		
		logger.info("+ End " + className + ".custList");

		return resultMap;
	}
	
	/**
	 * 고객 추가 및 수정
	 */
	@RequestMapping("setCust.do")
	@ResponseBody
	public Map<String, Object> setCust(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".custList");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "저장 되었습니다.";
		int ret = 0;
		try {
			ret = customerService.setCust(paramMap);
			if(ret == -99) {
				result = "FALSE";
				resultMsg = "이미 등록되어있는 사용자 입니다.";
			}
		} catch (Exception e) {
			result = "FALSE";
			resultMsg = "입력값을 확인해 주세요.";
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".custList");

		return resultMap;
	}
	
}