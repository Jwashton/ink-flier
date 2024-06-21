import { withState } from "./canvas.mjs";
import Stencils from "./stencils.mjs";
import View from './view.mjs';
import TouchList from "./touch.mjs";
import Mouse from "./mouse.mjs";

/************************************
 * Scene state                      *
 ************************************/

const camera = View();
const touchList = TouchList();
const mouse = Mouse();

const objects = [];

[...Array(80).keys()].forEach(n => {
  objects.push({
    type: 'square',
    x: (n % 10) * 50,
    y: Math.trunc(n / 10) * 50,
    size: 50,
    fill: `hsl(${n * 20} 90% 80%)`
  });
});

[
  { type: 'square', x: 20, y: 20, size: 20, fill: '#30a0aa' },
  { type: 'circle', x: 60, y: 40, radius: 25, fill: '#ffbb50' },
  { type: 'square', x: 80, y: 50, size: 30, fill: '#15ddaa' }
].forEach(object => {
  objects.push(object);
});

/************************************
 * Canvas management                *
 ************************************/
const draw = function draw(context) {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height);
  withState(context, ctx => {
    context.transform(...camera.matrix);
    for (const object of objects) {
      Stencils[object.type](context, object);
    }
  });
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
// - Be able to lerp from one camera place to another (automated transitions)
// - Be able to select objects in the scene
// - Set up race grid
// - Define track

const init = function init() {
  const canvas = document.getElementById('mainView');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  const context = canvas.getContext('2d');

  const controlForm = document.getElementById('viewControls');

  if (navigator.maxTouchPoints > 1) {
    controlForm.classList.add('touch');
  }

  const rotationInput = document.getElementById('rotation');
  const scaleInput = document.getElementById('scale');
  const debugView = document.getElementById('debug');
  updateDebugView(debugView);

  Mouse.bind(mouse, canvas);
  Mouse.on(mouse, 'dragStart', () => {
    View.startDrag(camera, mouse.position);

    updateDebugView(debugView);
  });

  Mouse.on(mouse, 'dragMove', () => {
    View.moveDrag(camera, mouse.position);

    updateDebugView(debugView);
    enqueueRerender(context);
  });

  TouchList.bind(touchList, canvas);
  TouchList.on(touchList, 'pinchStart', list => {
    View.startPinch(camera, ...TouchList.firstTwo(list));

    updateDebugView(debugView);
  });

  TouchList.on(touchList, 'pinchMove', list => {
    View.movePinch(camera, ...TouchList.firstTwo(list));

    updateDebugView(debugView);
    rotationInput.value = camera.rotation;
    scaleInput.value = camera.scale;
    enqueueRerender(context);
  });

  TouchList.on(touchList, 'touchStart', list => {
    updateDebugView(debugView);
  });

  TouchList.on(touchList, 'touchMove', list => {
    updateDebugView(debugView);
  });

  TouchList.on(touchList, 'touchEnd', list => {
    updateDebugView(debugView);
  });

  camera.rotation = Number(rotationInput.value);
  camera.scale = Number(scaleInput.value);
  View.update(camera);
  updateDebugView(debugView);
  enqueueRerender(context);

  rotationInput.addEventListener('input', event => {
    camera.rotation = Number(event.target.value);
    View.update(camera);
    updateDebugView(debugView);
    enqueueRerender(context);
  });

  scaleInput.addEventListener('input', event => {
    camera.scale = Number(event.target.value);
    View.update(camera);
    updateDebugView(debugView);
    enqueueRerender(context);
  });

  registerEventCallbacks(canvas, debugView);
  enqueueRerender(context);
};

init();
