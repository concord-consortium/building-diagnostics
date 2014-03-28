part of energy2d;

class Component {

  Math.MutableRectangle boundBox;
  String fillStyle = "rgba(255, 0, 0, 0.5)";
  String strokeColor = "black";
  int lineWidth = 4;

  Component(int left, int top, int width, int height) {
    boundBox = new Math.MutableRectangle(left, top, width, height);
  }

}
