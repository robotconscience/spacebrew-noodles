#include "testApp.h"

ofColor color;

//--------------------------------------------------------------
void testApp::setup(){
    string host = "lab-server.local"; // change to ec2-184-72-140-184.compute-1.amazonaws.com to test Spacebrew Cloud server
    string name = "speech-synth";
    string description = "It's amazing";
    spacebrew.addSubscribe("speech", "string");
    spacebrew.connect( host, name, description );
    ofAddListener(spacebrew.onMessageEvent, this, &testApp::onMessage);
    
    synthesizer.listVoices();
    synthesizer.initSynthesizer("Bad News");
}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){
    ofDrawBitmapString(lastMessage, 20, ofGetHeight() / 2.0f);

}

//--------------------------------------------------------------
void testApp::onMessage( Spacebrew::Message & msg ){
    if ( msg.name == "speech"){
        lastMessage = msg.value;
        synthesizer.speakPhrase( lastMessage );
    }
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){}

//--------------------------------------------------------------
void testApp::keyReleased(int key){}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y){}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){
}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){
}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ }