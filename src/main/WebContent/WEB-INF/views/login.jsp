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
    <link
      href="${pageContext.request.contextPath }/resources/css/login.css?after"
      rel="stylesheet"
    />
    <!-- 사용자 css -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script defer src="../resources/js/login.js"></script>

    <title>로그인 페이지</title>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
          <div class="card border-0 shadow rounded-3 my-5">
            <div class="card-body p-4 p-sm-5">
              <!-- <h5 class="card-title text-center mb-5 fw-light fs-5 btn-loginType" img src="../resources/image/carrotLogin.png"></h5> -->
              <div class="card-title loginLogo-div" ><img class="loginLogo" src="../resources/image/carrotLogin4.png"></div>
              <form action="/login" method="post">
                <div class="form-floating mb-3">
                  <input
                    type="id"
                    name="username"
                    class="form-control login-id-input"
                    id="floatingInput"
                    placeholder="ID"
                  />
                  <label for="floatingInput">아이디</label>
                </div>
                <div class="form-floating mb-3">
                  <input
                    type="password"
                    name="password"
                    class="form-control login-pw-input"
                    id="floatingPassword"
                    placeholder="Password"
                  />
                  <label for="floatingPassword">비밀번호</label>
                </div>
                <div>
                  <input
                    type="hidden"
                    id="token"
                    name="${_csrf.parameterName}"
                    value="${_csrf.token}"
                  />
                </div>

                <div class="mb-3 div-finder">
                  <span class = "userInfoCheck"> ${param.fail == true? '※ 계정 정보를 확인하여 주세요.':''} </span>
                  <!-- <button class="btn-finder" id="idFind">아이디 찾기</button> -->
                  <input
                    type="button"
                    class="btn-finder"
                    id="idFind"
                    value="아이디 찾기"
                  />
                  |
                  <input
                    type="button"
                    class="btn-finder"
                    id="passwordFind"
                    value="비밀번호 찾기"
                  />
                </div>
                <div class="d-grid">
                  <button
                    class="btn btn-primary btn-loginType btn-loginCheck fw-bold"
                    type="submit"
                  >
                    로그인
                  </button>
                </div>
              </form>
              <hr class="my-4" />
              <div class="d-grid mb-2">
                <button class="btn btn-email btn-loginType fw-bold">
                  <div>
                    <img
                      class="btn-logo-size"
                      src="../resources/image/email.png"
                    />
                    <span> 이메일로 회원가입</span>
                  </div>
                </button>
              </div>
              <div class="d-grid mb-2">
                <button
                  class="btn btn-google btn-loginType fw-bold"
                  onclick='location.href= "https://accounts.google.com/o/oauth2/v2/auth?client_id=${googleID}&redirect_uri=${googleURI}&response_type=code&scope=profile email"'
                >
                  <div>
                    <img
                      class="btn-logo-size"
                      src="../resources/image/google.png"
                    />
                    <span> 구글로 시작하기</span>
                  </div>
                </button>
              </div>

              <div class="d-grid mb-2">
                <button
                  class="btn btn-kakao btn-loginType fw-bold"
                  onclick='location.href="https://kauth.kakao.com/oauth/authorize?client_id=${kakaoID}&redirect_uri=${kakaoURI}&response_type=code"'
                >
                  <div>
                    <img
                      class="btn-logo-size"
                      src="../resources/image/kakao.png"
                    />
                    <span> 카카오로 시작하기</span>
                  </div>
                </button>
              </div>
              <div class="d-grid">
                <button
                  class="btn btn-naver btn-loginType fw-bold"
                  onclick='location.href="${naverAuthUrl}"'
                >
                  <div class="logo-len">
                    <img
                      class="btn-logo-size"
                      src="../resources/image/naver.png"
                    />
                    <span> 네이버로 시작하기</span>
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
<!-- 아이디 찾기 모달//이메일 인증요청  -->
    <div
      class="modal fade"
      id="idFinderModal"
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
              아이디 찾기
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
              <div class="label idModal_label">이메일:</div>
              <div class="input">
                <input
                  class="form-control idModal_input"
                  type="email"
                  id="idFinderModal_email"
                />
                <button class="btn orange-btn" id="idFinderModal_req">
                  인증요청
                </button>
              </div>
            </div>
            <div class="input-row-hidden">
              <div class="label idModal_label"></div>
              <div class="input">
                <span id="idFinderModal_reqmsg"></span>
              </div>
            </div>
            <div class="input-row">
              <div class="label idModal_label">인증번호:</div>
              <div class="input">
                <input
                  class="form-control idModal_input"
                  type="text"
                  id="idFinderModal_num"
                />
              </div>
            </div>
            <div class="input-row-hidden">
              <div class="label idModal_label"></div>
              <div class="input">
                <span id="idFinderModal_msg"></span>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn orange-btn"
              id="idFinderModal_compl"
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
    
    
    <!-- 비밀번호 찾기 모달  -->
    <div
      class="modal fade"
      id="pwdFinderModal"
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
              비밀번호 찾기
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
              <div class="label idModal_label">아이디:</div>
              <div class="input">
                <input
                  class="form-control idModal_input"
                  type="text"
                  id="pwdFinderModal_id"
                />

              </div>
            </div>
          
            <div class="input-row">
              <div class="label idModal_label">이메일:</div>
              <div class="input">
                <input
                  class="form-control idModal_input"
                  type="email"
                  id="pwdFinderModal_email"
                />
                <button class="btn orange-btn" id="pwdFinderModal_req">
                  인증요청
                </button>
              </div>
            </div>
            <div class="input-row-hidden">
              <div class="label idModal_label"></div>
              <div class="input">
                <span id="pwdFinderModal_reqmsg"></span>
              </div>
            </div>
            <div class="input-row">
              <div class="label idModal_label">인증번호:</div>
              <div class="input">
                <input
                  class="form-control idModal_input"
                  type="text"
                  id="pwdFinderModal_num"
                />
              </div>
            </div>
            <div class="input-row-hidden">
              <div class="label idModal_label"></div>
              <div class="input">
                <span id="pwdFinderModal_msg"></span>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn orange-btn"
              id="pwdFinderModal_compl"
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
    
    
    <!-- 비밀번호 재설정 모달  -->
    <div
      class="modal fade"
      id="pwdUpdateModal"
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
              비밀번호 재설정
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
              <div class="label idModal_label">비밀번호:</div>
              <div class="input">
                <input
                  class="form-control idModal_input"
                  type="password"
                  id="pwdUpdateModal_pwd"
                />
              </div>
            </div>
            <div class="input-row">
              <div class="label idModal_label">비밀번호 확인:</div>
              <div class="input">
                <input
                  class="form-control idModal_input"
                  type="password"
                  id="pwdUpdateModal_pwdChk"
                />
              </div>
            </div>
            <div class="input-row-hidden">
              <div class="label idModal_label"></div>
              <div class="input">
                <span id="pwdUpdateModal_msg"></span>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn orange-btn"
              id="pwdUpdateModal_compl"
            >
              변경
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
    <script src="${pageContext.request.contextPath}/resources/js/notifyModal.js"></script>
  </body>
</html>
