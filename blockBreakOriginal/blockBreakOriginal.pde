

//スタート画面
Start start;
//プレイ方法
Intro intro;
//ゲーム本体
Game game;

//ゲーム状況
int flag = 0;
int playing = 0;

boolean isPlaying = false;

void setup() {
  size(400, 600);
  //noStroke();
  PFont font;
  font = createFont("Meiryo", 48, true);
  textFont(font, 48);
  start = new Start();
  intro = new Intro();
  game = new Game();
}

void draw() {
  start.draw();
  switch(flag) {
  case 1:
    game.draw();
    isPlaying =true;
    break;
  case 2:
    intro.draw();
    break;
  }
}
//isPlaying = true;


//最初の画面
class Start {
  void draw() {
    background(255);
    fill(0);
    textSize(30);
    text("オリジナリティ溢れる", width/2-150, 150);
    text("ブロック崩し", width/2-90, 200);
    textSize(15);
    text("ゲームスタート Xキー", 40, 400);
    text("プレイ方法 Cキー", width/2+20, 400);

    if (isPlaying == false) {
      if (keyPressed) {
        switch(key) {
        case 'x':
          flag = 1;
          break;
        case 'c':
          flag = 2;
          break;
        }
      }
    }
  }
}
//プレイ方法画面
class Intro {
  void draw() {
    background(#00E1FC, 70);
    fill(0);
    textSize(10);
    text("アイェェェェェェｘ", 100, 100);
    text("xキーゲームスタート", 100, 300);
  }
}
//ゲーム本体
class Game {
  final int blockNumX = 20;                           // x軸方向のブロック数
  final int blockNumY = 5;                            // y軸方向のブロック数
  final int boxNumX =1;
  final int blockNumAll = blockNumX * blockNumY;      // 総ブロック数
  final int blockX_init = 0;                          // ブロック位置x軸初期値
  int blockX = 0;                                     // ブロック位置x軸
  int blockY = 35;                                    // ブロック位置y軸
  int barSize = 5;
  int itemCount;


  Ball ball;                                          // ボール定義
  Bar bar;                                            // バー定義
  Block[][] block;                                    // ブロック配列定義
  Box[] box;

  Game() {
    // ボールの生成
    ball = new Ball(width / 4, height / 3, 2, 5, 8);
    // バーの生成
    bar = new Bar(width / barSize, height / 100);
    // ブロック配列を生成
    block = new Block[blockNumY][blockNumX];
    //
    box = new Box[boxNumX];
    for (int i=0; i<box.length; i++) {
      
        int x=50*i+50;
        box[i]=new Box(x, 400, 20,20);
      
    }
    // ブロックのサイズを決定
    int blockSizeX = width / blockNumX;
    int blockSizeY = height / 30;
    // ブロック群を生成 [回答欄]

    for (int j=0; j<blockNumY; j++) {
      for (int k=0; k<blockNumX; k++) {
        int x=blockSizeX*k+blockX;
        int y=blockSizeY*j+blockY;
        block[j][k]=new Block(x, y, blockSizeX, blockSizeY);
      }
    }
  }
  void draw() {
    background(255);
    int breakBlockNum = 0;          // 壊れているブロックの数を初期化
    // 全てのブロックの破壊判定と描画 [回答欄]
    // クリアしているかの判定のため、壊れているブロックの数をカウントもしておく
    // ヒント: ブロックが消滅している場合、ブロックの衝突判定も描画も行わない
    for (int j=0; j<blockNumY; j++) {
      for (int k=0; k<blockNumX; k++) {
        if (block[j][k].broken) {
          breakBlockNum++;
        } else {
          block[j][k].show();
          block[j][k].collision(ball);
        }
      }
      for (int i=0; i<box.length; i++) {
       
          box[i].show();
          box[i].collision(ball);
        
      }
    }
    if (breakBlockNum < blockNumAll) {
      ball.move();                            // ボールの移動処理
      if (ball.collision() == false) {         // 壁との衝突判定
        fill(0, 0, 0);
        textSize(10);
        textAlign(CENTER, CENTER);
        text("Game Over!!", width / 2, height / 2);
      } else {
        bar.collision(ball);                    // バーとの衝突判定
      }
    } else {  // ブロックがすべて壊れているならば
      textSize(35);
      textAlign(CENTER, CENTER);                // テキストの配置を整える
      text("Clear!!", width / 2, height / 2);   // クリア表示
    }

    fill(0, 0, 0);
    textSize(12);
    textAlign(CENTER, CENTER);
    text("Block:" + (blockNumAll - breakBlockNum), width - 40, height - 25);   // 残りブロック数表示

    bar.show(ball);            // ボールを打ち返すためのボードを表示
    ball.show();           // ボールの描画
  }
}


class Ball {
  int x;                          // ボールのX座標
  int y;                          // ボールのY座標
  int vx;                         // ボールのX軸速度
  int vy;                         // ボールのY軸速度
  int d;                          // ボールの直径
  boolean penetrability;          // ボールのブロック貫通性

