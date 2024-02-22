require('dotenv').config(); // Load environment variables

const esbuild = require('esbuild');

esbuild.build({
  entryPoints: ['app/javascript/application.js'], // Adjust if you have multiple entry points
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  define: {
    'process.env.PROJECT_ID': JSON.stringify(process.env.PROJECT_ID),
  },
  // Add more configurations or plugins as needed
}).catch(() => process.exit(1));
