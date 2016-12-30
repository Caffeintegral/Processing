// 定数
final float PLAYER_RADIUS = 10;    // 主人公の大きさ
final int PLAYER_BULLET_COUNT = 5;  // 主人公の撃てる弾の最大数
final float ENEMY_RADIUS = 60;     // 敵の大きさ
final int ENEMY_BULLET_COUNT = 40;  // 敵の撃てる弾の最大数
final int ENEMY_LIFE = 50;         // 敵のライフ

// グローバル変数
Player player;
Bullet[] playerBullet;

Enemy enemy;
Bullet[] enemyBullet;

void setup() {
  size(720, 720);
  colorMode(RGB, 255, 255, 255);
  noStroke();

  setupGame();
}

void setupGame() {
  frameCount = 0;

  float centerX = width / 2;
  float offsetY = height / 5; 

  player = new Player(centerX, height - offsetY, PLAYER_RADIUS);
  enemy = new Enemy(centerX, offsetY, ENEMY_RADIUS, ENEMY_LIFE);

  playerBullet = new Bullet[PLAYER_BULLET_COUNT];
  for (int i = 0; i < playerBullet.length; i++) {
    playerBullet[i] = new Bullet();
  }
  enemyBullet = new Bullet[ENEMY_BULLET_COUNT];
  for (int i = 0; i < enemyBullet.length; i++) {
    enemyBullet[i] = new Bullet();
  }
}

void draw() {
  background(0, 0, 2);

  // 自機が死亡している？
  if (player.isDead()) {
    // ゲームオーバー処理を行う。
    updateGameOver();
  }
  // 敵が死亡している？
  else if (enemy.isDead()) {
    // ゲームクリア処理を行う。
    updateGameClear();
  } else {
    // ゲームを進行させる。
    updateGame();
  }
}

void updateGameOver() {
  enemy.update();
  enemy.draw();
  for (int i = 0; i < enemyBullet.length; i++) {
    enemyBullet[i].update();
    enemyBullet[i].draw();
  }

  // システムメッセージを表示する。
  fill(200);
  textSize(32);
  text("Game Over", width / 2 - 90, height / 2);
  textSize(10);
  text("Press R Key to restart.", width / 2 - 58, height / 2 + 20);

  // Rキーでリトライする。
  if (keyPressed && key == 'r') {
    setupGame();
  }
}

void updateGameClear() {
  player.update();
  player.draw();
  for (int i = 0; i < playerBullet.length; i++) {
    playerBullet[i].update();
    playerBullet[i].draw();
  }

  // システムメッセージを表示する。
  fill(200);
  textSize(32);
  text("Clear!", width / 2 - 50, height / 2);
  textSize(10);
  text("Press R Key to restart.", width / 2 - 58, height / 2 + 20);

  // Rキーでリトライする。
  if (keyPressed && key == 'r') {
    setupGame();
  }
}

void updateGame() {
  // 更新する。
  enemy.update();
  player.update();
  for (int i = 0; i < playerBullet.length; i++) {
    playerBullet[i].update();
  }
  for (int i = 0; i < enemyBullet.length; i++) {
    enemyBullet[i].update();
  }

  // ゲームを進行させる。
  if (frameCount < 100) {
    fill(200);
    textSize(32);
    text("Ready", width / 2 - 46, height / 2);
  } else {
    if (frameCount < 150) {
      fill(200);
      textSize(32);
      text("Go!", width / 2 - 24, height / 2);
    }

    // 自機が弾を撃つ。
    player.fire();

    // 敵が弾を撃つ。
    enemy.fire();

    // 自機と敵との衝突判定。
    {
      float dx = enemy.getX() - player.getX();
      float dy = enemy.getY() - player.getY();
      float r = enemy.getRadius() + player.getRadius();

      if (dx * dx + dy * dy < r * r) {
        player.kill();
      }
    }

    // 自機と敵の弾との衝突判定。
    for (int i = 0; i < enemyBullet.length; i++) {
      if (enemyBullet[i].isDead())
        continue;

      float dx = enemyBullet[i].getX() - player.getX();
      float dy = enemyBullet[i].getY() - player.getY();
      float r = enemyBullet[i].getRadius() + player.getRadius();

      if (dx * dx + dy * dy < r * r) {
        player.kill();
        enemyBullet[i].kill();
      }
    }

    // 敵と自機の弾との衝突判定。
    for (int i = 0; i < playerBullet.length; i++) {
      if (playerBullet[i].isDead())
        continue;

      float dx = playerBullet[i].getX() - enemy.getX();
      float dy = playerBullet[i].getY() - enemy.getY();
      float r = playerBullet[i].getRadius() + enemy.getRadius();

      if (dx * dx + dy * dy <  r * r) {
        playerBullet[i].kill();
        enemy.reduceLife();
      }
    }
  }

  // 描画する。
  enemy.draw();
  player.draw();
  for (int i = 0; i < playerBullet.length; i++) {
    playerBullet[i].draw();
  }
  for (int i = 0; i < enemyBullet.length; i++) {
    enemyBullet[i].draw();
  }
}

