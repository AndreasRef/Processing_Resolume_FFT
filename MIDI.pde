void midiBusSetup() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 2, 3); // Create a new MidiBus with the right input and output to match AKAI APC40
}


//Simples MIDI Recieve Functions. Perhaps also worth checking out the classBased ones?

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
  
  if (channel == 7 && pitch == 57 && velocity == 127) {
   bang(); 
  }
  
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  //Simple control messages
  if (channel == 0 && number == 7) {
  cp5.get("baseThreshold").setValue(int(map(value,0,127,100,1)));
  } 
  else if (channel == 1 && number == 7) {
  cp5.get("snareThreshold").setValue(int(map(value,0,127,100,0)));
  } 
    
  else if (channel == 0 && number == 16) {
  cp5.get("base").setValue(int(map(value,0,127,baseMin,baseMax)));
  } else if (channel == 0 && number == 17) {
  cp5.get("snare").setValue(int(map(value,0,127,snareMin,snareMax)));
  }
  else if (channel == 2 && number == 7) {
  cp5.get("baseTimerThreshold").setValue(int(map(value,0,127,0,1000)));
  }
  
  else if (channel == 3 && number == 7) {
  cp5.get("snareTimerThreshold").setValue(int(map(value,0,127,0,1000)));
  }
}