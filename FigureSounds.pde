import processing.sound.*;

SinOsc[] oscillators;
Env env;

int[] midiSequence = { 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72 }; 
int count = 0, frame = 1;
boolean envol = true, modeAuto = false, home = true;

float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.5;
float releaseTime = 0.4;

void setup() {
  size(650, 600);
  background(255);

  oscillators = new SinOsc[midiSequence.length];

  for (int i = 0; i < midiSequence.length; i++) oscillators[i] = new SinOsc(this);

  env  = new Env(this);
}      

void draw() {
  if (!home) {
    if (modeAuto) {
      int rand = (int) random(13);
      oscillators[rand].play(midiToFreq(midiSequence[rand] + count), 0.5);
      if (envol) env.play(oscillators[rand], attackTime, sustainTime, sustainLevel, releaseTime);
      drawRandomFigure();
    }
    fill(0);
    for (int i=0; i<7; i++) {
      fill(0);
      rect(i*100+50, 500, 50, 100);
      fill(255);
      rect(i*100, 500, 50, 100);
    }
    fill(0);
    textSize(35);
    if (modeAuto)
      text("AUTO", 5, 480);
    else
      text("MANUAL", 5, 480);
  } else
    mainScreen();
}

void keyPressed() {
  if (modeAuto) {
    if (keyCode == UP && frame < 10)
      frameRate(++frame);
    if (keyCode == DOWN && frame > 1)
      frameRate(--frame);
  } else
    if ((key == 'q' || key == 'Q')) envol = !envol;

  if (key == 'm' || key == 'M') {
    if (modeAuto)
      frameRate(60);
    else        
    frameRate(frame);
    modeAuto = !modeAuto;
    background(255);
    draw();
  }
  if (key == 'a' || key == 'A')
    if (count < 28) count++;
  if (key == 's' || key == 'S')
    if (count > 0) count--;
  if (key == 'h' || key == 'H') {
    if (home) background(255);
    home = !home;
  }
}

void mousePressed() {
  if (!home && !modeAuto && mouseY > 500) {
    int key_=(int)(mouseX/50);
    oscillators[key_].play(midiToFreq(midiSequence[key_] + count), 0.5);
    if (envol) env.play(oscillators[key_], attackTime, sustainTime, sustainLevel, releaseTime);
    drawRandomFigure();
  }
}

void drawRandomFigure() {
  color color_ = color(random(255), random(255), random(255));
  switch ((int) random(0, 3)) {
  case 0:
    drawEllipse(color_);
    break;
  case 1:
    drawQuad(color_);
    break;
  case 2:
    drawTriangle(color_);
    break;
  default:
    break;
  }
}

void drawEllipse(color color_) {
  fill(color_);
  ellipse(random(0, 600), random(0, 450), random(50, 300), random(50, 300));
}

void drawQuad(color color_) {
  fill(color_);
  rect(random(0, 600), random(0, 450), random(50, 300), random(50, 300));
}

void drawTriangle(color color_) {
  fill(color_);
  triangle(random(0, 600), random(0, 450), random(0, 600), random(0, 450), random(0, 600), random(0, 450));
}

float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}

void mainScreen() {
  background(0);
  fill(255);
  textSize(35);
  text("Figure Sounds", width / 2 - 125, 100);
  textSize(20);
  text("Mode Auto", width / 2 - 300, 150);
  text("Press UP/DOWN to increase/decrease sounds frequency", width / 2 - 275, 200);
  text("Press A/S to get higher/lower sounds", width / 2 - 275, 250);
  text("Mode Manual", width / 2 - 300, 300);
  text("Press piano keys with the mouse to listen notes", width / 2 - 275, 350);
  text("Press A/S to get higher/lower sounds", width / 2 - 275, 400);
  text("Press Q to extend sound of a note", width / 2 - 275, 450);
  text("Press H to return to main screen", width / 2 - 150, 500);
  textSize(15);
  text("Press H to continue", width / 2 - 75, height / 2 + 250);
}
