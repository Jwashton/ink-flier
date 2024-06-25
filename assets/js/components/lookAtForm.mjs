import Subscribable from '../util/subscribable.mjs';
import View from '../view.mjs';

const handleXInput = function handleXInput(lookAtForm, event) {
  View.setX(lookAtForm.camera, Number(event.target.value));

  Subscribable.dispatch(lookAtForm, 'update', { x: Number(event.target.value) });
};

const handleYInput = function handleYInput(lookAtForm, event) {
  View.setY(lookAtForm.camera, Number(event.target.value));

  Subscribable.dispatch(lookAtForm, 'update', { y: Number(event.target.value) });
};

const handleRotationInput = function handleRotationInput(lookAtForm, event) {
  View.setRotation(lookAtForm.camera, Number(event.target.value));

  Subscribable.dispatch(lookAtForm, 'update', { rotation: Number(event.target.value) });
};

const handleScaleInput = function handleScaleInput(lookAtForm, event) {
  View.setScale(lookAtForm.camera, Number(event.target.value));

  Subscribable.dispatch(lookAtForm, 'update', { scale: Number(event.target.value) });
};

const handleSubmit = function handleSubmit(lookAtForm, event) {
  event.preventDefault();

  console.log('submitting...', lookAtForm);

  Subscribable.dispatch(lookAtForm, 'submit', { view: lookAtForm.camera });

  lookAtForm.camera = View();
  View.setAll(lookAtForm.camera, {
    position: { x: Number(lookAtForm.inputs.x.value), y: Number(lookAtForm.inputs.y.value) },
    rotation: Number(lookAtForm.inputs.rotation.value),
    scale: Number(lookAtForm.inputs.scale.value)
  });
};

export const LookAtForm = function LookAtForm(touchEnabled) {
  const state = {
    camera: View(),
    touchEnabled,
    form: undefined,
    inputs: { x: undefined, y: undefined, rotation: undefined, scale: undefined }
  };

  return Subscribable(state, ['update', 'submit']);
};

LookAtForm.bind = function bind(lookAtForm) {
  lookAtForm.form = document.getElementById('lookAtControls');
  lookAtForm.inputs.x = document.getElementById('lookAtX');
  lookAtForm.inputs.y = document.getElementById('lookAtY');
  lookAtForm.inputs.rotation = document.getElementById('lookAtRotation');
  lookAtForm.inputs.scale = document.getElementById('lookAtScale');

  lookAtForm.form.addEventListener('submit', event => handleSubmit(lookAtForm, event));
  lookAtForm.inputs.x.addEventListener('input', event => handleXInput(lookAtForm, event));
  lookAtForm.inputs.y.addEventListener('input', event => handleYInput(lookAtForm, event));
  lookAtForm.inputs.rotation.addEventListener('input', event => handleRotationInput(lookAtForm, event));
  lookAtForm.inputs.scale.addEventListener('input', event => handleScaleInput(lookAtForm, event));
};

export default LookAtForm
