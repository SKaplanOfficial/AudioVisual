/*

 Music Visual #2 - Made by Stephen Kaplan
 Version: 1.0
 Date: June 24th, 2018
 
 File: Block.pde
*/
 
class Block{ // Works as a blueprint for all Block objects in blocks ArrayList
  // Attributes of a block object
  float xpos, ypos;
  float id;
  color c;
  float bw, bh;
  
  Block(int xpos_, int ypos_, int id_){
    xpos = xpos_;
    ypos = ypos_;
    id = id_;
    c = color(0,0,0);
    bw = width/horizontalAmount; // Block width
    bh = height/verticalAmount; // Block height
  }
  
  void display(){
    if (sqrt(fft.getBand(int(id))) > 3){ // Adjust number for threshold -> Higher = More intense music needed
      c = color(255,xpos/5,ypos/5,200); // Red-Yellow
      //c = color(xpos/5,100+xpos/2,255-xpos/5,200); // Blue-Yellow
    }else{
      c = color(21,21,21,20); // If intensity not great enough, block is just gray
    }
    
    pushMatrix(); // Keep translate() isolated to this block
    fill(c);
    stroke(red(c)/1.1,green(c)/1.1,blue(c)/1.1);
    translate(xpos-bw/2, ypos+bh/2, -500);
    box(bw, bh, 1+pow((fft.getBand(int(id)))*70, .7));
    // Box centers at translate points
    // width = bw, height = bh, depth based on 1/10 power of intensity
    // pow() is just serving to make things non-linear because I liked it more -- change as you see fit
    popMatrix();
  }
}
