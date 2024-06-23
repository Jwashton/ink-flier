import View from '../view.mjs';

const dispatch = function dispatch(controlForm, event) {
  for (const callback of controlForm.callbacks[event]) {
    callback(controlForm);
  }
};

const handleRotationInput = function handleRotationInput(controlForm, event) {
  View.setRotation(controlForm.camera, Number(event.target.value));
  
  dispatch(controlForm, 'update');
};

const handleScaleInput = function handleScaleInput(controlForm, event) {
  View.setScale(controlForm.camera, Number(event.target.value));
  
  dispatch(controlForm, 'update');
};

export const ControlForm = function ControlForm(camera, touchEnabled) {
  return {
    camera,
    touchEnabled,
    form: undefined,
    inputs: { rotation: undefined, scale: undefined },
    callbacks: { update: [] }
  };
};

ControlForm.bind = function bind(controlForm) {
  controlForm.form = document.getElementById('viewControls');
  controlForm.inputs.rotation = document.getElementById('rotation');
  controlForm.inputs.scale = document.getElementById('scale');

  if (controlForm.touchEnabled) {
    controlForm.form.classList.add('touch');
  }

  controlForm.inputs.rotation.addEventListener('input', event => handleRotationInput(controlForm, event));
  controlForm.inputs.scale.addEventListener('input', event => handleScaleInput(controlForm, event));
};

ControlForm.currentValues = function currentValues(controlForm) {
  return {
    rotation: Number(controlForm.inputs.rotation.value),
    scale: Number(controlForm.inputs.scale.value)
  };
};

ControlForm.on = function on(controlForm, event, callback) {
  if (!controlForm.callbacks[event]) {
    return false;
  }

  controlForm.callbacks[event].push(callback);

  return true;
};

export default ControlForm;