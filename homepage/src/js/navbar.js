//
// navbar.js
// Theme module
//

const navbarTogglable = document.querySelectorAll('.navbar-togglable');
const navbarCollapse = document.querySelectorAll('.navbar-collapse');
const windowEvents = ['load', 'scroll'];

let isLight = false;

function makeNavbarDark(navbar) {
  navbar.classList.remove('navbar-light');
  navbar.classList.remove('bg-white');
  navbar.classList.add('navbar-dark');

  isLight = false;
}

function makeNavbarLight(navbar) {
  navbar.classList.remove('navbar-dark');
  navbar.classList.add('navbar-light');
  navbar.classList.add('bg-white');

  isLight = true;
}

function toggleNavbar(navbar) {
  const scrollTop = window.pageYOffset;

  if (scrollTop && !isLight) {
    makeNavbarLight(navbar);
  }

  if (!scrollTop) {
    makeNavbarDark(navbar);
  }
}

function overflowHide() {
  const scrollbarWidth = getScrollbarWidth();

  document.documentElement.style.overflow = 'hidden';
  document.body.style.paddingRight = scrollbarWidth + 'px';
}

function overflowShow() {
  document.documentElement.style.overflow = '';
  document.body.style.paddingRight = '';
}

function getScrollbarWidth() {
  return window.innerWidth - document.documentElement.clientWidth;
}

navbarTogglable.forEach(function(navbar) {
  windowEvents.forEach(function(event) {
    window.addEventListener(event, function() {
      toggleNavbar(navbar);
    });
  });
});

navbarCollapse.forEach(function(collapse) {
  collapse.addEventListener('show.bs.collapse', function() {
    overflowHide();
  });

  collapse.addEventListener('hidden.bs.collapse', function() {
    overflowShow();
  });
});
