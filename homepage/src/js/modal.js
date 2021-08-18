//
// modal.js
// Theme module
//

const modals = document.querySelectorAll('.modal');

function overflowHide() {
  document.documentElement.style.overflowX = 'visible';
}

function overflowShow() {
  document.documentElement.style.overflowX = '';
}

modals.forEach((modal) => {
  modal.addEventListener('show.bs.modal', overflowHide);
  modal.addEventListener('hidden.bs.modal', overflowShow);
});
