library energy2d;

import 'dart:async';
import 'dart:html';
import 'dart:isolate';
import 'dart:math' as Math;

//import 'dart:js' as JavaScript;
//import 'package:three/three.dart';

part 'component.dart';

final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D context = canvas.context2D;
final HtmlElement appletWindow = querySelector("#applet_window");
final HtmlElement overlay = querySelector("#overlay");

ImageElement backgroundImage = new ImageElement(src: "house.png");

ImageData imageData;
List<int> pixels;

Component selectedComponent;
num dragStartPointX, dragStartPointY;
bool drag = false;

List<Component> components = new List<Component>();

Math.Random random = new Math.Random(0);

void main() {
  
  // set up our receive port callback
  ReceivePort port = new ReceivePort();
  port.listen(waitForResults);

  // launch the worker thread
  List<String> inputs = [1.0, 2.0];
  Future future = Isolate.spawnUri(new Uri.file("solver.dart"), inputs, port.sendPort);
  future.then((value) => print("${value}"));
   
  Component c = new Component(20, 20, 40, 40);
  components.add(c);

  c = new Component(200, 20, 30, 30);
  c.fillStyle = "rgba(0, 255, 0, 0.5)";
  components.add(c);

  _bind();

  // backgroundImage.onLoad.listen((e) => requestRedraw());
  
  imageData = context.getImageData(0, 0, canvas.width, canvas.height);
  pixels = imageData.data;
  
  window.animationFrame.then(_vizLoop);
  
}

// called in our main thread to update the display
void waitForResults(List<double> results) {
  print ("We are ${(results[0]*100).toInt()}% ${results[3]} done.");
}

void _bind() {
  canvas.onDoubleClick.listen(_onCanvasDoubleClick);
  canvas.onMouseMove.listen(_onCanvasMouseMove);
  canvas.onMouseDown.listen(_onCanvasMouseDown);
  canvas.onMouseUp.listen(_onCanvasMouseUp);
  overlay.onMouseDown.listen(_onOverlayMouseDown);  
}

/* interactivity */

// canvas

void _onCanvasDoubleClick(MouseEvent e) {
  e.preventDefault();
  selectedComponent = null;
  drag = false;
  for(Component c in components) {
    if (contains(e.client, c.boundBox)) {
      appletWindow.style.display = "block";
      overlay.style.display = "block";
    }
  }
  requestRedraw();
  e.stopPropagation();
}

void _onCanvasMouseDown(MouseEvent e) {
  e.preventDefault();
  selectedComponent = null;
  for(Component c in components) {
    if(contains(e.client, c.boundBox)) {
      selectedComponent = c;
      drag = true;
      Math.Point p = getRelativePoint(e.client);
      dragStartPointX = p.x - selectedComponent.boundBox.left;
      dragStartPointY = p.y - selectedComponent.boundBox.top;
      break;
    }
  }
  e.stopPropagation();
}

void _onCanvasMouseMove(MouseEvent e) {
  e.preventDefault();
  if(drag) {
    if(selectedComponent != null) {
      canvas.style.cursor = "pointer";
      Math.Point p1 = e.client;
      if (p1.x == 0 && p1.y == 0) return;
      Math.Point p2 = getRelativePoint(p1);
      selectedComponent.boundBox.left = p2.x - dragStartPointX;
      selectedComponent.boundBox.top = p2.y - dragStartPointY;
      requestRedraw();
    }    
  } else {
    bool b = false;
    for(Component c in components) {
      b = contains(e.client, c.boundBox);
      if(b) break;
    }
    canvas.style.cursor = b? "move" : "default";
  }
  e.stopPropagation();
}

void _onCanvasMouseUp(MouseEvent e) {
  e.preventDefault();
  selectedComponent = null;
  drag = false;
  e.stopPropagation();
}


// others

void _onOverlayMouseDown(MouseEvent e) {
  appletWindow.style.display = "none";
  overlay.style.display = "none";
  requestRedraw();
}



/* visualization */

void _vizLoop(num delta) {
  components.forEach((c) => c.move(random.nextInt(10) - 5, random.nextInt(10) - 5));
  requestRedraw();
  window.animationFrame.then(_vizLoop);
}

void requestRedraw() {
  clear();
  _drawImageData();
  context.drawImage(backgroundImage, 0, 20);
  components.forEach((c) => _drawComponent(c));
}

void clear() {
  context.clearRect(0, 0, canvas.width, canvas.height);
}

void _drawComponent(Component c) {
  context..lineWidth = c.lineWidth
         ..fillStyle = c.fillStyle
         ..fillRect(c.boundBox.left, c.boundBox.top, c.boundBox.width, c.boundBox.height)
         ..strokeStyle = c.strokeColor
         ..strokeRect(c.boundBox.left, c.boundBox.top, c.boundBox.width, c.boundBox.height);  
}

void _drawImageData() {
  int w = canvas.width;
  int h = canvas.height;
  int i = 0;
  double r = random.nextDouble();
  for(int y = 0; y < h; y++) {
    for(int x = 0; x < w; x++) {
      i = 4 * (y * w + x);
      pixels[i] = (255 * r * (1 - x / w)).round();
      pixels[i + 1] = 0;
      pixels[i + 2] = (255 * r * (x / w)).round();
      pixels[i + 3] = 128;
    }
  }
  context.putImageData(imageData, 0, 0);
}



/* utilities */

Math.Point getRelativePoint(Math.Point p) {
  Math.Rectangle boundRect = canvas.getBoundingClientRect();
  return new Math.Point(p.x - boundRect.left, p.y - boundRect.top);
}

bool contains(Math.Point p, Math.Rectangle r) {
  Math.Point p2 = getRelativePoint(p);
  num x = p2.x;
  num y = p2.y;
  return x > r.left && x < r.left + r.width && y > r.top && y < r.top + r.height;
}

