//import 'dart:math';
//import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershortestpath/Node.dart';

class GridTwo extends StatefulWidget {
  @override
  _GridTwoState createState() => new _GridTwoState();
}

class _GridTwoState extends State<GridTwo> {
  // accessible to class
  final int int64MaxValue = 9223372036854775807;
  List<List<Node>> gridState;
  bool _visible = true;
  @override

  void initState() {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width;
    int numCellsWidth = (size.width ~/ 40);
    double scale = itemWidth / numCellsWidth;
    double num = 0;
    int numRows = 0;
    int topPadding = 128;
    while(num < (size.height - topPadding)) {
      num += scale;
      numRows += 1;
    }
    int numCellsHeight = (numCellsWidth * numRows).toInt();

    int minusOneRow = 0;
    if (numRows % 2 == 1) {
      minusOneRow++;
    }
    int startRow = ((numRows ~/ 2) - minusOneRow);
    int startCol = (numCellsWidth ~/ 4);
    int endRow = ((numRows ~/ 2) - minusOneRow);
    int endCol = (numCellsWidth ~/4) * 3;

    // create initial grid which maps to visual grid
//    List<List<Node>> gridState = [];
    for (int row = 0; row < numRows; row++) {
      List<Node> curRow = List();
      for (int col = 0; col < numCellsWidth; col++) {
        curRow.add(Node(Colors.green, int64MaxValue ,row, col, false, false));
      }
      gridState.add(curRow);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: backgroundColor,
      body: Listener(
        onPointerDown: _detectTapedItem,
        onPointerMove: _detectTapedItem,
        child: GridView.builder(
          key: key,
          itemCount: jMazeLength,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: iMazeLength,
            childAspectRatio: 100 / 148,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            int x, y = 0;
            x = (index / iMazeLength).floor();
            y = (index % iMazeLength);
            mazeMatrix[x][y].position.x = x;
            mazeMatrix[x][y].position.y = y;
            return CustomRenderWidget(
              index: index,
              child: GestureDetector(
                onLongPress: () {
                  setState(() {
                    if (!Node.isStartNodePicked)
                      mazeMatrix[x][y].setStartNode();
                    else if (!Node.isEndNodePicked)
                      mazeMatrix[x][y].setEndNode();
                  });
                },
                child: AnimatedContainer(
                  curve: Curves.ease, //TODO Change the animation
                  duration: Duration(milliseconds: 500),
                  color: mazeMatrix[x][y].color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}