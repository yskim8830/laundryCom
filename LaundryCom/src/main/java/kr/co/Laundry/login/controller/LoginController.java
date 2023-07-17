package kr.co.Laundry.login.controller;

import java.io.IOException;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.Laundry.login.service.LoginService;

@Controller
public class LoginController {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	LoginService loginService;

	/**
	 * index 접속 시 로그인 페이지로 이동한다.
	 * 
	 * @param	Model result - Spring model object
	 * @param	Map paramMap - Request Param object
	 * @param	HttpServletRequest request - Servlet request object
	 * @param	HttpServletResponse response - Servlet response object
	 * @param	HttpSession session - Http session Object
	 * @return	String - page navigator
	 * @throws Exception
	 */
	@RequestMapping("login.do")
	public String index(Model result, @RequestParam Map<String, String> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start LoginController.login.do");
		if(request.getSession().getAttribute("seq") != null ){
			return "redirect:/";
		}
		logger.info("+ End LoginController.login.do");
		
		return "/login";
	}

	/**
	 * 사용자 로그인을 처리한다.
	 * 
	 * @param	Model result - Spring model object
	 * @param	Map paramMap - Request Param object
	 * @param	HttpServletRequest request - Servlet request object
	 * @param	HttpServletResponse response - Servlet response object
	 * @param	HttpSession session - Http session Object
	 * @return	String - page navigator
	 * @throws Exception
	 */
	@RequestMapping("loginProc.do")
	@ResponseBody
	public Map<String, String> loginProc(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start LoginController.loginProc.do");
		logger.info("   - ParamMap : " + paramMap);
		// 사용자 로그인
		Map<String, String> resultMap = loginService.loginProc(paramMap, session);
		logger.info("+ End LoginController.loginProc.do");

		return resultMap;
	}
	
	
	/**
	 * 로그아웃
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/logout.do")
	public ModelAndView loginOut(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
						
		ModelAndView mav = new ModelAndView();
		session.invalidate();
		mav.setViewName("redirect:/login.do");
		
		return mav;
	}
	
	@RequestMapping(value = "/favicon.ico", method = RequestMethod.GET)
	public void favicon( HttpServletRequest request, HttpServletResponse reponse ) {
		try {
			reponse.sendRedirect("/resources/favicon.ico");
		} catch (IOException e) {

			e.printStackTrace();

		}

	}
}
