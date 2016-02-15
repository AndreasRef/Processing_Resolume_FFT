void minimSetup() {
  minim   = new Minim(this);
  myAudio = minim.getLineIn(Minim.MONO);

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
}

void minimSetWindow() {
  switch(int(fftWindow.getValue())) {
  case 0: 
    myAudioFFT.window(FFT.NONE);
    break;
  case 1: 
    myAudioFFT.window(FFT.BARTLETT);
    break;
  case 2: 
    myAudioFFT.window(FFT.BARTLETTHANN);
    break;
  case 3: 
    myAudioFFT.window(FFT.BLACKMAN);
    break;
  case 4: 
    myAudioFFT.window(FFT.GAUSS);
    break;
  }
}

void stop() {
  myAudio.close();
  minim.stop();  
  super.stop();
}