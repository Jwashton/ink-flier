const lerp = function lerp(a, b, t) {
  return a + (b - a) * t;
};

export const Animation = function Animation(duration, start, stop) {
  const startTime = performance.now();
  const endTime = startTime + duration;

  const animation = {
    current() {
      console.log('duration', duration);
      console.log('now', performance.now());
      console.log(startTime);
      return lerp(start, stop, (performance.now() - startTime) / duration);
    },

    finished() {
      return performance.now() >= endTime;
    }
  };

  return animation;
};

export default Animation;