  // コンストラクタ
  Ball(int x, int y, int vx, int vy, int d) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.d = d;
    penetrability = false;
  }

  // ボールの移動
  void move() {
    x += vx;
    y += vy;
  }

  // 壁との衝突判定
  boolean collision() {
    if (x <= d / 2) {  // 左壁
      x = d / 2;
      vx = -vx;
    }
    if (y <= d / 2) {  // 天井
      y = d / 2;
      vy = -vy;
    }    
    if (x >= (width - d / 2)) {  // 右壁
      x = width - d / 2;
      vx = -vx;
    }
    if (y >= (height - d / 2)) {  // 底面(ゲームオーバー)
      vx = 0;
      vy = 0;
      return false;
    }
    return true;
  }

  // ボールの描画
  void show() {
    if (penetrability) {
      fill(255, 0, 0);        //　貫通弾の時は赤
    } else {
      fill(0, 0, 0);          //　通常時は黒
    }
    ellipse(x, y, d, d);      // ボールの描画
  }

  // これ以降、SetterとGetter
  int getX() {
    return x;
  }
  void setY(int y) {
    this.y = y;
  }
  int getY() {
    return y;
  }
  void setVx(int vx) {
    this.vx = vx;
  }
  int getVx() {
    return vx;
  }
  void setVy(int vy) {
    this.vy = vy;
  }
  int getVy() {
    return vy;
  }
  int getD() {
    return d;
  }
  void setPenetrability(boolean penetrability) {
    this.penetrability = penetrability;
  }
  boolean getPenetrability() {
    return penetrability;
  }
}

/**
 *    バー
 */
class Bar {
  final int y = height - 50;    // バーの左上のy座標 (底から50で固定)
  int sizeX;                    // バー全体の幅(なるべく5の倍数が良い)
  int sizeY;                    // バーの高さ
  int boxSizeX;                 // 分割した時の箱一つ分の幅(全体の1/5)
  int[] boxX;   // バーの各区切りのx座標(左から0)

  Bar(int sizeX, int sizeY) {
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    boxSizeX = sizeX / 5;
    boxX = new int[6];
  }

