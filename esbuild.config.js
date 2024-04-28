const esbuild = require('esbuild');
const path = require('path');
const vuePlugin = require('esbuild-plugin-vue').default;
const isDevelopment = process.env.NODE_ENV === 'development';

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outfile: 'app/assets/builds/application.js',
  plugins: [vuePlugin()],
  sourcemap: true,
  resolveExtensions: ['.js', '.vue'],
  format: 'esm',
  sourcemap: isDevelopment,
  define: {
    'process.env.NODE_ENV': '"development"',
    '__VUE_OPTIONS_API__': '"true"',
    '__VUE_PROD_DEVTOOLS__': isDevelopment ? '"true"' : '"false"',
  },
  loader: {
    '.js': 'jsx'
  },
  alias: {
    'vue': path.resolve(__dirname, 'node_modules/vue/dist/vue.esm-bundler.js')
  },
  minify: process.env.NODE_ENV === 'development'
}).catch((error) => {
  console.error("Build failed:", error);
  process.exit(1);
});

