//
// choices.js
// Theme module
//

import Choices from 'choices.js';

const toggles = document.querySelectorAll('[data-choices]');

toggles.forEach((toggle) => {
  const elementOptions = toggle.dataset.choices ? JSON.parse(toggle.dataset.choices) : {};

  const defaultOptions = {
    shouldSort: false,
    searchEnabled: false,
    classNames: {
      containerInner: toggle.className,
      input: 'form-control',
      inputCloned: 'form-control-xs',
      listDropdown: 'dropdown-menu',
      itemChoice: 'dropdown-item',
      activeState: 'show',
      selectedState: 'active',
    },
  };

  const options = {
    ...elementOptions,
    ...defaultOptions,
  };

  new Choices(toggle, options);
});

// Make available globally
window.Choices = Choices;
