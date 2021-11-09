class Cube{
  
  float x, y, z;
  float size;
  int note;

  Cube(float _x, float _y, float _z, float _size, int _note){
    x = _x;
    y = _y;
    z = _z;
    size = _size; 
    note = _note;
  }
  
  void draw(){
    push();
    translate(x, y, z);
    box(size); //TODO: Displaying size
    pop();
  }
    
  boolean contains(Pendulum p){    
    return p.x>=x-size/2 && p.x<x+size/2
        && p.y>=y-size/2 && p.y<y+size/2
        && p.z>=z-size/2 && p.z<z+size/2;
  }
}
