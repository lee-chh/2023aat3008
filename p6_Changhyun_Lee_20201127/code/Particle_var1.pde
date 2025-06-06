// Particle3 클래스 정의
class Particle3 {
  float x, y; // 위치
  float x_i,y_i; //초기위치
  float speedX, speedY; // 속도
  float gravity; // 중력
  color col; // 색상
  
  Particle3(float x, float y,color col) {
    this.x = x;
    this.y = y;
    this.x_i = x;
    this.y_i = y;
    this.speedX = constrain(randomGaussian() * 3, -5, 5); // 평균 0, 표준편차 2로 설정
    this.speedY = constrain(randomGaussian() * 3 ,-5, 5);
    this.gravity = 0;
    //this.col = color(random(255), random(255), random(255));
    this.col = col;
  }
  
  void update() {
    speedY += gravity; // 중력 적용
    x += speedX;
    y += speedY;
  }
  
  void display() {
    int movement = int(abs(sqrt((x-x_i)*(x-x_i)+(y-y_i)*(y-y_i))));
    float alpha = map(movement, 100, 0, 0, 255);
    fill(col,alpha);
    noStroke();
    ellipse(x, y, 3, 3); // 원 모양의 파티클
  }
}
