//
// quill.js
// Theme module
//

import Quill from 'quill';

const toggles = document.querySelectorAll('[data-quill]');

toggles.forEach((toggle) => {
  const elementOptions = toggle.dataset.quill ? JSON.parse(toggle.dataset.quill) : {};

  const defaultOptions = {
    modules: {
      toolbar: [
        ['bold', 'italic'],
        ['link', 'blockquote', 'code', 'image'],
        [
          {
            list: 'ordered',
          },
          {
            list: 'bullet',
          },
        ],
      ],
    },
    theme: 'snow',
  };

  const options = {
    ...defaultOptions,
    ...elementOptions,
  };

  new Quill(toggle, options);
});

// Make available globally
window.Quill = Quill;
