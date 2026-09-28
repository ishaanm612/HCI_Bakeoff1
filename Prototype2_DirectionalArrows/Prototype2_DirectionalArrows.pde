import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

// Prototype 2 (Idea 2): Directional arrows pointing to target + Hover outline
// Target square is highlighted in green.
// Inactive squares display arrows pointing towards the target square.
// Currently hovered square is signaled with a high-contrast outline.
// Trackpad is used to point and click.

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
  text("Prototype 2: Directional Arrows to Target | Hover Outline", width / 2, 20);
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

  if (curTarget == i)
  {
    // Target square: bright green
    fill(46, 204, 113);
    rect(bounds.x, bounds.y, bounds.width, bounds.height);

    fill(0);
    ellipse(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2, 6, 6);
  }
  else
  {
    // Non-target squares: dark gray with an arrow pointing to target center
    fill(55);
    rect(bounds.x, bounds.y, bounds.width, bounds.height);

    // Draw arrow pointing toward current target
    Rectangle targetBounds = getButtonLocation(curTarget);
    float srcX = bounds.x + bounds.width / 2f;
    float srcY = bounds.y + bounds.height / 2f;
    float dstX = targetBounds.x + targetBounds.width / 2f;
    float dstY = targetBounds.y + targetBounds.height / 2f;

    float angle = atan2(dstY - srcY, dstX - srcX);
    float arrowLen = 10;

    pushMatrix();
    translate(srcX, srcY);
    rotate(angle);
    stroke(140);
    strokeWeight(1.5f);
    line(-arrowLen / 2, 0, arrowLen / 2, 0);
    line(arrowLen / 2 - 4, -3, arrowLen / 2, 0);
    line(arrowLen / 2 - 4, 3, arrowLen / 2, 0);
    noStroke();
    popMatrix();
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

void keyPressed()
{
  if (key == 'r' || key == 'R')
  {
    initTrials();
  }
}

void mouseMoved() {}
void mouseDragged() {}
