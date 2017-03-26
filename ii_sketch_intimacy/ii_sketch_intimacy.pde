/**
 Indira Ardolic from the library of
 Kinect Infrared sensing to trigger video + poetry
 **/

PWindow win;  //multiwindows

import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import KinectPV2.*;
KinectPV2 kinect;

PImage img; 
int kwidth = KinectPV2.WIDTHDepth;
int kheight = KinectPV2.HEIGHTDepth;
float minThresh = 10; // 480;
float maxThresh = 573; //830;
float avgX;
float checkX = width;  //we check vids against this

//POEM variables are below
int signX = 50;
int signY = 200;
int signWid = 600;
int signHgt = 650;
StringList poem;
PFont font;
//boolean lines = false; //check where mouse is to advance the lines of the poem
float timer = 0; 
float a = 0.0;
int appear = 10; //how long we want them to wait before it goes, prob should disappear after a while or something?

//VIDEO variables are below
Movie couchDr;
Movie bedDr;
int movieW = 400;
int movieH = 280;
int wid = 150;
Obscure obs;
Obscure obs2;
Obscure obs3;

void movieEvent(Movie couchDr) {
  couchDr.read();
}

void bedDrEvent(Movie bedDr) {
  bedDr.read();
}

public void settings() {
  size(1820, 980, P3D); //1024, 848, P3D);
}

void setup() {
  win = new PWindow();  //multiwindow setup


  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.enableInfraredImg(true);
  kinect.enableInfraredLongExposureImg(true);
  kinect.init();

  img = createImage(2*kwidth, 2*kheight, RGB); //  img = createImage(kwidth, kheight, RGB);

  //poem setup stuff is below
  background(0);
  poem = new StringList("IT  WAS BAD ENOUGH YOU HEARD", "ME SING IN THE SHOWER", "BUT THEN YOU HEARD", "ME SAY YOUR NAME IN MY SLEEP", "I'M STILL EMBARRASSED OVER", "HOW I WOKE UP AND INSTINCTIVELY", "SAID I LOVE YOU", "PLEASE DON'T JUDGE ME", "FOR KNOWING HOW I FEEL", "I PROMISE I WILL NEVER", "MAKE THAT MISTAKE AGAIN");
  font = createFont("cityburn", 40);
  textFont(font);
  fill(0);
  textAlign(CENTER);

  /*
VIDEO CODE IS BELOW
   */

  obs = new Obscure(movieW-wid, movieH-wid, wid, wid);
  obs2 = new Obscure(movieW-wid, movieH-wid, wid, wid);
  obs3 = new Obscure(movieW-wid, movieH-wid, wid, wid);

  couchDr = new Movie(this, "couchDr.mp4"); 
  bedDr = new Movie(this, "bedDr.mp4"); 

  couchDr.loop();
  bedDr.loop();
}



//following code is for the videos
void videoPlay() {
  //video function to load up the mullholland drive bits
  float k = 1.0;
  k-=.5;

  if (avgX > checkX/2) {
    println(" the video will play/avgX: " + avgX);
    couchDr.play();
    couchDr.speed(1);
    bedDr.play();
  } else if (avgX < checkX/2) {
    println(" the poem + video will show/avgX: " + avgX);
    // couchDr.pause();
    bedDr.pause();
  } else {
    bedDr.play();
    couchDr.speed(k);
    obs.display();
    obs2.display();
    obs3.display();
  }
}

/*
  POETRY CODE IS BELOW
 */
void timeAdvance() {
  if (avgX < width/2) { // in future cases it'd be the ellipse tracker
    timer += 1;
    println("timer: " + timer);
    if (timer >appear) {
      a+= .5;
      //the goal is to make the lines appear bit by bit, so maybe the fill opacity increases
    }
  } else {
    timer = 0;
    a = 0;
    println("timer reset: " + timer);
    fill(0); //this draws a rectangle over everything or replace w line by line
    rect(0, 0, width, height);
    //   rect(a, 10, 400, 500);
  }

  for (int i = 0; i < poem.size(); i++) {
    String item = poem.get(i);
    fill(random(10, 50), 0, 0, a);
    text(item, 350, 360+40*i);  //timer value  can still be accessed anywhere
  }
}

void lineByLine() { //not super important to have rectangle float down. 
  pushStyle();
  fill(255, 100, 50, 80); //orange sign
  noStroke();
  ellipse(random(signX, signWid), random(signY, signHgt), signWid-signX, signHgt-signY); //makes ellipses in the sign dimensions
  popStyle();
}

void draw() {
  background(10);
  img.loadPixels();


  //obtain the depth frame, 8 bit gray scale format
  // image(kinect.getDepthImage(), 0, 0);
  //obtain the depth frame as strips of 256 gray scale values
  //we dont need the line below because it just puts the grey depth thing down

  //image(kinect.getDepth256Image(), 0, 0, width, height);// image(kinect.getDepth256Image(), 512, 0);

  //infrared data
  //  image(kinect.getInfraredImage(), 0, 424);
  // image(kinect.getInfraredLongExposureImage(), 0, 0, kwidth, kheight);

  //  int [] rawData256 = kinect.getRawDepth256Data();

  int [] rawData = kinect.getRawDepthData();

  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;

  for (int x = 0; x < KinectPV2.WIDTHDepth; x++) {
    for (int y = 0; y < KinectPV2.HEIGHTDepth; y++) {
      int offset = x +y * KinectPV2.WIDTHDepth;
      int d = rawData[offset];    //check how far away thing is

      if (d > minThresh && d < maxThresh ) { //&& x > 100
        img.pixels[offset*2] = color(0, 0, 250);//  img.pixels[x] = color(0, 250, 250);

        sumX += x;
        sumY += y;
        totalPixels++;
      } else {
        img.pixels[offset*2] = color(0);
      }
    }
  }
  img.updatePixels();
  image(img, 0, 0);//image(0, 0, width, height); //

  avgX = (sumX / totalPixels)*2;
  float avgY = (sumY / totalPixels)*2;
  fill(0, 0, 255);
  ellipse(avgX, avgY, 64, 64);
  //poem stuff is here
  pushStyle();
  fill(255, 100, 50);  //sign bg
  noStroke();
  rect(signX, signY, signWid, signHgt);
  popStyle();

  //lineByLine();
  timeAdvance();

  //video stuff is here
  videoPlay();
  image(couchDr, 0, 0, movieW, movieH);
  image(bedDr, width/2, 0, movieW, movieH);

  //values for [0 - 256] strip
  pushStyle();
  stroke(255);
  text(frameRate, 50, height - 50);
  popStyle();
}