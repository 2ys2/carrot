<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8" />
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header"
	content="${_csrf.headerName}" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>게시물 상세보기</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9"
	crossorigin="anonymous" />
<link
	href="${pageContext.request.contextPath}/resources/css/postDetail.css"
	rel="stylesheet" />
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
	crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>

<script
	src="${pageContext.request.contextPath}/resources/js/postDetail.js"
defer></script>
<!-- <script src="../../resources/js/postDetail.js" defer="defer"></script> -->
</head>

<body>
	<jsp:include page="/WEB-INF/views/header.jsp" />
<div class="section" nickname="${nickname}" postid="${postdetail.id}">
<div class="section-header">
	<div class="title">
		<h2>${ postdetail.title }</h2>
		<h4
			onclick="location.href='/page/userpageSell?id=${postdetail.writer}'" style="cursor: pointer">${ postdetail.nickname }</h4>
	</div>
</div>
<div class="section-content">
	<div class="post-wrapper">
		<div class="post-category">${ postdetail.categoryName }∙${ postdetail.time }</div>
		<div class="post-content">
			<pre>
			${ postdetail.content }
			</pre>
		</div>
		<div class="post-like">
			조회수 ${ postdetail.read_cnt } 댓글 ${ postdetail.reply_cnt }

			<!-- 본인일 경우 버튼 활성화 -->
			<sec:authorize access="isAuthenticated()">
				<sec:authentication property="principal.user" var="user" />
				<c:if test="${ postdetail.writer == user.id }">
					<div class="button-wrapper">
						<button class="orange-btn btn"
							onclick="btnEdit('${postdetail.id}')" id="btnUpdatePost"
							value="${postdetail.id}">수정</button>
						<button class="red-btn btn"
							onclick="btnDelete('${postdetail.id}')">삭제</button>
					</div>
				</c:if>
			</sec:authorize>
		</div>
	</div>
</div>



<div class="section-footer">
	<div class="reply-form">
		<label class="form-label">댓글작성</label>
		<textarea class="form-control" id="reply-form"></textarea>
		<div class="reply-form-button-wrapper">
			<button class="btn orange-btn"
				onclick="btnInsert('${ postdetail.id }')">댓글쓰기</button>
		</div>
	</div>
	<div class="reply-container">

		<c:forEach items="${ postdetail.replylist }" var="list">
			<c:if test="${ list.status == 0 }">
				<div class="reply-card" id="reply${list.id}">
					<div class="reply-header">
						<h5 onclick="location.href='/page/userpageSell?id=${list.writer}'" style="cursor: pointer">${ list.nickname }</h5>
						<span class="reply-time">${ list.time }</span>
					</div>
					<div class="reply-content">
						<pre> ${ list.content } </pre>
					</div>
					<div class="reply-footer">
						<button class="btn orange-btn"
							onclick="btnReReplyList(${list.id})">답글</button>
						<!-- 본인일 경우 버튼 활성화 -->
						<sec:authorize access="isAuthenticated()">
							<sec:authentication property="principal.user" var="user" />
							<c:if test="${ list.writer == user.id }">
								<button class="btn red-btn"
									onclick="btnDeleteReply('${list.id}')" id="replydelete"
									value="${ postdetail.id }">삭제</button>
							</c:if>
						</sec:authorize>
					</div>
				</div>
			</c:if>
			<c:if test="${ list.status != 0 }">
				<div class="reply-card nested">
					<div class="reply-content">
						<pre>삭제된 댓글 입니다.</pre>
					</div>
				</div>
			</c:if>

		</c:forEach>
			</div>


		</div>
	</div>
	<script src="${pageContext.request.contextPath}/resources/js/notifyModal.js"></script>
</body>
</html>