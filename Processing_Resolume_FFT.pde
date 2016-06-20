//YellowClaw Master: MIDI, OSC, controlP5, Minim

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

float       myAudioAmp       = 6500.0;
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

int         rectSize         = 70;

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

RadioButton baseSequentialOrRandom;

RadioButton baseLayerClips;
RadioButton baseOverUnder;

CheckBox snareLayers;
CheckBox baseLayers;

Range snareOscRange;

Range baseOscRange;

boolean snareOscToggle = true;
boolean baseOscToggle = true;

//Shared timer GUI variable
int timerWidth = 275;

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

//Variables for range of clips/columns being triggered 
int snareMinRange = 1;
int snareMaxRange = 7;

int baseMinRange = 1;
int baseMaxRange = 7;

//Variables for random number
int randNum;
int prevRandNum;

//Variables for sequential numbers
int seqNum = 1;
int prevSeqNum=1;


//Experiments 
int snareClipNumber;
int baseClipNumber;

int snarePianoClip;
int basePianoClip;

boolean snarePeakToggle = true;
boolean basePeakToggle = true;



// ************************************************************************************

void setup() {

  size(1000, 750);
  //pixelDensity(2); //Uncomment this line if running on a Retina display
  background(bgColor);

  //minim setup
  minimSetup();

  //osc setup
  oscSetup();

  //controlP5 setup
  controlP5Setup();

  //midiBusSetup
  midiBusSetup();


  PFont pfont = createFont("Helvetica", 32, true);
  textFont(pfont, 12);
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
    fill(200); 
    text(str((int)tempIndexCon), xStart + (i*xSpacing) + 10, stageMargin+myAudioMax+(stageMargin/2));

    //SNARE
    if (i==snare && snareOscToggle==true) {

      if (snareClipsColumnsEffect.getValue() == 2 ) {
        OscMessage myMessage = new OscMessage(cp5.get(Textfield.class, "SnareOscAdress").getText());
        myMessage.add((myAudioFFT.getAvg(snare) * myAudioAmp) * myAudioIndexAmp / 100); /* add an int to the osc message */
        oscP5.send(myMessage, myRemoteLocation);
      } 
      //If volume exceeds threshold
      if ((myAudioFFT.getAvg(snare) * myAudioAmp) * myAudioIndexAmp > snareThreshold && snareTimer > snareTimerThreshold && snareOscToggle==true && snarePeakToggle == true) { 
        if (snareTimer > snareTimerThreshold) {     
          if (snareClipsColumnsEffect.getValue() == 0) { // Trig clips (not columns)
            for (int j=0; j<snareLayers.getArrayValue().length; j++) { //Go through all the layers
              if ((int)snareLayers.getArrayValue()[j] == 1) { //Trig clips in the layers that are activated by snareLayers
                if (sequentialOrRandom.getValue() == 0) {
                  snareClipNumber = sequentialOrder(prevSeqNum);
                } else if (sequentialOrRandom.getValue() == 1) {
                  snareClipNumber = randomNoDublicates(snareMinRange, snareMaxRange, prevRandNum);
                } 
                OscMessage myMessage = new OscMessage("/layer" + (3 - j) + "/clip" + snareClipNumber + "/connect");
                myMessage.add(1); /* add an int to the osc message */
                oscP5.send(myMessage, myRemoteLocation);
              }
            }
            prevSeqNum++;
            if (prevSeqNum > snareMaxRange) {
              prevSeqNum = snareMinRange;
            }
          } else if (snareClipsColumnsEffect.getValue() == 1 ) { //Trig entire columns

            if (sequentialOrRandom.getValue() == 0) {
              snareClipNumber = sequentialOrder(prevSeqNum);
            } else if (sequentialOrRandom.getValue() == 1) {
              snareClipNumber = randomNoDublicates(snareMinRange, snareMaxRange, prevRandNum);
            } 

            OscMessage myMessage = new OscMessage("/track" +  snareClipNumber + "/connect");
            myMessage.add(1); /* add an int to the osc message */
            oscP5.send(myMessage, myRemoteLocation);
            prevSeqNum++;

            if (prevSeqNum > snareMaxRange) {
              prevSeqNum = snareMinRange;
            }
          }
        }
        prevRandNum = randNum;
        snareLastTimer = millis();
      }

      //If volume is BELOW threshold
      if ((myAudioFFT.getAvg(snare) * myAudioAmp) * myAudioIndexAmp < snareThreshold && snareTimer > snareTimerThreshold && snareOscToggle==true && snarePeakToggle == false) { 
        if (snareTimer > snareTimerThreshold) {     
          if (snareClipsColumnsEffect.getValue() == 0) { // Trig clips (not columns)
            for (int j=0; j<snareLayers.getArrayValue().length; j++) { //Go through all the layers
              if ((int)snareLayers.getArrayValue()[j] == 1) { //Trig clips in the layers that are activated by snareLayers
                if (sequentialOrRandom.getValue() == 0) {
                  snareClipNumber = sequentialOrder(prevSeqNum);
                } else if (sequentialOrRandom.getValue() == 1) {
                  snareClipNumber = randomNoDublicates(snareMinRange, snareMaxRange, prevRandNum);
                } 
                OscMessage myMessage = new OscMessage("/layer" + (3 - j) + "/clip" + snareClipNumber + "/connect");
                myMessage.add(1); /* add an int to the osc message */
                oscP5.send(myMessage, myRemoteLocation);
              }
            }
            prevSeqNum++;
            if (prevSeqNum > snareMaxRange) {
              prevSeqNum = snareMinRange;
            }
          } else if (snareClipsColumnsEffect.getValue() == 1 ) { //Trig entire columns

            if (sequentialOrRandom.getValue() == 0) {
              snareClipNumber = sequentialOrder(prevSeqNum);
            } else if (sequentialOrRandom.getValue() == 1) {
              snareClipNumber = randomNoDublicates(snareMinRange, snareMaxRange, prevRandNum);
            } 

            OscMessage myMessage = new OscMessage("/track" +  snareClipNumber + "/connect");
            myMessage.add(1); /* add an int to the osc message */
            oscP5.send(myMessage, myRemoteLocation);
            prevSeqNum++;

            if (prevSeqNum > snareMaxRange) {
              prevSeqNum = snareMinRange;
            }
          }
        }
        prevRandNum = randNum;
        snareLastTimer = millis();
      }


      //BASE
    } else if (i ==base && baseOscToggle==true) {
      if (baseClipsColumnsEffect.getValue() == 2 ) {
        OscMessage myMessage = new OscMessage(cp5.get(Textfield.class, "BaseOscAdress").getText());
        myMessage.add((myAudioFFT.getAvg(snare) * myAudioAmp) * myAudioIndexAmp / 100); /* add an int to the osc message */
        oscP5.send(myMessage, myRemoteLocation);
      } 
      //If volume exceeds threshold
      if ((myAudioFFT.getAvg(base) * myAudioAmp) * myAudioIndexAmp > baseThreshold && baseTimer > baseTimerThreshold && baseOscToggle==true && basePeakToggle == true) { 
        if (baseTimer > baseTimerThreshold) {     
          if (baseClipsColumnsEffect.getValue() == 0) { // Trig clips (not columns)
            for (int j=0; j<baseLayers.getArrayValue().length; j++) { //Go through all the layers
              if ((int)baseLayers.getArrayValue()[j] == 1) { //Trig clips in the layers that are activated by baseLayers
                if (baseSequentialOrRandom.getValue() == 0) {
                  baseClipNumber = sequentialOrder(prevSeqNum);
                } else if (baseSequentialOrRandom.getValue() == 1) {
                  baseClipNumber = randomNoDublicates(baseMinRange, baseMaxRange, prevRandNum);
                } 
                OscMessage myMessage = new OscMessage("/layer" + (3 - j) + "/clip" + baseClipNumber + "/connect");
                myMessage.add(1); /* add an int to the osc message */
                oscP5.send(myMessage, myRemoteLocation);
              }
            }
            prevSeqNum++;
            if (prevSeqNum > baseMaxRange) {
              prevSeqNum = baseMinRange;
            }
          } else if (baseClipsColumnsEffect.getValue() == 1 ) { //Trig entire columns

            if (baseSequentialOrRandom.getValue() == 0) {
              baseClipNumber = sequentialOrder(prevSeqNum);
            } else if (baseSequentialOrRandom.getValue() == 1) {
              baseClipNumber = randomNoDublicates(baseMinRange, baseMaxRange, prevRandNum);
            } 

            OscMessage myMessage = new OscMessage("/track" +  baseClipNumber + "/connect");
            myMessage.add(1); /* add an int to the osc message */
            oscP5.send(myMessage, myRemoteLocation);
            prevSeqNum++;

            if (prevSeqNum > baseMaxRange) {
              prevSeqNum = baseMinRange;
            }
          }
        }
        prevRandNum = randNum;
        baseLastTimer = millis();
      }

      //If volume is BELOW threshold
      if ((myAudioFFT.getAvg(base) * myAudioAmp) * myAudioIndexAmp < baseThreshold && baseTimer > baseTimerThreshold && baseOscToggle==true && basePeakToggle == false) { 
        if (baseTimer > baseTimerThreshold) {     
          if (baseClipsColumnsEffect.getValue() == 0) { // Trig clips (not columns)
            for (int j=0; j<snareLayers.getArrayValue().length; j++) { //Go through all the layers
              if ((int)snareLayers.getArrayValue()[j] == 1) { //Trig clips in the layers that are activated by baseLayers
                if (baseSequentialOrRandom.getValue() == 0) {
                  baseClipNumber = (prevSeqNum);
                } else if (baseSequentialOrRandom.getValue() == 1) {
                  baseClipNumber = randomNoDublicates(baseMinRange, baseMaxRange, prevRandNum);
                } 
                OscMessage myMessage = new OscMessage("/layer" + (3 - j) + "/clip" + baseClipNumber + "/connect");
                myMessage.add(1); /* add an int to the osc message */
                oscP5.send(myMessage, myRemoteLocation);
              }
            }
            prevSeqNum++;
            if (prevSeqNum > baseMaxRange) {
              prevSeqNum = baseMinRange;
            }
          } else if (baseClipsColumnsEffect.getValue() == 1 ) { //Trig entire columns

            if (baseSequentialOrRandom.getValue() == 0) {
              baseClipNumber = sequentialOrder(prevSeqNum);
            } else if (baseSequentialOrRandom.getValue() == 1) {
              baseClipNumber = randomNoDublicates(baseMinRange, baseMaxRange, prevRandNum);
            } 

            OscMessage myMessage = new OscMessage("/track" +  baseClipNumber + "/connect");
            myMessage.add(1); /* add an int to the osc message */
            oscP5.send(myMessage, myRemoteLocation);
            prevSeqNum++;

            if (prevSeqNum > baseMaxRange) {
              prevSeqNum = baseMinRange;
            }
          }
        }
        prevRandNum = randNum;
        baseLastTimer = millis();
      }
    }
    myAudioIndexAmp+=myAudioIndexStep;
  }
  myAudioIndexAmp = myAudioIndex;

  //Audio max line
  stroke(#FF3300); 
  noFill();
  line(stageMargin, stageMargin+myAudioMax, stageMargin + rectSize*snareMax + rectSize, stageMargin+myAudioMax);

  //baseThreshold line
  strokeWeight(4); 
  stroke(baseColor, 122);
  line(stageMargin + rectSize*baseMin, 100+baseThreshold, stageMargin + rectSize*baseMax+rectSize, 100+baseThreshold);

  //snareThreshold line
  stroke(snareColor, 122);
  line(stageMargin + rectSize*snareMin, 100+snareThreshold, stageMargin + rectSize*snareMax + rectSize, 100+snareThreshold);

  drawTimer(width/2-75, 300, snareTimer, snareTimerThreshold, "READY TO TRIG"); //Draw snareTimer
  drawTimer(0, 300, baseTimer, baseTimerThreshold, "READY TO TRIG"); //Draw baseTimer
  snareTimer = millis() - snareLastTimer;
  baseTimer = millis() - baseLastTimer;


  //Warning text
  if (snareOscToggle && baseOscToggle && (baseClipsColumnsEffect.getValue() == 1) && (snareClipsColumnsEffect.getValue() == 1)) {
    fill(255, 0, 0);
    text("Warning! Both snare and base \nare set to control columns... ", width/2 +100, height-100);
  }

  if (frameCount % 30 == 0) {
    println("snarePianoClip: " + snarePianoClip);
    println("basePianoClip: " + basePianoClip);
  }


  //PianoTrigs
  if (baseClipsColumnsEffect.getValue() == 3 ) pianoTrig(1, basePianoClip, baseTimerThreshold, 0);
  if (snareClipsColumnsEffect.getValue() == 3 ) pianoTrig(1, snarePianoClip, snareTimerThreshold, 1);
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
    fill(0, 255, 0);
  }

  rect(stageMargin, 0, constrain(map(instrumentTimer, 0, instrumentTimerThreshold, 0, timerWidth), 0, timerWidth), 10);
  stroke(255);
  line(stageMargin, -10, stageMargin, 20);
  line(stageMargin + timerWidth, -10, stageMargin + timerWidth, 20);
  fill(255);

  //textAlign(CENTER);
  //fill(255);
  //textSize(16);
  //text("Timer: " + instrumentTimerThreshold, (stageMargin + timerWidth)/2 + timerWidth/2, 0.5*stageMargin);

  textAlign(LEFT);
  textSize(16);
  if (instrumentTimer >instrumentTimerThreshold) { 
    text(message, stageMargin, -25);
  } else {
    text("ON HOLD...", stageMargin, -25);
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
    return randNum;
  }
}

