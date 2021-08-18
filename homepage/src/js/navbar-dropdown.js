//
// navbar-dropdown.js
// Theme module
//

// Selectors
const drops = document.querySelectorAll('.navbar-nav .dropdown, .navbar-nav .dropend');

// Events
const showEvents = ['mouseenter'];
const hideEvents = ['mouseleave', 'click'];

// Transition
const transitionDuration = 200;

// Breakpoint
const desktopSize = 992;

// Show drop
function showDrop(menu) {
  if (window.innerWidth < desktopSize) {
    return;
  }

  menu.classList.add('showing');

  setTimeout(function() {
    menu.classList.remove('showing');
    menu.classList.add('show');
  }, 1);
}

// Hide drop
function hideDrop(e, menu) {
  setTimeout(function() {
    if (window.innerWidth < desktopSize) {
      return;
    }

    if (!menu.classList.contains('show')) {
      return;
    }

    if (e.type === 'click' && e.target.closest('.dropdown-menu form')) {
      return;
    }

    menu.classList.add('showing');
    menu.classList.remove('show');

    setTimeout(function() {
      menu.classList.remove('showing');
    }, transitionDuration);
  }, 2);
}

drops.forEach(function(dropdown) {
  const menu = dropdown.querySelector('.dropdown-menu');

  // Show drop
  showEvents.forEach(function(event) {
    dropdown.addEventListener(event, function() {
      showDrop(menu);
    });
  });

  // Hide drop
  hideEvents.forEach(function(event) {
    dropdown.addEventListener(event, function(e) {
      hideDrop(e, menu);
    });
  });
});
