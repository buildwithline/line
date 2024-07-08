const esbuild = require('esbuild');
const { polyfillNode } = require('esbuild-plugin-polyfill-node');

async function build() {
  const postCssModule = await import('@chialab/esbuild-plugin-postcss');
  const postCssPlugin = postCssModule.default;

  esbuild
    .build({
      entryPoints: ['app/javascript/application.js'],
      bundle: true,
      sourcemap: true,
      format: 'esm',
      outdir: 'app/assets/builds',
      publicPath: '/assets',
      plugins: [
        polyfillNode(),
        postCssPlugin({
          plugins: [require('tailwindcss'), require('autoprefixer')],
        }),
      ],
      external: ['@walletconnect/web3-provider', '@web3modal/ui'],
    })
    .catch(() => process.exit(1));
}

build();
