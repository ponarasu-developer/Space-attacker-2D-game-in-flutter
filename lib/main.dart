// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:space_attack/astroid_modal.dart';
import 'package:space_attack/collisiondata.dart';
import 'package:space_attack/collisiondata.dart';

void main(List<String> args) {
  runApp(MyAppp());
}

class MyAppp extends StatelessWidget {
  const MyAppp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Space_Game(),
    );
  }
}

class Space_Game extends StatefulWidget {
  const Space_Game({super.key});

  @override
  State<Space_Game> createState() => _Space_GameState();
}

class _Space_GameState extends State<Space_Game> {
  GlobalKey shipglobalkey = GlobalKey();

  double shipx = 0.0;

  double shipy = 0.0;
  double maxhight = 0.0;
  double initialposition = 0.0;
  double time = 0.0;
  double velocity = 2.9;
  double gravity = -4.9;
  bool isgamerunning = false;
  int score = 0;
// ignore: non_constant_identifier_names
  List<GlobalObjectKey> globalKeydata = [];
  List<AstroidData> astroidData = [];

  List<AstroidData> setAsteroidData() {
    List<AstroidData> data = [
      AstroidData(alignment: Alignment(3.9, 0.7), size: Size(40, 60)),
      AstroidData(alignment: Alignment(1.8, -0.5), size: Size(80, 100)),
      AstroidData(alignment: Alignment(3, -0.2), size: Size(40, 50)),
      // AstroidData(alignment: Alignment(2.2, 0.2), size: Size(60, 30))
    ];

    return data;
  }

  void Startgame() {
    resetdata();
    isgamerunning = true;

    Timer.periodic(Duration(milliseconds: 30), (timer) {
      time = time + 0.02;
      setState(() {
        maxhight = velocity * time + gravity * time * time;
        shipy = initialposition - maxhight;

        if (isShipcolled()) {
          timer.cancel();
          isgamerunning = false;
        }
      });

      moveAstroid();
    });
  }

  void onjump() {
    setState(() {
      time = 0;
      initialposition = shipy;
    });
  }

  double generate() {
    Random rand = Random();
    double randomdouble = rand.nextDouble() * (-1.0 - 1.0) + 1.0;

    return randomdouble;
  }

  void initialGLobalkey() {
    for (var i = 0; i < 3; i++) {
      globalKeydata.add(GlobalObjectKey(i));
    }
  }

// astroid moving function
  void moveAstroid() {
    Alignment astroid1 = astroidData[0].alignment;
    Alignment astroid2 = astroidData[1].alignment;
    Alignment astroid3 = astroidData[2].alignment;

    if (astroid1.x > -1.4) {
      astroidData[0].alignment = Alignment(astroid1.x - 0.06, astroid1.y);
    } else {
      astroidData[0].alignment = Alignment(2, generate());
    }

    if (astroid2.x > -1.4) {
      astroidData[1].alignment = Alignment(astroid2.x - 0.06, astroid2.y);
    } else {
      astroidData[1].alignment = Alignment(1.6, generate());
    }

    if (astroid3.x > -1.4) {
      astroidData[2].alignment = Alignment(astroid3.x - 0.06, astroid3.y);
    } else {
      astroidData[2].alignment = Alignment(2.9, generate());
    }

    if (astroid1.x <= 0.021 && astroid1.x >= 0.001) {
      score++;
    }
    if (astroid2.x <= 0.021 && astroid2.x >= 0.001) {
      score++;
    }
    if (astroid3.x <= 0.021 && astroid3.x >= 0.001) {
      score++;
    }
  }

  bool isShipcolled() {
    if (shipy > 1.5) {
      return true;
    } else if (shipy < -1.1) {
      return true;
    } else if (checkcollision()) {
      return true;
    } else {
      return false;
    }
  }

  void resetdata() {
    setState(() {
      astroidData = setAsteroidData();
      shipx = 0.0;
      shipy = 0.0;
      maxhight = 0.0;
     
      time = 0.0;
      velocity = 2.9;
      initialposition = 0.0;
      gravity = -4.9;
      isgamerunning = false;
    });
  }

  bool checkcollision() {
    bool iscollied = false;

    RenderBox shiprenderbox =
        shipglobalkey.currentContext!.findRenderObject() as RenderBox;
//collision data
    List<collisiondatas> collisiondata = [];

    for (var element in globalKeydata) {
      RenderBox renderBox =
          element.currentContext!.findRenderObject() as RenderBox;

      collisiondata.add(collisiondatas(
          sizeofobject: renderBox.size,
          positionofBox: renderBox.localToGlobal(Offset.zero)));
    }

    for (var element in collisiondata) {
      final shipposition = shiprenderbox.localToGlobal(Offset.zero);
      final astroidposition = element.positionofBox;

      final astroidsize = element.sizeofobject;
      final shipsize = shiprenderbox.size;

      bool hello = (shipposition.dx < astroidposition.dx + astroidsize.width &&
          shipposition.dx + shipsize.width > astroidposition.dx &&
          shipposition.dy < astroidposition.dy + astroidsize.width &&
          shipposition.dy + shipsize.height > astroidposition.dy);

      if (hello) {
        iscollied = true;
        break;
      } else {
        iscollied = false;
      }
    }

    return iscollied;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    astroidData = setAsteroidData();
    initialGLobalkey();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: isgamerunning ? onjump : Startgame,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage("assets/bg2.jpg"))),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(shipx, shipy),
                  child: Container(
                    key: shipglobalkey,
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/ship.png"))),
                  ),
                ),
                Align(
                  alignment: astroidData[0].alignment,
                  child: Container(
                    key: globalKeydata[0],
                    height: astroidData[0].size.height,
                    width: astroidData[0].size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(astroidData[0].path))),
                  ),
                ),
                Align(
                  alignment: astroidData[1].alignment,
                  child: Container(
                    key: globalKeydata[1],
                    height: astroidData[1].size.height,
                    width: astroidData[1].size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(astroidData[0].path))),
                  ),
                ),
                Align(
                  alignment: astroidData[2].alignment,
                  child: Container(
                    key: globalKeydata[2],
                    height: astroidData[2].size.height,
                    width: astroidData[2].size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(astroidData[0].path))),
                  ),
                ),
                isgamerunning
                    ? SizedBox()
                    : const Align(
                        alignment: Alignment(0, -0.3),
                        child: Text(
                          "TAP TO PLAY",
                          style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 4,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                Align(
                  alignment: Alignment(0, 0.95),
                  child: Text(
                    "Score : $score",
                    style: TextStyle(
                        fontSize: 55,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
