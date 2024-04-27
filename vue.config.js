const path = require('path');

module.exports = {
    configureWebpack: {
        entry: {
            app: path.resolve(__dirname, 'app/javascript/application.js')
        }
    }
};
