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
    int numCellsWidth = (size.width ~/ 30);


    double scale = itemWidth / numCellsWidth;
    double num = 0;
    int heights = 0;
    int topPadding = 128;
    while(num < (size.height - topPadding)) {
      num += scale;
      heights += 1;
    }
    int numCellsHeight = (numCellsWidth * heights).toInt();

//    for i in
//    double height = (MediaQuery.of(context).size.height);
//    double width = (MediaQuery.of(context).size.width);
//    height = height/10;
//    width = width/10;
    return new Scaffold(
      body: GridView.count(
        crossAxisCount: numCellsWidth,
        scrollDirection: Axis.vertical,
        children: List.generate(numCellsHeight, (index) {
          return new Card(
            margin: new EdgeInsets.all(1.0),
            elevation: 0,
            color: Colors.green,
            child: new Container(
              child: Align(
                alignment: Alignment.center,
                child: new Text ("$heights",
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