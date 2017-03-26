/**
 Indira Ardolic from the library of
 Kinect Infrared sensing to trigger video + poetry
 
 The purpose of this applet is to read the data and see where the ellipse is at. 
 A video will play based on where you're standing.
 I plan to modify it to detect multiple blobs in the future. 
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

/* VIDEO variables + setups are below */
Movie couchDr;
Movie bedDr;
int movieX = width/2;  //private movie x n y's
int movieY = 10; 
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
  size(620, 580, P3D); //1024, 848, P3D);
}

void setup() {
  win = new PWindow();  //multiwindow setup

  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.enableInfraredImg(true);
  kinect.enableInfraredLongExposureImg(true);
  kinect.enableColorImg(true);  //we're gonna replace the video with this image

  kinect.init();

  img = createImage(2*kwidth, 2*kheight, RGB); //  img = createImage(kwidth, kheight, RGB);

  /* VIDEO SETUP CODE IS BELOW */

  obs = new Obscure(movieW-wid, movieH-wid, wid, wid); //these are pointless atm
  obs2 = new Obscure(movieW-wid, movieH-wid, wid, wid);
  obs3 = new Obscure(movieW-wid, movieH-wid, wid, wid);

  couchDr = new Movie(this, "couchDr.mp4"); 
  bedDr = new Movie(this, "bedDr.mp4"); 

  couchDr.loop();
  bedDr.loop();
}

/* VIDEO CODE */
void videoPlay() {  //video function to load up the mullholland drive bits

  if (avgX < width/2) {  //person is on the left, it plays
    println("u read meaningful poetry at this spot :" + avgX);
    image(couchDr, 0, 0, movieW, movieH);
    image(bedDr, width/2, 0, movieW, movieH);
    couchDr.play();
    couchDr.speed(1);
    bedDr.play();
  } else if (avgX > width/2) { //person is on the right, it pauses / you're shown instead
    image(couchDr, 0, 0, movieW, movieH);
    //    image(bedDr, width/2, 0, movieW, movieH); so instead of the makeout scene, we show the video of the onlookers
  image(kinect.getColorImage(), width/2, 0, movieW, movieH);

    println("u r caught peeping, shame on u: " + avgX);
    couchDr.speed(.5);
    bedDr.pause();
    //  image(watching, ); //this will be where we pop the kinect footage over the bed video
  } /*else {  //this code made use of the obscure methods, but i dont really care about them enough to let it keep going
   bedDr.play();
   couchDr.speed(1);
   obs.display();
   obs2.display();
   obs3.display();
   }*/
}

void draw() {
  background(10);
  img.loadPixels();

  /*
//  obtain the depth frame, 8 bit gray scale format
   image(kinect.getDepthImage(), 0, 0);
   // obtain the depth frame as strips of 256 gray scale values... we dont need the line below because it just puts the grey depth thing down:   
   image(kinect.getDepth256Image(), 0, 0, width, height);// image(kinect.getDepth256Image(), 512, 0);
   
   //   infrared data
   image(kinect.getInfraredImage(), 0, 424);
   image(kinect.getInfraredLongExposureImage(), 0, 0, kwidth, kheight);
   
   int [] rawData256 = kinect.getRawDepth256Data();
   */

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

  /* VIDEOs are drawn here */
  videoPlay();

  //values for [0 - 256] strip
  pushStyle();
  stroke(255);
  text(frameRate, 50, height - 50);
  popStyle();
}