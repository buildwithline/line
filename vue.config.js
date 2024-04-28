const path = require('path');

module.exports = {
    devServer: {
        proxy: {
            '/api': {  // Assuming your Rails API endpoints start with `/api`
                target: 'http://localhost:3000',
                changeOrigin: true,
                pathRewrite: { '^/api': '' },
            },
        },
    },
    configureWebpack: {
        entry: {
            app: path.resolve(__dirname, 'app/javascript/application.js')
        }
    }
};
