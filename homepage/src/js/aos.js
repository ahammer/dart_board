//
// aos.js
// Theme module
//

import AOS from 'aos';

const options = {
  duration: 700,
  easing: 'ease-out-quad',
  once: true,
  startEvent: 'load',
};

AOS.init(options);

// Make available globally
window.AOS = AOS;
