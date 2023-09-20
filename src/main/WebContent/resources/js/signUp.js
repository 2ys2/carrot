$("#btn-idCheck").click(function (e) {
  e.preventDefault();
  var username = $("#id").val();
  var tokenInput = $("#token");
  var data = { id: username };
  data[tokenInput.attr("name")] = tokenInput.val();
  var idTest = /^[a-zA-Z0-9]{6,12}$/;

  if (!idTest.test(username)) {
    alert("아이디는 영어와 숫자 6~12자 사용가능합니다.");
    $("#id").focus();
    return false;
  }
  if (username.search(/\s/) !== -1) {
    alert("아이디에는 공백이 들어갈 수 없습니다.");
  } else {
    if (username.trim().length !== 0) {
      $.ajax({
        async: true,
        type: "POST",
        data,
        url: "/api/signup/idcheck",
        dataType: "json",
        contentType: "application/x-www-form-urlencoded",
        success: function (cnt) {
          if (cnt > 0) {
            alert("해당 아이디는 이미 가입되어 있습니다.");
            $("#id").focus();
          } else {
            alert("사용 가능한 아이디입니다.");
            $("#nickname").focus();
            $("#idStatus").val("1");
          }
        },
        error: function (error) {
          alert("아이디를 재입력해주세요.");
        },
      });
    } else {
      alert("아이디를 입력해주세요.");
    }
  }
});

$("#btn-nicCheck").click(function (e) {
  e.preventDefault();
  var nickname = $("#nickname").val();
  var tokenInput = $("#token");
  var data = { nickname: nickname };
  data[tokenInput.attr("name")] = tokenInput.val();
  var nicknameTest = /^[가-힣a-zA-Z0-9]{3,7}$/;

  if (!nicknameTest.test(nickname)) {
    alert("닉네임은 한글, 영어, 숫자로 3~7글자로 입력 가능합니다.");
    $("#nickname").focus();
    return false;
  }
  if (nickname.search(/\s/) !== -1) {
    alert("닉네임에는 공백이 들어갈 수 없습니다.");
  } else {
    if (nickname.trim().length !== 0) {
      $.ajax({
        async: true,
        type: "POST",
        data,
        url: "/api/signup/niccheck",
        dataType: "json",
        contentType: "application/x-www-form-urlencoded",
        success: function (cnt) {
          if (cnt > 0) {
            alert("해당 닉네임은 이미 가입되어 있습니다.");
            //$("#submit").attr("disabled", "disabled");
            $("#nickname").focus();
          } else {
            alert("사용 가능한 닉네임입니다.");
            //$("#submit").removeAttr("disabled");
            $("#password").focus();
            $("#nicknameStatus").val("1");
          }
        },
        error: function (error) {
          alert("닉네임을 재입력해주세요.");
        },
      });
    } else {
      alert("닉네임을 입력해주세요.");
    }
  }
});

$("#btn-emailCheck").click(function (e) {
  e.preventDefault();

  var email = $("#email").val();
  var tokenInput = $("#token");
  var data = { email: email };
  data[tokenInput.attr("name")] = tokenInput.val();

  if (email.search(/\s/) !== -1 || email.trim().length === 0) {
    alert("이메일에는 공백이 들어갈 수 없습니다.");
  } else {
    $.ajax({
      async: true,
      type: "POST",
      data,
      url: "/api/signup/emailcheck",
      dataType: "json",
      contentType: "application/x-www-form-urlencoded",
      success: function (cnt) {
        if (cnt > 0) {
          alert("해당 이메일 존재");
          $("#eamil").focus();
        } else {
          $("#modal-text-email").val(email);
          $("#res-authnum-text").val("");
          $("#staticBackdrop").modal("show");
          sendEmail();
        }
      },
      error: function (error) {
        alert("이메일을 재입력해주세요.");
      },
    });
  }
});

function sendEmail() {
  var email_auth_cd = "";
  var eamil_auth_compl = false;

  $("#res-authnum").click(function () {
    if ($("#res-authnum-text").val() !== email_auth_cd) {
      alert("인증번호가 일치하지 않습니다.");
      eamil_auth_compl = false;
    }
    if ($("#res-authnum-text").val() === email_auth_cd) {
      alert("인증번호가 일치 합니다.");
      eamil_auth_compl = true;
    }
  });

  $("#request-authnum").click(function () {
    eamil_auth_compl = false;
    var email = $("#email").val();
    var tokenInput = $("#token");
    var data = { email: email };
    data[tokenInput.attr("name")] = tokenInput.val();

    $.ajax({
      type: "POST",
      url: "/api/sendemail",
      data,
      success: function (data) {
        alert("인증번호가 발송되었습니다.");
        email_auth_cd = data;
      },
      error: function (data) {
        alert("메일 발송에 실패했습니다.");
      },
    });
  });
  $("#submit-email-auth").click(function () {
    if (eamil_auth_compl === true) {
      alert("인증이 완료되었습니다.");
      $("#email").prop("readonly", true);
      $("#email").attr("style", "background-color:#80808021;");
      $("#staticBackdrop").modal("hide");
      $("#emailStatus").val("1");
    }
    if (eamil_auth_compl === false) {
      alert("인증이 완료되지 않았습니다.");
    }
  });
}