// 弾クラス
class Bullet {
  float x, y;             // 位置
  float vx, vy;           // 速度
  float radius;           // 半径
  boolean dead;           // 有効フラグ
  float r, g, b;          // 色

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  float getRadius() {
    return radius;
  }

  boolean isDead() {
    return dead;
  }

  Bullet() {
    dead = true;
  }

  // フィールド値を設定する。
  void setBullet(float x, float y, float vx, float vy, 
    float radius, float r, float g, float b) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.radius = radius;
    this.r = r;
    this.g = g;
    this.b = b;

    // 弾を有効にする。
    dead = false;
  }

  // 位置を更新する。
  void update() {
    if (dead)
      return;

    x += vx;
    y += vy;

    // 領域外に出たら消す。
    if (x < 0 || x > width || y < 0 || y > height)
      dead = true;
  }

  // 弾を殺す。
  void kill() {
    dead = true;
  }

  // 描画する。
  void draw() {
    if (dead)
      return;

    fill(r, g, b);
    ellipse(x, y, radius * 2, radius * 2);
  }
}

// 敵クラス
class Enemy {
  // 定数
  final float MoveRate = 0.2;        // ターゲットに近づく割合
  final float MaxBullet = 10;        // 一度に撃てる最大の弾数
  final float BulletRadius = 10.0;   // 弾の大きさ
  final float BulletGrowth = 1.0;    // 弾の成長倍率
  final float BulletDegree = 20;     // 弾の開き
  final float BulletSpeed = 7.0;     // 弾の速度

  // 変化しない値
  float centerX, centerY;      // 中心位置
  int maxLife;                 // 体力の最大値

  // 変化する値
  float x, y;      // 位置
  float radius;    // 半径
  boolean dead;    // 有効フラグ
  int count;       // 弾制御用カウンタ
  float lifeRate;  // 残りライフの割合を表す1～0の割合
  int life;        // 現在の体力
  float rad;       // リサージュ曲線用
  float delta;     // リサージュ曲線用

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  float getRadius() {
    return radius;
  }

  boolean isDead() {
    return dead;
  }

  Enemy(float centerX, float centerY, float radius, int life) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    this.life = maxLife = life;

