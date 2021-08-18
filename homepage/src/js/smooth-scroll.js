//
// smooth-scroll.js
// Theme module
//

import SmoothScroll from 'smooth-scroll';

const toggle = '[data-scroll]';
const header = '.navbar.fixed-top';
const offset = 24;

const options = {
  header: header,
  offset: function (anchor, toggle) {
    return toggle.dataset.scroll && JSON.parse(toggle.dataset.scroll).offset !== undefined
      ? JSON.parse(toggle.dataset.scroll).offset
      : offset;
  },
};

new SmoothScroll(toggle, options);

// Make available globally
window.SmoothScroll = SmoothScroll;
