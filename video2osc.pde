import processing.video.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Movie movie;
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
  // Load and play the video in a loop
  movie = new Movie(this, "pyrospeed0001-2081.mkv");
  //movie.loop();
  movie.play();
}

void movieEvent(Movie m) {
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
    hsum = hsum + hue(movie.pixels[i]);
    ssum = ssum + saturation(movie.pixels[i]);
    vsum = vsum + brightness(movie.pixels[i]);
    rsum = rsum + red(movie.pixels[i]);
    gsum = gsum + green(movie.pixels[i]);
    bsum = bsum + blue(movie.pixels[i]);
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
  image(movie, 0, 0, width, height);
}
