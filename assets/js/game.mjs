import { withState } from "./canvas.mjs";
import Animation from "./animation.mjs";
import Stencils from "./stencils.mjs";
import View from './view.mjs';
import TouchList from "./touch.mjs";
import Mouse from "./mouse.mjs";
import ControlForm from "./components/controlForm.mjs";
import LookAtForm from "./components/lookAtForm.mjs";

/************************************
 * Scene state                      *
 ************************************/

const camera = View();
const touchList = TouchList();
const mouse = Mouse();
const controlForm = ControlForm(camera, navigator.maxTouchPoints > 1);
const lookAtForm = LookAtForm();
let animating = false;
let animation;

const objects = [];

const graphColor = window.currentTheme() === 'dark' ? 'hsl(60deg 22% 86%)' : 'hsl(26deg 47% 6%)';

DOT_ROW_COUNT = 40;
DOT_SPACING = 50;
DOT_SIZE = 4;
DOT_HALF_SIZE = DOT_SIZE / 2;
DOT_HALF_ROW_COUNT = Math.trunc(DOT_ROW_COUNT / 2);
DOT_ROW_HALF_LENGTH = DOT_HALF_ROW_COUNT * DOT_SPACING;
console.log(DOT_ROW_HALF_LENGTH);

[...Array(DOT_ROW_COUNT ** 2).keys()].forEach(n => {
  objects.push({
    type: 'square',
    x: (n % DOT_ROW_COUNT) * DOT_SPACING - DOT_ROW_HALF_LENGTH - DOT_HALF_SIZE,
    y: Math.trunc(n / DOT_ROW_COUNT) * DOT_SPACING - DOT_ROW_HALF_LENGTH - DOT_HALF_SIZE,
    size: DOT_SIZE,
    fill: graphColor
  });
});

[
  { type: 'car', x: 50, y: 150, size: 25, fill: 'hsl(185deg, 56%, 43%)' },
  { type: 'car', x: 100, y: 100, size: 25, fill: 'hsl(37deg, 100%, 66%)' },
  { type: 'car', x: 150, y: 150, size: 25, fill: 'hsl(165deg, 83%, 47%)' },
  { type: 'car', x: 50, y: 100, size: 25, fill: 'hsl(20deg, 80%, 50%)' }
].forEach(object => {
  objects.push(object);
});

lookAtForm.on('submit', ({ view }) => {
  animating = true;
  console.log('submitted', view)
  animation = Animation(1000, View.scale(camera), View.scale(view));
  // View.setPosition(camera, View.position(view));
  // View.setRotation(camera, View.rotation(view));
});

/************************************
 * Canvas management                *
 ************************************/
const draw = function draw(context) {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height);

  if (animating) {
    console.log(animating);
    View.setScale(camera, animation.current());
    console.log(animation.current());

    if (animation.finished()) {
      animating = false;
    }
  }

  withState(context, () => {
    context.transform(...View.matrix(camera));
    for (const object of objects) {
      Stencils[object.type](context, object);
    }
  });

  if (animating) {
    enqueueRerender(context);
  }
};

const enqueueRerender = function enqueueRerender(context) {
  window.requestAnimationFrame(() => {
    draw(context);
  });
};

const debugValue = function debugValue(value, name) {
  const section = document.createElement('section');
  const header = document.createElement('h2');
  const code = document.createElement('pre');

  header.textContent = name;
  code.textContent = JSON.stringify(value, null, 2);

  section.appendChild(header);
  section.appendChild(code);

  return section;
};

const updateDebugView = function updateDebugView(element) {
  // element.innerHTML = '';
  // element.appendChild(debugValue(camera, 'camera'));
  // element.appendChild(debugValue(touchList, 'touchList'));
};

const registerEventCallbacks = function registerEventCallbacks(canvas, debugView) {
};

// Todos:
// - Scroll to zoom
// - Be able to lerp from one camera place to another (automated transitions)
// - Be able to select objects in the scene
// - Set up race grid
// - Define track

mouse.on('dragStart', () => {
  View.startDrag(camera, mouse.position);
});

touchList.on('pinchStart', () => {
  View.startPinch(camera, ...TouchList.firstTwo(touchList));
});

const init = function init() {
  const canvas = document.getElementById('mainView');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  View.setPosition(camera, { x: canvas.width / 2, y: canvas.height / 2 });
  ControlForm.bind(controlForm);
  LookAtForm.bind(lookAtForm);

  lookAtForm.on('submit', (_form) => {
    enqueueRerender(context);
  });

  const currentValues = ControlForm.currentValues(controlForm);

  View.setRotation(camera, Number(currentValues.rotation));
  View.setScale(camera, Number(currentValues.scale));

  controlForm.on('update', () => {
    enqueueRerender(context);
  });

  const context = canvas.getContext('2d');

  const debugView = document.getElementById('debug');
  updateDebugView(debugView);

  Mouse.bind(mouse, canvas);

  mouse.on('dragMove', () => {
    View.moveDrag(camera, mouse.position);

    updateDebugView(debugView);
    enqueueRerender(context);
  });

  TouchList.bind(touchList, canvas);

  touchList.on('pinchMove', () => {
    View.movePinch(camera, ...TouchList.firstTwo(touchList));

    updateDebugView(debugView);
    enqueueRerender(context);
  });

  updateDebugView(debugView);
  enqueueRerender(context);

  registerEventCallbacks(canvas, debugView);
  enqueueRerender(context);
};

init();
