//Bird bird;
Population pop;
int nextConnectionNo = 1000;
boolean showBestEachGen = false;
int upToGen = 0;
Player genPlayerTemp;
boolean showNothing = false;
ArrayList<Pipes> obstacles = new ArrayList<Pipes>();
float playerXpos = 200;

int obstacleTimer = 0;
int minimumTimeBetweenObstacles = 50;
int randomAddition = 0;

ArrayList<Integer> obstacleHistory = new ArrayList<Integer>();
ArrayList<Integer> randomAdditionHistory = new ArrayList<Integer>();
float speed = 10;
void setup() {
  frameRate(60);
  fullScreen();
  pop = new Population(150);
  //bird = new Bird();
}

void draw() {
  drawGame();
  if (showBestEachGen) {//show the best of each gen
    if (!genPlayerTemp.dead) {//if current gen player is not dead then update it
      genPlayerTemp.updateLocalObstacles();
      genPlayerTemp.look();
      genPlayerTemp.think();
      genPlayerTemp.update();
      genPlayerTemp.show();
    } else {//if dead move on to the next generation
      upToGen ++;
      if (upToGen >= pop.genPlayers.size()) {//if at the end then return to the start and stop doing it
        upToGen= 0;
        showBestEachGen = false;
      } else {//if not at the end then get the next generation
        genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
      }
    }
  } else {//if just evolving normally
    if (!pop.done()) {//if any players are alive then update them
      updateObstacles();
      pop.updateAlive();
    } else {//all dead
      //genetic algorithm 
      pop.naturalSelection();
      resetObstacles();
    }
  }
  writeInfo();
  drawBrain();
}


void drawGame() {
  if (!showNothing) {
    background(0,180,220);
    stroke(0);
    strokeWeight(2);
    //writeInfo();
    //drawBrain();
  }
}

void drawBrain() { //show the brain of whatever genome is currently showing
  int startX = 600;
  int startY = 10;
  int w = 600;
  int h = 400;
  if (showBestEachGen) {
    genPlayerTemp.brain.drawGenome(startX, startY, w, h);
  } else {
    for (int i = 0; i< pop.pop.size(); i++) {
      if (!pop.pop.get(i).dead) {
        pop.pop.get(i).brain.drawGenome(startX, startY, w, h);
        break;
      }
    }
  }
}

//writes info about the current player
void writeInfo() {
  fill(200);
  textAlign(LEFT);
  textSize(40);
  if (showBestEachGen) { //if showing the best for each gen then write the applicable info
    text("Score: " + genPlayerTemp.score, 30, height - 30);
    //text(, width/2-180, height-30);
    textAlign(RIGHT);
    text("Gen: " + (genPlayerTemp.gen +1), width -40, height-30);
    textSize(20);
    int x = 580;
    text("Speed", x, 18+50);
    text("Y Position", x, 18+2*50);
    text("Y Velocity", x, 18+3*50);
    text("Dist. to next Pipe", x, 18+4*50);
    text("Vertical Dist. to Top Pipe", x, 18+5*50);
    text("Vertical Dist. to Bottom Pipe", x, 18+6*50);
    text("Bias", x, 18+7*50);

    textAlign(LEFT);
    text("Jump", 1220, 218);
    text("Don't Jump", 1220, 318);
  } else { //evolving normally 
    text("Score: " + floor(pop.populationLife/3.0), 30, height - 30);
    //text(, width/2-180, height-30);
    textAlign(RIGHT);

    text("Gen: " + (pop.gen +1), width -40, height-30);
    textSize(20);
    int x = 580;
    text("Speed", x, 18+50);
    text("Y Position", x, 18+2*50);
    text("Y Velocity", x, 18+3*50);
    text("Dist. to next Pipe", x, 18+4*50);
    text("Vertical Dist. to Top Pipe", x, 18+5*50);
    text("Vertical Dist. to Bottom Pipe", x, 18+6*50);
    text("Bias", x, 18+7*50);

    textAlign(LEFT);
    text("Jump", 1220, 150);
    text("Don't Jump", 1220, 280);
  }
}

void keyPressed() {
 switch(key) {
   case 'g':
     showBestEachGen = !showBestEachGen;
     upToGen = 0;
     genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
     break;
   case 'n'://show absolutely nothing in order to speed up computation
    showNothing = !showNothing;
    break;
   case CODED://any of the arrow keys
    switch(keyCode) {
    case RIGHT://right is used to move through the generations
      if (showBestEachGen) {//if showing the best player each generation then move on to the next generation
        upToGen++;
        if (upToGen >= pop.genPlayers.size()) {//if reached the current generation then exit out of the showing generations mode
          showBestEachGen = false;
        } else {
          genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
        }
        break;
      }
      break;
    }
  }
}

//called every frame
void updateObstacles() {
  obstacleTimer ++;
  //speed += 0.002;
  if (obstacleTimer > minimumTimeBetweenObstacles + randomAddition) { //if the obstacle timer is high enough then add a new obstacle
    addObstacle();
  }
  moveObstacles();//move everything
  if (!showNothing) {//show everything
    showObstacles();
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------
//moves obstacles to the left based on the speed of the game 
void moveObstacles() {
  println(speed);
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).move(speed);
    if (obstacles.get(i).xPos < -playerXpos) { 
      obstacles.remove(i);
      i--;
    }
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//every so often add an obstacle 
void addObstacle() {
  int lifespan = pop.populationLife;
  Pipes temp = new Pipes();
  obstacles.add(temp);
  randomAddition = floor(random(50));
  randomAdditionHistory.add(randomAddition);
  obstacleTimer = 0;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------
//what do you think this does?
void showObstacles() {
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).show();
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------
//resets all the obstacles after every bird has died
void resetObstacles() {
  randomAdditionHistory = new ArrayList<Integer>();
  obstacleHistory = new ArrayList<Integer>();

  obstacles = new ArrayList<Pipes>();
  obstacleTimer = 0;
  randomAddition = 0;
  speed = 10;
}
