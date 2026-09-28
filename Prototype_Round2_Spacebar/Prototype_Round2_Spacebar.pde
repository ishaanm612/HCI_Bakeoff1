import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

// Prototype Round 2: Spacebar Bimanual Clicking + Lookahead + Hover Outline
// Refinement based on Round 1 Testing:
// - Trackpad physical clicking caused ~200ms latency and cursor slip.
// - Solution: Decouple steering and actuation.
//   Right hand steers on trackpad; Left thumb taps Spacebar to click with zero tremor.
// - Retains One-Step Lookahead and Hover Outline.

int margin = 200;
final int padding = 50;
final int buttonSize = 40;
ArrayList<Integer> trials = new ArrayList<Integer>();
int trialNum = 0;
int startTime = 0;
int finishTime = 0;
int hits = 0;
int misses = 0;
Robot robot;

int numRepeats = 1;
long lastClickTime = 0;

void setup()
{
  size(700, 700);
  noStroke();
  textFont(createFont("Arial", 16));
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER);

  try {
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }

  initTrials();
  surface.setLocation(0, 0);
}

void initTrials()
{
  trials.clear();
  trialNum = 0;
  startTime = 0;
  finishTime = 0;
  hits = 0;
  misses = 0;

  for (int i = 0; i < 16; i++)
    for (int k = 0; k < numRepeats; k++)
      trials.add(i);

  Collections.shuffle(trials);
  System.out.println("trial order: " + trials);
}

void draw()
{
  background(25);

  if (trialNum >= trials.size())
  {
    float timeTaken = (finishTime - startTime) / 1000f;
    float penalty = constrain(((95f - ((float)hits * 100f / (float)(hits + misses))) * 0.2f), 0, 100);
    fill(255);
    text("Finished!", width / 2, height / 2 - 40);
    text("Hits: " + hits, width / 2, height / 2 - 10);
    text("Misses: " + misses, width / 2, height / 2 + 10);
    text("Accuracy: " + nf((float)hits * 100f / (float)(hits + misses), 0, 1) + "%", width / 2, height / 2 + 30);
    text("Total time taken: " + nf(timeTaken, 0, 2) + " sec", width / 2, height / 2 + 60);
    text("Average time for each button: " + nf((timeTaken) / (float)(hits + misses), 0, 3) + " sec", width / 2, height / 2 + 80);
    text("Average time for each button + penalty: " + nf(((timeTaken) / (float)(hits + misses) + penalty), 0, 3) + " sec", width / 2, height / 2 + 110);
    
    fill(180);
    textSize(13);
    text("Press 'r' to restart", width / 2, height / 2 + 150);
    textSize(16);
    return;
  }

  fill(255);
  text((trialNum + 1) + " of " + trials.size(), 40, 20);

  fill(160);
  textSize(13);
  text("Round 2 Prototype: Trackpad Steer + Spacebar Click", width / 2, 20);
  textSize(16);

  for (int i = 0; i < 16; i++)
    drawButton(i);

  // Draw user cursor
  fill(255, 0, 0, 200);
  ellipse(mouseX, mouseY, 20, 20);
}

Rectangle getButtonLocation(int i)
{
  int x = (i % 4) * (padding + buttonSize) + margin;
  int y = (i / 4) * (padding + buttonSize) + margin;
  return new Rectangle(x, y, buttonSize, buttonSize);
}

void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);
  int curTarget = trials.get(trialNum);
  int nextTarget = (trialNum + 1 < trials.size()) ? trials.get(trialNum + 1) : -1;

  // Active target: bright green
  if (curTarget == i)
  {
    fill(46, 204, 113);
    rect(bounds.x, bounds.y, bounds.width, bounds.height);

    fill(0);
    ellipse(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2, 6, 6);
  }
  // Next target (Lookahead of 1): yellow/amber
  else if (nextTarget == i)
  {
    fill(241, 196, 15);
    rect(bounds.x, bounds.y, bounds.width, bounds.height);

    fill(50);
    textSize(10);
    text("NEXT", bounds.x + bounds.width / 2, bounds.y + bounds.height / 2 + 3);
    textSize(16);
  }
  // Inactive squares: dark gray
  else
  {
    fill(55);
    rect(bounds.x, bounds.y, bounds.width, bounds.height);
  }

  // Hover outline: check if cursor is currently inside this button
  if (mouseX > bounds.x && mouseX < bounds.x + bounds.width &&
      mouseY > bounds.y && mouseY < bounds.y + bounds.height)
  {
    noFill();
    stroke(255);
    strokeWeight(3);
    rect(bounds.x - 2, bounds.y - 2, bounds.width + 4, bounds.height + 4);
    noStroke();
  }
}

void registerClick()
{
  if (trialNum >= trials.size())
    return;

  // debounce rapid double taps (40ms)
  if (millis() - lastClickTime < 40)
    return;
  lastClickTime = millis();

  if (trialNum == 0)
    startTime = millis();

  if (trialNum == trials.size() - 1)
  {
    finishTime = millis();
    println("we're done!");
  }

  Rectangle bounds = getButtonLocation(trials.get(trialNum));

  if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && 
      (mouseY > bounds.y && mouseY < bounds.y + bounds.height))
  {
    System.out.println("HIT! " + trialNum + " " + (millis() - startTime));
    hits++;
  }
  else
  {
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime));
    misses++;
  }

  trialNum++;
}

void mousePressed()
{
  registerClick();
}

void keyPressed()
{
  // Spacebar triggers the click action!
  if (key == ' ')
  {
    registerClick();
  }
  else if (key == 'r' || key == 'R')
  {
    initTrials();
  }
}

void mouseMoved() {}
void mouseDragged() {}
