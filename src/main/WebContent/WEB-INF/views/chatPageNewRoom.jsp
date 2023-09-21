<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>채팅</title>
    <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
    rel="stylesheet"
    integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9"
    crossorigin="anonymous"
    />
    <link href="${pageContext.request.contextPath}/resources/css/chatPage.css" rel="stylesheet" />
    <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
    crossorigin="anonymous"
    ></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
  </head>
  <body>
    <jsp:include page="/WEB-INF/views/header.jsp"/>
    <div class="section">
      <div class="room-container" id="roomArea">
        <h2 class="username" id="userName" userId="${userId}">${username}</h2>
        <c:forEach items="${rooms}" var="room">
        <div class="chat-room" roomId="${room.id}" onclick="sendRoomChange(${room.id})">
            <div class="chat-room-header">
              <span class="chat-user">
                <c:choose>
                  <c:when test="${username eq room.buyerName}">${room.sellerName}</c:when>
                  <c:when test="${username eq room.sellerName}">${room.buyerName}</c:when>
                </c:choose>
              </span>
              <span class="last-message-time">
                <fmt:formatDate pattern="MM/dd HH:mm" value="${room.lastMessage.createdAt}"/>
              </span>
            </div>
            <div class="chat-room-content">
              <span class="last-message">${room.lastMessage.content}</span>
              <c:if test="${room.unReadCnt != 0}">
                <span class="badge bg-danger float-end unReadCnt">${room.unReadCnt}</span>
              </c:if>
            </div>
          </div>
        </c:forEach>
      </div>
      <div class="chat-container" roomId="-1">
        <div class="chat-header">
          <h2>
            ${item.writer_nickname}
          </h2>
        </div>

        <div class="chat-content" id="messageArea">

        </div>

          <div class="chat-input">
            <textarea class="form-control" id="chatInput"></textarea>
            <button class="btn orange-btn" id="send" onclick="sendBtnHandler2('${item.writer}', ${item.id})">전송</button>
          </div>
        </div>
      </div>
    </div>
    <script>
      $(window).scroll(function(){
        $('.header').css('left', 0-$(this).scrollLeft());
      });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/chat.js"></script>
  </body>
</html>

