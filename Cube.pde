class Cube{
  
  float x, y, z;
  float size;
  int note, bassNote;

  Cube(float _x, float _y, float _z, float _size, int _note, int _bassNote){
    x = _x;
    y = _y;
    z = _z;
    size = _size; 
    note = _note;
    bassNote = _bassNote;
  }
  
  void draw(){
    push();
    translate(x, y, z);
    //if(bassNote == G[0]) fill(127);
    box(size); //TODO: Displaying size
    pop();
  }
    
  boolean contains(Pendulum p){    
    return p.x>=x-size/2 && p.x<x+size/2
        && p.y>=y-size/2 && p.y<y+size/2
        && p.z>=z-size/2 && p.z<z+size/2;
  }
}
