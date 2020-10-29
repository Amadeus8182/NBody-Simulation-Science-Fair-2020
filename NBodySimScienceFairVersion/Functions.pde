void keyPressed() {
 if(key == ' ') {
   playing = !playing;
 }
 if(keyCode == SHIFT && playing == false) {
   update();
 }
 if(keyCode == CONTROL) {
  BarnesHut = !BarnesHut; 
 }
 if(key == 'w' || key == 'W') {
  showParticles = !showParticles; 
 }
  if(key == 'e' || key == 'E') {
  showParticleDirection = !showParticleDirection; 
 }
  if(key == 'q' || key == 'Q') {
  showQuad = !showQuad; 
 }
  if(key == 'd' || key == 'D') {
  showDensity = !showDensity; 
 }
}

void update() {
 for(Body body : bodies) {
  if(BarnesHut) {
   Body[] nBodies = quad.getParticles(body);
   for(Body body2 : nBodies) {       
     body.updateVelocity(body2);
   }
  } else {
   for(Body body2 : bodies) {       
     body.updateVelocity(body2);
   }
  }
 }
 for(Body body : bodies) {
  body.updatePosition();
 } 
}

void display(Boolean sP, Boolean sPD) {
 for(Body body : bodies) {
  body.display(sP, sPD); 
 }
}

void showDensity() {
 loadPixels();
 for(int x = 0; x < width; x++) {
  for(int y = 0; y < height; y++) {
   int index = x + y*width;
   float sum = 0;
   for(Body b : bodies) {
     float dt = dist(x, y, b.pos.x, b.pos.y);
     sum += ((dens)*b.radius)/dt;
   }
   pixels[index] = color(constrain(map(sum, 0, 255, 0, 46),0,255), 255, 255);
  } 
 }
 updatePixels();
}

void printStat() {
 println(millis()/frameCount);
}