//DB 주소값 받아오기
function changeLoc1Select() {
  var loc1Select = document.getElementById("loc1");
  var loc1SelectValue = loc1Select.options[loc1Select.selectedIndex].value;
  var loc2El = $("#loc2");
  var loc3El = $("#loc3");

  if (loc1SelectValue === "도시 선택") {
    loc2El.find("option:eq(0)").prop("selected", true);
    loc3El.find("option:eq(0)").prop("selected", true);

    loc2El.prop("disabled", true);
    loc3El.prop("disabled", true);
  } else {
    $.ajax({
      url: "/api/loc/get2",
      data: {
        "loc1": loc1SelectValue
      },
      method: "get",
      dataType: "json"
    }).done((data) => {
      var selectLoc2El = document.querySelector("#loc2");
      var selectLoc3El = document.querySelector("#loc3");
      selectLoc2El.innerHTML = `<option value="지역 선택">지역 선택</option>`;
      selectLoc3El.innerHTML = `<option value="동네 선택">동네 선택</option>`;
      loc2El.prop("disabled", false);
      loc3El.prop("disabled", true);
      data.forEach((loc) => {
        selectLoc2El.innerHTML += optionEl(loc);
      })
    });
  }
}

function changeLoc2Select() {
  var loc1Select = document.getElementById("loc1");
  var loc1SelectValue = loc1Select.options[loc1Select.selectedIndex].value;
  var loc2Select = document.getElementById("loc2");
  var loc2SelectValue = loc2Select.options[loc2Select.selectedIndex].value;
  var loc3El = $("#loc3");

  if (loc1SelectValue === "도시 선택" || loc2SelectValue === "지역 선택") {
    loc3El.find("option:eq(0)").prop("selected", true);

    loc3El.prop("disabled", true);
  } else {
    $.ajax({
      url: "/api/loc/get3",
      data: {
        "loc1": loc1SelectValue,
        "loc2": loc2SelectValue
      },
      method: "get",
      dataType: "json"
    }).done((data) => {
      var selectEl = document.querySelector("#loc3");
      selectEl.innerHTML = `<option value="동네 선택">동네 선택</option>`;
      loc3El.prop("disabled", false);
      data.forEach((loc) => {
        selectEl.innerHTML += optionEl(loc);
      })
    });
  }
}

function optionEl(loc) {
  return '<option value="' + loc + '">' + loc + "</option>";
}

$("#btn-cancel").click(function (e) {
  //메인으로 보내주기 이전? history먹히나?
  e.preventDefault();

  console.log($("#emailStatus").val());
});

$("#id").change(function () {
  if ($("#idStatus").val() === 1) {
    $("#idStatus").val("0");
  }
});
$("#nickname").change(function () {
  if ($("#nicknameStatus").val() === 1) {
    $("#nicknameStatus").val("0");
  }
});
function emailRewrite() {
  if ($("#email").prop("readonly") === true) {
    if (confirm("수정하시면 재인증이 필요합니다\n수정하시겠습니까?")) {
      $("#email").prop("readonly", false);
      $("#email").attr("style", "background-color:#fff;");
      $("#emailStatus").val("0");
    } else {
      alert("취소");
    }
  }
}

$("#btn-signUp").click(function (e) {
  e.preventDefault();
  var passwordInput = $("#password").val();
  var passwordTest =
    /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{6,12}$/;

  if ($("#idStatus").val() === "0") {
    alert("아이디 중복 확인을 해주세요.");
    return false;
  }
  if ($("#nicknameStatus").val() === "0") {
    alert("닉네임 중복 확인을 해주세요.");
    return false;
  }
  if (!passwordTest.test(passwordInput)) {
    alert(
      "비밀번호는 영어, 숫자, 특수문자 1개 이상씩 사용하여 6~12자로 적어주세요."
    );
    return false;
  }
  if ($("#password").val() !== $("#passwordChk").val()) {
    alert("비밀번호 확인을 해주세요.");
    return false;
  }
  if ($("#emailStatus").val() === "0") {
    alert("이메일 인증을 해주세요.");
    return false;
  }

  if (
    $("#loc1").val() === null ||
    $("#loc2").val() === null ||
    $("#loc3").val() === null
  ) {
    alert("위치를 지정해 주세요.");
    return false;
  }
  if ($("#agreement").is(":checked") === false) {
    alert("개인정보 수집에 동의해 주세요.");
    return false;
  }

  var id = $("#id").val();
  var nickname = $("#nickname").val();
  var password = $("#password").val();
  var email = $("#email").val();
  var loc1 = $("#loc1").val();
  var loc2 = $("#loc2").val();
  var loc3 = $("#loc3").val();
  var tokenInput = $("#token");
  var data = {
    id: id,
    nickname: nickname,
    password: password,
    email: email,
    loc1: loc1,
    loc2: loc2,
    loc3: loc3,
  };
  data[tokenInput.attr("name")] = tokenInput.val();

  $.ajax({
    async: true,
    type: "POST",
    data,
    url: "/api/signup",
    dataType: "json",
    contentType: "application/x-www-form-urlencoded",
    success: function (result) {
      if (result === 2) {
        alert("회원가입에 성공했습니다.\n로그인 창으로 돌아갑니다.");
        location.href = "/page/login";
      }
      alert("다시 시도해주세요.");
      location.href = "page/login";
    },
    error: function (error) {
      alert("회원가입을 다시 시도해 주세요.");
    },
  });
});
