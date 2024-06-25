import Subscribable from "./util/subscribable.mjs";

// Private functions
const handleStart = function handleStart(mouse, event) {
  event.preventDefault();

  mouse.position = { x: event.pageX, y: event.pageY };
  mouse.dragging = true;

  Subscribable.dispatch(mouse, 'mouseDown', {});
  Subscribable.dispatch(mouse, 'dragStart', {});
};

const handleMove = function handleMove(mouse, event) {
  event.preventDefault();

  mouse.position = { x: event.pageX, y: event.pageY };

  Subscribable.dispatch(mouse, 'mouseMove', {});

  if (mouse.dragging) {
    Subscribable.dispatch(mouse, 'dragMove', {});
  }
};

const handleEnd = function handleEnd(mouse, event) {
  event.preventDefault();

  mouse.dragging = false;

  Subscribable.dispatch(mouse, 'mouseUp', {});
};

// Public functions
export const Mouse = function Mouse() {
  const mouse = {
    position: { x: 0, y: 0 },
    dragging: false
  };

  return Subscribable(mouse, ['dragStart', 'dragMove', 'mouseDown', 'mouseMove', 'mouseUp']);
};

Mouse.bind = function bind(mouse, element) {
  element.addEventListener('mousedown', (event) => handleStart(mouse, event));
  element.addEventListener('mousemove', (event) => handleMove(mouse, event));
  element.addEventListener('mouseup', (event) => handleEnd(mouse, event));
};

export default Mouse;
