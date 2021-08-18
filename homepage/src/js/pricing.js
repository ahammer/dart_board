//
// pricing.js
// Theme module
//

import { CountUp } from 'countup.js';

const toggles = document.querySelectorAll('[data-toggle="price"]');
const DURATION = 1;

toggles.forEach(toggle => {
  toggle.addEventListener('change', (e) => {
    const input = e.target;
    const isChecked = input.checked;

    const target = input.dataset.target;
    const targets = document.querySelectorAll(target);

    targets.forEach(target => {
      const annual = target.dataset.annual;
      const monthly = target.dataset.monthly;
      const options = target.dataset.options ? JSON.parse(target.dataset.options) : {};

      options.startVal = isChecked ? annual : monthly;
      options.duration = options.duration ? options.duration : DURATION;

      const countUp = isChecked ? new CountUp(target, monthly, options) : new CountUp(target, annual, options);

      countUp.start();
    });
  });
});
