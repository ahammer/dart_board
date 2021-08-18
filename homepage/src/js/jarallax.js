//
// jarallax.js
// Theme module
//

import { jarallax, jarallaxElement, jarallaxVideo } from 'jarallax';

const toggles = document.querySelectorAll('[data-jarallax], [data-jarallax-element]');

// Add Video extension
jarallaxVideo();

// Add Element extension
jarallaxElement();

// Init Jarallax
jarallax(toggles);

// Make available globally
window.jarallax = jarallax;
window.jarallaxElement = jarallaxElement;
window.jarallaxVideo = jarallaxVideo;
