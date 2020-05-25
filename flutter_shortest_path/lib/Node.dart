import 'package:flutter/material.dart';

class Node {
    int row, col;
    int cost;
    Color color;
    bool startNode;
    bool endNode;

    Node(this.color, this.cost, this.row, this.col, this.startNode, this.endNode) {
      color = this.color;
      cost = this.cost;
      row = this.row;
      col = this.col;
      startNode = this.startNode;
      endNode = this.endNode;
    }

    setColor(color) {
      this.color = color;
    }
}