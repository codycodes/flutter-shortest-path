//import 'dart:math';
//import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershortestpath/Node.dart';

class GridOne extends StatefulWidget {
  @override
  _GridOneState createState() => new _GridOneState();
}

class _GridOneState extends State<GridOne> {
  final int int64MaxValue = 9223372036854775807;

  @override
  Widget build(BuildContext context) {
    // get size to create appropriate sized grid
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

    List<List<Node>> createGridData() {
      // Creates a list of list of Node representing state for each cell in the grid

      int minusOneRow = 0;
      if (numRows % 2 == 1) {
        minusOneRow++;
      }
      int startRow = ((numRows ~/ 2) - minusOneRow);
      int startCol = (numCellsWidth ~/ 4);
      int endRow = ((numRows ~/ 2) - minusOneRow);
      int endCol = (numCellsWidth ~/4) * 3;

      List<List<Node>> gridState = [];
      for (int row = 0; row < numRows; row++) {
        List<Node> curRow = List();
        for (int col = 0; col < numCellsWidth; col++) {
          if (row == startRow && col == startCol) {
            curRow.add(Node(Colors.red, 0, row, col, true, false));
          } else if (row == endRow && col == endCol) {
            curRow.add(Node(Colors.blue, int64MaxValue, row, col, false, true));
          } else {
            curRow.add(Node(Colors.green, int64MaxValue ,row, col, false, false));
          }
        }
        gridState.add(curRow);
      }
      return gridState;
    }

    List<List<Node>> gridState = createGridData();

//    minPq<HeapPriorityQueue><>
    Map<List<Node>, int> totalCosts = Map();

    // Getting height is dividing by the width
    // and then modulus gets the col
    List<int> convertIndexRowCol(idx) {
        int row = (idx/numCellsWidth).floor();
        int col = (idx % numCellsWidth);
        return [row, col];
    }

    Color getNodeColor(number) {
      // TODO: this could be a map of the number to the rowcol
      List<int> rowCol = convertIndexRowCol(number);
      return gridState[rowCol[0]][rowCol[1]].color;
    }

    return new Scaffold(
      body: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisCount: numCellsWidth,
        children: List.generate(numCellsHeight, (index) {
          List<int> rowCol = convertIndexRowCol(index);
          return new GestureDetector(
            onTap: () => print(rowCol),
            child: new Card(
              margin: new EdgeInsets.all(1.0),
              elevation: 0,
  //            color: getNodeColor(index),
              child: new AnimatedContainer(
              curve: Curves.ease,
              duration: Duration(milliseconds: 2000),
              color: getNodeColor(index),
              child: Align(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 1250),
                  alignment: Alignment.center,
                  child: new Text ("✨",
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                ),
              ),
            ),
            ),

//            new GestureDetector(
//              onLongPress: () {
//                setState(() {
//                  gridState[0][0].color = Colors.purple;
//                  print("happening!");
//                  print(gridState[0][0].color);
//                });
//              },
//            child: new AnimatedContainer(
//              curve: Curves.ease,
//              duration: Duration(milliseconds: 500),
////              color: gridState[0][0].color,
//              child: Align(
//                alignment: Alignment.center,
//                child: new Text ("✨",
//                style: TextStyle(
//                  fontSize: 20.0
//                ),
//              ),
//            ),
//            ),
//            ),
//          );
          );
        })
      )
    );

  }

}