import 'package:flutter/material.dart';

class Node {
    int row, col;
    int cost;
    Color color;
    bool startNode;
    bool endNode;
    bool isWall;
    bool isVisited;
    Node prevNode;

    Node(this.color, this.cost, this.row, this.col, this.startNode, this.endNode, this.isWall, this.isVisited, this.prevNode){
      color = this.color;
      cost = this.cost;
      row = this.row;
      col = this.col;
      startNode = this.startNode;
      endNode = this.endNode;
      isWall = this.isWall;
      isVisited = this.isVisited;
      prevNode = this.prevNode;
    }

    setColor(color) {
      this.color = color;
    }
}