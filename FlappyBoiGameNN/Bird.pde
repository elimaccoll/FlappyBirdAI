class Bird {

  float lifespan = 0; // how long the player lived for fitness func
  int score = 0;
  
  // base game stuff
  float yPos = height/2;
  float yVel = 0;
  float gravity = 0;
  int size = 50;
  boolean dead = false;
  float acceleration = 0.3;
  int pipeSpeed = 10;
  int counter = 0;
  int newPipeTimer = 0;
  int minTimeBetweenObs = 50;
  
  ArrayList<Pipes> pipes = new ArrayList<Pipes>();
  
  Bird() {
    addPipes();
  }
  
  void show() {
    fill(255,255,0);
    shapeMode(CENTER);
    circle(playerXpos, yPos, size);
    for(int i = 0; i < pipes.size(); i++) {
      pipes.get(i).show();
    }
    writeInfo();
  }
  
  float tempG;
  float tempA;
  void move() {
    counter++;
    if (counter == newPipeTimer + minTimeBetweenObs) {
      addPipes();
      counter = 0;
    }
    yVel += acceleration;
    yPos += yVel;
    if ((yPos >= height) || (yPos <= 0)){
      dead = true;
      println("Dead");
    }
    for(int i = 0; i < pipes.size(); i++) {
      pipes.get(i).move(pipeSpeed);
      if (pipes.get(i).offScreen()) {
        pipes.remove(i);
      }
    }
    
    for(int i = 0; i < pipes.size(); i++) {
      if (pipes.get(i).collided(playerXpos,yPos,size,size)) {
        dead = true;
      }
    }
  }
  
  void addPipes() {
    Pipes temp = new Pipes();
    pipes.add(temp);
    newPipeTimer = floor(random(10,50));
  }
  
  void update() {
    incrementScore();
    move();
  }
  
  void incrementScore() {
    lifespan++;
    if (lifespan % 3 ==0) {
      score+=1;
    }
  }
  
  void writeInfo() {
   fill(255,0,0);
   textAlign(LEFT);
   textSize(40);
   text("Score: " + score, 30, height - 30);
  }
}
