class QuadTree {
  PVector pos;
  PVector size;
  PVector COM;
  float capacity;
  float mass = 0;
  Boolean divided = false;
  Body[] Bodys = new Body[0];
  QuadTree[] children = new QuadTree[4];

  QuadTree(float x, float y, float w, float h, float n) {
    pos = new PVector(x, y);
    size = new PVector(w, h);
    capacity = n;
  }

  void display() {
    stroke(85, 255, 255);
    strokeWeight(1);
    noFill();
    rect(pos.x, pos.y, size.x, size.y);
    //if(divided || Bodys.length > 0) circle(COM.x, COM.y, mass);  
    if (divided == true) {
      children[0].display();
      children[1].display();
      children[2].display();
      children[3].display();
    }
  }

  void insertBody(Body pt) {
    if (Bodys.length < capacity && divided == false) {
      Bodys = (Body[])append(Bodys, pt);
    } else if (Bodys.length >= capacity || divided == true) {
      if (divided == false) {
        subDivide();
      }
      Bodys = (Body[])append(Bodys, pt);
      for (Body Body : Bodys) {
        checkQuad(children[0], Body);
        checkQuad(children[1], Body);
        checkQuad(children[2], Body);
        checkQuad(children[3], Body);
      }
      Bodys = new Body[0];
    }
  }

  Body[] query(PVector pos, float r) {   
    Body[] pts = new Body[0];   
    if (intersects(pos, r, this)) {
      for (Body pt : Bodys) {
        float dt = dist(pt.pos.x, pt.pos.y, pos.x, pos.y);
        if (dt < r && dt != 0) {
          pts = (Body[])append(pts, pt);
        }
      }
      if (divided == true) {
        Body[][] ptChild = new Body[4][0];
        ptChild[0] = children[0].query(pos, r);
        ptChild[1] = children[1].query(pos, r);
        ptChild[2] = children[2].query(pos, r);
        ptChild[3] = children[3].query(pos, r);
        for (int i = 0; i < ptChild.length; i++) {
          for (Body pt : ptChild[i]) {
            pts = (Body[])append(pts, pt);
          }
        }
      }
    }
    return pts;
  }

  void calculateCOM() {
   PVector[] COMS = new PVector[0];
   if(divided) {
    COM = new PVector(0,0);
    for(QuadTree qd : children) {
     if(qd.Bodys.length > 0 || qd.divided == true) { 
      qd.calculateCOM();
      COMS = (PVector[])append(COMS, qd.COM);
      mass += qd.mass;
     }
    }
    for(PVector com : COMS) {
     COM.add(com); 
    }
    COM.div(COMS.length);    
   } else {
     COM = new PVector(0,0);
     for(Body bd : Bodys) {
       mass += bd.mass;
       PVector bdPos = new PVector(bd.pos.x*bd.mass, bd.pos.y*bd.mass);
       COM.add(bdPos);
     }
     COM.div(mass);
   }
  }
  
  Body[] getParticles(Body bd) {  
    Body[] bdies = new Body[0];
    if(divided || Bodys.length > 0) {      
     float ratio = size.x/dist(bd.pos.x, bd.pos.y, COM.x, COM.y);
     if(ratio < threshold) {
      Body newBD = new Body(COM.x, COM.y, 10, mass, 0, 0, color(255, 0, 255));
      bdies = (Body[])append(bdies, newBD);
     } else if(ratio > threshold) {
      if(divided) {
       for(QuadTree qd : children) {
         for(Body body : qd.getParticles(bd)) bdies = (Body[])append(bdies, body);
       }
      } else if(Bodys.length > 0) {
        Body newBD = new Body(COM.x, COM.y, 10, mass, 0, 0, color(255, 0, 255));
        bdies = (Body[])append(bdies, newBD);
      }
     }
    }
    return bdies;
  }
  Boolean intersects(PVector p, float r, QuadTree quad) {
    float dX = max(quad.pos.x, min(p.x, quad.pos.x+quad.size.x));
    float dY = max(quad.pos.y, min(p.y, quad.pos.y+quad.size.y));
    float dist = dist(dX, dY, p.x, p.y);
    if (dist < r) {
      return true;
    }   
    return false;
  }

  void subDivide() {
    children[0] = new QuadTree(pos.x + size.x/2, pos.y, size.x/2, size.y/2, capacity);
    children[1] = new QuadTree(pos.x, pos.y, size.x/2, size.y/2, capacity);
    children[2] = new QuadTree(pos.x + size.x/2, pos.y + size.y/2, size.x/2, size.y/2, capacity);
    children[3] = new QuadTree(pos.x, pos.y + size.y/2, size.x/2, size.y/2, capacity);
    divided = true;
  }

  void checkQuad(QuadTree quad, Body pt) {
    if ((pt.pos.x >= quad.pos.x && pt.pos.x <= quad.pos.x+quad.size.x)&&(pt.pos.y >= quad.pos.y && pt.pos.y <= quad.pos.y+quad.size.y)) {
      quad.insertBody(pt);
    }
  }
}
