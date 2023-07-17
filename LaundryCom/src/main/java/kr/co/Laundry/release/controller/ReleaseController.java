package kr.co.Laundry.release.controller;

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

import kr.co.Laundry.data.dto.DeadlineDto;
import kr.co.Laundry.data.dto.StockDto;
import kr.co.Laundry.release.service.ReleaseService;

@Controller
@RequestMapping("/release")
public class ReleaseController {
	
	@Autowired
	ReleaseService releaseService;
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	/**
	 * 출고
	 * 
	 * @param	Model result - Spring model object
	 * @param	Map paramMap - Request Param object
	 * @param	HttpServletRequest request - Servlet request object
	 * @param	HttpServletResponse response - Servlet response object
	 * @param	HttpSession session - Http session Object
	 * @return	String - page navigator
	 * @throws Exception
	 */
	@RequestMapping("release.do")
	public String index(Model result, @RequestParam Map<String, String> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start ReleaseController.login.do");
		logger.info("+ End ReleaseController.login.do");

		return "/release/release";
	}
	
	/**
	 * 입고조회
	 */
	@RequestMapping("stockList.do")
	@ResponseBody
	public Map<String, Object> stockList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".stockList");
		logger.info("   - paramMap : " + paramMap);
		Map<String, Object> result = new HashMap<String, Object>();
		List<StockDto> listModel = releaseService.getStock(paramMap);
		List<DeadlineDto> listModelCount = releaseService.getStockCnt(paramMap);
		result.put("listModel", listModel);
		result.put("listModelCount", listModelCount);
		
		logger.info("+ End " + className + ".stockList");

		return result;
	}
	
	/**
	 * 출고 처리
	 */
	@RequestMapping("setRelStock.do")
	@ResponseBody
	public Map<String, Object> setRelStock(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".setRelStock");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "출고 되었습니다.";
		try {
			releaseService.modifyStock(paramMap);			
		} catch (Exception e) {
			result = "FALSE";
			resultMsg = "알수 없는 요청 입니다.";
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".setRelStock");

		return resultMap;
	}
}
