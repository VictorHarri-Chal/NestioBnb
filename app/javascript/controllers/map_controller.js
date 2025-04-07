import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers(this.boundsValue)

    this.map.on('moveend', () => {
      const bounds = this.map.getBounds().toArray();
      this.boundsValue = bounds;
      const sw = bounds[0];
      const ne = bounds[1];
      
      const searchParams = new URLSearchParams(window.location.search);
      searchParams.set('sw_lng', sw[0]);
      searchParams.set('sw_lat', sw[1]);
      searchParams.set('ne_lng', ne[0]);
      searchParams.set('ne_lat', ne[1]);

      const url = `${window.location.pathname}?${searchParams.toString()}`

      Turbo.visit(url, { frame: 'accommodations_list' });
    });
  }

  #addMarkersToMap() {
    this.markersValue.forEach((markerData) => {
      const el = document.createElement('div')
      el.innerHTML = markerData.markerhtml
      el.className = 'marker'

      const popup = new mapboxgl.Popup({ closeButton: false, className: 'rounded-lg' })
        .setHTML('<p>Loading...</p>')

      const marker = new mapboxgl.Marker(el)
        .setLngLat([ markerData.lng, markerData.lat ])
        .setPopup(popup)
        .addTo(this.map)

      popup.on('open', () => {
        const popupContent = popup.getElement().querySelector('p')
        if (popupContent && popupContent.innerText === 'Loading...') {
          this.#fetchPopupContent(popup, markerData.id)
        }
      })
    })
  }

  #fitMapToMarkers() {
    if (this.boundsValue) {
      this.map.fitBounds(this.boundsValue, { padding: 70, maxZoom: 15, duration: 0 })
    }
    else {
      this.map.fitBounds(this.markersValue.map(marker => [ marker.lng, marker.lat ]), { padding: 70, maxZoom: 15, duration: 0 })
    }
  }

  async #fetchPopupContent(popup, markerId) {
    try {
      const response = await fetch(`/accommodations/${markerId}/card`, {
        headers: {
          'Accept': 'text/html'
        }
      })

      const content = await response.text()
      popup.setHTML(content)

    } catch (error) {
      console.error("Failed to fetch popup content:", error)
      popup.setHTML('<p>Error loading content.</p>')
    }
  }
}
