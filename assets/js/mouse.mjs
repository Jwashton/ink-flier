// Private functions
const dispatch = function dispatch(mouse, event) {
  for (const callback of mouse.callbacks[event]) {
    callback(mouse);
  }
};

const handleStart = function handleStart(mouse, event) {
  event.preventDefault();

  mouse.position = { x: event.pageX, y: event.pageY };
  mouse.dragging = true;

  dispatch(mouse, 'mouseDown');
  dispatch(mouse, 'dragStart');
};

const handleMove = function handleMove(mouse, event) {
  event.preventDefault();

  mouse.position = { x: event.pageX, y: event.pageY };

  dispatch(mouse, 'mouseMove');

  if (mouse.dragging) {
    dispatch(mouse, 'dragMove');
  }
};

const handleEnd = function handleEnd(mouse, event) {
  event.preventDefault();

  mouse.dragging = false;

  dispatch(mouse, 'mouseUp');
};

// Public functions
export const Mouse = function Mouse() {
  const mouse = {
    callbacks: {
      'dragStart': [],
      'dragMove': [],
      'mouseDown': [],
      'mouseMove': [],
      'mouseUp': []
    },
    position: { x: 0, y: 0 },
    dragging: false
  };

  return mouse;
};

Mouse.on = function on(mouse, event, callback) {
  if (!mouse.callbacks[event]) {
    return false;
  }

  mouse.callbacks[event].push(callback);

  return true;
};

Mouse.bind = function bind(mouse, element) {
  element.addEventListener('mousedown', (event) => handleStart(mouse, event));
  element.addEventListener('mousemove', (event) => handleMove(mouse, event));
  element.addEventListener('mouseup', (event) => handleEnd(mouse, event));
};

export default Mouse;
