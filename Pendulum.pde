
class Pendulum{
  float x, y, z;
  Pendulum(){
    x = width/2;
    y = 0;
    z = 0;
  }
  
  void draw(){
    update();
    push();
    noStroke();
    fill(255);
    translate(x, y, z);
    sphere(10);
    pop();
    stroke(255);
    strokeWeight(1);
    line(-SPACE_SIZE/2, y, z, SPACE_SIZE/2, y, z);
    line(x, -SPACE_SIZE/2, z, x, SPACE_SIZE/2, z);
    line(x, y, -SPACE_SIZE/2, x, y, SPACE_SIZE/2);
  }
  
  void update(){
    //x = map(noise(millis()*0.001), 0, 1, -SPACE_SIZE/2, SPACE_SIZE/2);
    //y = map(noise(10 + millis()*0.001), 0, 1, -SPACE_SIZE/2, SPACE_SIZE/2);
    //z = map(noise(20 + millis()*0.001), 0, 1, -SPACE_SIZE/2, SPACE_SIZE/2);  
    
    x = sin(millis()*0.0002)*SPACE_SIZE/2;
    //y = sin(millis()*0.0003)*SPACE_SIZE/2;
    z = sin(millis()*0.0007)*SPACE_SIZE/2;
  }
}
