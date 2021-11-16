class Foot{
  
  float x, y, z;
  float v;
  float p = 0;
  float r;
  int type;
  float startAngle;
  float[] lastPosition = {0,0,0};
  //float[] lastVelocity = {0,0,0};
  float lastVelocityMag = 0;
  float lastAcceleration = 0;
  
  Foot(int _type){
    type = _type;
    r = SPACE_SIZE*0.4 + type*0;
    y = SPACE_SIZE/2;
    //startAngle = type == LEFT ?  : 0;
  }
  
  void draw(){
    
    //update();
    
    fill(255);
    noStroke();
    push();
    translate(x, y, z);
    sphere(10);  
    pop();
    
    stroke(255, 0, 0);
    strokeWeight(1);
    //line(-SPACE_SIZE/2, y, z, SPACE_SIZE/2, y, z);
    //line(x, -SPACE_SIZE/2, z, x, SPACE_SIZE/2, z);
    //line(x, y, -SPACE_SIZE/2, x, y, SPACE_SIZE/2);
    //line(0,SPACE_SIZE/2,0,x,y,z);
    
    float[] v = getVelocity();
    line(x, y, z, x+v[0]*10, y+v[1]*10, z+v[2]*10);
    stroke(0, 255, 0);
  }
  
  int handleEvents(){
    float a = getAcceleration();  
    float v = getVelocityMag();
    int event = NOTHING;
    
    if(v < VEL_THRESHOLD && lastVelocityMag >= VEL_THRESHOLD){
      event = KICK;
      //println(v + " - " + lastVelocityMag);
    }
    
    // Update lastAcceleration;
    lastAcceleration = a;
    
    return event;
  }
  
  void update(){
    lastVelocityMag = getVelocityMag();
    lastPosition = getPosition();
    
    float t = (type==1 ? PI : 0) + millis() * STEP_SPEED * 0.001;
    v = sin(t);
    if(v<0) v =0;
    p += v*0.05; 
    
    x = r*sin(startAngle + p);
    y = SPACE_SIZE/2-10*sin(v);
    z = r*cos(startAngle + p);
  }
  
  void update(float _x, float _y, float _z){
    lastVelocityMag = getVelocityMag();
    lastPosition = getPosition();
    
    x = _x;
    y = _y;
    z = _z;
  }
  
  float[] getPosition(){
    float[] pos ={x, y, z};   
    return pos;
  }
  
  float[] getVelocity(){
    float[] lp = lastPosition;
    float[] velocity = {x-lp[0], y-lp[1], z-lp[2]};  
    return velocity;
  }
  
  float getVelocityMag(){
    float[] v = getVelocity();  
    float mag = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
    return mag;
  }
    
  float getAcceleration(){
    float acceleration = getVelocityMag() - lastVelocityMag;
    return acceleration;
  }
}

void printVector(String name, float[] vec){
  println(name + ": [" + vec[0] + ", " + vec[1] + ", " + vec[2] + "]");
}
