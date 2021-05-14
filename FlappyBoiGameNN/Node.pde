class Node {
  int number; // node number
  float inputSum = 0; // sum before activation function
  float outputValue = 0; // after activation function is applied
  ArrayList<connectionGene> outputConnections = new ArrayList<connectionGene>(); 
  int layer = 0;
  PVector drawPos = new PVector(); // draws connections between nodes?
  
  // constructor
  Node(int num) {
   number = num; 
  }
  
  // the node sends its output to the inputs of the nodes its connected to
  void engage() {
   if (layer!= 0) {// don't do this for first layer (raw inputs) 
     outputValue = sigmoid(inputSum);
   }
   for (int i = 0; i < outputConnections.size(); i++) { // for each connection
     if (outputConnections.get(i).enabled) {//dont do shit if not enabled
        //add the weighted output to the sum of the inputs of whatever node this node is connected to
        outputConnections.get(i).toNode.inputSum += outputConnections.get(i).weight * outputValue;
      }
   }
  }
  
  // sigmoid activation function
  float sigmoid(float x) {
   float out = 1/(1+exp(-x));
   return out;
  }
  
  boolean isConnected(Node node) {
   if (node.layer == layer) { // cant be connected in the same layer
    return false; 
   }
   if (node.layer < layer) {
     for (int i = 0; i < node.outputConnections.size(); i++) {
       if (node.outputConnections.get(i).toNode == this) {
        return true; 
       }
     }
   }
   else { // same as checking fromNode?
     for (int i = 0; i < outputConnections.size(); i++) {
        if (outputConnections.get(i).toNode == node) {
          return true;
        }
      }
   }
   return false;
  }
  
  Node clone() {
   Node clone = new Node(number);
   clone.layer = layer;
   return clone;
  }
}
