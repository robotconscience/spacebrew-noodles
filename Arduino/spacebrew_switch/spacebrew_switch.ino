/*
Developed by the LAB at Rockwell Group

See "basic protoshield setup.PNG" in the examples directory
to see how this example is expecting the Arduino to be wired up.
I have the Ethernet shield sitting on top of the arduino, and then the
Sparkfun ProtoShield on top of that.

You must remember to include the Ethernet library, SPI library, 
and the WebSocketClient library 
(accessible here: https://github.com/labatrockwell/ArduinoWebsocketClient)
in order to use the Spacebrew library.

visit http://docs.spacebrew.cc/ for more info about Spacebrew!

putting the "toty" back in "Prototyping"
*/


#include <SPI.h>
#include <Spacebrew.h>
#include <Ethernet.h>
#include <WebSocketClient.h>

uint8_t mac[] = { 0xDE, 0xAE, 0xBE, 0xEF, 0xFE, 0xED };
Spacebrew spacebrewConnection;
int lastButton = LOW;

const int switchPin = 2;

void setup() {
  
  //register publishers and subscribers
  spacebrewConnection.addPublish("Switch", SB_BOOLEAN);
  
  //connect to the spacebrew server
  Ethernet.begin(mac);
  spacebrewConnection.connect("lab-server.rockwellgroup.com", "Arduino Switch", "Arduino Switch input");
  
  pinMode(switchPin, INPUT);
}


void loop() {
  //let the spacebrew library check for any incoming messages
  //and re-connect to the server if necessary
  spacebrewConnection.monitor();
  
  int buttonIn = digitalRead(switchPin);
  if (buttonIn != lastButton){
    //send the button state via spacebrew
    boolean button = buttonIn == HIGH ? true : false;
    spacebrewConnection.send("Switch", button );
    lastButton = buttonIn;
  }
}

