/*
概要
 上から降ってくる”単位”を24個以上集めるとクリアできるゲーム。
 基本的な操作は左右しかないためAキーDキーもしくは右クリック左クリックで操作する。
 プロローグはゲームをプレイしたいときに何回も見ることにならないようスキップできる仕様に。
 獲得したオブジェクトの個数によってエンディングが変わるように設定。
 この作品は16FI030とのシリーズものを想定しており、人名や世界観を共通のものとし続けてプレイすることが可能となっている。
 */

Start start; //導入
Prologue prologue; //プロローグ
Game game; //ゲーム本体
GoodEnd goodEnd; //グッドエンド
BadEnd badEnd; //バッドエンド
Credit credit; //クレジット

int flag = 0; //ゲームの状態
PImage img;
PImage img1;
PImage img2;
void setup() {
  size(600, 600);
  noStroke();
  smooth();
  PFont font;
  font = createFont("Meiryo", 48, true);
  textFont(font, 48);
  img = loadImage("woman.png");
  img1 = loadImage("woman1.png");
  img2 = loadImage("woman2.png");
  start = new Start();
  prologue = new Prologue();
  game = new Game();
  goodEnd = new GoodEnd();
  badEnd = new BadEnd();
  credit = new Credit();
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  background(0, 0, 0);
  switch(flag) {
  case 0:
    start.draw();
    start.flag();
    break;

  case 1:
    prologue.draw();
    break;

  case 2:
    game.draw();
    break;

  case 100:
    goodEnd.draw();
    break;

  case 101:
    badEnd.draw();
    break;

  case 201:
    credit.draw();
    break;
  }
}



//スタート画面
class Start {
  void draw() {
    background(0, 100, 0);
    textSize(30);
    textAlign(CENTER, CENTER);
    text("春からTDU～前編～", width/2, 100);
    image(img,200,90,200,300);
    text("プロローグ・・・P", width/2, 400);
    text("ゲームスタート・・・S", width/2, 450);
  }

  void flag() {
    switch(key) {
    case 'p':
      prologue = new Prologue();
      flag = 1;
      break;

    case 's':
      game = new Game();
      flag = 2;
      break;
    }
    if (keyPressed && key=='e') {
      flag=100;
    } else if (keyPressed && key=='b') {
      flag=101;
    }
  }
}

//プロローグ
class Prologue {
  float c=0;
  void draw() {
    background(0, 0, 0);
    image(img,175,50,250,350);
    fill(0, 0, 100);
    ellipse(30, 400, 20, 20);
    ellipse(30, 580, 20, 20);
    ellipse(570, 400, 20, 20);
    ellipse(570, 580, 20, 20);
    rect(30, 390, 540, 20);
    rect(30, 570, 540, 20);
    rect(20, 400, 20, 180);
    rect(560, 400, 20, 180);

    if (keyPressed&&key=='s') {
      game = new Game();
      flag = 2;
    }
    textSize(30);
    textAlign(CENTER, CENTER);
    text("PROLOGUE", 100, 100);
    textAlign(LEFT, CENTER);
    c+=0.04;
    if (c>0 && c<10) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("この物語は", 60, 430);
      text("今年からTDUに通うことになった", 60, 480);
      text("雨雪雫が", 60, 530);
    }
    if (c>=10 && c <20) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("無事２年生に進級できるかの", 60, 430);
      text("物語です．", 60, 480);
      text("", 60, 530);
    }
    if (c>=20 && c<30) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("ゲーム説明", 60, 430);
      text("降ってくる単位をキャッチし", 60, 480);
      text("24単位以上認定してもらおう！", 60, 530);
    }
    if (c>=30) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("Aキーorマウス左クリックで左", 60, 430);
      text("Dキーorマウス右クリックで右", 60, 480);
      text("Sキーでゲームスタート", 60, 530);
      if (keyPressed&&key=='s') {
        game = new Game();
        flag = 2;
      }
    }
  }
}

//ゲーム本体
class Game {
  int taniNum = 48;

  Stage stage;
  Shizu shizu;
  Tani[] tani;

  Game() {
    shizu = new Shizu(width/2-25, 500, 2, 5);
    stage = new Stage();
    tani = new Tani[taniNum];
    for (int i = 0; i<tani.length; i++) {
      tani[i] = new Tani(random(110, 120), 0-30*i, random(0, 1.5), random(0.9+(0.001*i), 1.4));
    }
  }

  void draw() {
    background(0, 0, 100);
    fill(0, 100, 0);
    stage.draw();
    shizu.move();
    shizu.wall();
    shizu.draw();
    for (int i = 0; i<tani.length; i++) {
      shizu.catched(tani[i]);
      tani[i].move();
      tani[i].draw();
    }

    if (shizu.m>106) {
      if (shizu.count>=24) {
        flag=100;
      } else if (shizu.count<24) {
        flag=101;
      }
    }
  }
}

//キャラの描画動き
class Shizu {
  float x;
  float y;
  int   d;
  float vx;
  int count=0;
  float m=0;

  Shizu(float x, float y, float vx, int d) {
    this.x=x;
    this.y=y;
    this.vx=vx;
    this.d=d;
  }

  void move() {
    if (keyPressed && key=='d' || mouseButton==RIGHT) {
      x +=2.5*vx;
    } else if (keyPressed && key=='a' || mouseButton==LEFT) {
      x -=5*vx;
    }
  }

  void wall() {
    if (x < 100) {
      x=100;
    } else if (x > 450) {
      x=450;
    }
  }

