import 'package:flutter/material.dart';

class Node {
    int row, col;
    int cost;
    Color color;
    bool startNode;
    bool endNode;
    bool isSet;

    Node(this.color, this.cost, this.row, this.col, this.startNode, this.endNode, this.isSet) {
      color = this.color;
      cost = this.cost;
      row = this.row;
      col = this.col;
      startNode = this.startNode;
      endNode = this.endNode;
      isSet = this.isSet;
    }

    setColor(color) {
      this.color = color;
    }
}