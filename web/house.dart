library house;

import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:web_gl';

part 'gl_program.dart';
part 'matrix.dart';

final HtmlElement container = querySelector("#container");
final HtmlElement appletWindow = querySelector("#applet_window");
final HtmlElement overlay = querySelector("#overlay");
final HtmlElement loadConductionButton = querySelector("#load_conduction");
final HtmlElement loadConvectionButton = querySelector("#load_convection");

CanvasElement canvas;
RenderingContext gl;


void main() {
  
  canvas = container.children[0];
  gl = canvas.getContext3d();
  gl.clearColor(51.0/255.0, 204.0/255.0, 1.0, 1.0);
  
  _bind();
  
  window.animationFrame.then(_vizLoop);

}

void _vizLoop(num delta) {
  requestRedraw();
  window.animationFrame.then(_vizLoop);
}

void _bind() {
  canvas.onDoubleClick.listen(_onCanvasDoubleClick);
  overlay.onMouseDown.listen(_onOverlayMouseDown);  
}

/* interactivity */

// canvas

void _onCanvasDoubleClick(MouseEvent e) {
  e.preventDefault();
  appletWindow.style.display = "block";
  overlay.style.display = "block";
  int index = 1;
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


// others

void _onOverlayMouseDown(MouseEvent e) {
  appletWindow.style.display = "none";
  overlay.style.display = "none";
  requestRedraw();
}



/* visualization */

void requestRedraw() {
}

