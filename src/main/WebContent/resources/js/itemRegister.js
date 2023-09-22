$(window).scroll(function () {
    $('.header').css('left', 0 - $(this).scrollLeft());
});

const inputFile = document.querySelector("input#file");
const uploadBtn = document.querySelector("button#upload");
const imgContainer = document.querySelector("div.image-container");
const mainImg = document.querySelector("div.image-wrapper > img");
const files = [];
const noImageUrl = "../image/noImage.png";

function getSmallImageWrapper(src, index) {
    return `
				<div class="image-wrapper-small">
						<img src="${src}" onclick="refreshMainImg(${index})"/>
						<button type="button" class="btn-close btn-close-black" aria-label="Close" onclick="deleteBtnHandler(${index})"></button>
				</div>
				`
}

async function refreshContainer() {
    let html = "";
    for (let i = 0; i < files.length; i++) {
        const file = files[i];
        html += await (getImageContainerHtml(file, i));
    }
    imgContainer.innerHTML = html;
    refreshMainImg(0);
}

function refreshMainImg(index) {
    if (files.length === 0 || index === undefined) {
        mainImg.src = noImageUrl;
        return;
    }
    const reader = new FileReader();
    reader.onload = (e) => {
        mainImg.src = e.target.result;
    }
    reader.readAsDataURL(files[index]);
}

function getImageContainerHtml(file, index) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = (e) => {
            resolve(getSmallImageWrapper(e.target.result, index));
        }
        reader.readAsDataURL(file);
    })
}

function uploadBtnHandler() {
    if (files.length >= 5) {
        alert("이미지 파일은 5개 까지만 업로드 가능합니다.");
        return;
    }
    inputFile.click();
}

function inputFileHandler(e) {
    const file = e.currentTarget.files[0];
    files.push(file);
    refreshContainer();
    e.currentTarget.value = "";
}

function deleteBtnHandler(index) {
    files.splice(index, 1);
    refreshContainer();
}

inputFile.addEventListener("change", inputFileHandler);
uploadBtn.addEventListener("click", uploadBtnHandler);

function uploadHandler() {
    const title = document.querySelector("input#title").value;
    const price = document.querySelector("input#price").value;
    const addr1 = document.querySelector("select#loc1").value;
    const addr2 = document.querySelector("select#loc2").value;
    const addr3 = document.querySelector("select#loc3").value;
    const categoryEl = document.querySelector("select#category_id");
    const categoryId = categoryEl.options[categoryEl.selectedIndex].value;
    const categoryName = categoryEl.options[categoryEl.selectedIndex].textContent;
    const content = document.querySelector("textarea#content").value;
    const token = document.querySelector("input#token");

    if (title == null || title === "") {
        alert("제목 입력 바람");
        return;
    }
    if (price == null) {
        alert("가격 입력 바람");
        return;
    }
    if (addr1 == null || addr1 === "" || addr2 == null || addr2 === "" || addr3 == null || addr3 === "") {
        alert("주소 모두 입력 바람");
        return;
    }
    if (categoryId == null || categoryId === 0) {
        alert("카테고리 입력 바람");
        return;
    }
    if (content == null || content === "") {
        alert("내용 입력 바람");
        return;
    }

    const formData = new FormData();
    // const files = document.querySelector("input[type=file]").files;
    for (const file of files) {
        formData.append("images", file);
    }
    formData.append("title", title);
    formData.append("price", price);
    formData.append("loc1", addr1);
    formData.append("loc2", addr2);
    formData.append("loc3", addr3);
    formData.append("category_id", categoryId);
    formData.append("category_name", categoryName);
    formData.append("content", content);
    formData.append(token.getAttribute("name"), token.value);

    $.ajax({
        url: "/api/item/insert",
        data: formData,
        enctype: "multipart/form-data",
        processData: false,
        contentType: false,
        method: "post",
        dataType: "text",
        error: function () {
            alert("애러 발생 ㅜㅜ");
        }
    }).done((result) => {
        if (result === "/page/itemRegister#") {
            alertModal("문제 발생, 관리자에 문의 바람");
        } else {
            registerAlertModal("등록 완료", result);
        }
    })
}

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
    return '<option value="' + loc + '">' + loc + '</option>'
}