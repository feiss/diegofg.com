import * as THREE from 'three';

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);

const renderer = new THREE.WebGLRenderer({
    canvas: document.getElementById('scene3d'),
    antialias: true,
});
renderer.setClearColor(new THREE.Color('#F2EFE6'));//'#F2EFE6'
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setAnimationLoop(animate);
renderer.setPixelRatio(window.devicePixelRatio * 1.5);

const geometry = new THREE.TorusGeometry();
const material = new THREE.MeshMatcapMaterial();
const matcapTexture = new THREE.TextureLoader().load('res/matcap.png');
material.matcap = matcapTexture;
const cube = new THREE.Mesh(geometry, material);

scene.add(cube);

camera.position.z = 3;

function animate(time) {
    // cube.rotation.x = time / 2000;
    // cube.rotation.y = time / 1000;
    camera.position.y = -document.body.scrollTop / 500;
    camera.rotation.x = document.body.scrollTop / 2000;
    renderer.render(scene, camera);
}

var tanFOV = Math.tan(((Math.PI / 180) * camera.fov / 2));
var windowHeight = window.innerHeight;
window.addEventListener('resize', onWindowResize, false);

function onWindowResize() {
    console.log('resize')
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.fov = (360 / Math.PI) * Math.atan(tanFOV * (window.innerHeight / windowHeight));

    camera.updateProjectionMatrix();
    camera.lookAt(scene.position);

    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.render(scene, camera);

}