  void collision(Ball ball) {
    if ((ball.getY() >= (y - ball.getD() / 2)) &&
      (ball.getY() <= (y + sizeY - ball.getD() / 2))) {  // ボールのy座標がバーと重なる時
      if ((ball.getX() >= boxX[0]) && (ball.getX() <= boxX[1])) {  // 左黒Boxに衝突
        ball.setVx(-2);
        ball.setY(y - ball.getD() / 2);
        ball.setVy(-ball.getVy());
        ball.setPenetrability(false);    // ボールのブロック貫通性なし
      } else if ((ball.getX() > boxX[1]) && (ball.getX() <= boxX[2])) {   // 左白Boxに衝突
        ball.setVx(-1);
        ball.setY(y - ball.getD() / 2);
        ball.setVy(-ball.getVy());
        ball.setPenetrability(false);    // ボールのブロック貫通性なし
      } else if ((ball.getX() > boxX[2]) && (ball.getX() <= boxX[3])) {   // 中心赤Boxに衝突
        ball.setY(y - ball.getD() / 2);
        ball.setVy(-ball.getVy());
        ball.setPenetrability(false);     // ボールのブロック貫通性なし
      } else if ((ball.getX() > boxX[3]) && (ball.getX() <= boxX[4])) {   // 右白Boxに衝突
        ball.setVx(1);
        ball.setY(y - ball.getD() / 2);
        ball.setVy(-ball.getVy());
        ball.setPenetrability(false);    // ボールのブロック貫通性なし
      } else if ((ball.getX() > boxX[4]) && (ball.getX() <= boxX[5])) {   // 右黒Boxに衝突
        ball.setVx(2); 
        ball.setY(y - ball.getD() / 2);
        ball.setVy(-ball.getVy());
        ball.setPenetrability(false);    // ボールのブロック貫通性なし
      }
    }
  }

  // バー表示メソッド
  void show(Ball ball) {
    boxX[0] = mouseX - this.sizeX / 2;            // 左黒Boxの左上頂点のx座標
    boxX[1] = mouseX - 3 * (boxSizeX / 2);     // 左白Boxの左上頂点のx座標
    boxX[2] = mouseX - boxSizeX / 2;           // 中央赤Boxの左上頂点のx座標
    boxX[3] = mouseX + boxSizeX / 2;           // 右白Boxの左上頂点のx座標
    boxX[4] = mouseX + 3 * (boxSizeX /2);      // 右黒Boxの左上頂点のx座標
    boxX[5] = mouseX + this.sizeX / 2;            // 右黒Boxの"右上"頂点のx座標


    //以下デバック用
    //boxX[0] = ball.getX() - this.sizeX / 2+15;
    //boxX[1] = ball.getX() - 3 * (boxSizeX / 2)+15;     
    //boxX[2] = ball.getX() - boxSizeX / 2+15;           
    //boxX[3] = ball.getX() + boxSizeX / 2+15;           
    //boxX[4] = ball.getX() + 3 * (boxSizeX /2)+15;      
    //boxX[5] = ball.getX() + this.sizeX / 2+15;         

    //boxX[0] = ball.getX() - this.sizeX / 2;
    //boxX[1] = ball.getX() - 3 * (boxSizeX / 2);    
    //boxX[2] = ball.getX() - boxSizeX / 2;          
    //boxX[3] = ball.getX() + boxSizeX / 2;           
    //boxX[4] = ball.getX() + 3 * (boxSizeX /2);      
    //boxX[5] = ball.getX() + this.sizeX / 2;          


    // バーの描画
    fill(0, 0, 0);
    rect(boxX[0], y, boxSizeX, sizeY);        // 左黒Box
    rect(boxX[1], y, boxSizeX, sizeY);        // 左白Box
    rect(boxX[2], y, boxSizeX, sizeY);        // 中央赤Box
    rect(boxX[3], y, boxSizeX, sizeY);        // 右黒Box
    rect(boxX[4], y, boxSizeX, sizeY);        // 右白Box
  }

  int getX(int i) {
    return boxX[i];
  }
  int getY() {
    return y;
  }
  int getSizeX() {
    return sizeX;
  }
  int getSizeY() {
    return sizeY;
  }
}

/**
 *    ブロック（ボールとブロックの衝突判定など）
 */
