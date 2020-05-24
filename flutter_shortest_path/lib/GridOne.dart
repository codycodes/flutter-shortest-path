import 'dart:math';
//import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GridOne extends StatefulWidget {
  @override
  _GridOneState createState() => new _GridOneState();
}

class _GridOneState extends State<GridOne> {
  final int int64MaxValue = 9223372036854775807;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width;
    int numCellsWidth = (size.width ~/ 40);

    double scale = itemWidth / numCellsWidth;
    double num = 0;
    int heights = 0;
    int topPadding = 128;
    while(num < (size.height - topPadding)) {
      num += scale;
      heights += 1;
    }
    int numCellsHeight = (numCellsWidth * heights).toInt();

    // should be moved somewhere
    // used to push the row up one if it's in the middle instead of down
    int minusOne = 0;
    if (heights % 2 == 1) {
      minusOne++;
    }
    int startRow = ((heights/2)- minusOne).floor();
    int startCol = (numCellsWidth ~/ 4);

    List<List<int>> createGridData() {
      // Creates a list of list of strings representing state for each cell in the grid
      List<List<int>> gridState = [];
      List.filled(numCellsWidth, '0');
      for (int i = 0; i < heights; i++) {
       gridState.add(List<int>.filled(numCellsWidth, int64MaxValue));
      }
      return gridState;
    }

    List<List<int>> gridState = createGridData();
    gridState[0][0] = 0;
    gridState[1][1] = int64MaxValue;

//    minPq<HeapPriorityQueue><>
    Map<List, int> totalCosts = Map();
    // Each index for the graph will not be changed
    totalCosts[[0,0]] = 1;

    // NODE class stuff
    // Getting height is dividing by the width (undo?) and then modulus gets the col
    List convertIndexRowCol(idx) {
        int row = (idx/numCellsWidth).floor();
        int col = (idx % numCellsWidth);
//        return row;
        return [row, col];
    }

    Color getNodeColor(number) {
      List rowCol = convertIndexRowCol(number);

      print(rowCol);
      print(totalCosts);
      if (totalCosts[rowCol] == 1) {
        return Colors.red;
      }
//      if (gridState[rowCol[0]][rowCol[1]] == 0){
//        return Colors.black;
//      }
      if (rowCol[0] == startRow && rowCol[1] == startCol) {
        //start
        return Colors.blue;
      } else if (rowCol[0] == ((heights/2)- minusOne).floor()
      && rowCol[1] == ((numCellsWidth/4) * 3)) {
        // end
        return Colors.red;
      } else {
        return Colors.green;
      }
    }

    return new Scaffold(
      body: GridView.count(
        crossAxisCount: numCellsWidth,
        scrollDirection: Axis.vertical,
        children: List.generate(numCellsHeight, (index) {
          return new Card(
            margin: new EdgeInsets.all(1.0),
            elevation: 0,
//            color: index  == 10 ? Colors.yellow : Colors.green,
            color: getNodeColor(index),
            child: new Container(
              child: Align(
                alignment: Alignment.center,
                child: new Text ("✨",
                style: TextStyle(
                  fontSize: 20.0
              ),
              ),
            ),
            ),
          );

        })
      )
    );

  }

}