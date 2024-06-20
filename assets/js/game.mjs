import { withState } from "./canvas.mjs";
import Stencils from "./stencils.mjs";
import View from './view.mjs';

/************************************
 * Scene state                      *
 ************************************/

const camera = View();

const objects = [
  { type: 'square', x: 20, y: 20, size: 20, fill: '#30a0aa' },
  { type: 'circle', x: 60, y: 40, radius: 25, fill: '#ffbb50' },
  { type: 'square', x: 80, y: 50, size: 30, fill: '#15ddaa' }
];

[...Array(20).keys()].forEach(n => {
  objects.push({
    type: 'square',
    x: n * 4 + 20,
    y: 50 - Math.sqrt(n * 20),
    size: 3,
    fill: `hsl(${n * 20} 90% 80%)`
  });
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

const updateDebugView = function updateDebugView(element) {
  element.textContent = JSON.stringify(camera, null, 2);
}

const registerEventCallbacks = function registerEventCallbacks(canvas, context) {

};

const init = function init() {
  const canvas = document.getElementById('mainView');
  const context = canvas.getContext('2d');

  const rotationInput = document.getElementById('rotation');
  const scaleInput = document.getElementById('scale');
  const debugView = document.getElementById('debug');
  updateDebugView(debugView);

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

  registerEventCallbacks(canvas, context);
  enqueueRerender(context);
};

init();
