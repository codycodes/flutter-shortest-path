import 'package:flutter/material.dart';

class Node {
    int row, col;
    Color color;
    bool startNode;
    bool endNode;

    Node(this.color, this.row, this.col, this.startNode, this.endNode) {
      color = this.color;
      row = this.row;
      col = this.col;
      startNode = this.startNode;
      endNode = this.endNode;
    }
}