int sequentialOrder (int prevSeqNum) {
  int seqNum = prevSeqNum;
  return seqNum;
}



void pianoTrig(int layer, int clip, int timerThreshold, int baseOrSnare) {

  if (baseOrSnare == 0) {
    if (baseTimer < timerThreshold) {
      OscMessage myMessage = new OscMessage("/layer" + layer + "/clip" + clip  + "/connect");
      myMessage.add(1);
      oscP5.send(myMessage, myRemoteLocation);
    } else if (baseTimer >timerThreshold) { //else if (counter >frames) {
      OscMessage myMessage = new OscMessage("/layer" + layer + "/clip" + clip  + "/connect");
      myMessage.add(0);
      oscP5.send(myMessage, myRemoteLocation);
    }
  } else if (baseOrSnare == 1) {
    if (snareTimer < timerThreshold) {
      OscMessage myMessage = new OscMessage("/layer" + layer + "/clip" + clip  + "/connect");
      myMessage.add(1);
      oscP5.send(myMessage, myRemoteLocation);
    } else if (snareTimer >timerThreshold) { //else if (counter >frames) {
      OscMessage myMessage = new OscMessage("/layer" + layer + "/clip" + clip  + "/connect");
      myMessage.add(0);
      oscP5.send(myMessage, myRemoteLocation);
    }
  }
}