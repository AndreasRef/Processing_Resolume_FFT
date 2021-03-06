void controlP5Setup() {

  cp5 = new ControlP5(this);

  PFont pfont = createFont("Helvetica", 32, true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 14);
  cp5.setFont(font);
  //Controllers are organized from the top and down and left to right

  cp5.addSlider("base")
    .setPosition(stageMargin+35 + 50*baseMin, 40)
    .setWidth(rectSize*(baseMax-baseMin))
    .setHeight(20)
    .setRange(baseMin, baseMax)
    .setValue(0)
    .setNumberOfTickMarks(baseMax-baseMin + 1)
    .setSliderMode(Slider.FLEXIBLE)
    .setColorActive(baseColor)
    .setColorForeground(baseColor)
    .setColorLabel(baseColor)
    ;

  cp5.addSlider("snare")
    .setPosition(stageMargin+35+50*snareMin, 70)
    .setWidth(rectSize*(snareMax-snareMin))
    .setHeight(20)
    .setRange(snareMin, snareMax) 
    .setValue(5)
    .setNumberOfTickMarks(snareMax-snareMin + 1)
    .setSliderMode(Slider.FLEXIBLE)
    .setColorActive(snareColor)
    .setColorForeground(snareColor)
    .setColorLabel(snareColor)
    ;


  cp5.addSlider("baseThreshold").setPosition(65, 100).setSize(20, 100).setColorForeground(baseColor).setColorActive(baseColor).setRange(100, 0).setValue(50).setColorLabel(baseColor);
  cp5.getController("baseThreshold").getValueLabel();
  cp5.getController("baseThreshold").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingY(10);

  cp5.addSlider("snareThreshold").setPosition(width-110, 100).setSize(20, 100).setColorForeground(snareColor).setColorActive(snareColor).setRange(100, 0).setValue(50).setColorLabel(snareColor);
  cp5.getController("snareThreshold").getValueLabel();
  cp5.getController("snareThreshold").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingY(10);

  cp5.addKnob("baseTimerThreshold").setPosition(width/2-75, 275).setRadius(25).setColorForeground(baseColor).setColorActive(baseColor).setRange(1, 1000).setValue(50).setColorLabel(baseColor);
  cp5.getController("baseTimerThreshold").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("baseTimerThreshold").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);  


  cp5.addKnob("snareTimerThreshold").setPosition(width - stageMargin- 50, 275).setRadius(25).setColorForeground(snareColor).setColorActive(snareColor).setRange(1, 1000).setValue(50).setColorLabel(snareColor);
  cp5.getController("snareTimerThreshold").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("snareTimerThreshold").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);  


  Group BASEOSC = cp5.addGroup("BASEOSC")
    .setPosition(stageMargin-25, 400)
    .setBarHeight(18)
    .setSize(350, 200)
    .activateEvent(true)
    .setColorBackground(0)
    .setColorLabel(snareColor)
    //.setColorForeground(snareColor)
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
    .addItem("Pianop", 3)
    .setNoneSelectedAllowed(false)
    .activate(0)
    .setGroup(BASEOSC)
    ;


  baseLayers = cp5.addCheckBox("baseLayers")
    .setPosition(250, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("Layer3", 3)
    .addItem("Layer2", 2)
    .addItem("Layer1", 1)
    .setNoneSelectedAllowed(false)
    .activate(2)
    .setGroup(BASEOSC)
  ;



  baseOscRange = cp5.addRange("baseRange")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
    .setPosition(10, 85)
    .setSize(215, 10)
    .setHandleSize(20)
    .setRange(1, 6)
    .setDecimalPrecision(0)
    // after the initialization we turn broadcast back on again
    .setBroadcast(true)
    .setLowValue(1)
    .setHighValue(6) 
    .setGroup(BASEOSC)
    ;



  baseSequentialOrRandom = cp5.addRadioButton("baseSequentialOrRandom")
    .setPosition(125, 10)
    .setSize(20, 15)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .addItem("_Sequential", 0)
    .addItem("_Random", 1)
    .setNoneSelectedAllowed(false)
    .activate(1)
    .setGroup(BASEOSC)
    ;




  cp5.addTextfield("BaseOscAdress")
    .setPosition(10, 110)
    .setSize(215, 30)
    .setFocus(false)
    .setLabel("OSC Effect Adress")
    .setGroup(BASEOSC)
    ;


  cp5.addToggle("basePeakToggle")
    .setPosition(235, 110)
    .setSize(30, 20)
    .setGroup(BASEOSC)
    .setLabel("Peak")
    ;


  cp5.addToggle("baseOscToggle")
    .setPosition(280, 110)
    .setSize(30, 20)
    .setGroup(BASEOSC)
    .setLabel("On/Off")
    ;


  cp5.addSlider("basePianoClip")
    .setPosition(10, 170)
    .setSize(212, 10)
    .setRange(1, 6) // values can range from big to small as well
    .setValue(1)
    .setNumberOfTickMarks(6)
    .setSliderMode(Slider.FLEXIBLE)
    .setGroup(BASEOSC)
    ;



  Group SNAREOSC = cp5.addGroup("SNAREOSC")
    .setPosition(width/2+25, 400)
    .setBarHeight(18)
    .setSize(350, 200)
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
    .addItem("PIANO", 3)
    .setNoneSelectedAllowed(false)
    .activate(0)
    .setGroup(SNAREOSC)
    ;

  sequentialOrRandom = cp5.addRadioButton("sequentialOrRandom")
    .setPosition(125, 10)
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
    .setPosition(250, 10)
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


  snareOscRange = cp5.addRange("snareRange")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
    .setPosition(10, 85)
    .setSize(215, 10)
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
    .setPosition(10, 110)
    .setSize(215, 30)
    //.setFont()
    .setFocus(false)
    //.setColor(color(255,0,0))
    //.setFont(createFont("arial",14))
    .setLabel("OSC Effect Adress")
    .setGroup(SNAREOSC)
    ;


  cp5.addToggle("snarePeakToggle")
    .setPosition(245, 110)
    .setSize(30, 20)
    .setGroup(SNAREOSC)
    .setLabel("Peak")
    ;


  cp5.addToggle("snareOscToggle")
    .setPosition(295, 110)
    .setSize(30, 20)
    .setGroup(SNAREOSC)
    .setLabel("On/Off")
    ;

  cp5.addSlider("snarePianoClip")
    .setPosition(10, 170)
    .setSize(212, 10)
    .setRange(1, 6) // values can range from big to small as well
    .setValue(1)
    .setNumberOfTickMarks(6)
    .setSliderMode(Slider.FLEXIBLE)
    .setGroup(SNAREOSC)
    ;


  Group FFT = cp5.addGroup("FFT")
    .setPosition(stageMargin-25, 625)
    .setBarHeight(18)
    .setWidth(350)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(100)
    .setLabel("FFT Variables")
    ;


  int fftOffsetX = 150;

  cp5.addSlider("myAudioAmp").setPosition(fftOffsetX, 10).setSize(175, 10).setRange(0, 15000).setValue(6500).setGroup(FFT);
  cp5.getController("myAudioAmp").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("myAudioAmp").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  cp5.addSlider("myAudioIndex").setPosition(fftOffsetX, 40).setSize(175, 10).setRange(0.0, 1.0).setValue(0.2).setGroup(FFT);
  cp5.getController("myAudioIndex").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("myAudioIndex").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  cp5.addSlider("myAudioIndexStep").setPosition(fftOffsetX, 70).setSize(175, 10).setRange(0.0, 1.0).setValue(0.5).setGroup(FFT);
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

  cp5.addBang("bang").setPosition(width-75, height-75).setSize(40, 40).setLabel("reset");
  cp5.getController("bang").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
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


  if (theEvent.isFrom(baseLayers)) {

    print("got an event from "+baseLayers.getName()+"\t\n");
    // checkbox uses arrayValue to store the state of 
    // individual checkbox-items. usage:
    println(baseLayers.getArrayValue());
    int col = 0;

    for (int i=0; i<baseLayers.getArrayValue().length; i++) {
      int n = (int)baseLayers.getArrayValue()[i];
      print(n);
      if (n==1) {
        // myColorBackground += checkbox.getItem(i).internalValue();
      }
    }
    println();
  }


  if (theEvent.isFrom("snareRange")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue(). min is at index 0, max is at index 1.

    snareMinRange = int(theEvent.getController().getArrayValue(0));
    snareMaxRange = int(theEvent.getController().getArrayValue(1));
  }
  
  
  if (theEvent.isFrom("baseRange")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue(). min is at index 0, max is at index 1.

    baseMinRange = int(theEvent.getController().getArrayValue(0));
    baseMaxRange = int(theEvent.getController().getArrayValue(1));
  }
  
}