class Block {
  int x;                       // 左上頂点のx座標
  int y;                       // 左上頂点のy座標
  int sizeX;                   // ブロックの幅
  int sizeY;                   // ブロックの高さ
  boolean broken;              // ブロックが破壊されているか否か
  // コンストラクタ
  Block(int x, int y, int sizeX, int sizeY) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    broken = false;
  }

  // ブロックの描画メソッド
  void show() {
    fill(0, 0, 172);

    rect(x, y, sizeX, sizeY);
  }


  // ボールとブロックとの衝突と破壊判定
  // 今回,ボールの衝突判定はボールの中心座標のみで行っている
  void collision(Ball ball) {
    // ボールが貫通弾でないなら、衝突した際にボールの進行方向を変える(速度を変える)
    if (!ball.getPenetrability()) {
      // ブロック左側に当たった場合
      if ((ball.getX() >= x) && (ball.getX() <= (x + 5)) && (ball.getY() >= y) && (ball.getY() <= (y + sizeY))) {
        ball.setVx(-1 * ball.getVx());
      }
      // ブロック右側に当たった場合
      if ((ball.getX() >= (x + sizeX - 5)) && (ball.getX() <= (x + sizeX)) && (ball.getY() >= y) && (ball.getY() <= (y+sizeY))) {
        ball.setVx(-1 * ball.getVx());
      }
      // ブロック上側に当たった場合
      if ((ball.getX() >= x) && (ball.getX() <= (x + sizeX)) && (ball.getY() >= y) && (ball.getY() <= (y + 5))) {
        ball.setVy(-1 * ball.getVy());
      }
      // ブロック下側に当たった場合
      if ((ball.getX() >= x) && (ball.getX() <= (x + sizeX)) && (ball.getY() >= (y + sizeY - 5)) && (ball.getY() <= (y + sizeY))) {
        ball.setVy(-1 * ball.getVy());
      }
    }

    // 衝突による破壊判定
    if ((ball.getX() >= x) && (ball.getX() <= (x + sizeX)) && (ball.getY() >= y) && (ball.getY() <= (y + sizeY))) {      
      broken = true;
    }
  }

  boolean isBroken() {
    return broken;
  }
}


class Box {
  float x;                       // 左上頂点のx座標
  int y;                       // 左上頂点のy座標
  int sizeX;                   // ブロックの幅
  int sizeY;                   // ブロックの高さ
  int rad;
  int r=10;
  int speed=1;
  // コンストラクタ
  Box(float x, int y, int sizeX, int sizeY) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }

  // ブロックの描画メソッド
  void show() {
    fill(114, 0, 0);
    rad+=speed;
    x+=cos(rad);
    y+=sin(rad);
    rect(x, y, sizeX, sizeY);
  }


  // ボールとブロックとの衝突と破壊判定
  // 今回,ボールの衝突判定はボールの中心座標のみで行っている
  void collision(Ball ball) {
    // ボールが貫通弾でないなら、衝突した際にボールの進行方向を変える(速度を変える)
    if (!ball.getPenetrability()) {
      // ブロック左側に当たった場合
      if ((ball.getX() >= x) && (ball.getX() <= (x + 5)) && (ball.getY() >= y) && (ball.getY() <= (y + sizeY))) {
        ball.setVx(-1 * ball.getVx());
      }
      // ブロック右側に当たった場合
      if ((ball.getX() >= (x + sizeX - 5)) && (ball.getX() <= (x + sizeX)) && (ball.getY() >= y) && (ball.getY() <= (y+sizeY))) {
        ball.setVx(-1 * ball.getVx());
      }
      // ブロック上側に当たった場合
      if ((ball.getX() >= x) && (ball.getX() <= (x + sizeX)) && (ball.getY() >= y) && (ball.getY() <= (y + 5))) {
        ball.setVy(-1 * ball.getVy());
      }
      // ブロック下側に当たった場合
      if ((ball.getX() >= x) && (ball.getX() <= (x + sizeX)) && (ball.getY() >= (y + sizeY - 5)) && (ball.getY() <= (y + sizeY))) {
        ball.setVy(-1 * ball.getVy());
      }
    }
  }
}