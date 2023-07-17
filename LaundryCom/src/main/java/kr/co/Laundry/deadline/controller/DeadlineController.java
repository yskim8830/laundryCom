package kr.co.Laundry.deadline.controller;

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
import kr.co.Laundry.data.dto.RelCntDto;
import kr.co.Laundry.data.dto.RelListDto;
import kr.co.Laundry.data.dto.SalesDto;
import kr.co.Laundry.data.dto.StockDto;
import kr.co.Laundry.data.dto.WereCntDto;
import kr.co.Laundry.data.dto.WereListDto;
import kr.co.Laundry.deadline.service.DeadlineService;

@Controller
@RequestMapping("/deadline")
public class DeadlineController {

	@Autowired
	DeadlineService deadlineService;
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	/**
	 * 관리
	 * 
	 * @param	Model result - Spring model object
	 * @param	Map paramMap - Request Param object
	 * @param	HttpServletRequest request - Servlet request object
	 * @param	HttpServletResponse response - Servlet response object
	 * @param	HttpSession session - Http session Object
	 * @return	String - page navigator
	 * @throws Exception
	 */
	@RequestMapping("deadline.do")
	public String index(Model result, @RequestParam Map<String, String> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start DeadlineController.login.do");
		logger.info("+ End DeadlineController.login.do");

		return "/deadline/deadline";
	}
	
	
	/**
	 * 입고 수정
	 */
	@RequestMapping("setStock.do")
	@ResponseBody
	public Map<String, Object> setStock(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".setStock");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "수정 되었습니다.";
		try {
			deadlineService.modifyStock(paramMap);			
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
	 * 입고 삭제
	 */
	@RequestMapping("delStock.do")
	@ResponseBody
	public Map<String, Object> delStock(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".delStock");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "SUCCESS";
		String resultMsg = "삭제 되었습니다.";
		try {
			deadlineService.deleteStock(paramMap);			
		} catch (Exception e) {
			result = "FALSE";
			resultMsg = "알수 없는 요청 입니다.";
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		logger.info("+ End " + className + ".delStock");

		return resultMap;
	}
	
	/**
	 * 정산- 통계
	 */
	@RequestMapping("statList.do")
	@ResponseBody
	public Map<String, Object> statList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".statList");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> result = new HashMap<String, Object>();
		List<WereCntDto> wereCnt = deadlineService.getWereCnt(paramMap);
		List<WereListDto> wereList = deadlineService.getWereList(paramMap);
		List<RelCntDto> relCnt = deadlineService.getRelCnt(paramMap);
		List<RelListDto> relList = deadlineService.getRelList(paramMap);
		List<SalesDto> salesList = deadlineService.getSales(paramMap);
		
		result.put("wereCnt", wereCnt);
		result.put("wereList", wereList);
		result.put("relCnt", relCnt);
		result.put("relList", relList);
		result.put("salesList", salesList);
		
		logger.info("+ End " + className + ".statList");

		return result;
	}
	
	
}
