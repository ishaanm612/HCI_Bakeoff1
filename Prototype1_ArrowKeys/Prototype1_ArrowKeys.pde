import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

// Prototype 1 (Idea 1): Keyboard arrow navigation + Trackpad click
// Target is highlighted in green-yellow.
// Currently selected square is signaled with a high-contrast outline.
// User moves selection cursor with Arrow Keys, and clicks on trackpad to select.

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
int selectedSquare = 0; // index of currently selected square (0-15)

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
  selectedSquare = 0;

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
  text("Prototype 1: Arrow Keys to Move | Trackpad to Click", width / 2, 20);
  textSize(16);

  for (int i = 0; i < 16; i++)
    drawButton(i);
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

  // Target square is highlighted in green-yellow
  if (curTarget == i)
    fill(173, 255, 47); // green-yellow
  else
    fill(60); // dark gray

  rect(bounds.x, bounds.y, bounds.width, bounds.height);

  // Currently selected square is signaled with a high-contrast white outline
  if (selectedSquare == i)
  {
    noFill();
    stroke(255);
    strokeWeight(3);
    rect(bounds.x - 2, bounds.y - 2, bounds.width + 4, bounds.height + 4);
    noStroke();
  }
}

// Trackpad click selects the currently highlighted square
void mousePressed()
{
  if (trialNum >= trials.size())
    return;

  if (trialNum == 0)
    startTime = millis();

  if (trialNum == trials.size() - 1)
  {
    finishTime = millis();
    println("we're done!");
  }

  int target = trials.get(trialNum);

  // Check if current selected square matches the target
  if (selectedSquare == target)
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

void keyPressed()
{
  // Navigate 4x4 grid with arrow keys
  if (key == CODED)
  {
    if (keyCode == UP && selectedSquare >= 4)
      selectedSquare -= 4;
    else if (keyCode == DOWN && selectedSquare < 12)
      selectedSquare += 4;
    else if (keyCode == LEFT && (selectedSquare % 4) > 0)
      selectedSquare -= 1;
    else if (keyCode == RIGHT && (selectedSquare % 4) < 3)
      selectedSquare += 1;
  }
  else if (key == 'r' || key == 'R')
  {
    initTrials();
  }
}

void mouseMoved() {}
void mouseDragged() {}
