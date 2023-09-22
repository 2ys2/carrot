let notifyModal = null;

function initModal() {
  const modal = document.createElement("div");
  modal.classList.add("modal");
  modal.classList.add("fade");
  modal.id = "notifyModal";
  modal.setAttribute("tabIndex", -1);
  modal.setAttribute("aria-hidden", "true");
  modal.innerHTML = `
  <div class="modal-dialog">
    <div class="modal-content">
     <div class="modal-header">
       <h1 class="modal-title fs-5" id="passwordModalLabel">알림</h1>
       <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
     </div>
     <div class="modal-body">
         <label style="width: 100%; font-weight: 500;" id="notifyContent"></label>
     </div>
     <div class="modal-footer">
       <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="confirmBtn">확인</button>
     </div>
    </div>
  </div>
  `;
  document.body.appendChild(modal);
  notifyModal = new bootstrap.Modal("#notifyModal");
}

function alertModal(content) {
  if (notifyModal === null) {
    initModal();
  }
  document.querySelector("label#notifyContent").textContent = content;
  notifyModal.show();
}

function registerAlertModal(content, url) {
  alertModal(content);
  $("#confirmBtn").click(function (){
    window.location = url;
  })
}