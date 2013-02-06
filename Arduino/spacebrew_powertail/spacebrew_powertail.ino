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

uint8_t mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
Spacebrew spacebrewConnection;

const int PowerTail = 0; // the pin that the LED is attached to

void setup() {
  //connect to spacebrew library info
  spacebrewConnection.onOpen(onOpen);
  spacebrewConnection.onClose(onClose);
  spacebrewConnection.onError(onError);
  
  //connect to message callbacks
  spacebrewConnection.onBooleanMessage(onBooleanMessage);
  spacebrewConnection.onStringMessage(onStringMessage);
  spacebrewConnection.onRangeMessage(onRangeMessage);
  
  //register publishers and subscribers
  spacebrewConnection.addSubscribe("PowerTail", SB_BOOLEAN);
  spacebrewConnection.addPublish("PowerTail_State", SB_STRING);
  
  //connect to the spacebrew server
  Ethernet.begin(mac);
  spacebrewConnection.connect("lab-server.rockwellgroup.com", "Powertail", "Arduino Powertail");
  
  pinMode(PowerTail, OUTPUT);
  digitalWrite(PowerTail, LOW);
}

void loop() {
  //let the spacebrew library check for any incoming messages
  //and re-connect to the server if necessary
  spacebrewConnection.monitor();
}

void onBooleanMessage(char *name, bool value){
  //turn the 'digital' LED on and off based on the incoming boolean
  int spacebrew_ledValue;
  if (value){
    spacebrew_ledValue = HIGH;
  spacebrewConnection.send("PowerTail_State", "hi");
  } else {
    spacebrew_ledValue = LOW;
  spacebrewConnection.send("PowerTail_State", "lo");
  }
  digitalWrite(PowerTail, spacebrew_ledValue);
  
}

void onStringMessage(char *name, char* message){
}

void onRangeMessage(char *name, int value){
}

void onOpen(){
}

void onClose(int code, char* message){
  //turn everything off if we get disconnected
  digitalWrite(PowerTail, LOW);
}

void onError(char* message){}
