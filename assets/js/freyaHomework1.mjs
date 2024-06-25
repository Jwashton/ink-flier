import Vector2D from "./util/vector2d.mjs";
import Stencils from "./util/stencils.mjs";
import { withState } from "./util/canvas.mjs";
import Mouse from "./mouse.mjs";

const barrel = Vector2D(50, 100);
let canvas;
let ctx;
let mouse = Mouse();
let player = {
  position: { x: 0, y: 0 }
};

const DANGER_RADIUS = 300;

const draw = function draw() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  const half_window_width = canvas.width / 2;
  const half_window_height = canvas.height / 2;

  withState(ctx, () => {
    ctx.transform(1, 0, 0, 1, half_window_width, half_window_height);

    Stencils.plus(ctx, {
      x: 0,
      y: 0,
      size: 30,
      stroke: 'hsl(180deg, 100%, 50%)',
      strokeSize: 2
    });

    const barrelColor = Vector2D.distance(player.position, barrel) < DANGER_RADIUS ? 'red' : 'green';

    Stencils.circle(ctx, {
      x: barrel.x,
      y: barrel.y,
      radius: 10,
      fill: barrelColor
    });

    Stencils.circle(ctx, {
      x: barrel.x,
      y: barrel.y,
      radius: DANGER_RADIUS,
      stroke: 'rgba(255, 0, 0, 0.5)'
    });

    Stencils.vector(ctx, {
      origin: { x: 0, y: 0 },
      vector: barrel,
      stroke: 'hsl(180deg, 100%, 50%)',
      strokeSize: 2
    });

    Stencils.plus(ctx, {
      x: player.position.x,
      y: player.position.y,
      size: 30,
      stroke: 'hsl(180deg, 100%, 50%)',
      strokeSize: 2
    });

    Stencils.vector(ctx, {
      origin: { x: 0, y: 0 },
      vector: player.position,
      stroke: 'hsl(180deg, 100%, 50%)',
      strokeSize: 2
    });
  });
};

const enqueueRerender = () => {
  requestAnimationFrame(draw);
};

mouse.on('mouseMove', ({ x, y }) => {
  const half_window_width = canvas.width / 2;
  const half_window_height = canvas.height / 2;

  player.position.x = x - half_window_width;
  player.position.y = y - half_window_height;

  enqueueRerender();
});

window.addEventListener('DOMContentLoaded', () => {
  canvas = document.getElementById('mainView');
  ctx = canvas.getContext('2d');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  Mouse.bind(mouse, canvas);

  draw();
});
