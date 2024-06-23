import Subscribable from "./subscribable.mjs";

// Private functions
const copyTouch = function copyTouch({ identifier, pageX, pageY }) {
  return { identifier, x: pageX, y: pageY };
};

const handleStart = function handleStart(touchList, event) {
  event.preventDefault();

  for (const touch of event.changedTouches) {
    touchList.points[touch.identifier] = copyTouch(touch);
    touchList.ids.push(touch.identifier);
  }

  Subribable.dispatch(touchList, 'touchStart', {});

  if (Object.keys(touchList.points).length === 2) {
    Subribable.dispatch(touchList, 'pinchStart', {});
  }
};

const handleMove = function handleMove(touchList, event) {
  event.preventDefault();

  for (const touch of event.changedTouches) {
    touchList.points[touch.identifier] = copyTouch(touch);
  }

  Subribable.dispatch(touchList, 'touchMove', {});

  if (Object.keys(touchList.points).length >= 2) {
    Subribable.dispatch(touchList, 'pinchMove', {});
  }
};

const handleEnd = function handleEnd(touchList, event) {
  event.preventDefault();

  for (const touch of event.changedTouches) {
    delete touchList.points[touch.identifier];
    touchList.ids = touchList.ids.filter(id => id !== touch.identifier);
  }

  Subribable.dispatch(touchList, 'touchEnd', {});
};

const handleCancel = function handleCancel(touchList, event) {
  event.preventDefault();

  for (const touch of event.changedTouches) {
    delete touchList.points[touch.identifier];
    touchList.ids = touchList.ids.filter(id => id !== touch.identifier);
  }

  Subribable.dispatch(touchList, 'touchCancel', {});
};

// Public functions
export const TouchList = function TouchList() {
  const touchList = {
    callbacks: {
      'pinchStart': [],
      'pinchMove': [],
      'touchStart': [],
      'touchMove': [],
      'touchEnd': [],
      'touchCancel': []
    },
    points: {},
    ids: []
  };

  return Subscribable(touchList, ['pinchStart', 'pinchMove', 'touchStart', 'touchMove', 'touchEnd', 'touchCancel']);
};

TouchList.firstTwo = function firstTwo(touchList) {
  return [
    touchList.points[touchList.ids[0]],
    touchList.points[touchList.ids[1]]
  ];
};

TouchList.bind = function bind(touchList, element) {
  element.addEventListener('touchstart', (event) => handleStart(touchList, event));
  element.addEventListener('touchmove', (event) => handleMove(touchList, event));
  element.addEventListener('touchend', (event) => handleEnd(touchList, event));
  element.addEventListener('touchcancel', (event) => handleCancel(touchList, event));
};

export default TouchList;
