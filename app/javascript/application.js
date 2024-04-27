// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import { createApp } from 'vue';
import CampaignButton from './components/CampaignButton.vue';

document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM content loaded');
    const app = createApp(CampaignButton);
    console.log('Vue app created:', app);
    app.mount('#vue-app');
});
