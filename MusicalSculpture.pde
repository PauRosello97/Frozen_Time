import oscP5.*;
import netP5.*;

Pendulum pendulum;
ArrayList<Cube> cubes;
final int SPACE_SIZE = 400;
final int GRID_SIZE = 5;
Cube spaceCube;
Cube currentCube;
OscP5 oscP5;
NetAddress myRemoteLocation;
final int SELECTED_NOTE = 5;

void setup()  {
  size(900, 900, P3D);
  pendulum = new Pendulum();
  currentCube = new Cube(0,0,0,0,0);
  oscP5 = new OscP5(this, 57121); // Processing works with 9999. No bigger!
  myRemoteLocation = new NetAddress("127.0.0.1", 9999);
  
  float cubeSize = SPACE_SIZE / GRID_SIZE;
  spaceCube = new Cube(0, 0, 0, SPACE_SIZE, 0);
  
  cubes = new ArrayList<Cube>();
  for(int i=0; i<GRID_SIZE; i++){
    for(int j=0; j<GRID_SIZE; j++){
      for(int k=0; k<GRID_SIZE; k++){
        cubes.add(new Cube(-SPACE_SIZE/2+(i+0.5)*cubeSize, -SPACE_SIZE/2+(j+0.5)*cubeSize, -SPACE_SIZE/2+(k+0.5)*cubeSize, cubeSize, notes[i][j][k]));
      }
    }
  }
}

void draw()  {
  background(0);
  lights();

  if(mousePressed) {
    ortho(-width/2, width/2, -height/2, height/2);
  } else {
    float fov = PI/3.0;
    float cameraZ = (height/2.0) / tan(fov/2.0);
    perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0);
  }
  translate(width/2, height/2, 0);
  rotateX(-PI/6);
  rotateY(PI/3);
  stroke(255);
  noFill();
  
  stroke(255);
  strokeWeight(1);
  for(Cube cube : cubes){
   
    if(cube.contains(pendulum)){
      if(cube != currentCube){
        playNote(cube.note);
        currentCube = cube;
      }
       
    }cube.draw(); 
      
  }
  strokeWeight(3);
  stroke(255, 0, 0);
  spaceCube.draw();
  
  pendulum.draw();
}

void playNote(int note){
  println(note);  
  OscMessage myMessage = new OscMessage("/note");
  
  myMessage.add(note); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

void oscEvent(OscMessage m) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println(m + "");
  if(m.checkAddrPattern("/position")){
    String v = m.get(0).stringValue();
    String[] coord = v.split(" ");
    println(v);
    float x = float(coord[0].substring(2));
    float y = float(coord[1].substring(2));
    float z = float(coord[2].substring(2));
    pendulum.x = x;
    pendulum.y = -(z-7)*1.5+SPACE_SIZE/2;
    pendulum.z = y;
    println("[" + x + ", " + y + ", " + z + "]"); 
  }
}