  void catched(Tani tani) {
    if ((tani.getX()>=x-20) && (tani.getX() <x+70) && (tani.getY() >500) && (tani.getY()<505)) {
      count+=1;
      tani.x=700;
    }
  }

  void draw() {
    fill(0, 100, 0);
    rect(x, y, d*10, d-2);
    ellipse(x+25, y+10, 10, 10);
    stroke(0);
    strokeWeight(3);
    line(x+25, y+10, x+25, y+35);
    line(x+25, y+35, x+15, y+45);
    line(x+25, y+35, x+35, y+45);
    line(x+25, y+25, x+30, y+25);
    line(x+25, y+25, x+20, y+25);
    line(x+20, y+25, x+15, y+30);
    line(x+30, y+25, x+35, y+30);

    m +=0.05;
    textSize(20);
    textAlign(CENTER, CENTER);
    text(count+"単位", 200, 100);
    //text(m, 300, 300);
  }
  void setX(float x) {
    this.x=x;
  }
  float getX() {
    return x;
  }
  void setY(float y) {
    this.y=y;
  }
  float getY() {
    return y;
  }
  void setVx(float vx) {
    this.vx = vx;
  }
  float getVx() {
    return vx;
  }
}

class Stage {
  void draw() {
    fill(0, 100, 100);
    rect(0, 550, 600, 2);
    fill(0, 100, 0);
    rect(0, 0, 100, 600);
    rect(500, 0, 100, 600);
  }
}

class Tani {
  float x;
  float y;
  float vx;
  float vy;

  Tani(float x, float y, float vx, float vy) {
    this.x=x;
    this.y=y;
    this.vx=vx;
    this.vy=vy;
  }
  void move() {
    x+=vx;
    y+=vy;
    if (y>590 && y<650) {
      vx=0;
      y=590;
    }
    if (x<105) {
      vx = -vx;
    } else if (x>485) {
      vx = -vx;
    }
  }

  void setX(float x) {
    this.x=x;
  }
  float getX() {
    return x;
  }
  void setY(float y) {
    this.y=y;
  }
  float getY() {
    return y;
  }
  void setVx(float vx) {
    this.vx = vx;
  }
  float getVx() {
    return vx;
  }
  void setVy(float vy) {
    this.vy = vy;
  }
  float getVy() {
    return vy;
  }

  void draw() {
    fill(0, 100, 100);
    textSize(12);
    textAlign(CENTER, CENTER);
    text("単位", x, y);
  }
}

//グッドエンド
class GoodEnd {
  float c;

  void draw() {
    background(0, 100, 0);
    image(img1,175,50,250,350);
    strokeWeight(0);
    fill(0, 0, 100);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("GOODEND", 100, 100);
    fill(0, 0, 100);
    ellipse(30, 400, 20, 20);
    ellipse(30, 580, 20, 20);
    ellipse(570, 400, 20, 20);
    ellipse(570, 580, 20, 20);
    rect(30, 390, 540, 20);
    rect(30, 570, 540, 20);
    rect(20, 400, 20, 180);
    rect(560, 400, 20, 180);
    textAlign(LEFT, CENTER);
    c+=0.04;
    if (c>0 && c<10) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("無事24単位以上", 60, 430);
      text("獲得することができたので", 60, 480);
      text("雨雪雫は", 60, 530);
    }
    if (c>=10 && c <20) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("2年生に進級することが", 60, 430);
      text("できた．", 60, 480);
      text("fin", 60, 530);
    }
    if (c>=20) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("", 60, 430);
      text("Tキーでスタートに戻る", 60, 480);
      text("", 60, 530);
      if (keyPressed&&key=='t') {
        credit = new Credit();
        flag = 201;
      }
    }
  }
}

//バッドエンド
class BadEnd {
  float c;
  void draw() {
    background(0, 100, 0);
    image(img2,175,50,250,350);
    strokeWeight(0);
    fill(0, 100, 100);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("BADEND", 100, 100);
    ellipse(30, 400, 20, 20);
    ellipse(30, 580, 20, 20);
    ellipse(570, 400, 20, 20);
    ellipse(570, 580, 20, 20);
    rect(30, 390, 540, 20);
    rect(30, 570, 540, 20);
    rect(20, 400, 20, 180);
    rect(560, 400, 20, 180);

    textAlign(LEFT, CENTER);
    textAlign(LEFT, CENTER);
    c+=0.04;
    if (c>0 && c<10) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("無情にも", 60, 430);
      text("24単位集めることができなかった", 60, 480);
      text("雨雪雫は", 60, 530);
    }
    if (c>=10 && c <20) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("来年も同じ授業を", 60, 430);
      text("履修するのであった．", 60, 480);
      text("To be continued", 60, 530);
    }
    if (c>=20) {
      fill(0, 100, 0);
      rect(40, 410, 520, 160);
      fill(0, 0, 100);
      text("", 60, 430);
      text("Tキーでスタートに戻る", 60, 480);
      text("", 60, 530);
      if (keyPressed&&key=='t') {
        credit = new Credit();
        flag = 201;
      }
    }
  }
}

class Credit {
  int counter;
  Credit() {
    counter=0;
  }
  void draw() {
    background(0);
    fill(0, 0, 100);
    textAlign(CENTER);
    textSize(60);
    text("提供", 300, 100);
    textSize(30);
    text("後編作成：16FI030", 300, 250);
    text("キャラ提供：東京工科大学パセリさん", 300, 400);
    text("キャラ名提供：16FI065", 300, 550);
    counter++;
    if (counter>250) {
      start = new Start();
      flag=0;
    }
  }
}