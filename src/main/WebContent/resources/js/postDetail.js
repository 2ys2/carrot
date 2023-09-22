/* postDetail.js */

$(window).scroll(function () {
	$('.header').css('left', 0 - $(this).scrollLeft());
});

const nickname = document.querySelector("div.section").getAttribute("nickname");
const townpostid = document.querySelector("div.section").getAttribute("postid");

/* 게시글 수정 */
function btnEdit(num) {
	location.href = "/page/editpost/" + num;
}

/* 게시글 삭제 */
function btnDelete(num) {
	$.ajax({
		url: '/api/post/delete',           // 요청할 서버url
		dataType: 'text',       // 데이터 타입 (html, xml, json, text 등등)
		data: { 'id': num },
		success: function (result) { // 결과 성공 콜백함수
			console.log(result);
			alertModal('게시글이 삭제되었습니다.');
			window.location.href = result;
		},
		error: function (jqXHR, textStatus, errorThrown) { // 결과 에러 콜백함수
			console.log(jqXHR);  //응답 메시지
			console.log(textStatus); //"error"로 고정인듯함
			console.log(errorThrown);
		}
	})
}

var header = $("meta[name='_csrf_header']").attr('content');
var token = $("meta[name='_csrf']").attr('content');

/* 댓글 등록 */
function btnInsert(num) {
	const repl_content = document.querySelector('#reply-form').value.replaceAll('<', '&lt;').replaceAll('>', '&gt;');
	let comment = {
		'townPostId': num,
		'parent': '0',
		'content': repl_content
	};

	$.ajax({
		url: '/api/post/insertreply',
		type: 'POST',
		dataType: 'json',
		contentType: 'application/json',
		data: JSON.stringify(comment),
		beforeSend: function (xhr) {
			xhr.setRequestHeader(header, token)
		},
		success: (data) => {
			console.log(data);
			document.querySelector('#reply-form').value = '';
			afterReplyInsert(data.nickname, repl_content, data.writer, data.time, data.id)
		},
		error: () => {
			alertModal('등록 실패')
		}
	})
}

function afterReplyInsert(nickname, content, writer, time, id) { //댓글 등록 후 -> 

	const commentbox = document.querySelector("div.reply-container");
	commentbox.innerHTML += `
        <div class="reply-card" id="reply${id}">
						<div class="reply-header">
							<h5 onclick="location.href='/page/userpageSell?id=${writer}'" style="cursor:pointer">${nickname}</h5>
							<span class="reply-time">${time}</span>
						</div>
						<div class="reply-content">
						<pre>${content}</pre>
						</div>
						<div class="reply-footer">
							<button class="btn orange-btn" onclick="btnReReplyList('${id}')">답글</button>
							<button class="btn red-btn" onclick="btnDeleteReply('${id}')">삭제</button>
						</div>
					</div>
`
}

/* 댓글 삭제 */
function btnDeleteReply(num) {


	let numbers = {
		'id': num,
		'postid': townpostid
	};

	$.ajax({
		url: '/api/post/deletereply',
		type: 'POST',
		dataType: 'json',
		contentType: 'application/json',
		data: JSON.stringify(numbers),
		beforeSend: function (xhr) {
			xhr.setRequestHeader(header, token)
		},
		success: () => location.reload(),
		error: () => {
			alertModal('삭제 실패')
		}
	})


}

/* 대댓글 등록 */
function btnInsertReply(num) {
	const re_repl_content = document.querySelector('#re-reply-form').value.replaceAll('<', '&lt;').replaceAll('>', '&gt;');

	let comment = {
		'townPostId': townpostid,
		'parent': num,
		'content': re_repl_content
	};

	$.ajax({
		url: '/api/post/insertreply',
		type: 'POST',
		dataType: 'json',
		contentType: 'application/json',
		data: JSON.stringify(comment),
		beforeSend: function (xhr) {
			xhr.setRequestHeader(header, token)
		},
		success: (data) => {
			const replyEl = document.querySelector("#reply"+num);
			const formDiv = replyEl.querySelector(".reply-form.nested");
			console.log(data);
			document.querySelector('#re-reply-form').value = '';
			afterReReplyInsert(data.nickname, re_repl_content, data.writer, data.time, data.id, formDiv)
			/* location.reload(); */
		},
		error: () => {
			alertModal('등록 실패')
		}
	})
}

