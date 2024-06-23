import Subscribable from '../subscribable.mjs';
import View from '../view.mjs';

const handleRotationInput = function handleRotationInput(controlForm, event) {
  View.setRotation(controlForm.camera, Number(event.target.value));
  
  Subscribable.dispatch(controlForm, 'update', { rotation: Number(event.target.value) });
};

const handleScaleInput = function handleScaleInput(controlForm, event) {
  View.setScale(controlForm.camera, Number(event.target.value));
  
  Subscribable.dispatch(controlForm, 'update', { scale: Number(event.target.value) });
};

export const ControlForm = function ControlForm(camera, touchEnabled) {
  const state = {
    camera,
    touchEnabled,
    form: undefined,
    inputs: { rotation: undefined, scale: undefined }
  };

  return Subscribable(state, ['update']);
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

export default ControlForm;