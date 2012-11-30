/**
 * Based on Minim's getLineIn example.
 *
 */
import spacebrew.*;  //import sb
import ddf.minim.*;  // import minim (sound library)

// Audio in stuff
Minim minim;
AudioInput in;

int soundRange = 0;

// spacebrew stuff
String server="localhost";
String name="SoundRange";
String description ="This is an output example that takes a computer's line in and sends its volume as a range.";

Spacebrew spacebrewConnection;

void setup(){
  size(512, 200, P3D);

  minim = new Minim(this);
  
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn();
  
  // setup spacebrew
  spacebrewConnection = new Spacebrew( this );
  spacebrewConnection.addPublish( "soundRange", soundRange );
  spacebrewConnection.connect("ws://"+server+":9000", name, description );
}

void draw(){
  background(0);
  stroke(255);
  // draw the waveforms
  for(int i = 0; i < in.bufferSize() - 1; i++){
    line(i, 50 + in.mix.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
  }
  
  // set up sound range
  soundRange = (int)( in.mix.level() * 1024 );
  
  text( str(soundRange), 50, 150 );
  
  // send current level as range
  spacebrewConnection.send(  "soundRange", soundRange );
}


void stop(){
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  
  super.stop();
}
