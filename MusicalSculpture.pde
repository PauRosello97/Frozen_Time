import oscP5.*;
import netP5.*;

Pendulum pendulum;
ArrayList<Cube> cubes;
Cube spaceCube;
Cube currentCube;
OscP5 oscP5;
NetAddress myRemoteLocation;
Foot leftFoot, rightFoot;

int lastBassNote = -1;

void setup()  {
  size(900, 900, P3D);
  pendulum = new Pendulum();
  currentCube = new Cube(0,0,0,0,0,0);
  oscP5 = new OscP5(this, 57121); // Processing works with 9999. No bigger!
  myRemoteLocation = new NetAddress("127.0.0.1", 9999);
  
  leftFoot = new Foot(LEFT);
  rightFoot = new Foot(RIGHT);
  
  float cubeSize = SPACE_SIZE / GRID_SIZE;
  spaceCube = new Cube(0, 0, 0, SPACE_SIZE, -1, -1);
  
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0);
  
  cubes = new ArrayList<Cube>();
  for(int i=0; i<GRID_SIZE; i++){
    for(int j=0; j<GRID_SIZE; j++){
      for(int k=0; k<GRID_SIZE; k++){
        cubes.add(new Cube(-SPACE_SIZE/2+(i+0.5)*cubeSize, -SPACE_SIZE/2+(j+0.5)*cubeSize, -SPACE_SIZE/2+(k+0.5)*cubeSize, cubeSize, notes[i][j][k], bassNotes[i][j][k]));
      }
    }
  }
}

void draw()  {
  background(0);
  lights();

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
        playNote(cube);
        currentCube = cube;
      }
      cube.draw();  
    }
  }
  
  handleEvents();
  
  leftFoot.draw();
  rightFoot.draw();
  
  strokeWeight(3);
  stroke(255, 0, 0);
  noFill();
  spaceCube.draw();
  pendulum.draw();
}

void playNote(Cube cube){
  int note = cube.note;
  int bassNote = cube.bassNote;
  println(bassNote);  
  
  OscMessage noteMessage = new OscMessage("/note");
  noteMessage.add(note); 
  oscP5.send(noteMessage, myRemoteLocation); 
  
  if(bassNote!=-1 && bassNote != lastBassNote){
    lastBassNote = cube.bassNote;  
    OscMessage bassMessage = new OscMessage("/bass");
    bassMessage.add(bassNote); 
    oscP5.send(bassMessage, myRemoteLocation); 
  }
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

void handleEvents(){
  int event = leftFoot.handleEvents();
  if(event == NOTHING) event = rightFoot.handleEvents();
  if(event == KICK) sendMessage("kick");
}

void sendMessage(String value){
  OscMessage noteMessage = new OscMessage("/"+value);
  oscP5.send(noteMessage, myRemoteLocation); 
}
