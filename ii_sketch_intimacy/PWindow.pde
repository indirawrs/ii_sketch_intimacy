class PWindow extends PApplet {


  //lets try to make this the poem?
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  StringList poem;
  PFont font;
  boolean lines = false; //check where mouse is to advance the lines of the poem
  float timer = 0; 
  float a = 0.0;
  int appear = 10; //how long we want them to wait before it goes, prob should disappear after a while..
  int signX = 50;
  int signY = 200;
  int signWid = 600;
  int signHgt = 650;


  void settings() {
    size(900, 900); //1080, 1920); should b big lol
  }

  void setup() {
    background(0);
    pushStyle();
    fill(255, 100, 50); //orange sign
    rect(signX, signY, signWid, signHgt);
    popStyle();
    poem = new StringList("IT  WAS BAD ENOUGH YOU HEARD", "ME SING IN THE SHOWER", "BUT THEN YOU HEARD", "ME SAY YOUR NAME IN MY SLEEP", "I'M STILL EMBARRASSED OVER", "HOW I WOKE UP AND INSTINCTIVELY", "SAID I LOVE YOU", "PLEASE DON'T JUDGE ME", "FOR KNOWING HOW I FEEL", "I PROMISE I WILL NEVER", "MAKE THAT MISTAKE AGAIN");
    font = createFont("cityburn", 40);
    textFont(font);
    fill(0);
    textAlign(CENTER);
  }

  void timeAdvance() {
    if (avgX < width/2) { //if ellipse is on the left, the "public space," written boundaries will be declared (poem is representative of that)
      timer += 1;
      println("timer: " + timer);
      if (timer > appear) {
        a+= .02;
        for (int i = 0; i < poem.size(); i++) {
          String item = poem.get(i);
          fill(random(10, 50), 0, 0, a);
          text(item, 350, 260+40*i);
        }
      }
    } else {
      timer = 0;
      a = 0;
      println("timer reset: " + timer);
      lineByLine();
    }
  }

  void lineByLine() { //when someone walks away the poetry will disappear slowly
    pushStyle();
    fill(255, 100, 50, 80); //orange sign
    noStroke();
    ellipse(random(signX+30, signWid), random(signY+30, signHgt), 30, 30); //makes ellipses in the sign dimensions
    popStyle();
  }

  void draw() {
    fill(255, 100, 50);
    noStroke();
    timeAdvance();
  }
}