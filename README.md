# Processing_Resolume_FFT
Automatic VJ interface for FFT powered communication between Processing, Resolume Arena and a MIDI controller


Processing libraries needed:
- oscP5
- netP5
- controlP5
- mimim
- themidibus

Works with:
Processing 3.0.1
Processing 3.0.2
&
Resolume Arena 5.0.1


Audio:
Current prototype uses soundFlower to analyse internal audio playing on the computer. To react to sound files placed on your computers local disk simply change from AudioInput to Audioplayer and from minim.getLineIn(Minim.MONO) to minim.loadFile(“yourMusicFile”) like so


***Global***
//AudioInput    myAudio;
AudioPlayer   myAudio;


***Setup***
//myAudio = minim.getLineIn(Minim.MONO);
myAudio = minim.loadFile(“yourMusicFile”);


License: 
To come….

Made by
Andreas Refsgaard for Circus Family 2016
www.andreasrefsgaard.dk
www.circusfamily.com
