// Particle2 클래스 정의
class Particle2 {
  float x, y; // 위치
  float speedX, speedY; // 속도
  float speedY_f;
  float gravity; // 중력
  color col; // 색상
  
  Particle2(float x, float y,float col1, float col2, float col3) {
    this.x = x;
    this.y = y;
    this.speedX = 0;
    this.speedY = random(-20, -10);
    this.speedY_f = speedY;
    this.gravity = 0.3;
    //this.col = color(random(255), random(255), random(255));
    this.col = color(col1, col2, col3);
  }
  
  void update() {
    speedY += gravity; // 중력 적용
    x += speedX;
    y += speedY;
  }
  
  void display() {
    int movement = int(126*speedY/speedY_f);
    for( float i = movement; i > 0; i--){
      float alpha = map(i, movement, 0, 0, 50);
      fill(col,alpha);
      noStroke();  
      ellipse(x, y+i, 7-i/(movement/7), 7-i/(movement/7)); // 원 모양의 파티클
    }
  }
}
