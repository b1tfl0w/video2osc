import processing.video.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
// Variable to hold onto Capture object.
Capture video;
// Variable to hold the movie.
//Movie movie;
float h, s, v, r, g, b, hsum, ssum, vsum, rsum, gsum, bsum;
int frame;
int sw = 640;
int sh = 480;

void setup() {
  size(640, 480);
  background(0);
  hsum = 0;
  ssum = 0;
  vsum = 0;
  rsum = 0;
  gsum = 0;
  bsum = 0;
  frame = 0;

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  // set remote
  myRemoteLocation = new NetAddress("127.0.0.1", 7001);
  // Start the capture process
  video = new Capture(this, width, height);  
  video.start();
  // Load and play the video in a loop
//  movie = new Movie(this, "pyrospeed0001-2081.mkv");
  //movie.loop();
//  movie.play();
}

//void movieEvent(Movie m) {
void captureEvent(Capture m) {  
  m.read();
  //color c = movie.pixels[50];
OscMessage hueMsg = new OscMessage("/hue");
OscMessage satMsg = new OscMessage("/sat");
OscMessage valMsg = new OscMessage("/val");
OscMessage rMsg = new OscMessage("/r");
OscMessage gMsg = new OscMessage("/g");
OscMessage bMsg = new OscMessage("/b");
OscMessage fMsg = new OscMessage("/frame");
  for (int i = 0; i < sw*sh; i++) {
    hsum = hsum + hue(video.pixels[i]);
    ssum = ssum + saturation(video.pixels[i]);
    vsum = vsum + brightness(video.pixels[i]);
    rsum = rsum + red(video.pixels[i]);
    gsum = gsum + green(video.pixels[i]);
    bsum = bsum + blue(video.pixels[i]);
  }
  h = hsum/(sw*sh);      
  s = ssum/(sw*sh);           
  v = vsum/(sw*sh);      
  r = rsum/(sw*sh);      
  g = gsum/(sw*sh);           
  b = bsum/(sw*sh);      
  hueMsg.add(h); /* add an int to the osc message */
  satMsg.add(s);
  valMsg.add(v);
  rMsg.add(r); /* add an int to the osc message */
  gMsg.add(g);
  bMsg.add(b);
  fMsg.add(frame);
  /* send the message */
  oscP5.send(hueMsg, myRemoteLocation);
  oscP5.send(satMsg, myRemoteLocation);
  oscP5.send(valMsg, myRemoteLocation);
  oscP5.send(rMsg, myRemoteLocation);
  oscP5.send(gMsg, myRemoteLocation);
  oscP5.send(bMsg, myRemoteLocation);
  oscP5.send(fMsg, myRemoteLocation);
  //print(h, s, v, "\n"); //turn on only for debug!
  hsum = 0;
  ssum = 0;
  vsum = 0;
  rsum = 0;
  gsum = 0;
  bsum = 0;
  frame = frame + 1;
}

void draw() {
  //if (movie.available() == true) {
  //  movie.read();
  //}
  image(video, 0, 0, width, height);
}
