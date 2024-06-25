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
}).catch(() => process.exit(1));