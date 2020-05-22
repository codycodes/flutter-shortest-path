import 'package:flutter/material.dart';

class GridOne extends StatefulWidget {
  @override
  _GridOneState createState() => new _GridOneState();
}

class _GridOneState extends State<GridOne> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GridView.count(
        crossAxisCount: 40,
        children: List.generate(120, (index) {
          return new Card(
            elevation: 10.0,
            child: new Container(
              child: Align(
                alignment: Alignment.center,
                child: new Text ("$index",
                style: TextStyle(
                  fontSize: 24.0
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