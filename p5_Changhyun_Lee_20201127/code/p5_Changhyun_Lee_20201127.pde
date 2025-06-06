int currentDay = 0; // 현재 날짜를 나타내는 변수


Table table;
PImage mapImage;
PFont koreanFont;

String[][] locationData = {
    {"강남구", "37.4951", "127.06278"},
    {"강동구", "37.55274", "127.14546"},
    {"강북구", "37.6349", "127.02015"},
    {"강서구", "37.56227", "126.81622"},
    {"관악구", "37.47876", "126.95235"},
    {"광진구", "37.53913", "127.08366"},
    {"구로구", "37.49447", "126.8502"},
    {"금천구", "37.47486", "126.89106"},
    {"노원구", "37.66045", "127.06718"},
    {"도봉구", "37.65066", "127.03011"},
    {"동대문구", "37.58189", "127.05408"},
    {"동작구", "37.50056", "126.95149"},
    {"마포구", "37.55438", "126.90926"},
    {"서대문구", "37.57809", "126.93506"},
    {"서초구", "37.49447", "127.01088"},
    {"성동구", "37.54784", "127.02461"},
    {"성북구", "37.60267", "127.01448"},
    {"송파구", "37.5021", "127.11113"},
    {"양천구", "37.52056", "126.87472"},
    {"영등포구", "37.52606", "126.90308"},
    {"용산구", "37.53391", "126.9775"},
    {"은평구", "37.61846", "126.9278"},
    {"종로구", "37.5729", "126.97928"},
    {"중구", "37.55986", "126.99398"},
    {"중랑구", "37.60199", "127.10461"}
};

float minPrice, maxPrice, minSize, maxSize;

String hoverLocation = null;

float[] circleSizes; // 각 구의 원 크기를 저장할 배열
int[] ranks; // 각 구의 순위를 저장할 배열


void setup() {
  size(800, 800);
  
  koreanFont = createFont("NanumGothic", 16); 
  textFont(koreanFont);
  
  table = loadTable("seoul_house.csv", "header");

  mapImage = loadImage("seoul_map.jpg");
  mapImage.resize(780, 810);
  background(242);
  image(mapImage, 50, -20);

  // 최소 및 최대 가격을 초기화합니다.
  minPrice = 70.6;
  maxPrice = 152.4;

  // 최소 및 최대 원 크기를 초기화합니다.
  minSize = 5;
  maxSize = 100;
  
  //circleSizes = new float[locationData.length];
  //ranks = new int[locationData.length];

  //for (int i = 0; i < circleSizes.length; i++) {
  //  circleSizes[i] = random(1, 25); 
  //  ranks[i] = getSizeRank(circleSizes[i]); 
  //}
}

void draw() {
  background(242);
  image(mapImage, 50, -20);
  
  // 현재 날짜를 왼쪽 상단에 출력
  fill(0);
  textSize(20);
  textAlign(LEFT, TOP);
  text("DAY: " + table.getString(currentDay, 0), 10, 10);


  // 각 원 크기 출
  for (int i = 0; i < locationData.length; i++) {
    float lat = float(locationData[i][1]);
    float lon = float(locationData[i][2]);
    float x = map(lon, 126.7, 127.2, 0, width);
    float y = map(lat, 37.4, 37.7, height, 0);

    String name = locationData[i][0]; // 현재 구의 이름
    int price = getHousePrice(name);


    // 집 가격에 따라 원의 크기 계산
    float circleSize = map(price, minPrice, maxPrice, minSize, maxSize);
    int alpha = int(map(circleSize, minSize, maxSize, 0, 255)); // 원 크기에 따라 alpha 계산
    
    if (dist(x, y, mouseX, mouseY) < circleSize / 2) {
      hoverLocation = name;
    }

    noStroke();
    fill(0, 0, 255,alpha); // 파란색으로 채우기
    ellipse(x, y, circleSize, circleSize); // 원 그리기

    
    //int sizeRank = getSizeRank(circleSizes[i]);

    //if (sizeRank == 1) {
    //  fill(0, 200, 0);
    //  text("저렴", x + circleSizes[i], y - circleSizes[i]);
    //} else if (sizeRank == 2) {
    //  fill(200, 200, 0);
    //  text("보통", x + circleSizes[i], y - circleSizes[i]);
    //} else if (sizeRank == 3) {
    //  fill(255, 0, 0);
    //  text("비쌈", x + circleSizes[i], y - circleSizes[i]);
    //}
  }
  // 마우스가 원 위에 있을 이름 표
  if (hoverLocation != null) {
    fill(0);
    textSize(16);
    textFont(koreanFont); // 폰트 설정 적용
    textAlign(CENTER, BOTTOM);
    text(hoverLocation, mouseX, mouseY);
  }

  

  // 날짜 업데이트
  currentDay++;
  if (currentDay >= table.getRowCount()) {
    currentDay = 0;
  }
}

int getHousePrice(String name) {
  int price = 0;
  String cellValue = table.getString(currentDay, name);
  if (cellValue != null && !cellValue.isEmpty()) {
    try {
      price = int(cellValue);
    } catch (NumberFormatException e) {
      // 부동 소수점으로 파싱할 수 없는 경우에 대한 오류 처리 get help from GPT
      println("부동 소수점으로 파싱할 수 없는 값: " + cellValue);
    }
  }
  return price;
}

//int getSizeRank(float circleSize) {
//  if (circleSize >= 1 && circleSize < 9) {
//    return 1; // "저렴"
//  } else if (circleSize >= 9 && circleSize < 18) {
//    return 2; // "보통"
//  } else if (circleSize >= 18 && circleSize <= 25) {
//    return 3; // "비쌈"
//  } else {
//    return 0;
//  }
//}
