class Pipes {
  float xPos;
  int w = 150;
  float h = 100;
  float h1;
  float h2;
  int gap = 300;
  int type;
  Pipes() {
    xPos = width;
    h1 = random(150,height-(gap+150)); // height of top pipe
    h2 = height - h1 - gap; // height of bottom pipe (negate)
    
    //println(h1);
    //println(h2);
    //println("=========");
  }
  
  float pipeLeft; //temp
  float pipeRight; //temp
  float birdLeft;
  float birdRight;
  float birdBottom;
  float birdTop;
  float botPipe;
  float topPipe;
  void show() {
    fill(0,255,0);
    stroke(0);
    rectMode(CORNER);
    rect(xPos, 0, w, h1); // top pipe
    rect(xPos, height, w, -h2); //bottom pipe
    
    //// correct
    //line(0,topPipe,width,topPipe); // checking top pipe
    //line(0,botPipe,width,botPipe); //checking bottom pipe
    
    //// correct
    //line(pipeLeft,0,pipeLeft,height); //checking pipeLeft
    //line(pipeRight,0,pipeRight,height); //checking pipeRight
    
    //// correct
    //line(birdLeft,0,birdLeft,height); //checking birdLeft
    //line(birdRight,0,birdRight,height); //checking birdRight
    
    //line(0,birdTop,width,birdTop); // checking top bird
    //line(0,birdBottom,width,birdBottom); //checking bottom bird
  }

  void move(float speed) {
    xPos -= speed;
  }
  
  boolean collided(float birdX, float birdY, float birdWidth, float birdHeight) {
    birdLeft = birdX - birdWidth/2;
    birdRight = birdX + birdWidth/2;
    pipeLeft = xPos;
    pipeRight = xPos + w;
    birdBottom = birdY + birdHeight/2;
    birdTop = birdY - birdHeight/2;
    botPipe = height - h2;
    topPipe = h1;
    //println("Bird Right: " + birdRight);
    //println("Bird Left: " + birdLeft);
    //println("Pipe Right: " + pipeRight);
    //println("Pipe Left: "  +pipeLeft);
    //println("Bird Bottom: " + birdBottom);
    //println("Bird Top: " + birdTop);
    //println("Bottom Pipe: " + botPipe);
    //println("Top Pipe: " + topPipe);
    //println("==============");
    
    if ((birdRight <= pipeRight) && (birdLeft >= pipeLeft)) {
      if ((birdTop <= topPipe) || (birdBottom >= botPipe)) {
       return true;
      } else {
       return false; 
      }
    }    
    else if (birdRight >= pipeLeft && birdLeft <= pipeLeft) { //hits left side of pipe
      // check if inbetween and safe
      if ((birdTop >= topPipe) && (birdBottom <= botPipe)) {
       return false;
      } else {
        return true;
      }
    }
    return false;
  }
  
  boolean offScreen() {
    float pipeRight = xPos + w/2;
    if (pipeRight <= 0) {
     return true; 
    }
    return false;
  }
}
