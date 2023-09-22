<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8" />
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Document</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9"
	crossorigin="anonymous" />
<link
	href="${pageContext.request.contextPath}/resources/css/mypagesell.css"
	rel="stylesheet" />
	
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
	crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/resources/js/mySellPage.js" defer></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7551008ffbd30aac5abaffdcc5a33d7f&libraries=services"></script>

</head>

<body>
	<jsp:include page="/WEB-INF/views/header.jsp" />
<div class="section">
	<div class="section-header">
		<div class="user-info-wrapper">
			<div id="user-info">
				<h4 id="username">${ userinfo.nickname }</h4>
		<span id="location">${ userinfo.loc1 } ${ userinfo.loc2 } ${ userinfo.loc3 }</span>
		<p id="dealCnt">거래횟수: ${ userinfo.completed_cnt }회</p>
		</div>
		<div class="button-wrapper">
			<button class="btn update" data-bs-target="#updateModal"
				data-bs-toggle="modal">내 정보수정</button>
		</div>
	</div>
</div>
<div class="section-content">
	<div class="section-tab">
		<ul class="nav nav-pills">
			<li class="nav-item"><a class="nav-link" aria-current="page" href="mypageSell">판매물품</a></li>
			<li class="nav-item"><a class="nav-link" href="mypageBuy">구매물품</a></li>
			<li class="nav-item"><a class="nav-link active" href="mypageHeart">찜 목록</a></li>
			<li class="nav-item"><a class="nav-link" href="mypageTrade">거래후기</a></li>
		</ul>
	</div>

	<div>
		<div class="items">		
		<c:if test="${list != null}">
					<c:forEach items="${list}" var="item">
						<c:if test="${ item.status == 0 }">
							<div class="card"
								onclick="location.href='/page/detail?id=${item.id}'">
								<c:if test="${item.imageList != null}">
									<c:forEach items="${item.imageList}" var="image" end="0">
										<img src="${image.url}" class="card-img-top">
									</c:forEach>
								</c:if>
								<c:if test="${item.imageList == null}">
									<img
										src="${pageContext.request.contextPath}/resources/image/noImage.png"
										class="card-img-top">
								</c:if>
								<div class="card-body">
									<h5 class="title">${ item.title }</h5>
									<p class="price">
										<fmt:formatNumber value="${item.price}" pattern="#,###" />
										원
									</p>
									<p class="location">${item.loc1} ${item.loc2} ${item.loc3}</p>
									<p class="count">찜 ${item.hart_cnt} ∙ 채팅 ${item.chat_cnt}</p>
								</div>
							</div>
						</c:if>
					</c:forEach>

					<c:forEach items="${list}" var="item">
						<c:if test="${ item.status == 1 }">
							<div class="card"
								onclick="location.href='/page/detail?id=${item.id}'">
								<c:if test="${item.imageList != null}">
									<c:forEach items="${item.imageList}" var="image" end="0">
										<img src="${image.url}" class="card-img-top" style="opacity: 0.5">
									</c:forEach>
								</c:if>
								<c:if test="${item.imageList == null}">
									<img
										src="${pageContext.request.contextPath}/resources/image/noImage.png"
										class="card-img-top" style="opacity: 0.5">
								</c:if>
								<div class="card-body">
									<h5 class="title">${ item.title }</h5>
									<p class="price">
										<fmt:formatNumber value="${item.price}" pattern="#,###" />
										원
									</p>
									<p class="location">${item.loc1} ${item.loc2} ${item.loc3}</p>
									<p class="count">찜 ${item.hart_cnt} ∙ 채팅 ${item.chat_cnt}</p>
								</div>
							</div>
						</c:if>
					</c:forEach>
					<c:if test="${ itemcnt % 4 != 0}">
                    <c:forEach var="i" begin="1" end="${itemcnt % 4}">
                        <div class="card hidden" id="${i}" style="visibility: hidden">
                        </div>
                    </c:forEach>
                </c:if>
					</c:if>
					
					<c:if test="${list == null }">
					<h3> 내역이 없습니다. </h3>
					</c:if>
					
				</div>
		</div>
	</div>

	<div class="section-footer"></div>
</div>

