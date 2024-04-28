import "@hotwired/turbo-rails";
import "./controllers";
// import { createApp } from 'node_modules/vue/dist/vue.esm-bundler.js';
// import CampaignButton from './components/CampaignButton.vue';

import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#vue-app')
// document.addEventListener('DOMContentLoaded', () => {
//     const app = createApp({
//         components: {
//             'campaign-button': CampaignButton
//         },
//         template: `<div>
//                        <campaign-button repo-name="YourRepoName"></campaign-button>
//                    </div>`
//     });

//     console.log('Vue app created', app);
//     app.mount('#vue-app');
// });
