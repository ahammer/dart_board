//
// isotope.js
// Theme module
//

import imagesLoaded from 'imagesloaded';
import Isotope from 'isotope-layout';

const toggles = document.querySelectorAll('[data-isotope]');
const filters = document.querySelectorAll('[data-filter]');

toggles.forEach(function (toggle) {
  imagesLoaded(toggle, function () {
    const options = JSON.parse(toggle.dataset.isotope);

    new Isotope(toggle, options);
  });
});

filters.forEach(function (filter) {
  filter.addEventListener('click', function (e) {
    e.preventDefault();

    const cat = filter.dataset.filter;
    const target = filter.dataset.bsTarget;
    const instance = Isotope.data(target);

    instance.arrange({
      filter: cat,
    });
  });
});

// Make available globally
window.Isotope = Isotope;
window.imagesLoaded = imagesLoaded;
