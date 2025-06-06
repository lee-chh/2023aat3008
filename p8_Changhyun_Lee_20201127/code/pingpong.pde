import oscP5.*;
import netP5.*;
import peasy.*;

OscP5 oscP5;
NetAddress dest;
PeasyCam cam;  // PeasyCam 선언
ArrayList<Ball> balls;  // Ball 클래스의 ArrayList
boolean gameStarted = false;

void setup() {
  size(960, 540, P3D);
  frameRate(60);
  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);

  // PeasyCam 초기화
  cam = new PeasyCam(this, width / 2);
  cam.setRotations(PI / 15, 0, 0);  // X축을 기준으로 시점 설정

  balls = new ArrayList<Ball>();  // ArrayList 초기화
}

void draw() {
  background(255);

  // 탁구대 그리기
  fill(0, 0, 255);
  box(152.5, 10, 274);
  translate(0, -10, 0);
  fill(180,180,180);
  box(183, 15.25, 3);
  translate(0, 10, 0);

  if (gameStarted) {
    // 게임이 시작되면 모든 Ball을 업데이트하고 표시
    for (Ball ball : balls) {
      ball.update();
      ball.display();
    }
  } else {
    // 게임이 시작되지 않았으면 메시지 표시
    cam.beginHUD(); // HUD 모드 시작
    displayStartMessage();
    cam.endHUD(); // HUD 모드 종료
  }
}


void oscEvent(OscMessage m) {
  m.print();
  float outputValue = m.get(0).floatValue(); // output_1의 값
  if (outputValue == 1) {
    // 클래스 1에 해당하는 경우
    println("Class 1");
    // 아무 작업 없음
  } else if (outputValue == 2) {
    // 클래스 2에 해당하는 경우
    println("Class 2");
    // 마지막으로 생성된 공의 조작
    if (balls.size() > 0) {
      Ball lastBall = balls.get(balls.size() - 1);
      if (lastBall.speedX > 0 && lastBall.speedY < 0) {
        // speedX가 양수이고 speedY가 음수인 경우
        lastBall.speedX *= -1;
        lastBall.speedZ *= -1;
      }
    }
  } else if (outputValue == 3) {
    // 클래스 3에 해당하는 경우
    println("Class 3");
    // 마지막으로 생성된 공의 조작
    if (balls.size() > 0) {
      Ball lastBall = balls.get(balls.size() - 1);
      if (lastBall.speedX < 0 && lastBall.speedY < 0) {
        // speedX가 음수이고 speedY가 음수인 경우
        lastBall.speedX *= -1;
        lastBall.speedZ *= -1;
      }
    }
  }
}


class Ball {
  float x, y, z;
  float speedX, speedY, speedZ;
  float gravity;

  Ball(float speedX) {
    this.x = 0;
    this.y = -30;
    this.z = -150;
    this.speedX = speedX;
    this.speedY = 0;
    this.speedZ = 10;
    this.gravity = 0.1;
  }

  void update() {
    speedY += gravity;
    x += speedX;
    y += speedY;
    z += speedZ;

    // 탁구대와의 충돌 체크
    if (y > -5 && y < 5 && z > -137 && z < 137) {
      // 충돌 발생 시 y 속도를 반대로 변경
      speedY = -speedY;
    }
    
    if (z < -151 && y < 0 && y > -50 && x > -76 && x < 76) {
      speedX *= -1;
      speedZ *= -1;
    }
  }

  void display() {
    pushMatrix(); // 현재 변환 상태 저장

    translate(x, y, z);

    fill(255, 127, 0);
    noStroke();
    sphere(4); // 지름이 15인 3D 구

    popMatrix(); // 이전 변환 상태로 복원
  }
}

void displayStartMessage() {
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(0);
  text("press [SPACE] to start!", width / 2, 200);
}

void keyPressed() {
  if (key == ' ') {
    // 스페이스바를 누르면 새로운 공 추가
    int direction = (balls.size() % 2 == 0) ? 1 : -1;  // 번갈아가며 방향 설정
    Ball newBall = new Ball(direction);
    balls.add(newBall);
    gameStarted = true;
  }
}
