package com.carrot.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
//import org.json.simple.JSONObject;
//import org.json.simple.parser.JSONParser;
//import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.carrot.domain.AuthVO;
import com.carrot.domain.GoogleRequest;
import com.carrot.domain.UserVO;
import com.carrot.handler.CustomUser;
import com.carrot.repository.UserRepository;
import com.carrot.service.GoogleLoginService;
import com.carrot.service.KakaoLoginService;
import com.carrot.service.NaverLogin;
import com.carrot.service.UserService;
import com.github.scribejava.core.model.OAuth2AccessToken;

/**
 * Handles requests for the application home page.
 */

@Controller
public class SnsLoginController {
	
	@Autowired
	private NaverLogin naverLogin;
	@Autowired
	private UserService service;
	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private KakaoLoginService kakaoLoginService;
	@Autowired
	private GoogleLoginService googleLoginService;
	
	private Random random = new Random();
	private int ranNum = (random.nextInt(888889) + 111111);
	private String ranNumStr = String.valueOf(ranNum);
	private UUID uuid = UUID.randomUUID();

//	네이버 로그인
	@RequestMapping("/api/signup/callback/naver")
	public String naverLogin(Model model, @RequestParam String code, @RequestParam String state, HttpSession session,
			RedirectAttributes redirectAttr) throws IOException, ParseException {
		
		OAuth2AccessToken oauthToken;
		oauthToken = naverLogin.getAccessToken(session, code, state);
		String apiResult = null;
		// 1. 로그인 사용자 정보를 읽어온다.
		apiResult = naverLogin.getUserProfile(oauthToken); 
		// 2. String형식인 apiResult를 json형태로 바꿈
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(apiResult);
		JSONObject jsonObj = (JSONObject) obj;
		// 3. 데이터 파싱
		JSONObject response_obj = (JSONObject) jsonObj.get("response");
		
		String id = (String) response_obj.get("id");
		String name = (String) response_obj.get("name");
		String email = (String) response_obj.get("email");
		String newId = "NAVER_" + id;

		String target = "@";
		int target_num = email.indexOf(target);
		String newNic = "NAVER_" + (String) email.substring(0, target_num) + "#" + ranNumStr;

		UserVO vo = new UserVO();
		List<AuthVO> authlist = new ArrayList<AuthVO>();
		AuthVO authVo = new AuthVO();
		authVo.setUser_id(newId);
		authVo.setAuth("ROLE_MEMBER");
		authlist.add(authVo);

		vo.setId(newId);
		vo.setAuthList(authlist);
		vo.setPassword(uuid.toString());
		vo.setNickname(newNic);
		vo.setEmail(email);
		// db에 해당 유저가 없을경우 join
		if (service.idCheck(newId) != 1) {
			service.signUp(vo);
			service.signUp_auth(authVo);
		} else {
			UserRepository mapper = sqlSession.getMapper(UserRepository.class);
			UserVO dataVo = mapper.selectById(newId);
			if (dataVo.getLoc1() != null)
				vo.setLoc1(dataVo.getLoc1());
			if (dataVo.getLoc2() != null)
				vo.setLoc2(dataVo.getLoc2());
			if (dataVo.getLoc3() != null)
				vo.setLoc3(dataVo.getLoc3());
		}
		CustomUser customUser = new CustomUser(vo);

		// 시큐리티 권한을 직접 세팅함
		Authentication authentication = new UsernamePasswordAuthenticationToken(customUser, null,
				customUser.getAuthorities());
		SecurityContextHolder.getContext().setAuthentication(authentication);

		if (vo.getLoc1() == null || vo.getLoc2() == null || vo.getLoc3() == null) {
			return "redirect:/api/success";

		}
		return "redirect:/page/main"; 
	}

