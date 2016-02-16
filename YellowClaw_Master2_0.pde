//YellowClaw Master: MIDI, OSC, controlP5, Minum

//OSC 
import oscP5.*;
import netP5.*;

//controlP5
import controlP5.*;

// Minim
import ddf.minim.*;
import ddf.minim.analysis.*;

//MidiBus
import themidibus.*; 
MidiBus myBus; 


//Minim
Minim       minim;
AudioInput  myAudio;

FFT         myAudioFFT;

int         myAudioRange     = 11;
int         myAudioMax       = 100;

float       myAudioAmp       = 65.0;
float       myAudioIndex     = 0.2;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.5;

int         base             = 0;
int         snare            = 5;

int baseMin = 0;
int baseMax = 10;

int snareMin = 0;
int snareMax = 10;

// ************************************************************************************

//Visualization constants

int         rectSize         = 50;

int         stageMargin      = 100;
int         stageWidth       = (myAudioRange * rectSize) + (stageMargin * 2);
int         stageHeight      = 300;

float       xStart           = stageMargin;
float       yStart           = stageMargin;
int         xSpacing         = rectSize;

color       bgColor          = #333333;
color       snareColor       = #00FFFD;
color       baseColor        = #FA00FF;

// ************************************************************************************

//OSC config
int portToListenTo = 12000; 
int portToSendTo = 7000;
String ipAddressToSendTo = "localhost";

OscP5 oscP5;
NetAddress myRemoteLocation;
OscBundle myBundle;
OscMessage myMessage;

//Control p5
ControlP5 cp5;
RadioButton fftWindow;
RadioButton snareClipsColumnsEffect;
RadioButton baseClipsColumnsEffect;
RadioButton sequentialOrRandom;

RadioButton baseLayerClips;
RadioButton baseOverUnder;

CheckBox snareLayers;

Range snareOscRange;

boolean snareOscToggle = true;
boolean baseOscToggle = true;

//Shared timer GUI variable
int timerWidth = 175;

//Timer variables (base)
int baseTimer = 0;
int baseLastTimer = 0;
int baseTimerThreshold;

//Timer variables (snare)
int snareTimer = 0;
int snareLastTimer = 0;
int snareTimerThreshold;

//Threshold variables
int baseThreshold;
int snareThreshold;


//Clip/column for the base to trigg
int baseClipOrColumn;
int sliderTicks2;

//Variables for range of clips/columns being triggered 
int minRange = 1;
int maxRange = 7;

//Variables for random number
int randNum;
int prevRandNum;

//Variables for sequential numbers
int seqNum = 1;
int prevSeqNum=1;


//Experiments 
int clipNumber;
boolean baseJustTrigged = false;

// ************************************************************************************

void setup() {

  size(750, 700);
  background(bgColor);

  //minim setup
  minimSetup();

  //osc setup
  oscSetup();

  //controlP5 setup
  controlP5Setup();

  //midiBusSetup
  midiBusSetup();
}