function afterReReplyInsert(nickname, content, writer, time, id, formDiv) { //대댓글 등록 후 ->

	//const commentbox = document.querySelector("#reply"+parent);
	const newreply = document.createElement("div")
	newreply.classList.add("reply-card");
	newreply.classList.add("nested");
	newreply.innerHTML += `
						<div class="reply-header">
							<h5 onclick="location.href='/page/userpageSell?id=${writer}'" style="cursor:pointer">${nickname}</h5>
							<span class="reply-time">${time}</span>
						</div>
						<div class="reply-content">
							<pre>${content}</pre>
						</div>
						<div class="reply-footer nested">
							<button class="btn red-btn" onclick="btnDeleteReply('${id}')">삭제</button>
						</div>
`
	formDiv.before(newreply);
}

const createNestedReplyElement = (replyEl, id) => {

	console.log(id);

	$.ajax({
		url: '/api/post/rereplylist',
		type: 'POST',
		dataType: 'json',
		contentType: 'application/json',
		data: JSON.stringify({
			parent: id
		}),
		beforeSend: function (xhr) {
			xhr.setRequestHeader(header, token)
		},
		success: (data) => {
			const nestedReplyEl = document.createElement("div");
			nestedReplyEl.classList.add("reply-card-nested-list");
			data.forEach((e) => {
				nestedReplyEl.innerHTML += getNestedReplyHtml(e);
			})
			

			nestedReplyEl.innerHTML+=`
			<div class="reply-form nested">
				<label class="form-label">답글작성</label>
				<textarea class="form-control" id="re-reply-form"></textarea>
				<div class="reply-form-button-wrapper">
				<button class="btn orange-btn" onclick="btnInsertReply('${id}')" id="enterreply">답글쓰기</button>
				</div>
			</div>
			`
			replyEl.appendChild(nestedReplyEl);

		}
	})
}

// function rereplyfrom(id){
// 	return `<div class="reply-form nested rereply-form">
// 	<label class="form-label">답글작성</label>
// 	<textarea class="form-control" id="re-reply-form"></textarea>
// 	<div class="reply-form-button-wrapper">
// 	<button class="btn orange-btn" onclick="btnInsertReply('${id}')" id="enterreply">답글쓰기</button>
// 	</div>
// 	</div>`
// }

function btnReReplyList(id) {
	const replyEl = document.querySelector("#reply" + id);
	/* const beforeEl = document.querySelector(e); */

	const nestedListEl = replyEl.querySelector(".reply-card-nested-list");
	console.log(nestedListEl);
	if (nestedListEl === null) {
		// ajax를통해 답글정보를 받는다.
		// 화면에 추가
		createNestedReplyElement(replyEl, id);
	}
	else {
		nestedListEl.remove();
	}
}

function getNestedReplyHtml(e) {

	if ( e.status === 0 ) {
		return `
	<div class="reply-card nested">
		<div class="reply-header">
			<h5 onclick="location.href='/page/userpageSell?id=${e.writer}'" style="cursor:pointer">${e.nickname}</h5>
			<span class="reply-time">${e.time}</span>
		</div>
		<div class="reply-content"><pre>${e.content}</pre></div>
		<div class="reply-footer nested">
			${e.nickname === nickname ? `<button class="btn red-btn" onclick="btnDeleteReply('${e.id}')">삭제</button>` : ''}
		</div>
	</div>
	`
	} else {
		return `
	<div class="reply-card nested">
					<div class="reply-content">
						<pre>삭제된 댓글 입니다.</pre>
					</div>
				</div>
	`
	}
}