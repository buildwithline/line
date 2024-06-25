const esbuild = require('esbuild');
const { polyfillNode } = require('esbuild-plugin-polyfill-node');
const { postCssPlugin } = require('esbuild-plugin-postcss2');

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  plugins: [
    polyfillNode(),
    postCssPlugin({
      plugins: [
        require('tailwindcss'),
        require('autoprefixer'),
      ],
    }),
  ],
  external: ['@walletconnect/web3-provider'],
  watch: {
    onRebuild(error, result) {
      if (error) console.error('watch build failed:', error);
      else console.log('watch build succeeded:', result);
    },
  },
}).catch(() => process.exit(1));