// import TSPS
import tsps.*;

// import Spacebrew
import spacebrew.*;

String server="lab-server.local";
String name="TSPS Pointer";
String description ="";

Spacebrew spacebrewConnection;
TSPS      tspsReceiver;

// say if there is anything in either quad
boolean quadOne   = false;
boolean quadTwo   = false;
boolean quadThree = false;
boolean quadFour  = false;

// setup up quads
PVector[] quads = new PVector[4];
String[] messages = {"quadOne", "quadTwo", "quadThree", "quadFour"};
boolean[] states  = {false, false, false, false};
boolean[] last_states  = {false, false, false, false};

void setup() {
  frameRate(60);
  size(600, 400);
  
  // setup TSPS
  tspsReceiver= new TSPS(this);
  
  // setup spacebrew
  spacebrewConnection = new Spacebrew( this );
  
  // add each thing you publish to
  spacebrewConnection.addPublish( "quadOne", quadOne ); 
  spacebrewConnection.addPublish( "quadTwo", quadTwo ); 
  spacebrewConnection.addPublish( "quadThree", quadThree ); 
  spacebrewConnection.addPublish( "quadFour", quadFour ); 
  spacebrewConnection.addPublish( "tspsX", 0 ); 
  spacebrewConnection.addPublish( "tspsY", 0 ); 

  // connect!
  spacebrewConnection.connect("ws://"+server+":9000", name, description );
  
  quads[0] = new PVector(width/4, 0);
  quads[1] = new PVector(width/2, 0);
  quads[2] = new PVector(width * 3/4, 0);
  quads[3] = new PVector(width, 0);
}

void draw() {
  background(0);
  
  // get array of people
  TSPSPerson[] people = tspsReceiver.getPeopleArray();
  
  // reset states
  for ( int j=0; j<states.length; j++){
    //states[j] = false;
  }
  
  // loop through people
  PVector last = new PVector(0,0);
  PVector highest = new PVector(0,0);
  println( people.length ) ;
  for (int i=0; i<people.length; i++){
      // draw highest point
      highest.set(people[i].highest.x / 640.0, people[i].highest.y / 480.0,0);
      
      if ( i == 0 ){
        spacebrewConnection.send("tspsX", (int) (highest.x * 1024) );
        spacebrewConnection.send("tspsY", (int) (highest.y * 1024) );
      }
      
      highest.x *= width;
      highest.y *= height;
      
      // check point against quads
      last.set(0,0,0);
      for ( int j=0; j<quads.length; j++){
        last_states[j] = states[j];
        if ( highest.x >= last.x && highest.x < quads[j].x ){
          states[j] = true;
          if ( states[j] != last_states[j] ){
            spacebrewConnection.send(messages[j], true);
          }
        } else {
          states[j] = false;
          if ( states[j] != last_states[j] ){
          }
        }
        last.set(quads[j].x,quads[j].y,0);
      }
      
  };
  
  // draw quads
  last.set(0,0,0);
  
  for ( int j=0; j<quads.length; j++){
    if ( states[j] == true ){
      fill(255);
    } else {
      fill(0);
    }
    rect(last.x,0,quads[j].x,height);
    last.set(quads[j].x,quads[j].y,0);
  }
  
  fill(255,0,0);
  ellipse(highest.x, highest.y, 5,5);
}

//void mousePressed() {
//  spacebrewConnection.send( "buttonPress", buttonSend);
//}

void onRangeMessage( String name, int value ){
  println("got int message "+name +" : "+ value);
}

void onBooleanMessage( String name, boolean value ){
  println("got bool message "+name +" : "+ value);  
}

void onStringMessage( String name, String value ){
  println("got string message "+name +" : "+ value);  
}