<!-- 회원정보 수정 모달 -->
<div class="modal fade" id="updateModal" tabindex="-1"
	aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="updateModalLabel">내정보수정</h1>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<div class="input-wrapper">
					<div class="input-row">
						<div class="label">ID:</div>
						<div class="input">
							<input class="form-control" type="text" value="${ userinfo.id }"
						id="userid" readonly="readonly">
				</div>
			</div>

			<div class="input-row">
				<div class="label">이메일:</div>
				<div class="input">
					<input class="form-control" type="text"
						value="${ userinfo.email }" id="newemail"> <input
						type="button" value="이메일인증" id="btn-emailCheck"
						onclick="emailModalOpen()">
				</div>
			</div>

			<div class="input-row">
				<div class="label">닉네임:</div>
				<div class="input">
					<input class="form-control" type="text"
						value="${ userinfo.nickname }" id="newnickname">
				</div>
			</div>

			<div class="input-row">
				<div class="label">지역:</div>
				<div class="input">
					<select class="form-select" id="loc1" name="loc1"
						onchange="changeLoc1Select()">
						<option value="도시 선택">도시 선택</option>
						<c:forEach items="${loc1List}" var="location1">
							<option ${location1 == userinfo.loc1 ? 'selected' : ''}
								value="${location1}">${location1}</option>
						</c:forEach>
					</select> <select class="form-select" id="loc2" name="loc2"
						onchange="changeLoc2Select()">
						<option value="지역 선택">지역 선택</option>
						<c:forEach items="${loc2List}" var="location2">
							<option ${location2 == userinfo.loc2 ? 'selected' : ''}
								value="${location2}">${location2}</option>
						</c:forEach>
					</select> <select class="form-select" id="loc3" name="loc3">
						<option value="동네 선택">동네 선택</option>
						<c:forEach items="${loc3List}" var="location3">
							<option ${location3 == userinfo.loc3 ? 'selected' : ''}
								value="${location3}">${location3}</option>
						</c:forEach>
					</select>

					<button class="btn" id="currBtn" onclick="currLocBtnHandler()">현재위치</button>
				</div>
			</div>
		</div>
	</div>

	<div class="modal-footer">
		<button class="btn orange-btn"
			onclick="updateInfo('${ userinfo.id }')">회원정보 수정</button>
		<!-- <button class="btn orange-btn" id="btnUdpateInfo" >회원정보 수정</button> -->
		<button class="btn orange-btn" onclick="passwordModalOpen()">비밀번호
			변경</button>
		<button class="btn btn-danger"
			onclick="btnWithdraw('${ userinfo.id }')">회원탈퇴</button>
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>

<!-- 비밀번호 변경 모달 -->
<div class="modal fade" id="passwordModal" tabindex="-1"
	aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="passwordModalLabel">비밀번호 변경</h1>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<div class="input-wrapper">
					<div class="input-row">
						<div class="label">현재비밀번호:</div>
						<div class="input">
							<input class="form-control" type="password" id="password">
						</div>
					</div>

					<div class="input-row">
						<div class="label">새 비밀번호:</div>
						<div class="input">
							<input class="form-control" type="password" id="newpassword1" placeholder="영어, 숫자, 특수문자 1개 이상씩 사용하여 6~12자">
						</div>
					</div>

					<div class="input-row">
						<div class="label">비밀번호 확인:</div>
						<div class="input">
							<input class="form-control" type="password" id=newpassword>
						</div>
					</div>

				</div>
			</div>
			<div class="modal-footer">
				<button class="btn orange-btn" onclick="updateModalOpen()">회원정보
					수정</button>
				<button class="btn orange-btn" onclick="updatePassword('${userinfo.id}')">비밀번호 변경</button>
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>


<!-- 이메일 인증 Modal -->
<div class="modal fade" id="#staticBackdrop" data-bs-backdrop="static"
	data-bs-keyboard="false" tabindex="-1"
	aria-labelledby="staticBackdropLabel" aria-hidden="true">
	<div class="modal-dialog ">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="staticBackdropLabel">이메일 인증</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body row">

				<div id="custom-modal-row" class="mb-3">
					<input type="text" id="modal-text-email" class="modal-text"
						readonly="readonly" /> <input type="button" id="request-authnum"
						value="인증 요청">
				</div>
				<div id="custom-modal-row" class="mb-3">
					<input type="text" id="res-authnum-text" class="modal-text" /> <input
						type="button" id="res-authnum" value="인증 확인">
					<!--  <input type="text" id="time-limit" value="유효시간" size="6"> -->
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary"
					id="submit-email-auth">확인</button>
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>
<script
	src="${pageContext.request.contextPath}/resources/js/kakaoGeocoder.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/notifyModal.js"></script>
</body>
</html>