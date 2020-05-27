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
  bool _loading = true;
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
      setState(() {
        _loading = false;
      });
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
        if (_loading || gridState.length == 0) {
//          TODO: there has to be a better way!
          Future.delayed(const Duration(milliseconds: 500), () {
            return gridState
                ?.elementAt(rowCol[0])
                ?.elementAt(rowCol[1])
                ?.color ?? Colors.green;
          });
          return Colors.green;
        }
//        if (gridState.length == 0)  {
//          return Colors.green;
         else {
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

      sortNodesByDistance(unvisitedNodes) {
        Comparator<Node> nodeComparator = (a ,b) => (a.cost.compareTo(b.cost)).toInt();
        unvisitedNodes.sort(nodeComparator);
      }

      getAllNodes() {
        List<Node> nodes = [];
        for (int row = 0; row < gridState.length; row++) {
          for (int col = 0; col < gridState[0].length; col++) {
            nodes.add(gridState[row][col]);
          }
        }
        return nodes;
      }

      List<Node> getUnvisitedNeighbors(Node node) {
        List<Node> neighbors = [];
        int col = node.col;
        int row = node.row;
        if (row > 0) {
          neighbors.add(gridState[row - 1][col]);
//          print("Add upper");
        }
        if (row < gridState.length - 1) {
          neighbors.add(gridState[row + 1][col]);
//          print("Add lower");
        }
        if (col > 0) {
          neighbors.add(gridState[row][col - 1]);
//          print("Add left");
        }
        if (col < gridState[0].length - 1) {
          neighbors.add(gridState[row][col + 1]);
//          print("Add right");
        }
//        print("NEIGHBOR CHECK");
//        for(int i = 0; i < neighbors.length; i++){
//          print(neighbors[i].row);
//          print(neighbors[i].col);
//          print(neighbors[i].cost);
//          print(neighbors[i].isVisited);
//          print(neighbors[i].color);
//          print("-----***");
//        }
        return neighbors.where((f) => !f.isVisited).toList();
        }

      List<Object> shift(List<Object> list, int v) {
          if(list == null || list.isEmpty) {
            return list;
          }
          var i = v % list.length;
          return list.sublist(i)..addAll(list.sublist(0, i));
      }

      updateUnvisitedNeighbors(node) {
        List<Node> unvisitedNeighbors = getUnvisitedNeighbors(node);
//        print("UNVISITED");
        for (int i = 0; i < unvisitedNeighbors.length; i++) {
//          print("**NODE**");
//          print(unvisitedNeighbors[i].row);
//          print(unvisitedNeighbors[i].col);
          unvisitedNeighbors[i].cost = node.cost + 1;
//          print(unvisitedNeighbors[i].cost);
//          print(unvisitedNeighbors[i].color);
          unvisitedNeighbors[i].prevNode = node;
//          print("-----");
        }
      }

      dijkstra() {
//        if (gridState[startRow][startCol] != null || gridState[endRow][endCol] != null) {
////          TODO: determine the equality of the start/end node
//          return false;
//        }
        print("********GO");
        List<Node> visitedNodesInOrder = [];
        Node closestNode;
        List<Node> unvisitedNodes = getAllNodes();

        gridState[startRow][startCol].cost = 0;
        while (unvisitedNodes.length > 0) {
//          for (int i = 0; i < 700; i++) {
//            print("I: $i");
            sortNodesByDistance(unvisitedNodes);
//            print("OOOOooh: ");
//            for (int j= 0; j < 10; j++) {
//              print(unvisitedNodes[j].cost);
//            }
//            print("CLOSEST UNVISIT BEFORE SET: ");
//            print(unvisitedNodes[0].row);
//            print(unvisitedNodes[0].col);
//            print(unvisitedNodes[0].cost);
            if (unvisitedNodes != null && unvisitedNodes.isNotEmpty){
               closestNode = unvisitedNodes.removeAt(0);
//               print("CLOSEST NODE SET");
            }
//            print("CLOSEST UNVISIT: ");
//            print(unvisitedNodes[0].row);
//            print(unvisitedNodes[0].col);
//            print(unvisitedNodes[0].cost);
//            print("CLOSEST: ");
//            print(closestNode.row);
//            print(closestNode.col);
//            print(closestNode.cost);
//            unvisitedNodes = shift(unvisitedNodes, 1);
//            print("CLOSEST UNVISIT AFTER SHIFT: ");
//            print(unvisitedNodes[0].row);
//            print(unvisitedNodes[0].col);
//            print(unvisitedNodes[0].cost);

//            print("*****");
  //          TODO: handle wall
  //            if (closestNode.isWall) {
  //            }
            if (closestNode.cost == int64MaxValue) {
              return visitedNodesInOrder;
            }
//            print("******");
            if (closestNode.row == endRow && closestNode.col == endCol) {
              print("WE MADE IT!");
              return visitedNodesInOrder;
            }
//            print("UPDATING NEW NODES");
            updateUnvisitedNeighbors(closestNode);
            // Set this at the end
            setState(() {
              closestNode.color = Colors.black;
              closestNode.isVisited = true;
            });
            visitedNodesInOrder.add(closestNode);
//            print("NODES VISITED SO FAR");
//            for (int i = 0; i < visitedNodesInOrder.length; i++){
//              print(visitedNodesInOrder[i].row);
//              print(visitedNodesInOrder[i].col);
//              print("----");
//            }
//            print("CLOSEST UNVISIT AFTER SHIFT END: ");
//            print(unvisitedNodes[0].row);
//            print(unvisitedNodes[0].col);
//            print(unvisitedNodes[0].cost);
//            closestNode = null;
          }
//          for (int i = 0; i < 3; i++) {
//            print(unvisitedNodes[i].cost);
//          }
  //        }
//        print(gridState[startRow][startCol].cost);


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