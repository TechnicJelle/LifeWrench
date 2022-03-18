int topHealth = 20;
Button topPlus;
Button topMin;
float topHue = 120;
int topRecent = 0;
int millisTopRecent = 0;
int millisTopHue = 0;

int btmHealth = 20;
Button btmPlus;
Button btmMin;
float btmHue = 0;
int btmRecent = 0;
int millisBtmRecent = 0;
int millisBtmHue = 0;

int millisAtMousePressed = 0;
int millisAtLastBtn = 0;

Button rando;
int framesAtStartRoll;
int framesTillRollStops;

Button setHealthTo20;
Button setHealthTo40;

float btnSize;

float txtSize;

final float HUE_SEL_FAC = 0.05;

String emojiUp;
String emojiDown;
String emojiRandom;

PFont font;

void setup() {
  fullScreen();
  frameRate(15);
  colorMode(HSB, 360, 100, 100);

  emojiUp = new String(Character.toChars(0x2B06)) + new String(Character.toChars(0xFE0F));
  emojiDown = new String(Character.toChars(0x2B07)) + new String(Character.toChars(0xFE0F));
  emojiRandom = new String(Character.toChars(0x1F503));

  btnSize = width/8;

  printArray(PFont.list());
  font = createFont("Monospaced", 12);
  textFont(font);

  rando = new Button(width/2-btnSize*0.5, height/2-btnSize/2, btnSize, btnSize, emojiRandom);

  setHealthTo20 = new Button(width/2-btnSize*1.5, height/2-btnSize/2, btnSize, btnSize, "20");
  setHealthTo40 = new Button(width/2+btnSize*0.5, height/2-btnSize/2, btnSize, btnSize, "40");

  topPlus = new Button(0, btnSize, btnSize, btnSize, "+");
  topMin = new Button(width-btnSize, btnSize, btnSize, btnSize, "-");

  btmPlus = new Button(width-btnSize, height-btnSize*2, btnSize, btnSize, "+");
  btmMin = new Button(0, height-btnSize*2, btnSize, btnSize, "-");
}

void rainbow(float y, float h, int step) {
  strokeWeight(step);
  for (float x = 0; x <= width; x += step) {
    stroke(map(x, 0, width, 0, 360), 100, 100);
    line(x, y, x, y+h);
  }
}


void draw() {
  rainbow(0, height, 18);

  if (mousePressed && millis() > millisAtMousePressed + 500 && millis() > millisAtLastBtn + 100)
    btnCheck();

  topPlayer();
  btmPlayer();

  stroke(0);
  strokeWeight(2);
  line(0, height/2, width, height/2);

  if (frameCount < framesAtStartRoll + framesTillRollStops) {
    rando.label = random(100) < 50 ? emojiUp : emojiDown;
    rando.render(180);
  } else {
    rando.render();
    if (frameCount > framesAtStartRoll + framesTillRollStops + frameRate*5) {
      rando.label = emojiRandom;
    }
  }
  setHealthTo20.render();
  setHealthTo40.render();
}
//15 best ways to farm potatoes

void topPlayer() {
  pushMatrix();
  translate(width, height/2);
  rotate(PI);

  //background
  fill(topHue, 100, 100);
  noStroke();
  float h = height/2;
  if (millis() < millisTopHue + 5000)
    h -= height*HUE_SEL_FAC;
  rect(0, 0, width, h);

  //hue selector
  if (millis() < millisTopHue + 5000)
    stroke(0);
  else
    stroke(0, 50);
  strokeWeight(2);
  line(0, height/2-height*HUE_SEL_FAC, width, height/2-height*HUE_SEL_FAC);

  //health text
  fill(0);
  textBox(str(topHealth), 0, 0, width, height/2-height*HUE_SEL_FAC);

  //health difference text
  if (millis() < millisTopRecent + 3000) {
    fill(360);
    textSize(height*0.1);
    textAlign(CENTER, TOP);
    text((topRecent > 0 ? "+" : "") + topRecent, width*0.75, btnSize/2);
  } else {
    topRecent = 0;
  }

  popMatrix();

  topPlus.render();
  topMin.render();
}

void topH(int d) {
  topHealth += d;
  topRecent += d;
  millisTopRecent = millis();
}

void btmPlayer() {
  pushMatrix();
  translate(0, height/2);

  //background
  float h = height/2;
  if (millis() < millisBtmHue + 5000)
    h -= height*HUE_SEL_FAC;
  fill(btmHue, 100, 100);
  noStroke();
  rect(0, 0, width, h);

  //hue selector
  if (millis() < millisBtmHue + 5000)
    stroke(0);
  else
    stroke(0, 50);
  strokeWeight(2);
  line(0, height/2-height*HUE_SEL_FAC, width, height/2-height*HUE_SEL_FAC);


  //health text
  fill(0);
  textBox(str(btmHealth), 0, 0, width, height/2-height*HUE_SEL_FAC);

  //health difference text
  if (millis() < millisBtmRecent + 3000) {
    fill(360);
    textSize(height*0.1);
    textAlign(CENTER, TOP);
    text((btmRecent > 0 ? "+" : "") + btmRecent, width*0.75, btnSize/2);
  } else {
    btmRecent = 0;
  }

  popMatrix();

  btmPlus.render();
  btmMin.render();
}

void btmH(int d) {
  btmHealth += d;
  btmRecent += d;
  millisBtmRecent = millis();
}

void mousePressed() {
  millisAtMousePressed = millis();
  if (setHealthTo20.isClicked()) {
    topHealth = 20;
    btmHealth = 20;
    return;
  } else if (setHealthTo40.isClicked()) {
    topHealth = 40;
    btmHealth = 40;
    return;
  } else if (rando.isClicked()) {
    framesAtStartRoll = frameCount;
    framesTillRollStops = round(random(10, 60));
    return;
  }
  btnCheck();
}

void btnCheck() {
  boolean click = false;
  if (btmPlus.isClicked() || (mouseX > width/2 && mouseY > height/2 && mouseY < height*(1-HUE_SEL_FAC))) {
    btmH(1);
    click = true;
  } else if (btmMin.isClicked() || (mouseX < width/2 && mouseY > height/2 && mouseY < height*(1-HUE_SEL_FAC))) {
    btmH(-1);
    click = true;
  } else if (topPlus.isClicked() || (mouseX < width/2 && mouseY < height/2 && mouseY > height*HUE_SEL_FAC)) {
    topH(1);
    ;
    click = true;
  } else if (topMin.isClicked() || (mouseX > width/2 && mouseY < height/2 && mouseY > height*HUE_SEL_FAC)) {
    topH(-1);
    click = true;
  }

  if (click) {
    millisAtLastBtn = millis();
  }
}

void mouseDragged() {
  if (mouseY < height*HUE_SEL_FAC) {
    topHue = map(mouseX, 0, width, 0, 360);
    millisTopHue = millis();
  } else if (mouseY > height*(1-HUE_SEL_FAC)) {
    btmHue = map(mouseX, 0, width, 0, 360);
    millisBtmHue = millis();
  }
}

void textBox(String text, float posX, float posY, float fitX, float fitY) {
  textFont(font);
  textSize(min(font.getSize()*fitX/(textWidth(text)+1), fitY));
  textAlign(CENTER, CENTER);
  text(text, posX + fitX*0.503, posY + fitY*0.475);
}
