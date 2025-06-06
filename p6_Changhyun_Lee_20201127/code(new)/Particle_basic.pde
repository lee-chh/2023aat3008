// Particle 클래스 정의
class Particle {
  float x, y; // 위치
  float speedX, speedY; // 속도
  float gravity; // 중력
  color col; // 색상
  
  Particle(float x, float y,color col) {
    this.x = x;
    this.y = y;
    this.speedX = constrain(randomGaussian() * 2, -5, 5); // 평균 0, 표준편차 2로 설정
    this.speedY = constrain(randomGaussian() * 2-5, -10, 4);
    this.gravity = 0.3;
    //this.col = color(random(255), random(255), random(255));
    this.col = col;
  }
  
  void update() {
    speedY += gravity; // 중력 적용
    x += speedX;
    y += speedY;
  }
  
  void display() {
    fill(col);
    noStroke();
    ellipse(x, y, 3, 3); // 원 모양의 파티클
  }
}
