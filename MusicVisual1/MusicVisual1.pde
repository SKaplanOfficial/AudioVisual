/*

 Music Visual #1 - Made by Stephen Kaplan
 Version: 1.0
 Date: August 19th, 2017
 
 Default Song: Legendary [Top Shelf Sounds]
 Artists: Amadeus 
 Music provided by Top Shelf Sounds : https://goo.gl/18xxWt
 Download/Stream : http://myaudiograb.com/sdWNesOHHa
 
 New In This Version:
 - Cleaned up code a bit
 
 To-Do:
 - Add song file chooser
 - Interact with & display metadata (Song title, author, lyrics, etc)
 - Add more user-changeable background designs
 - Use beat detection somehow
 */


// Minim imports and vars
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer song;
FFT         fft;

// Lists
ArrayList<Dot> dots = new ArrayList<Dot>();

// Background
color[] colors  = {color(0, 0, 0), color(125, 10, 45), color(255, 0, 0), color(255, 20, 147), color(255, 165, 0), color(0, 255, 0), color(0, 0, 255), color(117, 214, 255), color(128, 0, 128)};
int newColor;
int prevColor;
int lerpController;
float lerpRange = 60; // How many frames each color is displayed for
float lerpCount;

// Regulation
float freqController = 2; // Larger = less frequencies shown in frame, same number of points despite freqController value
int dotCount = 250; // Number of points
float freq;

void setup() {
  // Create window
  fullScreen();
  noCursor();

  // Dot creation
  for (int x=0; x<=width; x+=width/dotCount) {
    dots.add(new Dot(x, height/2));
  }

  // Minim Setup
  minim = new Minim(this);
  song = minim.loadFile("Amadeus - Legendary.mp3", 1024); // Implement song chooser later
  fft = new FFT( song.bufferSize(), song.sampleRate() ); // Breaks down soundfile into individual frequencies to work with
  song.play();
}

void draw() {
  background(200); // White BG makes lighter colors; could've done this by just making the colors brighter but... meh.

  fft.forward( song.mix );


  if (lerpCount > 0) { // If the lerpController has reached 300...
    // Start switching colors by blending the new and old color...
    fill(lerpColor(colors[newColor], colors[prevColor], (1/(lerpRange/lerpCount))), 100);
    lerpCount--; // Continue blending until lerpCount returns to a value of 0
  } else {
    fill(colors[newColor], 100); // Otherwise just stay on the same color
  }

  noStroke();
  rect(0, 0, width, height); // Rectangle makes background 

  for (int i=0; i<dots.size(); i++) {
    dots.get(i).update(height/2+sin(freq+i*5)*125); // Amplitude of 125, Horizontal Stretch by 5, ypos dependent on where dot is and what freq is currently playing
    dots.get(i).display();
  }

  stroke(red(colors[newColor])/1.2, green(colors[newColor])/1.2, blue(colors[newColor])/1.2, 150); // Stroke matches background, but darker
  for (int i=0; i<=width; i+=(fft.specSize()/20)) { // 20 waving strands on top and bottom
    for (int o=0; o<300; o+=8) {
      strokeWeight(1);
      point(i-25-100*sin(radians(o)), 0+o); // Rotate independently from freq
      point(i-25-100*sin(radians(o)), height-o);
    }
  }

  freq += fft.getFreq(10)/500; // Controls rotation

  if (lerpController > 300) {
    changeColor();
    lerpController = 0;
  } else {
    lerpController++;
  }
}

void keyPressed() {
  if (key == '[') { // DECREASE RANGE OF FREQ DISPLAYED
    freqController /= 2;
  } else if (key == ']') { // INCREASE RANGE OF FREQ DISPLAYED
    freqController *= 2;
  }
}

void changeColor() {
  prevColor = newColor;
  newColor = (int) random(colors.length);
  lerpCount = lerpRange; // Begins color transform
}

class Dot {
  float x, y, z, freq;

  Dot(float xpos, float ypos) {
    x = xpos;
    y = ypos;
  }

  void update(float newY) {
    y = newY;
    freq = fft.getFreq(dist(x, y, width/2, height/2)*freqController); // Fft num controlled by distance from center of window
    // Further from center = higher freq detected
  }

  void display() {
    stroke(red(colors[newColor])/1.2, green(colors[newColor])/1.2, blue(colors[newColor])/1.2, 100); // Stroke matches background, but darker
    strokeWeight(freq/2+3); 
    point(x, y);

    stroke(255);
    strokeWeight(freq/4+2);
    point(x, y);
  }
}