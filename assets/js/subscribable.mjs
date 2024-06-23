export const Subscribable = function (object, events) {
  object.subscribers = {};

  for (const event of events) {
    object.subscribers[event] = [];
  }

  object.on = function on(event, callback) {
    if (!object.subscribers[event]) {
      throw new Error(`Event ${event} is not supported by this object.`);
    }

    object.subscribers[event].push(callback);

    return object;
  };

  return object;
};

Subscribable.dispatch = function (object, event) {
  for (const callback of object.subscribers[event]) {
    callback(object);
  }
};

export default Subscribable;