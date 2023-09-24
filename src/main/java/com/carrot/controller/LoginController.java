package com.carrot.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.carrot.domain.AuthVO;
import com.carrot.domain.UserVO;
import com.carrot.handler.CustomUser;
import com.carrot.repository.UserRepository;
import com.carrot.service.NaverLogin;
import com.carrot.service.UserService;

@Controller
@PropertySource("/WEB-INF/application.properties")
public class LoginController {

	@Autowired
	private UserService userService;
	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private BCryptPasswordEncoder encoder;
	@Autowired
	private NaverLogin naverLogin;

	@Value("${oauth2.kakao.client-id}")
	private String KAKAO_ID;
	@Value("${oauth2.kakao.redirect_uri}")
	private String KAKAO_URI;
	@Value("${oauth2.google.client-id}")
	private String GOOGLE_ID;
	@Value("${oauth2.google.redirect_uri}")
	private String GOOGLE_URI;

	@GetMapping("/page/login")
	public String login(HttpSession session) {
		String naverAuthUrl = naverLogin.getAuthorizationUrl(session);
		session.setAttribute("naverAuthUrl", naverAuthUrl);
		session.setAttribute("kakaoID", KAKAO_ID);
		session.setAttribute("kakaoURI", KAKAO_URI);
		session.setAttribute("googleID", GOOGLE_ID);
		session.setAttribute("googleURI", GOOGLE_URI);
		
		return "login";
	}

	@GetMapping("/page/signup")
	public String signUp() {
		return "signUp";
	}

	@ResponseBody
	@PostMapping("/api/signup")
	public boolean signUp(@RequestParam String id, @RequestParam String nickname, @RequestParam String password, @RequestParam String email, 
			@RequestParam String loc1, @RequestParam String loc2, @RequestParam String loc3, RedirectAttributes redirectAttr) {
		String encodepw = encoder.encode(password);

		UserVO vo = new UserVO(id, nickname, encodepw, email, loc1, loc2, loc3);
		AuthVO authVo = new AuthVO(id);
		UserRepository mapper = sqlSession.getMapper(UserRepository.class);

		int result = mapper.signUp(vo);
		result += mapper.signUp_auth(authVo);
		if(result < 2) {
			return false;
		}
		return true;
	}

	@GetMapping("/api/success")
	public String success(Model model, RedirectAttributes redirectAttr) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserRepository mapper = sqlSession.getMapper(UserRepository.class);
		UserVO vo = mapper.selectById(authentication.getName());
		model.addAttribute("user", vo);
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		CustomUser customuser = (CustomUser) principal;

		if (customuser.getUser().getLoc1() == null || customuser.getUser().getLoc2() == null
				|| customuser.getUser().getLoc3() == null) {
			//redirectAttr.addAttribute("req_locRegist", false);
			redirectAttr.addFlashAttribute("req_locRegist", false);
			redirectAttr.addFlashAttribute("user", vo);
		}

		return "redirect:/page/main";
	}
	
	@GetMapping("/access_denied")
	public String deny() {

		return "accessDenied";
	}

	@ResponseBody
	@PostMapping("/api/signup/idcheck")
	public int idCheck(@RequestParam String id) {
		int cnt = 0;
		cnt = userService.idCheck(id);

		return cnt;
	}

	@ResponseBody
	@PostMapping("/api/signup/niccheck")
	public int nicCheck(@RequestParam String nickname) {
		int cnt = 0;
		cnt = userService.nicCheck(nickname);

		return cnt;
	}

	@ResponseBody
	@PostMapping("/api/signup/emailcheck")
	public int emailCheck(@RequestParam String email) {
		int cnt = 0;
		cnt = userService.emailCheck(email);
		return cnt;
	}
	
	@GetMapping("/api/loginfail")
	public String loginfail(HttpServletRequest request, RedirectAttributes redirectAttr) {
       
		String loginFailMsg = (String) request.getSession().getAttribute("loginFailureMessage");

        if (loginFailMsg != null) {
            // RedirectAttributes를 사용하여 메시지를 다음 요청으로 전달
        	redirectAttr.addFlashAttribute("LoginFailMessage", loginFailMsg);

            // 메시지를 한 번 사용하면 세션에서 제거합니다.
            request.getSession().removeAttribute("loginFailureMessage");
        }
        // 로그인 페이지로 리다이렉트
        return "redirect:/page/login";
	}
	
	@ResponseBody
	@PostMapping("/api/finduser/id")
	public String findId(@RequestParam String email) {
		String id = userService.findId(email);
		
		if(id == null) {
			id = "미가입";
		}
		return id;
	}
	
	@ResponseBody
	@PostMapping("/api/finduser/password")
	public int findPassword(@RequestParam("id") String id, @RequestParam("email") String email) {
		
		int cnt = userService.findPassword(id, email);
		return cnt;
	}
	@ResponseBody
	@PostMapping("/api/finduser/newpwd")
	public int updatePassword(@RequestParam("id") String id, @RequestParam("password") String password) {
		String encodepw = encoder.encode(password);
		int cnt = userService.updatePassword(id, encodepw);
		return cnt;
	}
	
	
}
