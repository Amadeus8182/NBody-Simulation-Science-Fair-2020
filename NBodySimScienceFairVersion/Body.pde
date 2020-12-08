class Body {
 PVector pos;  
 PVector velocity;
 float radius;
 float mass;
 color rgb;
 Body(float x, float y, float r, float m, float vx, float vy, color c) {
   pos = new PVector(x,y);
   velocity = new PVector(vx, vy);
   radius = r;
   mass = m;
   rgb = c;
 }
 
 void updateVelocity(Body body) {
   float dist = dist(pos.x, pos.y, body.pos.x, body.pos.y);
   if(body != this) {    
    PVector deltaPos = new PVector(body.pos.x-pos.x,body.pos.y-pos.y);
    float denom = (dist*dist+sft*sft)*sqrt(dist*dist+sft*sft);
    PVector acceleration = new PVector(G*body.mass*deltaPos.x/denom, G*body.mass*deltaPos.y/denom); 
    velocity.add(acceleration);
   }
 }
 
 void updatePosition() {   
   pos = new PVector((pos.x + (velocity.x) + width)%width, (pos.y + (velocity.y) + height)%height);
   //pos.add(velocity);
   //if(pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
   // pos = new PVector(random(width), random(height));
   // velocity.mult(0);
   // }
 }
 
 void display(Boolean sP, Boolean sPD) {
   stroke(rgb);
   //noStroke();
   //noFill();
   fill(rgb);
   
   strokeWeight(1);
   if(sP)circle(pos.x, pos.y, radius*2);
   //point(pos.x, pos.y);
   //stroke(255,25);
   stroke(rgb);
   if(sPD)line(pos.x, pos.y, velocity.x*10+pos.x, velocity.y*10+pos.y);
 } 
}
