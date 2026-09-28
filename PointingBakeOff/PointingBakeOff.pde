import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

//when in doubt, consult the Processsing reference: https://processing.org/reference/

int margin = 200; //set the margin around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the test
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
Robot robot; //initialized in setup 

int numRepeats = 1; //sets the number of times each button repeats in the test

// prototype switcher for testing / video
// 0: baseline scaffold
// 1: lookahead + spacebar click
// 2: crosshair lines + audio beep
// 3: final design (lookahead vector, crosshairs, precision cursor, spacebar)
int prototypeMode = 3;

long lastClickTime = 0;

void setup()
{
  size(700, 700); // set the size of the window
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects

  try {
    robot = new Robot(); //create a "Java Robot" class that can move the system cursor
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }

  initTrials();
  
  surface.setLocation(0,0);// put window in top left corner of screen (doesn't always work)
}

void initTrials()
{
  trials.clear();
  trialNum = 0;
  startTime = 0;
  finishTime = 0;
  hits = 0;
  misses = 0;

  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  for (int i = 0; i < 16; i++) //generate list of targets and randomize the order
      // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  System.out.println("trial order: " + trials);
}

void draw()
{
  if (prototypeMode == 0) {
    background(0); // scaffold black
    cursor(ARROW);
  } else {
    background(25); // dark gray
    noCursor();
  }

  if (trialNum >= trials.size()) //check to see if test is over
  {
    cursor(ARROW);
    float timeTaken = (finishTime-startTime) / 1000f;
    float penalty = constrain(((95f-((float)hits*100f/(float)(hits+misses)))*.2f),0,100);
    fill(255); //set fill color to white
    //write to screen (not console)
    text("Finished!", width / 2, height / 2 - 40); 
    text("Hits: " + hits, width / 2, height / 2 - 10);
    text("Misses: " + misses, width / 2, height / 2 + 10);
    text("Accuracy: " + nf((float)hits*100f/(float)(hits+misses), 0, 1) +"%", width / 2, height / 2 + 30);
    text("Total time taken: " + nf(timeTaken, 0, 2) + " sec", width / 2, height / 2 + 60);
    text("Average time for each button: " + nf((timeTaken)/(float)(hits+misses),0,3) + " sec", width / 2, height / 2 + 80);
    text("Average time for each button + penalty: " + nf(((timeTaken)/(float)(hits+misses) + penalty),0,3) + " sec", width / 2, height / 2 + 110);
    
    fill(180);
    textSize(13);
    text("Press 'r' to restart  |  Keys 0-3 change prototype mode", width / 2, height / 2 + 150);
    textSize(16);
    return;
  }

  // guide lines (modes 2 & 3)
  if (prototypeMode >= 2) {
    drawCrosshairs();
  }
  if (prototypeMode >= 3) {
    drawNextTargetVector();
  }

  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on

  // small mode label on top
  fill(160);
  textSize(13);
  text("Mode " + prototypeMode + "  [0: Scaffold, 1: Lookahead+Space, 2: Crosshairs, 3: Final]  ('r' to reset)", width / 2, 20);
  textSize(16);

  for (int i = 0; i < 16; i++)// for all button
    drawButton(i); //draw button

  // draw cursor
  if (prototypeMode == 0) {
    fill(255, 0, 0, 200); // set fill color to translucent red
    ellipse(mouseX, mouseY, 20, 20); //draw user cursor as a circle with a diameter of 20
  } else {
    drawCustomCursor();
  }
}

// full-screen subtle crosshair through current target center
void drawCrosshairs()
{
  Rectangle targetBounds = getButtonLocation(trials.get(trialNum));
  int cx = targetBounds.x + targetBounds.width / 2;
  int cy = targetBounds.y + targetBounds.height / 2;

  stroke(0, 255, 150, 40);
  strokeWeight(1);
  line(0, cy, width, cy);
  line(cx, 0, cx, height);
  noStroke();
}

// line connecting current target to next target (lookahead of 1)
void drawNextTargetVector()
{
  if (trialNum + 1 >= trials.size()) return;

  Rectangle cur = getButtonLocation(trials.get(trialNum));
  Rectangle nxt = getButtonLocation(trials.get(trialNum + 1));
  int x1 = cur.x + cur.width / 2;
  int y1 = cur.y + cur.height / 2;
  int x2 = nxt.x + nxt.width / 2;
  int y2 = nxt.y + nxt.height / 2;

  stroke(255, 190, 0, 90);
  strokeWeight(2);
  line(x1, y1, x2, y2);
  noStroke();
}

