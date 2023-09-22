/* mySellPage */

$(window).scroll(function () {
  $(".header").css("left", 0 - $(this).scrollLeft());
});

var header = $("meta[name='_csrf_header']").attr("content");
var token = $("meta[name='_csrf']").attr("content");

// 쓰로틀
// 물품목록 4개씩 고정하기 위해
function rescaleCard() {
  const wrapperWidth = document.querySelector("div.items").offsetWidth;
  const offset = 30;
  const cardWidth = Math.ceil((wrapperWidth * 270) / 1336);

  const cards = document.querySelectorAll("div.card");
  const cardImg = document.querySelectorAll("img.card-img-top");
  for (let i = 0; i < cards.length; i++) {
    cards[i].style.width = `${cardWidth}px`;
    if (cardImg[i]) {
      cardImg[i].style.height = `${cardWidth}px`;
    }
  }
}

rescaleCard();

function throttle(fn, delay) {
  let waiting = false;
  return () => {
    if (!waiting) {
      fn.apply(this);
      waiting = true;
      setTimeout(() => {
        waiting = false;
      }, delay);
    }
  };
}

window.addEventListener("resize", throttle(rescaleCard, 100));

const updateModal = new bootstrap.Modal("#updateModal");
const passwordModal = new bootstrap.Modal("#passwordModal");

function passwordModalOpen() {
  updateModal.hide();
  passwordModal.show();
}

function updateModalOpen() {
  passwordModal.hide();
  updateModal.show();
}

function updateInfo(e) {
  /* var target = document.getElementById('btnUdpateInfo');
    const e = document.querySelector('#userid').value;

    target.addEventListener('click', function(e){ */
  const nickname = document.querySelector("#newnickname").value;
  const email = document.querySelector("#newemail").value;
  const loc1 = document.querySelector("#loc1").value;
  const loc2 = document.querySelector("#loc2").value;
  const loc3 = document.querySelector("#loc3").value;

  if (loc1 === "도시 선택" || loc2 === "지역 선택" || loc3 == "동네 선택") {
    alertModal("지역 설정을 꼭 해주셔야 합니다.");
    return false;
  }

  let data = {
    id: e,
    nickname: nickname,
    email: email,
    loc1: loc1,
    loc2: loc2,
    loc3: loc3,
  };

  $.ajax({
    url: "/api/myPage/updateinfo",
    type: "POST",
    dataType: "json",
    contentType: "application/json",
    data: JSON.stringify(data),
    beforeSend: function (xhr) {
      xhr.setRequestHeader(header, token);
    },
    success: (result) => {
      console.log(result);
      location.reload();
    },
    error: () => {
      alertModal("수정 실패");
      location.reload();
    },
  });
}
/* ) */

function updatePassword(e) {
  const password = document.querySelector("#password").value.replaceAll('<', '&lt;').replaceAll('>', '&gt;');;
  const newpassword1 = document.querySelector("#newpassword1").value.replaceAll('<', '&lt;').replaceAll('>', '&gt;');;
  const newpassword = document.querySelector("#newpassword").value.replaceAll('<', '&lt;').replaceAll('>', '&gt;');;
 
  var passwordTest =
   /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{6,12}$/;

  
	if (!passwordTest.test(newpassword1)) {
	alertModal(
	  "비밀번호는 영어, 숫자, 특수문자 1개 이상씩 사용하여 6~12자로 적어주세요."
	);
	return false;
  }
  
  if (newpassword1 !== newpassword) {
    alertModal("비밀번호 확인을 해주세요.");
    return false;
  }
  
  let data = {
    id: e,
    password: password,
    newpassword: newpassword,
  };

  $.ajax({
    url: "/api/myPage/updatepassword",
    type: "POST",
    dataType: "json",
    contentType: "application/json",
    data: JSON.stringify(data),
    beforeSend: function (xhr) {
      xhr.setRequestHeader(header, token);
    },
    success: (result) => {
      console.log(result);
      alertModal("변경 성공했습니다.\n다시 로그인 해주세요.");
      passwordModal.hide();
      logout();
    },
    error: () => {
      alertModal("변경 실패 비밀번호를 다시 확인해 주세요");
      location.reload();
    },
  });
}

function btnWithdraw(e) {
  let userid = { id: e };

  $.ajax({
    url: "/api/myPage/withdraw",
    type: "POST",
    dataType: "json",
    contentType: "application/json",
    data: JSON.stringify(userid),
    beforeSend: function (xhr) {
      xhr.setRequestHeader(header, token);
    },
    success: (result) => {
      console.log(result);
      logout();
    },
    error: () => {
      alertModal("탈퇴 실패");
      //location.reload();
    },
  });
}

function logout() {
  $.ajax({
    url: "/logout",
    type: "POST",
    dataType: "json",
    contentType: "application/json",
    beforeSend: function (xhr) {
      xhr.setRequestHeader(header, token);
    },
    success: (result) => {
      console.log("logout");
      console.log(result);
      location.reload();
    },
  });
}

