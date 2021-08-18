//
// bigpicture.js
// Theme module

import BigPicture from 'bigpicture';

const toggles = document.querySelectorAll('[data-bigpicture]');

toggles.forEach(function (toggle) {
  toggle.addEventListener('click', function (e) {
    e.preventDefault();

    const elementOptions = JSON.parse(toggle.dataset.bigpicture);

    const defaultOptions = {
      el: toggle,
      noLoader: true,
    };

    const options = {
      ...defaultOptions,
      ...elementOptions,
    };

    BigPicture(options);
  });
});

// Make available globally
window.BigPicture = BigPicture;
