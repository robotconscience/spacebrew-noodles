/**
 * Based on Minim's Forward FFT example.
 *
 */
import spacebrew.*;  //import sb
import ddf.minim.analysis.*; // import minim (sound library)
import ddf.minim.*;  

// Audio in stuff
Minim minim;
AudioInput in;
FFT fft;

int pitchRange = 0;

// spacebrew stuff
String server="localhost";
String name="PitchRange";
String description ="This is an output example that takes a computer's line in and sends its volume as a range.";

Spacebrew spacebrewConnection;

void setup(){
  size(512, 200, P3D);

  // setup sound input + analysis
  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  // setup spacebrew
  spacebrewConnection = new Spacebrew( this );
  spacebrewConnection.addPublish( "pitchRange", pitchRange );
  spacebrewConnection.connect("ws://"+server+":9000", name, description );
}

int threshold = 10; // arbitrary threshold to decide if frequency loud enough to care about
int lowFreq   = 0;  // lowest frequency to listen to
int highFreq  = 60; // highest frequency to listen to... i can get up here if i whistle

void draw(){
  background(0);
  stroke(255);
  
  // process FFT
  fft.forward(in.mix);
  
  // quick and dirty pitch detection... won't work well with more than one
  // source, etc
  // draw the processed bands + figure out the highest one
  int highest = 0;
  float highestValue = -1;
  for(int i = 0; i < fft.specSize(); i++){
    // draw the line for frequency band i, scaling it by 4 so we can see it a bit better
    float val = fft.getBand(i);
    line(i, height, i, height - val*4);
    if ( val > highestValue && val > threshold  ){
      highestValue = fft.getBand(i);
      highest = i;
    }
  }
  
  if ( highest != -1 ){    
    // map band to 0-1024 range
    pitchRange = (int) map( highest, lowFreq, highFreq, 0, 1024) ;
    if ( pitchRange > 1024) pitchRange = 1024;
    
    text( "Highest band: "+str(highest), 50, 150 );
    text( "Range: "+str(pitchRange), 50, 180 );
  
    // send current level as range
    spacebrewConnection.send(  "pitchRange", pitchRange );
  }
}


void stop(){
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  
  super.stop();
}
