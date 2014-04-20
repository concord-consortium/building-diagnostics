var container;
var appletWindow;
var overlay;
var loadConductionButton;
var loadConvectionButton;
var scene;
var camera;
var renderer;

init();
animate();

function init() {

	container = document.getElementById("container");
	appletWindow = document.getElementById("applet_window");
	overlay = document.getElementById("overlay");
	loadConductionButton = document.getElementById("load_conduction");
	loadConvectionButton = document.getElementById("load_convection");

	scene = new THREE.Scene();
	var WIDTH = 800, HEIGHT = 800;

	renderer = new THREE.WebGLRenderer({
		antialias : true
	});
	renderer.setSize(WIDTH, HEIGHT);
	renderer.setClearColor(0x00ccff, 1);
	container.appendChild(renderer.domElement);
	container.addEventListener('click', function(evt) {
		alert(evt.clientX);
	}, false);

	camera = new THREE.PerspectiveCamera(45, WIDTH / HEIGHT, 0.1, 10000);
	camera.position.set(0, 20, 180);
	scene.add(camera);

	// window.addEventListener('resize', function() {
	// var WIDTH = window.innerWidth, HEIGHT = window.innerHeight;
	// renderer.setSize(WIDTH, HEIGHT);
	// camera.aspect = WIDTH / HEIGHT;
	// camera.updateProjectionMatrix();
	// });

	var vertexShader = document.getElementById('vertexShader').textContent;
	var fragmentShader = document.getElementById('fragmentShader').textContent;
	var uniforms = {
		topColor : {
			type : "c",
			value : new THREE.Color(0x000000)
		},
		bottomColor : {
			type : "c",
			value : new THREE.Color(0x262626)
		},
		offset : {
			type : "f",
			value : 100
		},
		exponent : {
			type : "f",
			value : 0.7
		}
	}

	var lightAmb = new THREE.AmbientLight(0x555555);
	scene.add(lightAmb);

	var light = new THREE.PointLight(0xffffff, 1.0);
	light.position.set(-100, 200, 100);
	scene.add(light);

	var sphereSize = 1;
	var pointLightHelper = new THREE.PointLightHelper(light, sphereSize);
	scene.add(pointLightHelper);

	var light2 = new THREE.PointLight(0xd7f0ff, 0.2);
	light2.position.set(200, 200, 1000);
	scene.add(light2);

	var sphereSize = 1;
	var pointLightHelper2 = new THREE.PointLightHelper(light2, sphereSize);
	scene.add(pointLightHelper2);

	var light3 = new THREE.PointLight(0xFFFFFF, 0.5);
	light3.position.set(150, 200, -100);
	scene.add(light3);

	var sphereSize = 1;
	var pointLightHelper3 = new THREE.PointLightHelper(light3, sphereSize);
	scene.add(pointLightHelper3);

	var directionalLight = new THREE.DirectionalLight(0xffffff);
	directionalLight.position.set(-1, 0, 0).normalize();
	scene.add(directionalLight);

	var gridXZ = new THREE.GridHelper(400, 10);
	gridXZ.setColors(new THREE.Color(0x336633), new THREE.Color(0x336633));
	gridXZ.position.set(0, 0, 0);
	scene.add(gridXZ);

	var axes = new THREE.AxisHelper(1000);
	axes.position.set(0, 0, 0);
	scene.add(axes);

	var loaderEnabled = true;
	if (loaderEnabled) {
		var loader = new THREE.ColladaLoader();
		loader.options.convertUpAxis = true;
		loader.load('house.dae', function(collada) {
			var dae = collada.scene;
			var skin = collada.skins[0];
			dae.position.set(0, 0, 0); // x, z, y
			dae.scale.set(0.1, 0.1, 0.1);
			scene.add(dae);
		});
	}

	controls = new THREE.OrbitControls(camera, renderer.domElement);

}

function animate() {

	requestAnimationFrame(animate);
	renderer.render(scene, camera);
	controls.update();

}
