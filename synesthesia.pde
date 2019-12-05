import themidibus.*; //Import the library
import java.util.Map;


MidiBus myBus; // The MidiBus
int pitch;
int vel;
HashMap<Integer,MyNote> currentNotes = new HashMap<Integer,MyNote>();
float col;
float fade;

class MyNote extends Note{
  float yAxis;
  float r;
  float g;
  float b;
  MyNote(int c, int p, int v){
    super(c, p, v);
    yAxis = random(height);
    r = random(255);
    g = random(255);
    b = random(255);
  }
  
  float getY(){
    return yAxis;
  }
  float getR(){
    return r;
  }
  float getG(){
    return g;
  }
  float getB(){
    return b;
  }
  
}

void setup() {
  size(1600, 1000);
  background(255);
  MidiBus mb = new MidiBus(this, 1, 2);
  noStroke();
  col = 0;
  fade = 1; // 34 is good for waldstein, 2 is good for enpus
}

void draw() {  
  colorMode(RGB);
  noStroke();
   //fill(255, fade);
   //rect(0, 0, width, height);
  // fill(205, 205, 184, 2);
  // rect(0,height/2, width/2, height/2);
  //fill(0, fade);
  //rect(width/2, height/2, width, height);
  //fill(255,105,255,1);
  //rect(width/2, 0, width, height);
  // The above lines split the screen into four different colored sections
  
  stroke(0);
  if (currentNotes.size() == 2){
    draw2point();
  } else if (currentNotes.size() == 1){
    drawElipse();
  } else if (currentNotes.size() > 2){
    drawPolygon();
  }
}


void noteOn(int c, int p, int v){
  pitch = p;
  vel = v;
  
  currentNotes.put(new Integer(p), new MyNote(c, p, v));
}


void noteOff(int c, int p, int v){
  pitch = 0;
  vel = 0;
  currentNotes.remove(p);
}

void drawPolygon(){
  colorMode(RGB);
  beginShape();
    try{
      for (Map.Entry n : currentNotes.entrySet()) { 
        
        MyNote note = ((MyNote)n.getValue()); 
        fill(note.getR(), note.getG(), note.getB(), 40);
        float offset = random(note.velocity);
        vertex( (((float) (note.pitch()-36)/60)*width) + offset, note.getY()+offset);
      } 
    } catch (java.util.ConcurrentModificationException e)
    {
      print("here");
    }
    endShape();
}

void drawElipse(){
  colorMode(RGB);
  try{
      for (Map.Entry n : currentNotes.entrySet()) { 
        MyNote note = ((MyNote)n.getValue()); 
        fill(note.getR(), note.getG(), note.getB());
        float offsetX = random(15);
        float offsetY = random(15);
        ellipse( (((float) (note.pitch()-36)/60)*width), note.getY(), note.velocity() + offsetX, note.velocity() + offsetY);
      } 
    } catch (java.util.ConcurrentModificationException e)
    {
      print("here");
    }
}

void draw2point(){
  colorMode(HSB);
 try{
      beginShape();
      for (Map.Entry n : currentNotes.entrySet()) { 
        stroke(col, 150, 250);
        MyNote note = ((MyNote)n.getValue()); 
        fill(col, 250, 250);
        float offsetX = random(note.velocity()/3);
        float offsetY = random(note.velocity()/3);
        vertex( (((float) (note.pitch()-36)/60)*width) + offsetX, note.getY()+offsetY);
        ellipse( (((float) (note.pitch()-36)/60)*width), note.getY(), (note.velocity() + offsetX)/3, (note.velocity() + offsetY)/3);
        col++;
        if (col >254){
          col = 0;
        }
      } 
    } catch (java.util.ConcurrentModificationException e)
    {
      print("here");
    }
      endShape();
}

void keyPressed() {
  if (keyCode == 81){
     background(255);
  }
  keyCode = 0;
}
