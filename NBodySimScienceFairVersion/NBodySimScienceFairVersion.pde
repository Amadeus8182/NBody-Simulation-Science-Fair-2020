//CONSTANTS
float sft = 75;
float G = 0.5;
float threshold = 1;
int timeStep = 1;
int N = 10000;

//DISPLAYS AND STATS
float dens = 5;
int milli = 0;
int endFrame = 500;

//BOOLEANS FOR UPDATES AND DISPLAYS
Boolean playing = true;
Boolean showParticles = true;
Boolean showParticleDirection = false;
Boolean showQuad = false;

//QUAD AND BODY
Body[] bodies = new Body[0];
QuadTree quad;

//BARNES-HUT ALGORITHM / PARTICLE-PARTICLE METHOD
Boolean BarnesHut = true;

void setup() {
 size(980, 980);
 colorMode(HSB);
 smooth();

 for(int i = 0; i < n; i++) {
  float a = random(0, 360);
  float r = (height/2-100) * sqrt(random(1));  
  color c;
  c = color(180, 215, 235, 55);
  bodies = (Body[])append(bodies, new Body(r*cos(radians(a))+width/2, r*sin(radians(a))+height/2, 0.5, 25, 0, 0, color(c)));  
 }
}

void draw() {
 background(0);
 fill(255);
 
 //QUAD
 if(BarnesHut) {
  quad = new QuadTree(0, 0, width, height, 1);
  for(Body body : bodies) {
    quad.insertBody(body);
  } 
  quad.calculateCOM();
 }
 //UPDATES
 if(playing) {
   for(int i = 0; i < timeStep; i++) {
    update(); 
   }
 }
 
 //DISPLAY
 if(showQuad) quad.display();  
 if(showDensity) showDensity(); 
 display(showParticles, showParticleDirection);
 
 //TEXT INFO
 fill(255);
 text("FPS: "+floor(frameRate), 0, 10);
 text("N = " + bodies.length, 0, 20);
 text("Frame Count: " + frameCount, 0, 30);
 text("Timesteps Per Frame: " + timeStep, 0, 40);
 text("Threshold: " + threshold, 0, 50);
 text("Gravity: " + G, 0, 60);
 text("Dampening: " + sft, 0, 70);
 if(BarnesHut) {
  text("Barnes-Hut Algorithm", 0, 80);
 } else {
  text("Particle-Particle Method", 0, 80); 
 }
 
 //EXIT
 if(frameCount == endFrame) {
  printStat();
  exit(); 
 }
}
