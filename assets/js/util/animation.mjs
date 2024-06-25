const lerp = function lerp(a, b, t) {
  return a + (b - a) * t;
};

const isPoint = function isPoint(object) {
  return object.hasOwnProperty('x') && object.hasOwnProperty('y');
};

const isNumber = function isNumber(object) {
  return typeof object === 'number';
};

const isView = function isView(object) {
  return object.hasOwnProperty('position') && object.hasOwnProperty('rotation') && object.hasOwnProperty('scale');
};

export const Animation = function Animation(duration, start, stop) {
  const startTime = performance.now();
  const endTime = startTime + duration;

  const animation = {
    current: undefined,
    finished() {
      return performance.now() >= endTime;
    }
  };

  if (isNumber(start) && isNumber(stop)) {
    animation.current = () => {
      return lerp(start, stop, (performance.now() - startTime) / duration);
    }
  } else if (isPoint(start) && isPoint(stop)) {
    // Copy the important information in case `start` changes during the animation
    const startX = start.x;
    const startY = start.y;

    animation.current = () => {
      const t = (performance.now() - startTime) / duration;

      return {
        x: lerp(startX, stop.x, t),
        y: lerp(startY, stop.y, t)
      };
    };
  } else if (isView(start) && isView(stop)) {
    // Copy the important information in case `start` changes during the animation
    const startX = start.position.x;
    const startY = start.position.y;
    const startRotation = start.rotation;
    const startScale = start.scale;

    animation.current = () => {
      const t = (performance.now() - startTime) / duration;

      return {
        position: {
          x: lerp(startX, stop.position.x, t),
          y: lerp(startY, stop.position.y, t)
        },
        rotation: lerp(startRotation, stop.rotation, t),
        scale: lerp(startScale, stop.scale, t)
      };
    };
  } else {
    throw new Error('Unsupported animation');
  }

  return animation;
};

export default Animation;

