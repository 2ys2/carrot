package com.carrot.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		System.out.println("login success");

//		String msg = auth.getName()+"�� ȯ���մϴ�.";
//		request.setAttribute("msg", msg); //request ������ ����
		
		response.sendRedirect("/api/success");
		
	}
}
