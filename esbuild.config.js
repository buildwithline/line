const esbuild = require('esbuild');
const VuePlugin = require('esbuild-plugin-vue').default;

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outfile: 'app/assets/builds/application.js',
  plugins: [VuePlugin()],
  sourcemap: true,
  format: 'esm',
  define: {
    'process.env.NODE_ENV': '"development"',
    '__VUE_OPTIONS_API__': '"true"',
    '__VUE_PROD_DEVTOOLS__': '"false"',
    '__VUE_PROD_HYDRATION_MISMATCH_DETAILS__': 'false', // Disable hydration mismatch details
  },
  minify: process.env.NODE_ENV === 'production',
  external: ['vue'],
}).catch(() => process.exit(1));
