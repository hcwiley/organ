 /**
*Hit P to start playing music. <br />
*Use arrow keys to move the picture around.<br />
*Hold Ctrl key and move mouse around to control x,y and rotations<br />
*Hold Shift key and move mouse around to control z and rotations<br />
*Hold Alt key and move mouse around to contrl x,y position<br />
*Press R to rotate around X axis 15 degrees<br />
*/
import ddf.minim.*;
import processing.opengl.*;

Minim minim;
AudioInput player;
String[] lines;
int check;
int[][] vec;
int totalI = 0;
int mx =0 , my =0 , mz =0 , dx, dy, dz, l, tx = 400, ty = 300;
float s;
float x1 = 50, x2 = 550, y1 = 300, y2 = 600;
float lc, rc;
void setup()
{
  size(1280,800, OPENGL);
  lines = loadStrings("small.vec");
  vec = new int[3][lines.length];
  minim = new Minim(this);
  s = .25;
  frameRate(26);
  // load a file, give the AudioPlayer buffers that are 2048 samples long
  player = minim.getLineIn(Minim.STEREO, 1024);
  // play the file
  noStroke();
  l = lines.length;
  for(int i = 0; i<l;i++){
    String pieces[] = split(lines[i], ' ');
    for(int c=0; c<3; c++)
      vec[c][i]= int(pieces[c]);
  }
}

void draw()
{
  lights();
  translate(tx, ty, 0);
  scale(s);
  rotateX(map(mx, 0, width, 0, PI));
  rotateY(map(my, 0, width, 0, PI));
  rotateZ(map(mz, 0, height, 0, -PI));
//  translate(700, 700, 700);
  float xpoints[][] = new float[3144][3];
  if(check % 10 == 0){
    for(int i = 0; i < player.bufferSize() - 1; i++){
      if(totalI < 3143)
        totalI ++;
      else
        totalI = 0;
      lc = player.left.get(i);
      rc = player.right.get(i);
      //print("lc: "+ lc+", rc: "+rc);
      //xpoints[totalI][0] = (lc/abs(lc))*(lc*245)*(lc*845);
      xpoints[totalI][0] = (lc/abs(lc))*((lc*345)*(lc*845));
      xpoints[totalI][1] = (rc/abs(rc))*((rc*945)*(rc*945));
      xpoints[totalI][2] = (lc/abs(lc))*((lc*245)*(rc*345));
    }
    shapeMode(CENTER);
    beginShape(QUADS);
    background(0);
    for(int i = 0; i<l; i++){
      //stroke((xpoints[i][0]),(xpoints[i][1]),(xpoints[i][2]));
      fill(156-(xpoints[i][0]),15*(xpoints[i][1]),255-(xpoints[i][2]));
      //stroke(random(255),random(255),random(255));
      if (i < 6144)
        vertex(vec[0][i]+xpoints[i][0], vec[1][i]+xpoints[i][1], vec[2][i]+xpoints[i][2]);
    }
    endShape(CLOSE);
  }
  check ++;
  if(check < 0){
    println("reloading...");
    lines = loadStrings("saved.vec");
    l = lines.length;
    for(int i = 0; i<l; i++){
      String pieces[] = split(lines[i], ' ');
      for(int c=0; c<3; c++)
        vec[c][i]= int(pieces[c]);
    }
    check = 0;
  }
}

void keyPressed()
{
  if(keyCode == CONTROL){
        mx = mouseX;//(x - mouseX)+ x;
        my = mouseY;//(y - mouseY)+ y;SDSDS
  }
  else if ( key == 'p' ){
    print("playing...\n");
    //player.play();
  }
  else if(keyCode == SHIFT){
    mz =  mouseY;//(z - mouseY)+ z;
  }
  else if(keyCode == ALT){
    tx = mouseX;
    ty = mouseY;
  }
  else if(keyCode == UP){
    print(key+"\n");
    ty -= 15;
  }
  else if(keyCode == DOWN){
    print(key+"\n");
    ty += 15;
  }
  else if(keyCode == LEFT){
    print(key+"\n");
    tx -= 15;
  }
  else if(keyCode == RIGHT){
    print(key+"\n");
    tx += 15;
  }
  else if (key == 'b' || key == 'B'){
    s = s*1.5;
  }
  else if(key=='l' || key == 'L'){
    s = s*.50;
  }
  else if ( key == 's' ) super.stop();
  else if ( key == '1' ){
    mx =0 ; my =0 ; mz =0 ; tx = 400; ty = 300; s = .25;
    println("Preset 1\nmx= "+mx +"; my= "+ my +"; mz= "+mz+"; dx= "+dx +"; dy= "+dy+"; dz= "+dz+"; tx= "+tx +"; ty= "+ty);
  }
  else if ( key == '2' ){
    mx = 450; my =0 ;  mz =490 ; tx = 404; ty = 607;
    println("Preset 1\nmx= "+mx +"; my= "+ my +"; mz= "+mz+"; dx= "+dx +"; dy= "+dy+"; dz= "+dz+"; tx= "+tx +"; ty= "+ty);
  }
  else if ( key == '3' ){
    mx= 787; my= 752; mz= 533; tx= 524; ty= 292;
    println("Preset 2\nmx= "+mx +"; my= "+ my +"; mz= "+mz+"; dx= "+dx +"; dy= "+dy+"; dz= "+dz+"; tx= "+tx +"; ty= "+ty);
  }
  else if ( key == '4' ){
    mx= 193; my= 172; mz= 899; dx= 0; dy= 0; dz= 0; tx= 508; ty= 659;
    println("Preset 2\nmx= "+mx +"; my= "+ my +"; mz= "+mz+"; dx= "+dx +"; dy= "+dy+"; dz= "+dz+"; tx= "+tx +"; ty= "+ty);
  }

  else if ( key == 'q' ) println("mx= "+mx +"; my= "+ my +"; mz= "+mz+"; dx= "+dx +"; dy= "+dy+"; dz= "+dz+"; tx= "+tx +"; ty= "+ty);
  else if ( key == 'r' ) mx+=15;
  //else if ( key == 'f' ) player.loop(10);
}

void stop()
{
  // always close Minim audio classes when you are done with them
  player.close();
  // always stop Minim before exiting
  minim.stop();
  
  super.stop();
}

