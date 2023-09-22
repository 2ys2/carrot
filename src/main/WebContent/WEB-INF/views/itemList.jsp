<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
    <link href="${pageContext.request.contextPath}/resources/css/itemList.css" rel="stylesheet">
    <script defer src="${pageContext.request.contextPath}/resources/js/itemList.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>
<div class="section">
    <div class="img-wrapper">
        <img src="${pageContext.request.contextPath}/resources/image/mainImg.png" width="100%">
    </div>
    <div class="section-header">
        <div class="search">
            <c:if test="${searchInfo == null}">
                <h3 class="curr-location">${user.nickname}님 동네 물품</h3>
            </c:if>
            <c:if test="${searchInfo != null}">
                <h3 class="curr-location">검색 결과 : </h3>
            </c:if>
            <div class="search-location">
                <select class="form-select" id="loc1" name="loc1" onchange="changeLoc1Select()">
                    <option value="도시 선택">도시 선택</option>
                    <c:if test="${searchInfo == null}">
                        <c:forEach items="${loc1List}" var="location1">
                            <option ${location1 == user.loc1 ? 'selected' : ''}
                                    value="${location1}">${location1}</option>
                        </c:forEach>
                    </c:if>
                    <c:if test="${searchInfo != null}">
                        <c:forEach items="${loc1List}" var="location1">
                            <option ${location1 == searchInfo.loc1 ? 'selected' : ''}
                                    value="${location1}">${location1}</option>
                        </c:forEach>
                    </c:if>
                </select>
                <c:if test="${searchInfo == null}">
                    <select class="form-select" id="loc2" name="loc2" onchange="changeLoc2Select()">
                        <option value="지역 선택">지역 선택</option>
                        <c:forEach items="${loc2List}" var="location2">
                            <option ${location2 == user.loc2 ? 'selected' : ''}
                                    value="${location2}">${location2}</option>
                        </c:forEach>
                    </select>
                </c:if>
                <c:if test="${searchInfo != null}">
                    <select class="form-select" id="loc2" name="loc2" ${searchInfo.loc1 == null ? "disabled" : ""}
                            onchange="changeLoc2Select()">
                        <option value="지역 선택">지역 선택</option>
                        <c:forEach items="${loc2List}" var="location2">
                            <option ${location2 == searchInfo.loc2 ? 'selected' : ''}
                                    value="${location2}">${location2}</option>
                        </c:forEach>
                    </select>
                </c:if>
                <c:if test="${searchInfo == null}">
                    <select class="form-select" id="loc3" name="loc3">
                        <option value="동네 선택">동네 선택</option>
                        <c:forEach items="${loc3List}" var="location3">
                            <option ${location3 == user.loc3 ? 'selected' : ''}
                                    value="${location3}">${location3}</option>
                        </c:forEach>
                    </select>
                </c:if>
                <c:if test="${searchInfo != null}">
                    <select class="form-select" id="loc3" name="loc3" ${searchInfo.loc2 == null ? "disabled" : ""}>
                        <option value="동네 선택">동네 선택</option>
                        <c:forEach items="${loc3List}" var="location3">
                            <option ${location3 == searchInfo.loc3 ? 'selected' : ''}
                                    value="${location3}">${location3}</option>
                        </c:forEach>
                    </select>
                </c:if>
                <button class="btn" id="currBtn" onclick="currLocBtnHandler()">현재위치</button>
            </div>
            <div class="search-keyword">
                <select class="form-select" id="categorySelect" name="categorySelect">
                    <option value="0" ${searchInfo == null ? "selected" : ""}>전체검색</option>
                    <option value="1" ${searchInfo.category_id == 1 ? "selected" : ""}>디지털기기</option>
                    <option value="2" ${searchInfo.category_id == 2 ? "selected" : ""}>가구/인테리어</option>
                    <option value="3" ${searchInfo.category_id == 3 ? "selected" : ""}>유아동</option>
                    <option value="4" ${searchInfo.category_id == 4 ? "selected" : ""}>여성의류</option>
                    <option value="5" ${searchInfo.category_id == 5 ? "selected" : ""}>남성패션/잡화</option>
                    <option value="6" ${searchInfo.category_id == 6 ? "selected" : ""}>스포츠/레저</option>
                    <option value="7" ${searchInfo.category_id == 7 ? "selected" : ""}>도서</option>
                    <option value="8" ${searchInfo.category_id == 8 ? "selected" : ""}>가공식품</option>
                    <option value="9" ${searchInfo.category_id == 9 ? "selected" : ""}>식물</option>
                    <option value="10" ${searchInfo.category_id == 10 ? "selected" : ""}>삽니다</option>
                    <option value="11" ${searchInfo.category_id == 11 ? "selected" : ""}>생활가전</option>
                    <option value="12" ${searchInfo.category_id == 12 ? "selected" : ""}>생활/주방</option>
                    <option value="13" ${searchInfo.category_id == 13 ? "selected" : ""}>유아도서</option>
                    <option value="14" ${searchInfo.category_id == 14 ? "selected" : ""}>여성잡화</option>
                    <option value="15" ${searchInfo.category_id == 15 ? "selected" : ""}>뷰티/미용</option>
                    <option value="16" ${searchInfo.category_id == 16 ? "selected" : ""}>취미/게임/음반</option>
                    <option value="17" ${searchInfo.category_id == 17 ? "selected" : ""}>티켓/교환권</option>
                    <option value="18" ${searchInfo.category_id == 18 ? "selected" : ""}>반려동물용품</option>
                    <option value="19" ${searchInfo.category_id == 19 ? "selected" : ""}>기타 중고물품</option>
                </select>
                <input type="text" id="title" placeholder="검색어 입력" class="form-control"
                       value="${searchInfo != null ? searchInfo.title : ""}">
                <button class="btn" id="searchBtn" onclick="searchBtnHandler()">검색</button>
            </div>
        </div>

    </div>
    <div class="section-content" id="component">
        <c:if test="${list == null}">
            <h3> 동네에 등록된 물건이 없네용 ㅜ</h3>
        </c:if>
        <c:if test="${list != null}">
            <div class="items">
                <c:forEach items="${list}" var="item">
                    <div class="card" onclick="location.href='/page/detail?id=${item.id}'">
                        <c:if test="${item.imageList == null}">
                            <img src="${pageContext.request.contextPath}/resources/image/noImage.png"
                                 class="card-img-top">
                        </c:if>
                        <c:if test="${item.imageList != null}">
                            <c:forEach items="${item.imageList}" var="image" end="0">
                                <img src="${image.url}" class="card-img-top">
                            </c:forEach>
                        </c:if>
                        <div class="card-body">
                            <p class="title">${item.title}</p>
                            <p class="price"><fmt:formatNumber value="${item.price}" pattern="#,###"/></p>
                            <p class="location">${item.loc1} ${item.loc2} ${item.loc3}</p>
                            <p class="count">관심 ${item.hart_cnt} • 채팅 ${item.chat_cnt}</p>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${page.total == page.current}">
                    <c:forEach var="i" begin="1" end="${page.currPageCnt}">
                        <div class="card hidden" id="${i}">
                        </div>
                    </c:forEach>
                </c:if>
            </div>
        </c:if>
    </div>
    <div class="section-footer">
        <nav>
            <c:if test="${searchInfo == null}">
                <ul class="pagination">
                    <c:if test="${page.start != 1}">
                        <li class="page-item">
                            <a class="page-link"
                               onclick="window.location='/page/itemList?category_id=0&loc1=${user.loc1}&loc2=${user.loc2}&loc3=${user.loc3}&pageNo=${page.start - 1}'">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach var="i" begin="${page.start}" end="${page.end}">
                        <li class="page-item ${i == page.current ? 'active' : ''}">
                            <a class="page-link"
                               onclick="window.location='/page/itemList?category_id=0&loc1=${user.loc1}&loc2=${user.loc2}&loc3=${user.loc3}&pageNo=${i}'">
                                    ${i}
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${page.end != page.total}">
                        <li class="page-item">
                            <a class="page-link"
                               onclick="window.location='/page/itemList?category_id=0&loc1=${user.loc1}&loc2=${user.loc2}&loc3=${user.loc3}&pageNo=${page.end + 1}'">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </c:if>
            <c:if test="${searchInfo != null}">
                <ul class="pagination">
                    <c:if test="${page.start != 1}">
                        <li class="page-item">
                            <a class="page-link"
                               onclick="window.location='/page/itemList?category_id=${searchInfo.category_id}&loc1=${searchInfo.loc1}&loc2=${searchInfo.loc2}&loc3=${searchInfo.loc3}&title=${searchInfo.title}&pageNo=${page.start - 1}'">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach var="i" begin="${page.start}" end="${page.end}">
                        <li class="page-item ${i == page.current ? 'active' : ''}">
                            <a class="page-link"
                               onclick="window.location='/page/itemList?category_id=${searchInfo.category_id}&loc1=${searchInfo.loc1}&loc2=${searchInfo.loc2}&loc3=${searchInfo.loc3}&title=${searchInfo.title}&pageNo=${i}'">
                                    ${i}
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${page.end != page.total}">
                        <li class="page-item">
                            <a class="page-link"
                               onclick="window.location='/page/itemList?category_id=${searchInfo.category_id}&loc1=${searchInfo.loc1}&loc2=${searchInfo.loc2}&loc3=${searchInfo.loc3}&title=${searchInfo.title}&pageNo=${page.end + 1}'">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </c:if>
        </nav>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/kakaoGeocoder.js"></script>
</body>
</html>
