void controlP5Setup() {

  cp5 = new ControlP5(this);

  //Controllers are organized from the top and down and left to right

  cp5.addSlider("base")
    .setPosition(stageMargin+25 + 50*baseMin, 70)
    .setWidth(50*(baseMax-baseMin))
    .setRange(baseMin, baseMax)
    .setValue(0)
    .setNumberOfTickMarks(baseMax-baseMin + 1)
    ;

  cp5.addSlider("snare")
    .setPosition(stageMargin+25+50*snareMin, 80)
    .setWidth(50*(snareMax-snareMin))
    .setRange(snareMin, snareMax) 
    .setValue(5)
    .setNumberOfTickMarks(snareMax-snareMin + 1)
    ;


  cp5.addSlider("baseThreshold").setPosition(75, 100).setSize(10, 100).setColorForeground(baseColor).setColorActive(baseColor).setRange(100, 0).setValue(5);
  cp5.getController("baseThreshold").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingY(10);

  cp5.addSlider("snareThreshold").setPosition(width-75, 100).setSize(10, 100).setColorForeground(snareColor).setColorActive(snareColor).setRange(100, 0).setValue(50);
  cp5.getController("snareThreshold").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingY(10);

  cp5.addKnob("baseTimerThreshold").setPosition(width/2-75, 275).setRadius(25).setColorForeground(baseColor).setColorActive(baseColor).setRange(1, 1000).setValue(50);
  cp5.getController("baseTimerThreshold").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("baseTimerThreshold").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);  


  cp5.addKnob("snareTimerThreshold").setPosition(width - stageMargin- 50, 275).setRadius(25).setColorForeground(snareColor).setColorActive(snareColor).setRange(1, 1000).setValue(50);
  cp5.getController("snareTimerThreshold").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("snareTimerThreshold").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);  


  Group BASEOSC = cp5.addGroup("BASEOSC")
    .setPosition(stageMargin-25, 400)
    .setSize(300, 150)
    .activateEvent(true)
    .setColorBackground(0)
    .setColorLabel(baseColor)
    .setBackgroundColor(color(255, 80))
    //.setBackgroundHeight(100)
    .setLabel("BASE OSC Controls")
    ;

  baseClipsColumnsEffect = cp5.addRadioButton("baseClipsColumnsEffect")
    .setPosition(10, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("Clips", 0)
    .addItem("Columns", 1)
    .addItem("Effect", 2)
    .setNoneSelectedAllowed(false)
    .activate(0)
    .setGroup(BASEOSC)
    ;


  baseLayerClips = cp5.addRadioButton("baseLayerClips")
    .setPosition(100, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("LAYER 3", 3)
    .addItem("LAYER 2", 2)
    .addItem("LAYER 1", 1)
    .setNoneSelectedAllowed(false)
    .activate(0)
    .setGroup(BASEOSC)
    ;   


  cp5.addSlider("baseClipOrColumn")
    .setPosition(10, 75)
    .setWidth(100)
    .setRange(1, 7) // values can range from big to small as well
    .setValue(7)
    .setNumberOfTickMarks(7)
    .setSliderMode(Slider.FLEXIBLE)
    .setGroup(BASEOSC)
    .setLabel("Clip/Column")
    ;

  baseOverUnder = cp5.addRadioButton("baseOverUnder")
    .setPosition(200, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("silenceTrig", 0)
    .addItem("peakTrig", 1)
    .setNoneSelectedAllowed(false)
    .activate(0)
    .setGroup(BASEOSC)
    ;   


  cp5.addTextfield("BaseOscAdress")
    .setPosition(10, 100)
    .setSize(215, 30)
    //.setFont()
    .setFocus(false)
    //.setColor(color(255,0,0))
    //.setFont(createFont("arial",14))
    .setLabel("OSC Effect Adress")
    .setGroup(BASEOSC)
    ;


  cp5.addToggle("baseOscToggle")
    .setPosition(250, 110)
    .setSize(30, 20)
    .setGroup(BASEOSC)
    .setLabel("On/Off")
    ;



  Group SNAREOSC = cp5.addGroup("SNAREOSC")
    .setPosition(width/2+25, 400)
    .setSize(300, 150)
    .activateEvent(true)
    .setColorBackground(0)
    .setColorLabel(snareColor)
    //.setColorForeground(snareColor)
    .setBackgroundColor(color(255, 80))
    //.setBackgroundHeight(100)
    .setLabel("SNARE OSC Controls")
    ;

  snareClipsColumnsEffect = cp5.addRadioButton("snareClipsColumnsEffect")
    .setPosition(10, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("CLIPS", 0)
    .addItem("COLUMNS", 1)
    .addItem("EFFECT", 2)
    .setNoneSelectedAllowed(false)
    .activate(0)
    .setGroup(SNAREOSC)
    ;

  sequentialOrRandom = cp5.addRadioButton("sequentialOrRandom")
    .setPosition(80, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("Sequential", 0)
    .addItem("Random", 1)
    .setNoneSelectedAllowed(false)
    .activate(1)
    .setGroup(SNAREOSC)
    ;

  snareLayers = cp5.addCheckBox("snareLayers")
    .setPosition(180, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("Layer 3", 3)
    .addItem("Layer 2", 2)
    .addItem("Layer 1", 1)
    .setNoneSelectedAllowed(false)
    .activate(2)
    .setGroup(SNAREOSC)
    ;


  snareOscRange = cp5.addRange("range")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
    .setPosition(10, 75)
    .setSize(130, 10)
    .setHandleSize(20)
    .setRange(1, 6)
    .setDecimalPrecision(0)
    // after the initialization we turn broadcast back on again
    .setBroadcast(true)
    .setLowValue(1)
    .setHighValue(6)
    //.snapToTickMarks(true)
    //.setColorForeground(snareColor)
    //.setColorBackground(0) 
    .setGroup(SNAREOSC)
    ;


  cp5.addTextfield("SnareOscAdress")
    .setPosition(10, 100)
    .setSize(215, 30)
    //.setFont()
    .setFocus(false)
    //.setColor(color(255,0,0))
    //.setFont(createFont("arial",14))
    .setLabel("OSC Effect Adress")
    .setGroup(SNAREOSC)
    ;

  cp5.addToggle("snareOscToggle")
    .setPosition(250, 110)
    .setSize(30, 20)
    .setGroup(SNAREOSC)
    .setLabel("On/Off")
    ;


  Group FFT = cp5.addGroup("FFT")
    .setPosition(stageMargin-25, 575)
    .setWidth(300)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(100)
    .setLabel("FFT Variables")
    ;


  cp5.addSlider("myAudioAmp").setPosition(100, 10).setSize(175, 10).setRange(0, 100).setValue(65).setGroup(FFT);
  cp5.getController("myAudioAmp").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("myAudioAmp").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  cp5.addSlider("myAudioIndex").setPosition(100, 40).setSize(175, 10).setRange(0.0, 1.0).setValue(0.2).setGroup(FFT);
  cp5.getController("myAudioIndex").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("myAudioIndex").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  cp5.addSlider("myAudioIndexStep").setPosition(100, 70).setSize(175, 10).setRange(0.0, 1.0).setValue(0.5).setGroup(FFT);
  cp5.getController("myAudioIndexStep").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("myAudioIndexStep").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);


  fftWindow = cp5.addRadioButton("fftWindow")
    .setPosition(10, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("NONE", 0)
    .addItem("BARTLETT", 1)
    .addItem("BARTLETTHANN", 2)
    .addItem("BLACKMAN", 3)
    .addItem("GAUSS", 4)
    .setNoneSelectedAllowed(false)
    .setCaptionLabel("FFT Window Type") 
    .activate(0)
    .setGroup(FFT)
    ;

  cp5.addBang("bang").setPosition(width-40, height-40).setSize(20, 20).setLabel("reset");
}


public void bang() {
  //This is not updated right now...
  cp5.get("myAudioAmp").setValue(65);
  cp5.get("snareThreshold").setValue(50);
  cp5.get("snareTimerThreshold").setValue(50);
  cp5.get("myAudioIndex").setValue(0.2);
  cp5.get("myAudioIndexStep").setValue(0.5);
  cp5.get("fftWindow").setValue(4);
  snare = 5;
  fftWindow.activate(4);
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(snareLayers)) {

    print("got an event from "+snareLayers.getName()+"\t\n");
    // checkbox uses arrayValue to store the state of 
    // individual checkbox-items. usage:
    println(snareLayers.getArrayValue());
    int col = 0;

    for (int i=0; i<snareLayers.getArrayValue().length; i++) {
      int n = (int)snareLayers.getArrayValue()[i];
      print(n);
      if (n==1) {
        // myColorBackground += checkbox.getItem(i).internalValue();
      }
    }
    println();
  }

  if (theEvent.isFrom("range")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue(). min is at index 0, max is at index 1.

    minRange = int(theEvent.getController().getArrayValue(0));
    maxRange = int(theEvent.getController().getArrayValue(1));
  }
}