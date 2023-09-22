<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Document</title>
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7551008ffbd30aac5abaffdcc5a33d7f&libraries=services"></script>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9"
            crossorigin="anonymous"
    />
    <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
            crossorigin="anonymous"
    ></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <link href="${pageContext.request.contextPath}/resources/css/itemRegister.css" rel="stylesheet"/>
    <script defer src="${pageContext.request.contextPath}/resources/js/itemRegister.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>
<div class="section">
    <div class="section-header">
        <div class="image-wrapper">
            <img src="${pageContext.request.contextPath}/resources/image/noImage.png" id="currImg"/>
        </div>
        <input type="file" class="hidden" id="file" accept="image/*"/>

        <div class="image-container">

        </div>

        <div class="button-wrapper">
            <button class="btn" id="upload">이미지추가</button>
        </div>

    </div>

    <div class="section-content">
        <div class="input-wrapper">
            <label class="form-label" for="title">제목</label>
            <input class="form-control" id="title" name="title" value="${item == null ? "" : item.title}"/>
            <div class="input-row">
                <div>
                    <label class="form-label" for="price">가격</label>
                    <input class="form-control" id="price" type="number" name="price"
                           value="${item == null ? "" : item.price}">
                </div>
                <div>
                    <label class="form-label">카테고리</label>
                    <select class="form-select category" id="category_id" name="category_id">
                        <option ${item == null ? "selected" : ""}></option>
                        <option value="1" ${item.category_id == 1 ? "selected" : ""}>디지털기기</option>
                        <option value="2" ${item.category_id == 2 ? "selected" : ""}>가구/인테리어</option>
                        <option value="3" ${item.category_id == 3 ? "selected" : ""}>유아동</option>
                        <option value="4" ${item.category_id == 4 ? "selected" : ""}>여성의류</option>
                        <option value="5" ${item.category_id == 5 ? "selected" : ""}>남성패션/잡화</option>
                        <option value="6" ${item.category_id == 6 ? "selected" : ""}>스포츠/레저</option>
                        <option value="7" ${item.category_id == 7 ? "selected" : ""}>도서</option>
                        <option value="8" ${item.category_id == 8 ? "selected" : ""}>가공식품</option>
                        <option value="9" ${item.category_id == 9 ? "selected" : ""}>식물</option>
                        <option value="10" ${item.category_id == 10 ? "selected" : ""}>삽니다</option>
                        <option value="11" ${item.category_id == 11 ? "selected" : ""}>생활가전</option>
                        <option value="12" ${item.category_id == 12 ? "selected" : ""}>생활/주방</option>
                        <option value="13" ${item.category_id == 13 ? "selected" : ""}>유아도서</option>
                        <option value="14" ${item.category_id == 14 ? "selected" : ""}>여성잡화</option>
                        <option value="15" ${item.category_id == 15 ? "selected" : ""}>뷰티/미용</option>
                        <option value="16" ${item.category_id == 16 ? "selected" : ""}>취미/게임/음반</option>
                        <option value="17" ${item.category_id == 17 ? "selected" : ""}>티켓/교환권</option>
                        <option value="18" ${item.category_id == 18 ? "selected" : ""}>반려동물용품</option>
                        <option value="19" ${item.category_id == 19 ? "selected" : ""}>기타 중고물품</option>
                    </select>
                </div>
            </div>

            <label class="form-label">지역</label>
            <div class="select-wrapper">
                <select class="form-select" id="loc1" name="loc1"
                        onchange="changeLoc1Select()">
                    <option value="도시 선택">도시 선택</option>
                    <c:forEach items="${loc1List}" var="location1">
                        <option ${location1 == user.loc1 ? 'selected' : ''} value="${location1}">${location1}</option>
                    </c:forEach>
                </select>
                <select class="form-select" id="loc2" name="loc2"
                        onchange="changeLoc2Select()">
                    <option value="지역 선택">지역 선택</option>
                    <c:forEach items="${loc2List}" var="location2">
                        <option ${location2 == user.loc2 ? 'selected' : ''} value="${location2}">${location2}</option>
                    </c:forEach>
                </select>
                <select class="form-select" id="loc3" name="loc3">
                    <option value="동네 선택">동네 선택</option>
                    <c:forEach items="${loc3List}" var="location3">
                        <option ${location3 == user.loc3 ? 'selected' : ''} value="${location3}">${location3}</option>
                    </c:forEach>
                </select>
                <button class="btn orange-btn" id="currBtn" onclick="currLocBtnHandler()">현재위치</button>
            </div>


            <label class="form-label">내용</label>
            <textarea class="form-control" id="content" name="content">${item == null ? "" : item.content}</textarea>
            <div class="button-wrapper">
                <button class="btn orange-btn" id="insertBtn" value="${item == null ? "" : item.id}"
                        name="${item == null ? "insert" : "update"}" onclick="uploadHandler()">
                    물품 ${item == null ? "등록" : "수정"}</button>
            </div>
            <input type="hidden" id="token" name="${_csrf.parameterName}" value="${_csrf.token}">
        </div>


    </div>


    <div class="section-footer">

    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/kakaoGeocoder.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/notifyModal.js"></script>
</body>
</html>