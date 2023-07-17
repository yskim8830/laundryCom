package kr.co.Laundry.warehousing.controller;

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

import kr.co.Laundry.data.dto.ProductGroupDto;
import kr.co.Laundry.warehousing.service.WarehousingService;

@Controller
@RequestMapping("/warehousing/")
public class WarehousingController {

	@Autowired
	WarehousingService warehousingService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	/**
	 * 입고 화면
	 * 
	 * @param	Model result - Spring model object
	 * @param	Map paramMap - Request Param object
	 * @param	HttpServletRequest request - Servlet request object
	 * @param	HttpServletResponse response - Servlet response object
	 * @param	HttpSession session - Http session Object
	 * @return	String - page navigator
	 * @throws Exception
	 */
	@RequestMapping("warehousing.do")
	public String index(Model result, @RequestParam Map<String, String> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start WarehousingController.login.do");
		logger.info("+ End WarehousingController.login.do");

		return "/warehousing/warehousing";
	}
	
	/**
	 * 품목 조회
	 */
	@RequestMapping("prodList.do")
	@ResponseBody
	public Map<String, Object> prodList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".prodList");
		logger.info("   - paramMap : " + paramMap);
		
		List<ProductGroupDto> listGrpModel = warehousingService.getGrpProd(paramMap);
		//List<ProductDto> listModel = warehousingService.getProd(paramMap);
		Map<String, Object> listModel = warehousingService.getAllProd(paramMap);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("listGrpModel", listGrpModel);
		resultMap.put("listModel", listModel);
		
		logger.info("+ End " + className + ".prodList");
 
		return resultMap;
	}
	
	/**
	 * 입고 처리
	 */
	@RequestMapping("setStock.do")
	@ResponseBody
	public Map<String, Object> setStock(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".setStock");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "저장 되었습니다.";
		try {
			warehousingService.setStock(paramMap);			
		} catch (Exception e) {
			result = "FALSE";
			resultMsg = "알수 없는 요청 입니다.";
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".setStock");

		return resultMap;
	}
	
	/**
	 * 신규 품목저장
	 */
	@RequestMapping("setProd.do")
	@ResponseBody
	public Map<String, Object> setProd(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".setProd");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "저장 되었습니다.";
		try {
			warehousingService.setProd(paramMap);			
		} catch (Exception e) {
			result = "FALSE";
			resultMsg = "알수 없는 요청 입니다.";
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".setProd");

		return resultMap;
	}
}