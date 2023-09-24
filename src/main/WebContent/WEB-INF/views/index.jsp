<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta id="_csrf" name="_csrf" content="${_csrf.token}" />
    <meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" />
    <title>당근 나라</title>
    
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
    <link href="${pageContext.request.contextPath}/resources/css/index.css" rel="stylesheet">
    <script defer src="../resources/js/index.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>
<div class="section">
    <div class="img1">
        <img src="${pageContext.request.contextPath}/resources/image/mainImg1.png" width="100%"/>
    </div>
    <div class="img2">
        <img src="${pageContext.request.contextPath}/resources/image/mainImg2.png" width="100%"/>
    </div>
    <div class="img3">
        <img src="${pageContext.request.contextPath}/resources/image/mainImg3.png" width="100%"/>
    </div>
</div>

<!-- 회원정보 수정 모달 -->
<div class="modal fade" id="newSnsIdModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false"
  aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="updateModalLabel"  >내 정보수정</h1>
      </div>
          <div class="modal-body">
            <div class="input-wrapper">
                당근나라를 방문해주셔서 감사합니다.<br>
                본 서비스는  위치 설정을 해야만, 서비스를 이용하실 수 있습니다.<br><hr>
        
              <div class="input-row">
                <input type="hidden" id="id" value="${user.id}"/>
                <input type="hidden" id="token" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="label">닉네임:</div>
                <div class="input">
                  <input class="form-control" type="text"
                    value="${user.nickname}" id="nickname">
                </div>
              </div>
        
              <div class="input-row">
                <div class="label">지역:</div>
                <div class="input">
                  <select class="form-select" id="loc1" name="loc1" onchange="changeLoc1Select()">
                                <option selected>도시 선택</option>
                                <option value="강원특별자치도">강원특별자치도</option>
                                <option value="경기도">경기도</option>
                                <option value="경상남도">경상남도</option>
                                <option value="경상북도">경상북도</option>
                                <option value="광주광역시">광주광역시</option>
                                <option value="대구광역시">대구광역시</option>
                                <option value="대전광역시">대전광역시</option>
                                <option value="부산광역시">부산광역시</option>
                                <option value="서울특별시">서울특별시</option>
                                <option value="세종특별자치시">세종특별자치시</option>
                                <option value="울산광역시">울산광역시</option>
                                <option value="인천광역시">인천광역시</option>
                                <option value="전라남도">전라남도</option>
                                <option value="전라북도">전라북도</option>
                                <option value="제주특별자치도">제주특별자치도</option>
                                <option value="충청남도">충청남도</option>
                                <option value="충청북도">충청북도</option>
                  </select> 
                  
                            <select id="loc2" class="form-select" name="loc2" onchange="changeLoc2Select()" disabled>
                                <option selected>지역 선택</option>
                            </select>
                        
                           <select class="form-select" id="loc3" name="loc3" disabled>
                                <option selected>동네 선택</option>
                  </select>
        
                  <button class="btn orange-btn" id="currBtn"  onclick="currLocBtnHandler()">현재위치</button>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button id="newSnsIdModify" class="btn orange-btn">회원정보 수정</button>
         </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/notifyModal.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/kakaoGeocoder.js"></script>  
<script>
$(window).scroll(function(){
    $('.header').css('left', 0-$(this).scrollLeft());
});
function newModalOpen() {
    var myModal = new bootstrap.Modal(document.getElementById('newSnsIdModal'));
    myModal.show();
}
if(${req_locRegist} ===  false){
  newModalOpen(); 
} 
</script>
</body>
</html>