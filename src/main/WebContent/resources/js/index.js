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
var header = $("meta[name='_csrf_header']").attr("content");
var token = $("meta[name='_csrf']").attr("content");

$("#newSnsIdModify").click(function () {
  var id = $("#id").val();
  var nickname = $("#nickname").val();
  var tokenInput = $("#token");
  var loc1 = $("#loc1").val();
  var loc2 = $("#loc2").val();
  var loc3 = $("#loc3").val();
  var data = { id: id, nickname: nickname, loc1: loc1, loc2: loc2, loc3: loc3 };
  data[tokenInput.attr("name")] = tokenInput.val();

  var nicknameTest = /^[가-힣a-zA-Z0-9]{3,7}$/;

  if (!nicknameTest.test(nickname)) {
    alertModal("닉네임은 한글, 영어, 숫자로 3~7글자로 입력 가능합니다.");
    $("#nickname").focus();
    return false;
  }
  if (loc1 === "도시 선택" || loc2 === "지역 선택" || loc3 === "동네 선택") {
    alertModal("위치를 지정해 주세요.");
    return false;
  }

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
        $("#nickname").focus();
      } else {
        newSnsUpdate();
      }
    },
    error: function (error) {
      alertModal("닉네임을 재입력해주세요.");
    },
  });

  function newSnsUpdate() {
    var id = $("#id").val();
    var nickname = $("#nickname").val();
    var tokenInput = $("#token");
    var loc1 = $("#loc1").val();
    var loc2 = $("#loc2").val();
    var loc3 = $("#loc3").val();
    var data2 = {
      id: id,
      nickname: nickname,
      loc1: loc1,
      loc2: loc2,
      loc3: loc3,
    };
    data2[tokenInput.attr("name")] = tokenInput.val();
    $.ajax({
      url: "/api/myPage/updateinfo",
      type: "POST",
      dataType: "json",
      contentType: "application/json",
      data: JSON.stringify(data2),
      beforeSend: function (xhr) {
        xhr.setRequestHeader(header, token);
      },
      success: (result) => {
        $("#newSnsIdModal").modal("hide");
        alertModal("수정이 완료 되었습니다");
      },
      error: () => {
        alertModal("다시 시도해주세요.");
      },
    });
  }
});
// function newModalOpen() {
//   var myModal = new bootstrap.Modal(document.getElementById('newSnsIdModal'));
//   myModal.show();
// }
// if(${req_locRegist} ===  false){
// newModalOpen();
// }
