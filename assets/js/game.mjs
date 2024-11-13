import * as THREE from 'three';

const scene = new THREE.Scene();
const camera = new THREE.OrthographicCamera(window.innerWidth / -2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / -2, 1, 1000);

const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);


const geometry = new THREE.BufferGeometry();
const vertices = new Float32Array([
  -20.0, -20.0, 0.0,
  20.0, -20.0, 0.0,
  0.0, 20.0, 0.0
]);
geometry.setAttribute('position', new THREE.BufferAttribute(vertices, 3));
const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
const cube = new THREE.Mesh(geometry, material);
scene.add(cube);

camera.position.z = 100;


const animate = function () {
  renderer.render(scene, camera);

  cube.rotation.x += 0.01;
  cube.rotation.y += 0.01;
};

renderer.setAnimationLoop(animate);
