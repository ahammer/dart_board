//
// countup.js
// Theme module
//

import { CountUp } from 'countup.js';

const toggles = document.querySelectorAll('[data-countup]');

function init(toggle) {
  const endVal = toggle.dataset.to ? +toggle.dataset.to : null;
  const options = toggle.dataset.countup ? JSON.parse(toggle.dataset.countup) : {};

  const countUp = new CountUp(toggle, endVal, options);

  countUp.start();
}

toggles.forEach((toggle) => {
  if (toggle.getAttribute('data-aos-id') !== 'countup:in') {
    init(toggle);
  }
});

document.addEventListener('aos:in:countup:in', function (e) {
  const counts =
    e.detail instanceof Element
      ? [e.detail]
      : document.querySelectorAll('.aos-animate[data-aos-id="countup:in"]:not(.counted)');

  counts.forEach((count) => {
    init(count);
  });
});

// Make available globally
window.CountUp = CountUp;
