// A connection between 2 nodes
class connectionGene {
  Node fromNode;
  Node toNode;
  float weight;
  boolean enabled = true;
  int innovationNo;
  
  connectionGene(Node from, Node to, float w, int num) {
   fromNode = from;
   toNode = to;
   weight = w;
   innovationNo = num;
  }
  
  // I think i should optimize this - seems random rn | adjust weights for unsupervised learning
  void mutateWeight() {
    float rand2 = random(1);
    if (rand2 < 0.1) {//10% of the time completely change the weight
      weight = random(-1, 1);
    } else {//otherwise slightly change it
      weight += randomGaussian()/50;
      //keep weight between bounds
      if(weight > 1){
        weight = 1;
      }
      if(weight < -1){
        weight = -1;        
        
      }
    }
  }
  
  //returns a copy of this connectionGene
  connectionGene clone(Node from, Node  to) {
    connectionGene clone = new connectionGene(from, to, weight, innovationNo);
    clone.enabled = enabled;
    return clone;
  }
}