    // 初期位置
    this.x = centerX;
    this.y = centerY;    
    rad = PI / 2;
  }

  // 位置を変更する。
  void update() {
    // ライフレートを更新する。
    lifeRate = (maxLife - life) / (float)maxLife;

    // リサージュ曲線を用いてターゲット位置を求める。
    delta += (PI / 64) * lifeRate;
    float tx = (width / 3) * cos(rad) + centerX;
    float ty = (height / 12) * sin(rad + delta) + centerY;
    rad += 0.05f * lifeRate;

    // ターゲット位置に近づける。
    x += (tx - x) * MoveRate;
    y += (ty - y) * MoveRate;
  }

  // 弾を撃つ。
  void fire() {
    int coolDown = 100 - (int)(90 * lifeRate);

    if (count > coolDown) {
      count = 0;

      float currentBulletSize = BulletRadius + (BulletRadius * BulletGrowth  * lifeRate);
      int numBullet = (int)(MaxBullet * lifeRate);

      float startDegree = -(numBullet - 1) * BulletDegree / 2;

      for (int i = 0; i < numBullet; i++) {
        float rad = radians(startDegree + BulletDegree * i) + PI / 2;
        setBullet(x + cos(rad) * radius * 0.5f, y + sin(rad) * radius * 0.5f, 
          cos(rad) * BulletSpeed, BulletSpeed, currentBulletSize);
      }
    }

    count++;
  }

  void setBullet(float x, float y, float vx, float vy, float radius) {
    // 弾の色を適当に決める。
    int r = 100;
    int g = 100;
    int b = 110;

    // 死んでいる弾を再利用する。
    for (int i = 0; i < enemyBullet.length; i++) {
      if (enemyBullet[i].isDead()) {
        enemyBullet[i].setBullet(x, y, vx, vy, radius, r, g, b);
        break;
      }
    }
  }

  // 体力を1減らす。
  void reduceLife() {
    life--;

    // 体力が無くなると死亡する。
    if (life <= 0) {
      life = 0;
      dead = true;
    }
  }

  // 描画する。
  void draw() {
    // ライフ割合の後半部分を用いる。
    float rate = max(0, (lifeRate - 0.5f) * 2);

    // 体を描画する。
    fill(40 + 50 * rate, 40, 40);
    ellipse(x, y, radius * 2, radius * 2);

    // 目を描画する。
    fill(200, 200, 200);
    float eyeWidth = radius * 1.2f;
    float eyeHeight = radius * (0.6f + 0.2f * rate);
    int eyeTess = 20;  // 分割数
    float tx, ty;   // 頂点位置
    beginShape();
    for (int i = 0; i <= eyeTess; i++) {
      tx = x + (eyeWidth * i / (float)eyeTess) - (eyeWidth / 2);
      ty = y + (eyeHeight / 2) * (sin(radians(i * 180 / (float)eyeTess)));
      vertex(tx, ty);
    }
    for (int i = 0; i <= eyeTess; i++) {
      tx = x - (eyeWidth * i / (float)eyeTess) + (eyeWidth / 2);
      ty = y - (eyeHeight / 2) * (sin(radians(i * 180 / (float)eyeTess)));
      vertex(tx, ty);
    }
    endShape(CLOSE);

    // 瞳を描画する。
    fill(0, 0, 0);
    float pp = radius * 0.1f;
    float pr = radius * 0.4f;
    ellipse(x, y + pp, pr, pr);

    // 画面上部にライフバーを描画する。
    drawLifeBar();
  }

  void drawLifeBar() {
    fill(180, 180, 180);
    float offset = 10.0f;
    rect(offset, offset, (width - offset - offset) * (1 - lifeRate), offset);
  }
}

// 自機クラス
class Player {
  // 定数
  final float MoveRate = 0.2;  // ターゲットに近づく割合
  final int Frequency = 15;    // 弾の発射頻度

  // 変化する値
  float x, y;      // 位置
  float radius;    // 半径
  boolean dead;    // 有効フラグ
  int count;       // 弾制御用カウンタ

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  float getRadius() {
    return radius;
  }

  boolean isDead() {
    return dead;
  }

  Player(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
  }

  // 位置座標を更新する。
  void update() {
    // マウス位置に近づける。
    x += (mouseX - x) * MoveRate;
    y += (mouseY - y) * MoveRate;

    // 領域外に出ないようにする。
    if (x < radius)
      x = radius;
    if (x > width - radius)
      x = width - radius;
    if (y < radius)
      y = radius;
    if (y > height - radius)
      y = height - radius;
  }

  // 弾を撃つ。
  void fire() {
    // ボタンを押している間は弾を撃つ。
    if (mousePressed) {
      // 連続で撃たないように調節する。
      if ((count % Frequency) == 0) {
        setBullet(x, y, 0, -10, radius);
      }
      count++;
    } else {
      count = 0;
    }
  }

  // 主人公を殺す。
  void kill() {
    dead = true;
  }

  // 弾を生成する。
  void setBullet(float x, float y, float vx, float vy, float radius) {
    // 弾の色を適当に決める。
    int r = 200;
    int g = 200;
    int b = 200;

    // 死んでいる弾を再利用する。
    for (int i = 0; i < playerBullet.length; i++) {
      if (playerBullet[i].isDead()) {
        playerBullet[i].setBullet(x, y, vx, vy, radius, r, g, b);
        break;
      }
    }
  }

  // 描画する。
  void draw() {
    // 本体を描画する。
    fill(200);
    ellipse(x, y, radius * 2, radius * 3);

    // 窓を描画する。
    fill(100);
    ellipse(x, y - radius * 0.1f, radius, radius);
    fill(100, 100, 250);
    ellipse(x, y - radius * 0.1f, radius * 0.8f, radius * 0.8f);

    // 羽を描画する。
    fill(100, 10, 10);
    triangle(x - radius * 2, y + radius, x - radius, y + radius, x - radius, y);
    triangle(x + radius * 2, y + radius, x + radius, y + radius, x + radius, y);
  }
}