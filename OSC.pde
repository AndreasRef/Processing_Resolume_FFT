void oscSetup() {
  oscP5 = new OscP5(this, portToListenTo);
  myRemoteLocation = new NetAddress(ipAddressToSendTo, portToSendTo);  
  myMessage = new OscMessage("/"); 
}