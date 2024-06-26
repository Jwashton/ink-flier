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

const MAX_BOUNCES = 5;

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

  const raySlope = slope({ start: rayStart, end: rayEnd });
  const rayYIntercept = yIntercept({ start: rayStart, end: rayEnd });

  let x, y;

  if (wall.start.x === wall.end.x) {
    if (rayStart.x === rayEnd.x) {
      return null;
    }

    x = wall.start.x;
    y = raySlope * x + rayYIntercept;
  } else {
    const wallSlope = slope(wall);
    const wallYIntercept = yIntercept(wall);

    if (raySlope === wallSlope) {
      return null;
    }

    if (rayStart.x === rayEnd.x) {
      x = rayStart.x;
      y = wallSlope * x + wallYIntercept;
    } else {
      x = (rayYIntercept - wallYIntercept) / (wallSlope - raySlope);
      y = raySlope * x + rayYIntercept;
    }
  }

  if (
    x >= Math.min(start.x, end.x) &&
    x <= Math.max(start.x, end.x) &&
    y >= Math.min(start.y, end.y) &&
    y <= Math.max(start.y, end.y) &&
    Vector2D.dot(Vector2D.sub({ x, y }, source), ray) > 0
  ) {
    return { x, y };
  } else {
    return null;
  }
};

const normal = function normal(wall) {
  const { start, end } = wall;
  const dx = end.x - start.x;
  const dy = end.y - start.y;

  return Vector2D.normalize({ x: dy, y: -dx });
};

const findWall = function findWall(source, ray) {
  return walls.reduce((closest, wall) => {
    const intersection = findIntersection(source, ray, wall);
    if (!intersection) {
      return closest;
    }

    const distance = Vector2D.distance(source, intersection);
    if (distance < closest.distance) {
      return { wall, intersection, distance };
    }
  
    return closest;
  }, { wall: null, intersection: null, distance: Infinity });
};

const drawBeam = function drawBeam(origin, direction, bounces) {
  if (bounces === 0) {
    return;
  }

  const beamEnd = Vector2D.add(origin, direction);
  const closestWall = findWall(origin, direction);

  if (closestWall.wall) {
    const { wall, intersection } = closestWall;
    const n = normal(wall);
    const reflection = Vector2D.sub(direction, Vector2D.scale(n, 2 * Vector2D.dot(direction, n)));

    ctx.beginPath();
    ctx.moveTo(origin.x, origin.y);
    ctx.lineTo(intersection.x, intersection.y);
    ctx.strokeStyle = 'hsl(180deg, 100%, 50%)';
    ctx.stroke();

    drawBeam(intersection, reflection, bounces - 1);
  }
}

const drawLaser = function drawLaser() {
  const direction = Vector2D.sub(player.direction, player.position);

  drawBeam(player.position, direction, MAX_BOUNCES);
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
