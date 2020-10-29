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

void printStat() {
 println(millis()/frameCount);
}
