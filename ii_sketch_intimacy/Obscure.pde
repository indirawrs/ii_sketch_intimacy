/**
 * Indira Ardolic // intimacy installation obscuration methods
 * Obscure Class
 * purpose is to create rectangles if value is true
 }*/

class Obscure {
  float x, y; // X-coordinate, y-coordinate
  float w; // width and height

  // Constructor
  Obscure(float xpos, float ypos, float rwidth, float rheight) {
    x = xpos;
    y = ypos;
    w = rwidth;
    w = rheight;
  }

  void hidden() {
  }

  void display() {
    pushStyle();
    noStroke();
    colorMode(HSB);
    fill(random(255), 220, 250);
    ellipse(random(0, x), random(0, y), random(0, w), w);
    popStyle();
  }
}