//
// typed.js
// Theme module
//

import Typed from 'typed.js';

const toggles = document.querySelectorAll('[data-typed]');

toggles.forEach((toggle) => {
  const elementOptions = toggle.dataset.typed ? JSON.parse(toggle.dataset.typed) : {};

  const defaultOptions = {
    typeSpeed: 40,
    backSpeed: 40,
    backDelay: 1000,
    loop: true,
  };

  const options = {
    ...defaultOptions,
    ...elementOptions,
  };

  new Typed(toggle, options);
});

// Make available globally
window.Typed = Typed;
