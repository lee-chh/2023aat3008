//Planet Class//
PImage img;
PShape texture_earth;

class Planet {
  float distance; // 중심행성으로부터의 거리 
  float angle = 0; // 현재 각도
  float orbitalSpeed; // 공전 속도
  float axisInclination; // 궤도 경사
  float diameter; // 행성의 지름
  PImage planetTexture; //행성의 텍스처 

  Planet(float distance, float diameter, float orbitalSpeed, float axisInclination, PImage planetTexture) {
    this.distance = distance;
    this.diameter = diameter;
    this.orbitalSpeed = orbitalSpeed;
    this.axisInclination = axisInclination;
    this.planetTexture=planetTexture ;
  }

  void update() {
    angle += orbitalSpeed;
  }

  void display() {
    pushMatrix();
    rotateX(axisInclination);
    translate(distance * cos(angle), 0, distance * sin(angle));

    texture_earth = createShape(SPHERE,diameter);
    texture_earth.setTexture(planetTexture);
    shape(texture_earth);
    popMatrix();
  }
}
