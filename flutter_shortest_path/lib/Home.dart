import 'package:flutter/material.dart';
import 'GridOne.dart' as GridOne;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

Map<int, Color> purpleTints =
{
  50:Color.fromRGBO(51,0,111, .1),
  100:Color.fromRGBO(51,0,111, .2),
  200:Color.fromRGBO(51,0,111, .3),
  300:Color.fromRGBO(51,0,111, .4),
  400:Color.fromRGBO(51,0,111, .5),
  500:Color.fromRGBO(51,0,111, .6),
  600:Color.fromRGBO(51,0,111, .7),
  700:Color.fromRGBO(51,0,111, .8),
  800:Color.fromRGBO(51,0,111, .9),
  900:Color.fromRGBO(51,0,111, 1),
};
MaterialColor uwPurple = MaterialColor(0xFF4B2E83, purpleTints);

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new AppBar(
        title: new Text("Grid View"),
        backgroundColor: uwPurple,
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.face),),
            new Tab(icon: new Icon(Icons.image),),
          ],
        ),
      ),

      body: new TabBarView(
        controller: controller,
        children: <Widget> [
          new GridOne.GridOne(),
          new GridOne.GridOne()
        ],
      ),

    );
  }
}