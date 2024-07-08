const esbuild = require('esbuild');
const { polyfillNode } = require('esbuild-plugin-polyfill-node');

async function build() {
  const postCssModule = await import('@chialab/esbuild-plugin-postcss');
  const postCssPlugin = postCssModule.default;

  const context = await esbuild.context({
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
  });

  await context.watch({
    onRebuild(error, result) {
      if (error) console.error('watch build failed:', error);
      else console.log('watch build succeeded:', result);
    },
  });
}

build().catch(() => process.exit(1));
