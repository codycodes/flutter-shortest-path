//import 'dart:math';
//import 'dart:collection';

//import 'package:after_layout/after_layout.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershortestpath/Node.dart';

class GridOne extends StatefulWidget {
  @override
  _GridOneState createState() => new _GridOneState();
}
//class _GridOneState extends State<GridOne> with AfterLayoutMixin<GridOne>{
class _GridOneState extends State<GridOne> {
  // accessible to class
  final int int64MaxValue = 9223372036854775807;
  List<List<Node>> gridState = [];
  bool _visible = false;
  int startRow;
  int startCol;
  int endRow;
  int endCol;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
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
      startRow = ((numRows ~/ 2) - minusOneRow);
      startCol = (numCellsWidth ~/ 4);
      endRow = ((numRows ~/ 2) - minusOneRow);
      endCol = (numCellsWidth ~/4) * 3;

      // initialize vals in grid which maps to visual grid
      for (int row = 0; row < numRows; row++) {
        List<Node> curRow = List();
        for (int col = 0; col < numCellsWidth; col++) {
          if (row == startRow && col == startCol) {
            curRow.add(Node(Colors.red, int64MaxValue ,row, col, false, false));
          } else if (row == endRow && col == endCol) {
            curRow.add(Node(Colors.blue, int64MaxValue ,row, col, false, false));
          } else {
            curRow.add(Node(Colors.green, int64MaxValue ,row, col, false, false));
          }
        }
        gridState.add(curRow);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      var size = MediaQuery
          .of(context)
          .size;
      final double itemWidth = size.width;
      int numCellsWidth = (size.width ~/ 40);
      double scale = itemWidth / numCellsWidth;

      double num = 0;
      int numRows = 0;
      int topPadding = 128;
      while (num < (size.height - topPadding)) {
        num += scale;
        numRows += 1;
      }
      int numCellsHeight = (numCellsWidth * numRows).toInt();

      // and then modulus gets the col
      List<int> convertIndexRowCol(idx) {
        int row = (idx / numCellsWidth).floor();
        int col = (idx % numCellsWidth);
        return [row, col];
      }

      Color getNodeColor(number) {
        // TODO: this could be a map of the number to the rowcol
        List<int> rowCol = convertIndexRowCol(number);
        if (gridState.length == 0) {
          return Colors.white;
        } else {
          return gridState
              ?.elementAt(rowCol[0])
              ?.elementAt(rowCol[1])
              ?.color ?? Colors.green;
        }
      }

      clearGrid() {
        // Clears the grid except for the start and end nodes
        for (int row = 0; row < numRows; row++) {
          List<Node> curRow = List();
          for (int col = 0; col < numCellsWidth; col++) {
            if (row == startRow && col == startCol) {
              gridState[row][col].color = Colors.red;
            } else if (row == endRow && col == endCol) {
              gridState[row][col].color = Colors.blue;
            } else {
              gridState[row][col].color = Colors.green;
            }
          }
        }
      }

      return new Scaffold(
        body: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            crossAxisCount: numCellsWidth,
            children: List.generate(numCellsHeight, (index) {
              List<int> rowCol = convertIndexRowCol(index);
              return new GestureDetector(
                onTap: () =>
                    setState(() {
                      gridState[rowCol[0]][rowCol[1]].color = Colors.yellow;
                    }),
                onLongPress: () =>
                    setState(() {
                      _visible = !_visible;

                    }),
                child: new Card(
                  margin: new EdgeInsets.all(1.0),
                  elevation: 0,
                  child: new AnimatedContainer(
                    curve: Curves.ease,
                    color: getNodeColor(index),
                    duration: Duration(milliseconds: 500),
                    child: Align(
                      child: Container(
                        alignment: Alignment.center,
                        child: new AnimatedOpacity(
                          opacity: _visible ? 1.0 : 0.0,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 350),
                          child: new Text ("✨",
                            style: TextStyle(
                                fontSize: 20.0
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Call setState. This tells Flutter to rebuild the
            // UI with the changes.
            setState(() {
              _visible = !_visible;
              clearGrid();
            });
          },
          tooltip: 'Toggle Opacity',
          child: Icon(Icons.flip),
        ),

      );
  }
}