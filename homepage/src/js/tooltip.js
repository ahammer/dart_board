//
// tooltip.js
// Theme module
//

import { Tooltip } from 'bootstrap';

const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');

tooltips.forEach((tooltip) => {
  new Tooltip(tooltip);
});
