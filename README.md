# Processing_Resolume_FFT
Automatic VJ interface for FFT powered communication between Processing, Resolume Arena and a MIDI controller


## Tested with:
Processing 3.0.1
Processing 3.0.2
Resolume Arena 5.0.1

## Processing libraries needed:
- oscP5
- netP5
- controlP5
- mimim
- themidibus


## Audio:
Current prototype uses soundFlower to analyse internal audio playing on the computer. To react to sound files placed on your computers local disk simply change from AudioInput to Audioplayer and from minim.getLineIn(Minim.MONO) to minim.loadFile(“yourMusicFile”) like so


**Global variable**
AudioPlayer   myAudio;
//AudioInput  myAudio;


**Setup in minim.pde **
myAudio = minim.loadFile(“yourMusicFile”);
//myAudio = minim.getLineIn(Minim.MONO);


## OSC Adresses
Make sure you type in the complete correct adress including slashes (e.g. */composition/link1/values*). Only works with parameters that accepts floats between 0.0-1.0.

###License: 
To come….

###Made by
Andreas Refsgaard for Circus Family 2016
www.andreasrefsgaard.dk
www.circusfamily.com
