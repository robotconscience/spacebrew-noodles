import spacebrew.*;

import ddf.minim.*;
import ddf.minim.signals.*;

String server="localhost";
String name="SawWaveOutput";
String description ="This example takes a range input and sends it to two slightly out of tune saw waves";

Spacebrew spacebrewConnection;

// sound stuff

Minim minim;
AudioOutput out;
SawWave saw, saw2;

void setup() {
  size(600, 400);
  
  // setup sound
  minim = new Minim(this);
  
  // get a line out from Minim, default sample rate is 44100, default bit depth is 16
  out = minim.getLineOut(Minim.STEREO, 2048);
  
  // make two hard-panned saw waves 
  saw = new SawWave(0, 0.5, out.sampleRate());
  saw.portamento(100);
  saw.setPan(-1);
  saw2 = new SawWave(0, 0.5, out.sampleRate());
  saw2.portamento(100);
  saw2.setPan(1);
  
  // add the oscillator to the line out
  out.addSignal(saw);
  out.addSignal(saw2);
  
  // spacebrew
  spacebrewConnection = new Spacebrew( this );
  
  // add each thing you subscribe to
  spacebrewConnection.addSubscribe( "saw", "range" );
  spacebrewConnection.addSubscribe( "saw2", "range" );
  
  // connect!
  spacebrewConnection.connect("ws://"+server+":9000", name, description );
  
}

void draw() {
  background(0);
  stroke(255);
  // draw the waveforms
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line(i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50);
    line(i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50);
  }
}

//void mousePressed() {
//  spacebrewConnection.send( "buttonPress", buttonSend);
//}

void onRangeMessage( String name, int value ){
  float range = 400.f/512.f;
  if ( name.equals("saw")){  
    saw.setFreq( value * range );
  } else if ( name.equals("saw2")){
    saw2.setFreq( value * range );
  }
}

void onBooleanMessage( String name, boolean value ){
  println("got bool message "+name +" : "+ value);  
}

void onStringMessage( String name, String value ){
  println("got string message "+name +" : "+ value);  
}

void stop()
{
  // always close Minim audio classes when you are done with them
  out.close();
  minim.stop();

  super.stop();
}
