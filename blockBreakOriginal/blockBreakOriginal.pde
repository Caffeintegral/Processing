/*
ブロック崩しを邪魔する要素として、狙いとしては視覚的に注目させミスを誘発させようと考えた。
壊れているブロックの数に応じて難易度としてボックスの数を増やした。
ブロックを回すことによりボールが吸い込まれているような錯覚に陥らせることができる。
隠し要素としてゲームをクリアすると高難易度のモードができるようになる。
ゲームの基本的な紹介するページを導入

*/

//スタート画面
Start start;
//プレイ方法
Intro intro;
//ゲーム本体
Game game;
//ゲーム本体2
InfernoGame infernoGame;

//ゲーム状況
int flag = 0; //ゲームの状態
boolean isPlaying = false; //ゲーム中か否か
boolean getInferno = false; //インフェルノモード解放

void setup() {
  size(400, 600);
  //noStroke();
  PFont font;
  font = createFont("Meiryo", 48, true);
  textFont(font, 48);
  start = new Start();
  intro = new Intro();
  game = new Game();
  infernoGame = new InfernoGame();
}

void draw() {
  switch(flag) {
  case 0:
    start.draw();
    break;
  case 1:
    game.draw();
    break;
  case 2:
    intro.draw();
    break;
  case 99: //後から難易度足しやすいようにとりあえず９９
    infernoGame.draw();
  }
}


//最初の画面
class Start {
  void draw() {
    if (getInferno == false) {
      flag=0;
      background(255);
      fill(0);
      textSize(30);
      textAlign(CENTER, CENTER);
      text("オリジナリティ溢れる", width/2, 150);
      text("ブロック崩し", width/2, 200);
      textSize(15);
      textAlign(CENTER, CENTER);
      text("ゲームスタート Xキー", width/2-80, 400);
      text("プレイ方法 Cキー", width/2+80, 400);
    } else if (getInferno == true) {
      flag=0;
      background(0);
      fill(255, 0, 0);
      textSize(30);
      textAlign(CENTER, CENTER);
      text("WELLCOME TO INFERNO", width/2, 150);
      text("ゲームスタート Iキー", width/2, 200);
      textSize(15);
      textAlign(CENTER, CENTER);
      text("通常ゲームスタート Xキー", width/2-80, 400);
      text("プレイ方法 Cキー", width/2+80, 400);
    }

    if (isPlaying == false) { //inferno off
      if (getInferno == false) {
        if (keyPressed) {
          switch(key) {
          case 'x':
            game = new Game();
            flag = 1;
            break;

          case 'c':
            game = new Game();
            flag = 2;
            break;
          }
        }
      } else if (getInferno == true) { //on
        if (keyPressed) { 
          switch(key) {
          case 'x':
            game = new Game();
            flag = 1;
            break;

          case 'c':
            game = new Game();
            flag = 2;
            break;

          case 'i':
            infernoGame = new InfernoGame();
            game = new Game();
            flag = 99;
            break;
          }
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
    textSize(15);
    textAlign(CENTER, CENTER);
    text("ボールをバーで打ち返してブロックを消そう！！", width/2, 50);
    text("ブロックを消していくといろいろと起きるぞ！！", width/2, 100);
    text("最後のほうはすごいことが・・・！？", width/2, 150);
    text("クリアすると・・・！？", width/2, 200);
    text("ここから先は君の眼で確かめてくれ！！", width/2, 250);
    text("注意！！ 酔いやすい人は無理せず", width/2, 300);
    text("戻る Bキー", 100, 500);
    if (keyPressed && key=='b') {
      flag = 0;
    }
  }
}
//ゲーム本体
class Game {
  final int blockNumX = 20;                           // x軸方向のブロック数
  final int blockNumY = 5;                            // y軸方向のブロック数
  final int boxNumX =8;
  final int secBoxNum = 10;
  final int thiBoxNum = 15;
  final int fouBoxNum= 15;
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
  SecBox[] secBox;
  ThiBox[] thiBox;
  FouBox[] fouBox;

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
      int x=50;
      box[i]=new Box(x, 400, 20, 20, i);
    }

    secBox = new SecBox[boxNumX];
    for (int i=0; i<secBox.length; i++) {
      int x=50;
      secBox[i]=new SecBox(x, 400, 20, 20, i);
    }

    thiBox = new ThiBox[boxNumX];
    for (int i=0; i<thiBox.length; i++) {
      int x=50;
      thiBox[i]=new ThiBox(x, 400, 20, 20, i);
    }

    fouBox = new FouBox[boxNumX];
    for (int i=0; i<fouBox.length; i++) {
      int x=50;
      fouBox[i]=new FouBox(x, 400, 20, 20, i);
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
    //int breakBlockNum =99; //クリアデバック用
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
    }
    //変なブロック
    if (breakBlockNum>5 && breakBlockNum<11 ||
      breakBlockNum>25 && breakBlockNum<31 ||
      breakBlockNum>50 && breakBlockNum<56 ||
      breakBlockNum>60 && breakBlockNum<66 ||
      breakBlockNum>75 && breakBlockNum<81 ||
      breakBlockNum>85 && breakBlockNum<91) {
      textSize(30);
      textAlign(CENTER, CENTER);
      fill(0);
      text("WARNING", width/2, 180);
    }
    if (breakBlockNum>10 && breakBlockNum<51 ||
      breakBlockNum>80) {
      for (int i=0; i<box.length; i++) {
        box[i].show();
        box[i].collision(ball);
      }
    }

    if (breakBlockNum>30 && breakBlockNum<51 ||
      breakBlockNum>80) {
      for (int i=0; i<secBox.length; i++) {
        secBox[i].show();
        secBox[i].collision(ball);
      }
    }

    if (breakBlockNum>55 && breakBlockNum <65 ||
      breakBlockNum>90) {
      for (int i=0; i<thiBox.length; i++) {
        thiBox[i].show();
        thiBox[i].collision(ball);
      }
    }

    if (breakBlockNum>65 && breakBlockNum<75 ||
      breakBlockNum>90) {
      for (int i=0; i<fouBox.length; i++) {
        fouBox[i].show();
        fouBox[i].collision(ball);
      }
    }

    if (breakBlockNum>90 && breakBlockNum<99) {
      textSize(30);
      textAlign(CENTER, CENTER);
      fill(0);
      text("あ　と　す　こ　し", width/2, 150);
    }


    if (breakBlockNum < blockNumAll) {
      ball.move();                            // ボールの移動処理
      if (ball.collision() == false) {         // 壁との衝突判定
        fill(0, 0, 0);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Game Over!!　Rキーでスタート画面に", width / 2, height / 2);
        if (keyPressed && key == 'r') {
          isPlaying=false;
          flag = 0;
        }
      } else {
        bar.collision(ball);                    // バーとの衝突判定
      }
    } else {  // ブロックがすべて壊れているならば
      textSize(20);
      textAlign(CENTER, CENTER);                // テキストの配置を整える
      text("Clear!! Rキーでスタート画面に", width / 2, height / 2);   // クリア表示
      if (keyPressed && key == 'r') {
        isPlaying=false;
        getInferno=true;
        flag = 0;
      }
    }

    fill(0, 0, 0);
    textSize(12);
    textAlign(CENTER, CENTER);
    text("Block:" + (blockNumAll - breakBlockNum), width - 40, height - 25);   // 残りブロック数表示

    bar.show(ball);            // ボールを打ち返すためのボードを表示
    ball.show();           // ボールの描画
  }
}

//難易度インフェルノ
class InfernoGame {
  final int blockNumX = 20;                           // x軸方向のブロック数
  final int blockNumY = 5;                            // y軸方向のブロック数
  final int boxNumX =8;                               // ボックス１の個数
  final int secBoxNum = 10;                           // ２の個数
  final int thiBoxNum = 15;                           // ３の個数
  final int fouBoxNum= 15;                            // ４の個数
  final int blockNumAll = blockNumX * blockNumY;      // 総ブロック数
  final int blockX_init = 0;                          // ブロック位置x軸初期値
  int blockX = 0;                                     // ブロック位置x軸
  int blockY = 35;                                    // ブロック位置y軸
  int barSize = 5;
  int itemCount;


