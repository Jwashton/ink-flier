import Vector2D from "./util/vector2d.mjs";
import Stencils from "./util/stencils.mjs";
import { withState } from "./util/canvas.mjs";
import Mouse from "./mouse.mjs";

let canvas;
let ctx;
let mouse = Mouse();
let player = {
  position: { x: 0, y: 0 },
  direction: { x: 0, y: 0 }
};

const MAX_BOUNCES = 10;

const walls = [
  { start: { x: -60, y: 200 }, end: { x: 200, y: 100 } },
  { start: { x: 200, y: 100 }, end: { x: 300, y: 0 } },
  { start: { x: 300, y: 0 }, end: { x: 300, y: -200 } },
  { start: { x: 300, y: -200 }, end: { x: 200, y: -300 } },
  { start: { x: 200, y: -300 }, end: { x: 0, y: -300 } },
  { start: { x: 0, y: -300 }, end: { x: -200, y: -200 } },
  { start: { x: -200, y: -200 }, end: { x: -300, y: 0 } },
  { start: { x: -300, y: 0 }, end: { x: -300, y: 200 } },
  { start: { x: -300, y: 200 }, end: { x: -200, y: 300 } },
  { start: { x: -200, y: 300 }, end: { x: -60, y: 200 } }
];

const drawOrigin = function drawOrigin() {
  Stencils.plus(ctx, {
    x: 0,
    y: 0,
    size: 30,
    stroke: 'hsl(180deg, 100%, 50%)',
    strokeSize: 2
  });
};

const drawWalls = function drawWalls() {
  withState(ctx, () => {
    ctx.strokeStyle = 'white';
    walls.forEach(wall => {
      ctx.beginPath();
      ctx.moveTo(wall.start.x, wall.start.y);
      ctx.lineTo(wall.end.x, wall.end.y);
      ctx.stroke();
    });
  });
};

const drawPlayer = function drawPlayer() {
  Stencils.circle(ctx, {
    x: player.position.x,
    y: player.position.y,
    radius: 5,
    fill: 'hsl(180deg, 100%, 50%)'
  });
};

const slope = function slope({ start, end }) {
  return ((end.y - start.y) / (end.x - start.x));
};

const yIntercept = function yIntercept({ start, end }) {
  return start.y - slope({ start, end }) * start.x;
};

const findIntersection = function checkIntersection(source, ray, wall) {
  const { start, end } = wall;
  const rayStart = source;
  const rayEnd = Vector2D.add(source, ray);

  if (wall.start.x === wall.end.x) {
    if (rayStart.x === rayEnd.x) {
      return null;
    }
    const raySlope = slope({ start: rayStart, end: rayEnd });
    const rayYIntercept = yIntercept({ start: rayStart, end: rayEnd });

    const x = wall.start.x;
    const y = raySlope * x + rayYIntercept;

    if (
      y >= Math.min(start.y, end.y) &&
      y <= Math.max(start.y, end.y)
    ) {
      return { x, y };
    } else {
      return null;
    }
  }
  const wallSlope = slope(wall);
  const wallYIntercept = yIntercept(wall);
  const raySlope = slope({ start: rayStart, end: rayEnd });
  const rayYIntercept = yIntercept({ start: rayStart, end: rayEnd });

  if (wallSlope === raySlope) {
    return null;
  }

  const x = (rayYIntercept - wallYIntercept) / (wallSlope - raySlope);
  const y = wallSlope * x + wallYIntercept;

  if (
    x >= Math.min(start.x, end.x) &&
    x <= Math.max(start.x, end.x) &&
    y >= Math.min(start.y, end.y) &&
    y <= Math.max(start.y, end.y)
  ) {
    return { x, y };
  } else {
    return null;
  }
};

const drawLaser = function drawLaser() {
  const direction = Vector2D.sub(player.direction, player.position);
  // const localDirection = Vector2D.add(player.position, direction);
  // const beamStart = Vector2D.scale(direction, 500);

  for (const wall of walls) {
    const intersection = findIntersection(player.position, direction, wall);
    if (intersection) {
      Stencils.circle(ctx, {
        x: intersection.x,
        y: intersection.y,
        radius: 5,
        fill: 'hsl(180deg, 100%, 50%)'
      });

      ctx.beginPath();
      ctx.moveTo(player.position.x, player.position.y);
      ctx.lineTo(intersection.x, intersection.y);
      ctx.strokeStyle = 'hsl(180deg, 100%, 50%)';
      ctx.stroke();
    }
  }

  // ctx.beginPath();
  // ctx.moveTo(player.position.x, player.position.y);
  // ctx.lineTo(beamStart.x, beamStart.y);
  // ctx.strokeStyle = 'hsl(180deg, 100%, 50%)';
  // ctx.stroke();
};

const draw = function draw() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  const half_window_width = canvas.width / 2;
  const half_window_height = canvas.height / 2;

  withState(ctx, () => {
    ctx.transform(1, 0, 0, 1, half_window_width, half_window_height);

    drawOrigin();
    drawWalls();
    drawPlayer();
    drawLaser();
  });
};

const enqueueRerender = () => {
  requestAnimationFrame(draw);
};

mouse.on('mouseMove', ({ x, y }) => {
  const half_window_width = canvas.width / 2;
  const half_window_height = canvas.height / 2;

  player.direction.x = x - half_window_width;
  player.direction.y = y - half_window_height;

  enqueueRerender();
});

mouse.on('mouseDown', ({ x, y }) => {
  player.position.x = x - canvas.width / 2;
  player.position.y = y - canvas.height / 2;

  console.log(player);

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