/* function changeLoc1Select() {
    var loc1Select = document.getElementById("loc1");
    var loc1SelectValue = loc1Select.options[loc1Select.selectedIndex].value;
  
    $.ajax({
      url: "/api/loc/get2",
      data: {
        loc1: loc1SelectValue,
      },
      method: "get",
      dataType: "json",
    }).done((data) => {
      var selectEl = document.querySelector("#loc2");
      selectEl.innerHTML = "";
      data.forEach((loc) => {
        selectEl.innerHTML += optionEl(loc);
      });
    });
  }
  function changeLoc2Select() {
    var loc1Select = document.getElementById("loc1");
    var loc1SelectValue = loc1Select.options[loc1Select.selectedIndex].value;
    var loc2Select = document.getElementById("loc2");
    var loc2SelectValue = loc2Select.options[loc2Select.selectedIndex].value;
  
    $.ajax({
      url: "/api/loc/get3",
      data: {
        loc1: loc1SelectValue,
        loc2: loc2SelectValue,
      },
      method: "get",
      dataType: "json",
    }).done((data) => {
      var selectEl = document.querySelector("#loc3");
      selectEl.innerHTML = "";
      data.forEach((loc) => {
        selectEl.innerHTML += optionEl(loc);
      });
    });
  }
  
  function optionEl(loc) {
    return '<option value="' + loc + '">' + loc + "</option>";
  } */

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
        loc1: loc1SelectValue,
      },
      method: "get",
      dataType: "json",
    }).done((data) => {
      var selectLoc2El = document.querySelector("#loc2");
      var selectLoc3El = document.querySelector("#loc3");
      selectLoc2El.innerHTML = `<option value="지역 선택">지역 선택</option>`;
      selectLoc3El.innerHTML = `<option value="동네 선택">동네 선택</option>`;
      loc2El.prop("disabled", false);
      loc3El.prop("disabled", true);
      data.forEach((loc) => {
        selectLoc2El.innerHTML += optionEl(loc);
      });
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
        loc1: loc1SelectValue,
        loc2: loc2SelectValue,
      },
      method: "get",
      dataType: "json",
    }).done((data) => {
      var selectEl = document.querySelector("#loc3");
      selectEl.innerHTML = `<option value="동네 선택">동네 선택</option>`;
      loc3El.prop("disabled", false);
      data.forEach((loc) => {
        selectEl.innerHTML += optionEl(loc);
      });
    });
  }
}

function optionEl(loc) {
  return '<option value="' + loc + '">' + loc + "</option>";
}

$("#emailModal_req").click(function (e) {
  e.preventDefault();
  var email = $("#emailModal_email").val();
  var tokenInput = $("#token");
  var data = { email: email };
  data[tokenInput.attr("name")] = tokenInput.val();
  console.log(email);
  console.log("데이터:" + data);
  $.ajax({
    async: true,
    type: "POST",
    data,
    url: "/api/mypage/emailcheck",
    dataType: "json",
    contentType: "application/x-www-form-urlencoded",
    success: function (cnt) {
      if (cnt > 0) {
        alertModal("해당 이메일 존재");
        $("#emailModal_email").focus();
      } else {
        sendEmail();
      }
    },
    error: function (error) {
      alertModal("이메일을 재입력해주세요.");
    },
  });
});

function sendEmail() {
  var email_auth_cd = "";
  var eamil_auth_compl = false;

  var email = $("#emailModal_email").val();
  var tokenInput = $("#token");
  var data = { email: email };
  data[tokenInput.attr("name")] = tokenInput.val();

  $.ajax({
    type: "POST",
    url: "/api/sendemail",
    data,
    success: function (data) {
      alertModal("인증번호가 발송되었습니다.");
      email_auth_cd = data;
    },
    error: function (data) {
      alertModal("메일 발송에 실패했습니다.");
    },
  });

  $("#emailModal_compl").click(function () {
    console.log("모달: " + $("#emailModal_num").val());
    console.log("발급 :" + email_auth_cd);
    if ($("#emailModal_num").val() === email_auth_cd) {
      alertModal("인증이 완료되었습니다.");
      $("#emailModal_email").val(email);
      emailModalClose();
    }
    if ($("#emailModal_num").val() !== email_auth_cd) {
      alertModal("인증에 실패했습니다.");
    }
  });
}
function emailModalOpen() {
  $("#updateModal").modal("hide");
  $("#emailModal").modal("show");
}
function emailModalClose() {
  $("#emailModal").modal("hide");
  $("#updateModal").modal("show");
}

function nicknameModalOpen() {
  $("#updateModal").modal("hide");
  $("#nicknameModal").modal("show");
}
function nicknameModalClose() {
  $("#nicknameModal").modal("hide");
  $("#updateModal").modal("show");
}

$("#nicknameModal_req").click(function (e) {
  e.preventDefault();
  var nickname = $("#nicknameModal_nic").val();
  var tokenInput = $("#token");
  var data = { nickname: nickname };
  data[tokenInput.attr("name")] = tokenInput.val();
  var nicknameTest = /^[가-힣a-zA-Z0-9]{3,7}$/;

  if (!nicknameTest.test(nickname)) {
    alertModal("닉네임은 한글, 영어, 숫자로 3~7글자로 입력 가능합니다.");
    $("#nicknameModal_nic").focus();
    return false;
  }
  if (nickname.search(/\s/) !== -1) {
    alertModal("닉네임에는 공백이 들어갈 수 없습니다.");
  } else {
    if (nickname.trim().length !== 0) {
      $.ajax({
        async: true,
        type: "POST",
        data,
        url: "/api/mypage/niccheck",
        dataType: "json",
        contentType: "application/x-www-form-urlencoded",
        success: function (cnt) {
          if (cnt > 0) {
            alertModal("이미 존재하는 닉네임입니다.");
            //$("#submit").attr("disabled", "disabled");
            $("#nicknameModal_nic").focus();
          } else {
            alertModal("사용 가능한 닉네임 입니다");
            //$("#submit").removeAttr("disabled");
          }
        },
        error: function (error) {
          alertModal("닉네임을 재입력해주세요.");
        },
      });
    } else {
      alertModal("닉네임을 입력해주세요.");
    }
  }
});

$("#nicknameModal_compl").click(function (e) {
  alertModal("회원 정보 수정 버튼을 꼭 눌러주세요.");
  $("#newnickname").val($("#nicknameModal_nic").val());
  nicknameModalClose();
});
