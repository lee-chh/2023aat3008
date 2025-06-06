/*
  Project #1 by Changhyun Lee
  
  Select one of the 600 divisors (from 30, 40, 50, 60, 75, 100, 120, 150, 200, 300) and divide the screen into the selected divisors to draw a grid. Select one number between 0 and 3, create four options to draw one part of the quarter circle through the lines according to the number you select. Draw a quarter circle of different colors in one grid. The grid changes in size every second (frame rate: 4), sometimes a circle is created (not a complete circle)
  
*/

const divisor600 = [30, 40, 50, 60, 75, 100, 120, 150, 200, 300]

function setup() {
  createCanvas (600, 600);
  
  frameRate(1)
}

function draw() {
  
  rd600 = divisor600[int(random(10))] // random divior, min is 30, max is 300
  cube = 600 / rd600 //the number of cubes in a each line
  background(0);
  stroke(255)
  
  for(let i = 0; i < cube; i++) {
    
    for (let j = 0; j< cube; j++) {
      
      // basic setup for line
      stroke( random(256), random (256), random (256))
      strokeWeight(1)
      
      // make the grid
      line(i * rd600,0, i * rd600,600)
      line(0,i * rd600,600, i * rd600)
      
      // choose random number(0~3) for select the type
      let r = int(random(4))
      
      if(r == 0){
        for(let k = 0; k < rd600; k= k + 4) {
          line(((i + 1) * rd600) - k, (j * rd600) + 0, (i * rd600) + 0, (j * rd600) + k)
        }
      }
      
      else if(r == 1){
        for(let k = 0; k < rd600; k = k + 4) {
          line(((i) * rd600) + k, (j * rd600) + 0, ((i + 1) * rd600) + 0, (j * rd600) + k)
        }
      }
      
      if(r == 2){
        for(let k = 0; k < rd600; k = k + 4) {
          line(((i + 0) * rd600) + 0, (j * rd600) + k, (i * rd600) + k, ((j + 1) * rd600) + 0)
        }
      }
      
      if(r == 3){
        for(let k = 0; k < rd600; k = k + 4) {
          line(((i) * rd600) + k, ((j + 1) * rd600) + 0, ((i + 1) * rd600) + 0, ((j + 1) * rd600) - k)
        }
        
      }
    }
  }
}