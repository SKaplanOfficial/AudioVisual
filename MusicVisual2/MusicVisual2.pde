/*

 Music Visual #2 - Made by Stephen Kaplan
 Version: 1.0
 Date: June 24th, 2018
 
 File: MusicVisual2.pde

 Default Song: European Starling
 Artist: Chad Crouch
 Music provided by Free Music Archive
 Download/Stream : http://freemusicarchive.org/music/Chad_Crouch/Bird_Watching_Piano_Preludes/European_Starling

 New In This Version:
 - Cleaned up code a bit
*/


// Minim imports and vars
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer jingle;
FFT         fft;


// PostFX imports and vars
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PostFX fx;


// Lists
ArrayList<Block> blocks = new ArrayList<Block>();


// Regulators
int horizontalAmount = 12; // Square: 100
int verticalAmount = 2; // Square: 62
int wait = 50; // ms to wait before song starts

void setup() {
  // Create window
  fullScreen(P3D);

  // Initialize PostFX object
  fx = new PostFX(this);

  // Initialize minim object
  minim = new Minim(this);
  //jingle = minim.loadFile("Chad Crouch - European Starling.mp3", 1024);
  jingle = minim.loadFile("/Users/stevekaplan/Downloads/Green.mp3", 1024);
  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() ); // Breaks down soundfile into individual frequencies to work with

  // Create rows of blocks, then columns
  // Width/height of blocks based on horizontalAmount/verticalAmount
  for (int y=0; y<height; y+=height/verticalAmount) {
    for (int x=0; x<width; x+=width/horizontalAmount) {
      blocks.add(new Block(x, y, blocks.size()-1));
      // blocks.size()-1 = position in ArrayList of this object
    }
  }

  background(21,21,21); // Gray background
}

void draw() {
  noCursor(); // Don't want cursor to block view

  if (wait > 0){ // Decrease wait if needed
    wait--;
  }else{ // Otherwise play the song forward
    jingle.play();
    fft.forward( jingle.mix );
  }

  pushMatrix();
  translate(0, 0, -600); // Set back a lot in 3D space to allow room for blocks
  fill(13,18,25, 140); // Higher opacity -> Slower beginning "animation"
  noStroke();
  rect(-width*2, -height*2, width*5, height*5);
  popMatrix();

  for (int i=0; i<blocks.size(); i++) { // Go through each item in blocks
    blocks.get(i).display(); // Run the code in the block's display submethod
  }

  fx.render() // Once everything has been drawn to the screen, add an effect over it
    .bloom(0.1, 50, 10)
    .compose();
}