// check if mouse is inside any button
boolean isHoveringAnyButton()
{
  for (int i = 0; i < 16; i++) {
    Rectangle b = getButtonLocation(i);
    if (mouseX > b.x && mouseX < b.x + b.width && mouseY > b.y && mouseY < b.y + b.height) {
      return true;
    }
  }
  return false;
}

// custom cursor: turns green when hovering any button
void drawCustomCursor()
{
  boolean hovering = isHoveringAnyButton();

  // outer ring
  noFill();
  if (hovering) {
    stroke(0, 255, 120, 220);
    fill(0, 255, 120, 40);
  } else {
    stroke(255, 200);
  }
  strokeWeight(1.5f);
  ellipse(mouseX, mouseY, 16, 16);

  // center dot
  if (hovering) {
    fill(0, 255, 120);
  } else {
    fill(255, 60, 60);
  }
  noStroke();
  ellipse(mouseX, mouseY, 4, 4);
}

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button ID, what is its location and size
{
   int x = (i % 4) * (padding + buttonSize) + margin;
   int y = (i / 4) * (padding + buttonSize) + margin;
   return new Rectangle(x, y, buttonSize, buttonSize);
}

//you can edit this method to change how buttons appear
void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);
  int curTarget = trials.get(trialNum);
  int nextTarget = (trialNum + 1 < trials.size()) ? trials.get(trialNum + 1) : -1;

  if (prototypeMode == 0)
  {
    if (curTarget == i)
      fill(0, 255, 255); // if so, fill cyan
    else
      fill(200); // if not, fill gray

    rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
    return;
  }

  // current target: bright green
  if (curTarget == i)
  {
    fill(46, 204, 113);
    rect(bounds.x, bounds.y, bounds.width, bounds.height);

    // center point for precision
    fill(0);
    ellipse(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2, 6, 6);
  }
  // next target: yellow/orange (lookahead of 1)
  else if (nextTarget == i && prototypeMode >= 1)
  {
    fill(241, 196, 15);
    rect(bounds.x, bounds.y, bounds.width, bounds.height);

    fill(50);
    textSize(10);
    text("NEXT", bounds.x + bounds.width / 2, bounds.y + bounds.height / 2 + 3);
    textSize(16);
  }
  // non-targets: visible gray
  else
  {
    fill(60);
    rect(bounds.x, bounds.y, bounds.width, bounds.height);
  }
}

void registerClick()
{
  if (trialNum >= trials.size()) //if task is over, just return
    return;

  // debounce double-taps
  if (millis() - lastClickTime < 50)
    return;
  lastClickTime = millis();

  if (trialNum == 0) //check if first click, if so, start timer
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    println("we're done!");
  }

  Rectangle bounds = getButtonLocation(trials.get(trialNum));

  //check to see if mouse cursor is inside button 
  if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height))
  {
    System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hits++;
    if (prototypeMode >= 2) {
      Toolkit.getDefaultToolkit().beep();
    }
  } 
  else
  {
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
  }

  trialNum++; //Increment trial number
}

void mousePressed() // test to see if hit was in target!
{
  registerClick();
}

void mouseMoved()
{
   //can do stuff everytime the mouse is moved (i.e., not clicked)
   //https://processing.org/reference/mouseMoved_.html
}

void mouseDragged()
{
  //can do stuff everytime the mouse is dragged
  //https://processing.org/reference/mouseDragged_.html
}

void keyPressed() 
{
  // spacebar to click (in prototypes 1, 2, 3)
  if (key == ' ' && prototypeMode >= 1)
  {
    registerClick();
  }
  // restart with a new shuffle
  else if (key == 'r' || key == 'R')
  {
    initTrials();
  }
  // prototype mode switching
  else if (key == '0')
  {
    prototypeMode = 0;
  }
  else if (key == '1')
  {
    prototypeMode = 1;
  }
  else if (key == '2')
  {
    prototypeMode = 2;
  }
  else if (key == '3')
  {
    prototypeMode = 3;
  }
}
