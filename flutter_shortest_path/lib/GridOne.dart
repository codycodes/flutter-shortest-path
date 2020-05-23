import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GridOne extends StatefulWidget {
  @override
  _GridOneState createState() => new _GridOneState();
}

class _GridOneState extends State<GridOne> {
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


    List<List<String>> gridState = [ List.filled(numCellsHeight, '0') ];

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
      int minusOne = 0;
      if (heights % 2 == 1) {
        minusOne++;
      }
      if (rowCol[0] == ((heights/2)- minusOne).floor()
      && rowCol[1] == (numCellsWidth/4)) {
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