  Ball ball;                                          // ボール定義
  Bar bar;                                            // バー定義
  Block[][] block;                                    // ブロック配列定義
  Box[] box;                                          // ボックス１の配列定義
  SecBox[] secBox;                                    // ２
  ThiBox[] thiBox;                                    // ３
  FouBox[] fouBox;                                    // ４

  InfernoGame() {
    // ボールの生成
    ball = new Ball(width / 4, height / 3, 5, 8, 8);
    // バーの生成
    bar = new Bar(width / barSize, height / 100);
    block = new Block[blockNumY][blockNumX];
    //
    box = new Box[boxNumX];
    for (int i=0; i<box.length; i++) {
      int x=50;
      box[i]=new Box(x, 400, 20, 20, i);
    }

    secBox = new SecBox[boxNumX];
    for (int i=0; i<secBox.length; i++) {
      int x=50;
      secBox[i]=new SecBox(x, 400, 20, 20, i);
    }

    thiBox = new ThiBox[boxNumX];
    for (int i=0; i<thiBox.length; i++) {
      int x=50;
      thiBox[i]=new ThiBox(x, 400, 20, 20, i);
    }

    fouBox = new FouBox[boxNumX];
    for (int i=0; i<fouBox.length; i++) {
      int x=50;
      fouBox[i]=new FouBox(x, 400, 20, 20, i);
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
    background(0);
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
    }

    if (breakBlockNum>0 && breakBlockNum<6) {
      textSize(30);
      textAlign(CENTER, CENTER);
      fill(255, 0, 0);
      text("WARNING", width/2, 180);
    }
    if (breakBlockNum>5) {
      for (int i=0; i<box.length; i++) {

        box[i].show();
        box[i].collision(ball);
      }
    }
    if (breakBlockNum>5) {
      for (int i=0; i<secBox.length; i++) {
        secBox[i].show();
        secBox[i].collision(ball);
      }
    }

    if (breakBlockNum>5) {
      for (int i=0; i<thiBox.length; i++) {
        thiBox[i].show();
        thiBox[i].collision(ball);
      }
    }

    if (breakBlockNum>5) {
      for (int i=0; i<fouBox.length; i++) {
        fouBox[i].show();
        fouBox[i].collision(ball);
      }
    }

    if (breakBlockNum>90 && breakBlockNum<99) {
      textSize(30);
      textAlign(CENTER, CENTER);
      fill(255, 0, 0);
      text("あ　と　す　こ　し", width/2, 150);
    }


    if (breakBlockNum < blockNumAll) {
      ball.move();                            // ボールの移動処理
      if (ball.collision() == false) {         // 壁との衝突判定
        fill(255, 0, 0);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Game Over!!　Rキーでスタート画面に", width / 2, height / 2);
        if (keyPressed && key == 'r') {
          isPlaying=false;
          flag = 0;
        }
      } else {
        bar.collision(ball);                    // バーとの衝突判定
      }
    } else {  // ブロックがすべて壊れているならば
      textSize(20);
      textAlign(CENTER, CENTER);                // テキストの配置を整える
      fill(255, 0, 0);
      text("Clear!! Rキーでスタート画面に", width / 2, height / 2);   // クリア表示
      if (keyPressed && key == 'r') {
        isPlaying=false;
        flag = 0;
      }
    }

    fill(255, 0, 0);
    textSize(12);
    textAlign(CENTER, CENTER);
    text("Block:" + (blockNumAll - breakBlockNum), width - 40, height - 25);   // 残りブロック数表示
    fill(255, 255, 0);
    bar.show(ball);            // ボールを打ち返すためのボードを表示
    ball.show();           // ボールの描画
  }
}

//ボールのクラス
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
    } else {
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

    ////デバック用
    //boxX[0] = ball.getX() - this.sizeX / 2;
    //boxX[1] = ball.getX() - 3 * (boxSizeX / 2);    
    //boxX[2] = ball.getX() - boxSizeX / 2;          
    //boxX[3] = ball.getX() + boxSizeX / 2;           
    //boxX[4] = ball.getX() + 3 * (boxSizeX /2);      
    //boxX[5] = ball.getX() + this.sizeX / 2;          


    //バーの描画
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

//オリジナリティあふれるブロック１
class Box {
  float x;                       // 左上頂点のx座標
  float y;                       // 左上頂点のy座標
  int sizeX;                   // ブロックの幅
  int sizeY;                   // ブロックの高さ
  float rad;
  int r=10;
  int speed=1;
  // コンストラクタ
  Box(float x, int y, int sizeX, int sizeY, int i) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    rad=i*PI/4;
  }

  // ブロックの描画メソッド
  void show() {
    fill(114, 0, 0);
    rad+=0.05;
    x=cos(rad)*60+200;
    y=sin(rad)*80+300;
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

//オリジナリティあふれるブロック２
class SecBox {
  float x;                       // 左上頂点のx座標
  float y;                       // 左上頂点のy座標
  int sizeX;                   // ブロックの幅
  int sizeY;                   // ブロックの高さ
  float rad;
  int r=10;
  int speed=1;
  // コンストラクタ
  SecBox(float x, int y, int sizeX, int sizeY, int i) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    rad=i*PI/4;
  }

  // ブロックの描画メソッド
  void show() {
    fill(114, 0, 0);
    rad+=0.05;
    x=-cos(rad)*140+200;
    y=sin(rad)*120+300;
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

//オリジナリティあふれるブロック３
class ThiBox {
  float x;                       // 左上頂点のx座標
  float y;                       // 左上頂点のy座標
  int sizeX;                   // ブロックの幅
  int sizeY;                   // ブロックの高さ
  float rad;
  int r=10;
  int speed=1;
  // コンストラクタ
  ThiBox(float x, int y, int sizeX, int sizeY, int i) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    rad=i*PI/4;
  }

  // ブロックの描画メソッド
  void show() {
    fill(114, 0, 0);
    rad+=0.05;
    x=-sin(rad)*140+200;
    y=sin(rad)*120+300;
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

//オリジナリティあふれるブロック４
class FouBox {
  float x;                       // 左上頂点のx座標
  float y;                       // 左上頂点のy座標
  int sizeX;                   // ブロックの幅
  int sizeY;                   // ブロックの高さ
  float rad;
  int r=10;
  int speed=1;
  // コンストラクタ
  FouBox(float x, int y, int sizeX, int sizeY, int i) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    rad=i*PI/4;
  }

  // ブロックの描画メソッド
  void show() {
    fill(114, 0, 0);
    rad+=0.05;
    x=cos(rad)*140+200;
    y=cos(rad)*120+300;
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