void draw() {
  background(bgColor);

  minimSetWindow();

  myAudioFFT.forward(myAudio.mix);

  for (int i = 0; i < myAudioRange; ++i) {
    stroke(0);
    strokeWeight(1);
    if (i == snare && i ==base) fill(lerpColor(baseColor, snareColor, .5)); // others
    else if (i==base)     fill(baseColor); // base
    else if (i==snare) fill(snareColor); // snare
    else          fill(#CCCCCC); // others

    float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
    float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
    rect( xStart + (i*xSpacing), yStart, rectSize, tempIndexCon);

    // visualize the number data for range item
    fill(#0095a8); 
    text(str((int)tempIndexCon), xStart + (i*xSpacing) + 10, stageMargin+myAudioMax+(stageMargin/2));

    if (i==snare && snareOscToggle==true) {

      if (snareClipsColumnsEffect.getValue() == 2 ) {
        OscMessage myMessage = new OscMessage(cp5.get(Textfield.class, "SnareOscAdress").getText());
        myMessage.add((myAudioFFT.getAvg(snare) * myAudioAmp) * myAudioIndexAmp / 100); /* add an int to the osc message */
        oscP5.send(myMessage, myRemoteLocation);
      } else { //Set effect back to 0 // NOT WORKING!!!
        //OscMessage myMessage = new OscMessage(cp5.get(Textfield.class, "SnareOscAdress").getText());
        //myMessage.add(0); /* add an int to the osc message */
        //oscP5.send(myMessage, myRemoteLocation);
      }


      if ((myAudioFFT.getAvg(snare) * myAudioAmp) * myAudioIndexAmp > snareThreshold && snareTimer > snareTimerThreshold && snareOscToggle==true) { //If volume exceeds threshold
        if (snareTimer > snareTimerThreshold) {
          if (snareClipsColumnsEffect.getValue() == 0) { // Trig clips (not columns)
            for (int j=0; j<snareLayers.getArrayValue().length; j++) { //Go through all the layers
              if ((int)snareLayers.getArrayValue()[j] == 1) { //Trig clips in the layers that are activated by snareLayers
                if (sequentialOrRandom.getValue() == 0) {
                  clipNumber = sequentialOrder(prevSeqNum);
                } else if (sequentialOrRandom.getValue() == 1) {
                  clipNumber = randomNoDublicates(minRange, maxRange, prevRandNum);
                } 
                OscMessage myMessage = new OscMessage("/layer" + (3 - j) + "/clip" + clipNumber + "/connect");
                myMessage.add(1); /* add an int to the osc message */
                oscP5.send(myMessage, myRemoteLocation);
              }
            }
            prevSeqNum++;
            if (prevSeqNum > maxRange) {
              prevSeqNum = minRange;
            }
          } else if (snareClipsColumnsEffect.getValue() == 1 ) { //Trig entire columns

            if (sequentialOrRandom.getValue() == 0) {
              clipNumber = sequentialOrder(prevSeqNum);
            } else if (sequentialOrRandom.getValue() == 1) {
              clipNumber = randomNoDublicates(minRange, maxRange, prevRandNum);
            } 

            OscMessage myMessage = new OscMessage("/track" +  clipNumber + "/connect");
            myMessage.add(1); /* add an int to the osc message */
            oscP5.send(myMessage, myRemoteLocation);
            prevSeqNum++;

            println("Hello" + random(1));

            if (prevSeqNum > maxRange) {
              prevSeqNum = minRange;
            }
          }
        }
        prevRandNum = randNum;
        snareLastTimer = millis();
      }
    } else if (i ==base && baseOscToggle==true) {

      if (baseClipsColumnsEffect.getValue() == 2 ) {
        OscMessage myMessage = new OscMessage(cp5.get(Textfield.class, "BaseOscAdress").getText());
        myMessage.add((myAudioFFT.getAvg(base) * myAudioAmp) * myAudioIndexAmp / 100); /* add an int to the osc message */
        oscP5.send(myMessage, myRemoteLocation);
        println("Set effect");
      } else { //Set effect back to 0 // NOT WORKING!!!
        //OscMessage myMessage = new OscMessage(cp5.get(Textfield.class, "BaseOscAdress").getText());
        //myMessage.add(0); /* add an int to the osc message */
        //oscP5.send(myMessage, myRemoteLocation);
        //println("Set to 0");
      }


      if (int(baseOverUnder.getValue()) == 0) {
        if ((myAudioFFT.getAvg(base) * myAudioAmp) * myAudioIndexAmp < baseThreshold) {
          if (baseTimer > baseTimerThreshold && baseJustTrigged == false) {
            if (baseClipsColumnsEffect.getValue() == 0 ) { //Trig single clips
              OscMessage myMessage = new OscMessage("/layer" + int(baseLayerClips.getValue()) + "/clip" + baseClipOrColumn  + "/connect");
              myMessage.add(1);
              oscP5.send(myMessage, myRemoteLocation);
              baseJustTrigged = true;
            } else if (baseClipsColumnsEffect.getValue() == 1 ) { //Trig entire columns
              OscMessage myMessage = new OscMessage("/track" + baseClipOrColumn + "/connect");
              myMessage.add(1); /* add an int to the osc message */
              oscP5.send(myMessage, myRemoteLocation);
              baseJustTrigged = true;
            }
          }
        } else {  

          OscMessage myMessage = new OscMessage("/layer" + int(baseLayerClips.getValue()) + "/clip" + baseClipOrColumn  + "/connect");
          myMessage.add(0);
          oscP5.send(myMessage, myRemoteLocation);

          baseJustTrigged = false;
          baseLastTimer = millis();
        }
      } else if (int(baseOverUnder.getValue()) == 1) {

        if ((myAudioFFT.getAvg(base) * myAudioAmp) * myAudioIndexAmp > baseThreshold) {
          if (baseTimer > baseTimerThreshold && baseOscToggle==true && baseJustTrigged == false) {
            if (baseClipsColumnsEffect.getValue() == 0 ) { //Trig single clips
              OscMessage myMessage = new OscMessage("/layer" + int(baseLayerClips.getValue()) + "/clip" + baseClipOrColumn  + "/connect");
              myMessage.add(1);
              oscP5.send(myMessage, myRemoteLocation);
              baseJustTrigged = true;
            } else if (baseClipsColumnsEffect.getValue() == 1 ) { //Trig entire columns
              OscMessage myMessage = new OscMessage("/track" + baseClipOrColumn + "/connect");
              myMessage.add(1); /* add an int to the osc message */
              oscP5.send(myMessage, myRemoteLocation);
              baseJustTrigged = true;
            }
          }
        } else {  

          OscMessage myMessage = new OscMessage("/layer" + int(baseLayerClips.getValue()) + "/clip" + baseClipOrColumn  + "/connect");
          myMessage.add(0);
          oscP5.send(myMessage, myRemoteLocation);

          baseJustTrigged = false;
          baseLastTimer = millis();
        }
      }
    }
    myAudioIndexAmp+=myAudioIndexStep;
  }
  myAudioIndexAmp = myAudioIndex;

  //Audio max line
  stroke(#FF3300); 
  noFill();
  line(stageMargin, stageMargin+myAudioMax, width-stageMargin, stageMargin+myAudioMax);

  //baseThreshold line
  strokeWeight(4); 
  stroke(baseColor, 122);
  line(stageMargin + 50*baseMin, 100+baseThreshold, stageMargin + 50*baseMax+50, 100+baseThreshold);

  //snareThreshold line
  stroke(snareColor, 122);
  line(stageMargin + 50*snareMin, 100+snareThreshold, stageMargin + 50*snareMax + 50, 100+snareThreshold);

  //base box
  noStroke(); 
  fill(0);
  rect(stageMargin + 50*base, (stageMargin/2)-10, 50, 20);
  fill(baseColor); 
  text("BASE", stageMargin+50*base+5, (stageMargin/2)+4);

  //snare box
  noStroke(); 
  if (snare==base) {
    fill(0);
    rect(stageMargin+50*snare, (stageMargin/2)-30, 50, 20);
    fill(snareColor); 
    text("SNARE", stageMargin+50*snare+5, (stageMargin/2)-16);
  } else {
    fill(0);
    rect(stageMargin+50*snare, (stageMargin/2)-10, 50, 20);
    fill(snareColor); 
    text("SNARE", stageMargin+50*snare+5, (stageMargin/2)+4);
  }

  drawTimer(width/2-75, 300, snareTimer, snareTimerThreshold, "Ready to trig"); //Draw snareTimer
  drawTimer(0, 300, baseTimer, baseTimerThreshold, "Triggering"); //Draw baseTimer
  snareTimer = millis() - snareLastTimer;
  baseTimer = millis() - baseLastTimer;


  //Warning text
  if (snareOscToggle && baseOscToggle && (baseClipsColumnsEffect.getValue() == 1) && (snareClipsColumnsEffect.getValue() == 1)) {
    fill(255, 0, 0);
    text("Warning! Both snare and base \nare set to control columns... ", width/2 +100, height-100);
  }
}

void drawTimer(int posX, int posY, int instrumentTimer, int instrumentTimerThreshold, String message) {

  pushMatrix();
  translate(posX, posY);
  pushStyle();
  strokeWeight(1);
  //Draw a small bar that indicates when you can retrig
  if (instrumentTimer < instrumentTimerThreshold) { 
    fill(255, 0, 0);
  } else {
    fill(snareColor);
  }

  rect(stageMargin, 0, constrain(map(instrumentTimer, 0, instrumentTimerThreshold, 0, timerWidth), 0, timerWidth), 10);
  stroke(255);
  line(stageMargin, -10, stageMargin, 20);
  line(stageMargin + timerWidth, -10, stageMargin + timerWidth, 20);
  fill(255);

  textAlign(CENTER);
  fill(255);
  textSize(16);
  text("Timer: " + instrumentTimerThreshold, (stageMargin + timerWidth)/2 + timerWidth/4, 0.5*stageMargin);

  textAlign(LEFT);
  //textSize(24);
  if (instrumentTimer >instrumentTimerThreshold) { 
    text(message, stageMargin, -25);
  } else {
    text("On hold...", stageMargin, -25);
  }
  popStyle();
  popMatrix();
}

int randomNoDublicates (int min, int max, int prevRandNum) {

  if (min == max) {
    return min;
  } else {

    randNum = ceil(random(min, max));
    while (randNum == prevRandNum) {
      randNum = int(random(min, max));
    }
    //println(randNum);
    return randNum;
  }
}

int sequentialOrder (int prevSeqNum) {
  int seqNum = prevSeqNum;
  //println(seqNum);
  return seqNum;
}