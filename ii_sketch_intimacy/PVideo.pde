/*
The purpose of this applet is to project the videos separately from the dat
 */


class PVideo extends PApplet {
  PVideo() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(500, 200);
  }

  void setup() {
    background(255, 0, 0);
  }

  void draw() {
  }
}