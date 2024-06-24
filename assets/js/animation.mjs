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
    animation.current = () => {
      const t = (performance.now() - startTime) / duration;

      return {
        x: lerp(start.x, stop.x, t),
        y: lerp(start.y, stop.y, t)
      };
    };
  } else if (isView(start) && isView(stop)) {
    animation.current = () => {
      const t = (performance.now() - startTime) / duration;

      return {
        position: {
          x: lerp(start.position.x, stop.position.x, t),
          y: lerp(start.position.y, stop.position.y, t)
        },
        rotation: lerp(start.rotation, stop.rotation, t),
        scale: lerp(start.scale, stop.scale, t)
      };
    };
  } else {
    throw new Error('Unsupported animation');
  }

  return animation;
};

export default Animation;

