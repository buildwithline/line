require('dotenv').config(); // Load environment variables

const esbuild = require('esbuild');

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  define: {
    'process.env.PROJECT_ID': JSON.stringify(process.env.PROJECT_ID),
  },
}).catch(() => process.exit(1));
  }
}).then(() => {
  console.log('Build completed successfully.');
}).catch(() => {
  console.error('Build failed.');
  process.exit(1);
});