	@GetMapping("/api/signup/callback/kakao")
	public String kakaoLogin(@RequestParam(value = "code", required = false) String code,
			RedirectAttributes redirectAttr) throws Exception {
		String access_Token = kakaoLoginService.getAccessToken(code);
		HashMap<String, String> userInfo = kakaoLoginService.getUserInfo(access_Token);

		String id = userInfo.get("id"); // 카카오 가상의 아이디
		String nickname = userInfo.get("nickname");
		String email = userInfo.get("email");
		String newId = "KAKAO_" + id;
		String ranNumStr = String.valueOf(ranNum);
		String newNic = "KAKAO_" + nickname + "#" + ranNumStr;

		UserVO vo = new UserVO();
		List<AuthVO> authlist = new ArrayList<AuthVO>();
		AuthVO authVo = new AuthVO();
		authVo.setUser_id(newId);
		authVo.setAuth("ROLE_MEMBER");
		authlist.add(authVo);

		vo.setId(newId);
		vo.setAuthList(authlist);
		vo.setPassword(uuid.toString());
		vo.setNickname(newNic);
		vo.setEmail(email);
		// db에 해당 유저가 없을경우 join
		if (service.idCheck(newId) != 1) {
			service.signUp(vo);
			service.signUp_auth(authVo);
		} else {
			UserRepository mapper = sqlSession.getMapper(UserRepository.class);
			UserVO dataVo = mapper.selectById(newId);
			if (dataVo.getLoc1() != null)
				vo.setLoc1(dataVo.getLoc1());
			if (dataVo.getLoc2() != null)
				vo.setLoc2(dataVo.getLoc2());
			if (dataVo.getLoc3() != null)
				vo.setLoc3(dataVo.getLoc3());
		}
		CustomUser customUser = new CustomUser(vo);

		// 시큐리티 권한을 직접 세팅함
		Authentication authentication = new UsernamePasswordAuthenticationToken(customUser, null,
				customUser.getAuthorities());
		SecurityContextHolder.getContext().setAuthentication(authentication);

		if (vo.getLoc1() == null || vo.getLoc2() == null || vo.getLoc3() == null) {
			return "redirect:/api/success";
		}
		return "redirect:/page/main"; 

	}
	
	@GetMapping("/api/signup/callback/google")
	public String googleLogin(@RequestParam("code") String accessCode, RedirectAttributes redirectAttr) {
		ResponseEntity<GoogleRequest> requestEntity = googleLoginService.getGoogleAccessToken(accessCode);
		
		//sub = JWT에 포함된 주체(subject)를 나타냅니다. 주체는 사용자의 고유 식별자입니다.
		String id = requestEntity.getBody().getSub(); 
		String email = requestEntity.getBody().getEmail();
		
		String newId = "GOOGLE_" + id;
		String target = "@";
		int target_num = email.indexOf(target);
		String newNic = "GOOGLE_" + (String) email.substring(0, target_num) + "#" + ranNumStr;
		
		UserVO vo = new UserVO();
		List<AuthVO> authlist = new ArrayList<AuthVO>();
		AuthVO authVo = new AuthVO();
		authVo.setUser_id(newId);
		authVo.setAuth("ROLE_MEMBER");
		authlist.add(authVo);

		vo.setId(newId);
		vo.setAuthList(authlist);
		vo.setPassword(uuid.toString());
		vo.setNickname(newNic);
		vo.setEmail(email);
		// db에 해당 유저가 없을경우 join
		if (service.idCheck(newId) != 1) {
			service.signUp(vo);
			service.signUp_auth(authVo);
		} else {
			UserRepository mapper = sqlSession.getMapper(UserRepository.class);
			UserVO dataVo = mapper.selectById(newId);
			if (dataVo.getLoc1() != null)
				vo.setLoc1(dataVo.getLoc1());
			if (dataVo.getLoc2() != null)
				vo.setLoc2(dataVo.getLoc2());
			if (dataVo.getLoc3() != null)
				vo.setLoc3(dataVo.getLoc3());
		}
		CustomUser customUser = new CustomUser(vo);

		// 시큐리티 권한을 직접 세팅함
		Authentication authentication = new UsernamePasswordAuthenticationToken(customUser, null,
				customUser.getAuthorities());
		SecurityContextHolder.getContext().setAuthentication(authentication);

		if (vo.getLoc1() == null || vo.getLoc2() == null || vo.getLoc3() == null) {
			
			return "redirect:/api/success";
//				
		}
		return "redirect:/page/main"; 
	}
}