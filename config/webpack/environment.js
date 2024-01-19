// config/webpack.config.js

const { environment } = require('@rails/webpacker');
const tailwindcss = require('tailwindcss');

// Add the tailwindcss plugin to the environment
environment.plugins.prepend('tailwindcss', tailwindcss);

module.exports = environment;
