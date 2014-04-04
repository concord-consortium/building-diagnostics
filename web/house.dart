library energy2d;

import 'dart:html';
import 'dart:web_gl';

final HtmlElement container = querySelector("#container");
final HtmlElement appletWindow = querySelector("#applet_window");
final HtmlElement overlay = querySelector("#overlay");
final HtmlElement loadConductionButton = querySelector("#load_conduction");
final HtmlElement loadConvectionButton = querySelector("#load_convection");

CanvasElement canvas;
RenderingContext context3D;

void main() {
  
  Element child = container.children[0];
  canvas = child;
  context3D = canvas.getContext3d();
  
  _bind();

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
  appletWindow.style.display = "block";
  overlay.style.display = "block";
  int index = 0;
  switch(index){
    case 0:
      loadConductionButton.click();
      break;
    case 1:
      loadConvectionButton.click();
      break;
  }
  e.stopPropagation();
}

void _onCanvasMouseDown(MouseEvent e) {
  e.preventDefault();
  e.stopPropagation();
}

void _onCanvasMouseMove(MouseEvent e) {
  e.preventDefault();
  e.stopPropagation();
}

void _onCanvasMouseUp(MouseEvent e) {
  e.preventDefault();
  e.stopPropagation();
}


// others

void _onOverlayMouseDown(MouseEvent e) {
  appletWindow.style.display = "none";
  overlay.style.display = "none";
  requestRedraw();
}



/* visualization */

void requestRedraw() {
}

