class Player {
  float fitness;
  Genome brain;
  boolean replay = false;
  boolean released = true;
  float unadjustedFitness;
  int lifespan = 0;//how long the player lived for fitness
  int bestScore =0;//stores the score achieved used for replay
  boolean dead;
  int score;
  int gen = 0;

  int genomeInputs = 6;
  int genomeOutputs = 2;

  float[] vision = new float[genomeInputs];//t he input array fed into the neuralNet 
  float[] decision = new float[genomeOutputs]; //the out put of the NN 
  //-------------------------------------
  float yVel = 0;
  //float gravity =1.2;
  float acceleration = 0.3;
  //int runCount = -5;
  int size = 50;
  float yPos = height/2;
  //float xPos = 200;
  
  //ArrayList<Obstacle> replayObstacles = new ArrayList<Obstacle>();
  ArrayList<Pipes> replayObstacles = new ArrayList<Pipes>();
  ArrayList<Bird> replayBirds = new ArrayList<Bird>();
  ArrayList<Integer> localObstacleHistory = new ArrayList<Integer>();
  ArrayList<Integer> localRandomAdditionHistory = new ArrayList<Integer>();
  int historyCounter = 0;
  int localObstacleTimer = 0;
  float localSpeed = 10; //pipeSpeed ?
  int localRandomAddition = 0;

  boolean duck= false;
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor

  Player() {
    brain = new Genome(genomeInputs, genomeOutputs);
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //show the boi
  void show() {
    fill(255,255,0);
    shapeMode(CENTER);
    circle(playerXpos, yPos, size);
    fill(0);
    circle(playerXpos - 10, yPos - 7, 3);
    circle(playerXpos + 10, yPos - 7, 3);
    //line(playerXpos + 10, yPos + 10, playerXpos - 10, yPos + 10);
    curve(playerXpos + 15, yPos, playerXpos + 8, yPos + 15, playerXpos - 8, yPos + 15, playerXpos - 15, yPos);

  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  
  void incrementCounters() {
    lifespan++;
    if (lifespan % 3 ==0) {
      score+=1;
    }
  }


  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //checks for collisions and if this is a replay move all the obstacles
  void move() {
    yVel += acceleration;
    yPos += yVel;
    if ((yPos >= height) || (yPos <= 0)){
      dead = true;
      println("Dead");
    }
    if (!replay) {
      for(int i = 0; i < obstacles.size(); i++) {
        if (obstacles.get(i).collided(playerXpos,yPos,size,size)) {
          dead = true;
        }
      }
    } 
    else {//if replaying then move local obstacles
      for (int i = 0; i< replayObstacles.size(); i++) {
        if (obstacles.get(i).collided(playerXpos,yPos,size,size)) {
        dead = true;
        }
      }
    }
  }


  //---------------------------------------------------------------------------------------------------------------------------------------------------------
//what could this do????
  void jump() {
    if (yVel >= -3) {
      yVel = -8;
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //called every frame
  void update() {
    incrementCounters();
    move();
  }
  //----------------------------------------------------------------------------------------------------------------------------------------------------------
  //get inputs for Neural network
  
  // inputs:
  // 0 - speed
  // 1 - y position
  // 2 - y vel
  // 3 - horizontal distance to next pipe
  // 4 - vertical distance to next top pipe
  // 5 - vertical distance to next bottom pipe
  // add 6 - distance between closest pipe and next pipe
  // outputs:
  // 6 - jump
  void look() {
    if (!replay) {
      float min = 10000;
      int minIndex = -1;
      for (int i = 0; i< obstacles.size(); i++) { //if the distance between the left of the player and the right of the obstacle is the least
        if (obstacles.get(i).xPos + obstacles.get(i).w/2 - (playerXpos - size/2) < min &&  obstacles.get(i).xPos + obstacles.get(i).w/2 - (playerXpos - size/2) > 0) {
          min = obstacles.get(i).xPos + obstacles.get(i).w/2 - (playerXpos - size/2);
          minIndex = i;
        }
      }
      vision[0] = speed;
      vision[1] = yPos;
      vision[2] = yVel;
      
      if (minIndex == -1) { //no obstacles
        vision[3] = 0;
        vision[4] = 0;
        vision[5] = 0;
      }
      else {
        vision[3] = 1.0/(min/10.0);
        vision[4] = yPos - obstacles.get(minIndex).topPipe;
        vision[5] = yPos + obstacles.get(minIndex).botPipe;
      }
    }
    else {//if replayign then move local obstacles
      for (int i = 0; i< replayObstacles.size(); i++) {
        if (replayObstacles.get(i).collided(playerXpos, yPos + size/2, size*0.5, size)) {
          dead = true;
        }
      }
    }
  }


  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //gets the output of the brain then converts them to actions
  void think() {
    float max = 0;
    int maxIndex = 0;
    decision = brain.feedForward(vision); //output of neural network
    println("Decision length: " + decision.length);
    for (int i = 0; i < decision.length; i++) {
      if (decision[i] > max) {
       max = decision[i];
       maxIndex = i;
      }
    }
    switch(maxIndex) {
    case 0:
      jump();
      break;
    case 1:
      println("Don't Jump!");
      break;
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //returns a clone of this player with the same brian
  Player clone() {
    Player clone = new Player();
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork(); 
    clone.gen = gen;
    clone.bestScore = score;
    return clone;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //since there is some randomness in games sometimes when we want to replay the game we need to remove that randomness
  //this fuction does that

  Player cloneForReplay() {
    Player clone = new Player();
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork();
    clone.gen = gen;
    clone.bestScore = score;
    clone.replay = true;
    if (replay) {
      clone.localObstacleHistory = (ArrayList)localObstacleHistory.clone();
      clone.localRandomAdditionHistory = (ArrayList)localRandomAdditionHistory.clone();
    } else {
      clone.localObstacleHistory = (ArrayList)obstacleHistory.clone();
      clone.localRandomAdditionHistory = (ArrayList)randomAdditionHistory.clone();
    }

    return clone;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //fot Genetic algorithm
  void calculateFitness() {
    fitness = score*score;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  Player crossover(Player parent2) {
    Player child = new Player();
    child.brain = brain.crossover(parent2.brain);
    child.brain.generateNetwork();
    return child;
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------------------
  //if replaying then the dino has local obstacles
  void updateLocalObstacles() {
    localObstacleTimer ++;
    localSpeed += 0.002;
    if (localObstacleTimer > minimumTimeBetweenObstacles + localRandomAddition) {
      addLocalObstacle();
    }
    moveLocalObstacles();
    showLocalObstacles();
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void moveLocalObstacles() {
    for (int i = 0; i< replayObstacles.size(); i++) {
      replayObstacles.get(i).move(localSpeed);
      if (replayObstacles.get(i).xPos < -100) {
        replayObstacles.remove(i);
        i--;
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------------------------
  void addLocalObstacle() {
    localRandomAddition = localRandomAdditionHistory.get(historyCounter);
    historyCounter ++;
    replayObstacles.add(new Pipes());
    localObstacleTimer = 0;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void showLocalObstacles() {
    for (int i = 0; i< replayObstacles.size(); i++) {
      replayObstacles.get(i).show();
    }
  }
}
