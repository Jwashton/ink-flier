import esbuild from 'esbuild';

const args = process.argv.slice(2);
const watch = args.includes('--watch');
const deploy = args.includes('--deploy');

const loader = {
  // Add loaders for images/fonts/etc, e.g. { '.svg': 'file' }
};

const plugins = [
  // Add and configure plugins here
];

// Define esbuild options
let opts = {
  entryPoints: ['js/app.mjs', 'js/game.mjs', 'css/app.css'],
  bundle: true,
  logLevel: 'info',
  target: ['firefox127', 'chrome126'],
  outdir: '../priv/static/assets',
  external: ['*.css', 'fonts/*', 'images/*'],
  nodePaths: ['../deps'],
  loader,
  plugins
};

if (deploy) {
  opts = {
    ...opts,
    minify: true
  };
}

if (watch) {
  opts = {
    ...opts,
    sourcemap: 'inline'
  };

  esbuild
    .context(opts)
    .then((ctx) => {
      ctx.watch();
    })
    .catch((_error) => {
      process.exit(1);
    });
} else {
  esbuild.build(opts);
}
