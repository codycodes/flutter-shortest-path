//import 'dart:math';
//import 'dart:collection';

//import 'package:after_layout/after_layout.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttershortestpath/Home.dart';
import 'package:fluttershortestpath/Node.dart';

class GridOne extends StatefulWidget {
  @override
  _GridOneState createState() => new _GridOneState();
}
//class _GridOneState extends State<GridOne> with AfterLayoutMixin<GridOne>{
class _GridOneState extends State<GridOne> {
  // accessible to class
  // defer to largest JS value (2^53-1) since dart and JS differ
  final int int64MaxValue = 9007199254740991;
  List<List<Node>> gridState = [];
  bool _visible = false;
  bool _loaded = false;
  int startRow;
  int startCol;
  int endRow;
  int endCol;
  int numCellsWidth;
  int numCells;
  int numRows;
  double scale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      var size = MediaQuery.of(context).size;
      final double itemWidth = size.width;
      numCellsWidth = (size.width ~/ 40);
      double scale = itemWidth / numCellsWidth;
      double num = 0;
      numRows = 0;
      int topPadding = 128;
      while(num < (size.height - topPadding)) {
        num += scale;
        numRows += 1;
      }

      numCells = (numCellsWidth * numRows).toInt();
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
            curRow.add(Node(Colors.red, int64MaxValue ,row, col, false, false, false, false, null));
          } else if (row == endRow && col == endCol) {
            curRow.add(Node(Colors.blue, int64MaxValue ,row, col, false, false, false, false, null));
          } else {
            curRow.add(Node(Colors.green, int64MaxValue ,row, col, false, false, false, false, null));
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

        numCellsWidth = (size.width ~/ 40);
        var gl = gridState.asMap().containsKey(0);
        if (gl && numCellsWidth > gridState[0].length) {
          numCellsWidth = gridState[0].length;
        }
      final double itemWidth = size.width;
//        TODO: adapt the screen size properly!
//    rebuild the widget with a new widget when screen size changes! https://bit.ly/2TGK605
    if (_loaded && scale != itemWidth / numCellsWidth) {
      return AlertDialog(
        title: Text(
          "Please refresh page or return to previous orientation/window size",
          style: TextStyle(color: Colors.white),
          ),
        content: Text(
          "The screen size has changed and you must refresh the page with this size or make the window its previous size to continue using the application normally.",
          style: TextStyle(color: Colors.white),
          ),
        elevation: 24.0,
        backgroundColor: uwPurple,
//        shape: CircleBorder(),
      );
    } else {
      scale = itemWidth / numCellsWidth;
    }


      double num = 0;
      int numRows = 0;
      int topPadding = 128;
      while (num < (size.height - topPadding)) {
        num += scale;
        numRows += 1;
      }
      if (gl && numRows > gridState.length) {
        numRows = gridState.length;
      }
      numCells = (numCellsWidth * numRows).toInt();

      // and then modulus gets the col
      List<int> convertIndexRowCol(idx) {
        int row = (idx / numCellsWidth).floor();
        int col = (idx % numCellsWidth);
        return [row, col];
      }

      Color getNodeColor(number) {
        // TODO: this could be a map of the number to the rowcol
        List<int> rowCol = convertIndexRowCol(number);
//        if (rowCol[0] >= gridState.length || rowCol[1] >= gridState[0].length){
//          rowCol[0] = gridState.length-1;
//          rowCol[1] = gridState[0].length-1;
//          print("reset");
//        }
        if (gridState.length == 0) {
          return Colors.green;
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

      dijkstra() {
        print("GO");
      }

      _loaded = true;

      return new Scaffold(
        body: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            crossAxisCount: numCellsWidth,
            children: List.generate(numCells, (index) {
              List<int> rowCol = convertIndexRowCol(index);
              return new GestureDetector(
                onTap: () =>
                    setState(() {
                      if (gridState[rowCol[0]][rowCol[1]].isWall) {
                        gridState[rowCol[0]][rowCol[1]].color = Colors.green;
                      } else if (rowCol[1] == startCol && rowCol[0] == startRow ) {
                      } else if (rowCol[0] == endRow && rowCol[1] == endCol) {
                      } else {
                        gridState[rowCol[0]][rowCol[1]].color = Colors.yellow;
                        gridState[rowCol[0]][rowCol[1]].isWall = true;
                      }
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
                          duration: Duration(milliseconds: 1000),
                          child: new Text (
                            index % 2 == 0 ? "🧹" : "✨",
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  // Call setState. This tells Flutter to rebuild the
                  // UI with the changes.
                  setState(() {
                    _visible = !_visible;
                  });
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    setState(() {
                      _visible = !_visible;
                      clearGrid();
                    });
                  });
                },
                tooltip: 'Clear Walls',
                backgroundColor: uwPurple,
                child: Icon(Icons.flip),
              ),
              FloatingActionButton(
                onPressed: () {
                  // Call setState. This tells Flutter to rebuild the
                  // UI with the changes.
                  dijkstra();
//                  setState(() {
//                    _visible = !_visible;
//                  });
                },
                tooltip: 'Go!',
                backgroundColor: uwPurple,
                child: Icon(Icons.directions),
              ),
            ]
          )
        )
      );
  }
}