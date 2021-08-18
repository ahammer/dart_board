//
// map.js
// Theme module
//

const maps = document.querySelectorAll('[data-map]');
const accessToken = 'pk.eyJ1IjoiZ29vZHRoZW1lcyIsImEiOiJjanU5eHR4N2cybDU5NGVwOHZwNGprb3E0In0.msdw9q16dh8v4azJXUdiXg';

maps.forEach((map) => {
  const elementOptions = map.dataset.map ? JSON.parse(map.dataset.map) : {};

  const defaultOptions = {
    container: map,
    style: 'mapbox://styles/mapbox/light-v9',
    scrollZoom: false,
    interactive: false,
  };

  const options = {
    ...defaultOptions,
    ...elementOptions,
  };

  // Get access token
  mapboxgl.accessToken = accessToken;

  // Init map
  new mapboxgl.Map(options);
});
