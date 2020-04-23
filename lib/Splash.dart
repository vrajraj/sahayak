import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flare_dart/actor.dart';

import 'auth.dart';
import 'root_page.dart';
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds:6), () =>  Navigator.pushReplacement(context,
      new MaterialPageRoute(builder: (context) =>  new RootPage(auth: new Auth())),
    )
    );
  }
  Widget build(BuildContext context) {
    return Container(
      child: FlareActor('assets/dy.flr',fit: BoxFit.fill,animation:'Untitled')
    );
  }
}

