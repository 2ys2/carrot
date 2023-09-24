<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />

    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- 부트스트랩 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- 부트스트랩 -->
    <link href="../resources/css/signUp.css?after" rel="stylesheet" />
    <!-- 사용자 css -->
    <script
      type="text/javascript"
      src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7551008ffbd30aac5abaffdcc5a33d7f&libraries=services"
    ></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script defer src="../resources/js/signUp.js"></script>

    <title>회원가입 페이지</title>
  </head>
  <body>
    <div class="container">
      <form action="/api/signup" method="post" accept-charset="UTF-8">
        <div class="input-form-backgroud row">
          <div class="input-form col-md-12 mx-auto">
            <h4 class="mb-3">회원가입</h4>
            <br />
            <div class="row">
              <label for="id">아이디</label>
              <div class="col-md-8 mb-3">
                <input type="text" class="form-control" id="id" name="id" placeholder="영문, 숫자 6~12자 입력" required/>
                <input type="hidden" id="idStatus" value="0" />
              </div>
              <div class="col-md-4 mb-3 button-row">
                <input type="button" id="btn-idCheck" class="btn orange-btn btn-custom" value="중복체크"/>
              </div>
            </div>

            <div class="row">
              <label for="nickname">닉네임</label>
              <div class="col-md-8 mb-3">
                <input type="text" class="form-control" id="nickname" name="nickname" placeholder="한글, 영문, 숫자 3~7자 입력" required/>
                <input type="hidden" id="nicknameStatus" value="0" />
              </div>
              <div class="col-md-4 mb-3 button-row">
                <input type="button" id="btn-nicCheck" class="btn orange-btn btn-custom" value="중복체크"/>
              </div>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="password">비밀번호 입력</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="6~12자 이내 영문,숫자,특문 입력" required/>
              </div>
              <div class="col-md-6 mb-3">
                <label for="passwordChk">비밀번호 확인</label> 
                <input type="password" class="form-control" id="passwordChk" name="passwordChk" placeholder="6~12자 이내 영문,숫자,특문 입력" required />
              </div>
              
            </div>

            <div class="row">
              <label for="email">이메일</label>
              <div class="col-md-8 mb-3">
                <input type="email" class="form-control" id="email" name="email" placeholder="id@example.com" onclick="emailRewrite()" required />
                <input type="hidden" id="emailStatus" value="0" />
              </div>
              <div class="col-md-4 mb-3 button-row">
                <input type="button" id="btn-emailCheck" class="btn orange-btn btn-custom" value="인증 받기"/>
              </div>
            </div>

            <div class="row loc-row">
              <label for="location">위치</label>
              <div class="col-md-4 mb-3">
                <select id="loc1" class="form-select" name="loc1" onchange="changeLoc1Select()" >
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
              </div>

              <div class="col-md-3 mb-3">
                <select id="loc2" class="form-select" name="loc2" onchange="changeLoc2Select()" disabled>
                  <option selected>지역 선택</option>
                </select>
              </div>
              <div class="col-md-3 mb-3">
                <select id="loc3" class="form-select" name="loc3" disabled>
                  <option selected>동네 선택</option>
                </select>
              </div>
              <div class="col-md-2 mb-3 button-row">
                <input type="button" id="btn-myLoc" class="btn orange-btn" value="내 위치" onclick="currLocBtnHandler()"/>
              </div>
            </div>

            <input type="hidden" id="token" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <hr class="mb-3" />
            <div class="custom-control custom-checkbox button-row">
              <input type="checkbox" class="custom-control-input" id="agreement" required />
              <label class="custom-control-label" for="agreement">개인정보 수집 및 이용에 동의합니다.</label>
            </div>
            <br />
            <div class="register-row">
              <button type="button" id="btn-signUp" class="btn orange-btn btn-custom" >
                가입
              </button>
              <input type="button" id="btn-cancel" class="btn btn-cancel btn-custom" value="취소"/>
            </div>
          </div>
        </div>
      </form>
      <footer class="my-3 text-center text-small">
        <p class="mb-1">&copy; 당근 나라</p>
      </footer>
    </div>


    <!-- 이메일 인증Modal -->
    <!--  
    <div class="modal fade" id="emailCertifyModal" data-bs-backdrop="static" data-bs-keyboard="false" 
    	tabindex="-1" aria-labelledby="emailCertifyModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="emailCertifyModalLabel">이메일 인증</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body row">
            <div id="custom-modal-row" class="mb-3">
              <input type="text" id="modal-text-email" class="modal-text" readonly="readonly"/>
              <input type="button" id="request-authnum" value="인증 요청" />
            </div>
            <div id="custom-modal-row" class="mb-3">
              <input type="text" id="res-authnum-text" class="modal-text" />
              <input type="button" id="res-authnum" value="인증 확인" />
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn orange-btn" id="submit-email-auth">
              확인
            </button>
            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal" >
              취소
            </button>
          </div>
        </div>
      </div>
    </div>
    -->
    
    <!-- 이메일 인증요청  -->
    <div
      class="modal fade"
      id="emailCertifyModal"
      data-bs-backdrop="static"
      data-bs-keyboard="false"
      tabindex="-1"
      aria-labelledby="staticBackdropLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="staticBackdropLabel">
              이메일 인증
            </h1>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div class="input-row">
              <div class="label idModal_label">인증번호:</div>
              <div class="input">
                <input
                  class="form-control idModal_input"
                  type="text"
                  id="emailModal_num"
                />
              </div>
            </div>
            <div class="input-row-hidden">
              <div class="label idModal_label"></div>
              <div class="input">
                <span id="emailModal_msg">※ 인증번호 전송 대기중입니다.</span>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn orange-btn"
              id="emailModal_compl"
            >
              인증확인
            </button>
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              취소
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <%-- 이메일 수정 confirm 모달 --%>
    <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="passwordModalLabel">알림</h1>
                </div>
                <div class="modal-body">
                    <label style="width: 100%; font-weight: 500;" id="modalContent"></label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="cfmodal_confirmBtn">확인</button>
                    <button type="button" class="btn btn-danger" id="cfmodal_cancelBtn">취소</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/resources/js/kakaoGeocoder.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/notifyModal.js"></script>
  </body>
</html>