import "@hotwired/turbo-rails";
import "./controllers";
// import { createApp } from 'node_modules/vue/dist/vue.esm-bundler.js';
// import CampaignButton from './components/CampaignButton.vue';

import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#vue-app')
// document.addEventListener('DOMContentLoaded', () => {
//   const app = createApp(App)
//   app.mount('#vue-app');
// });
