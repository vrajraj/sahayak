import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _HomePageState createState() => _HomePageState(auth:auth,onSignOut:onSignOut);
}

class _HomePageState extends State<HomePage> {

  final BaseAuth auth;
  final VoidCallback onSignOut;

  _HomePageState({this.auth, this.onSignOut});



  @override
  Widget build(BuildContext context) {
    void _signOut() async {try {
      await auth.signOut();
      onSignOut();}
    catch (e) {print(e);}
    }

    //main part
    final GoogleSignIn googleSignIn = new GoogleSignIn();

    void GoogleSignOut() async
    {
      await googleSignIn.signOut();
      print("user signout");
    }


    return Scaffold(
        backgroundColor: Colors.indigoAccent,
        appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text("DocsFaces"),
    ),
    endDrawer:
    new Drawer(
    child:
    new ListView(
    children: <Widget>[
    new ListTile(
    title: Text("friends", style: new TextStyle(fontSize: 16,color: Colors.black ),),
    trailing: new Icon(Icons.accessibility_new),
    onTap: ()=> Navigator.pushReplacement(context,new  MaterialPageRoute(builder: (context) => new HomePage()),),
    ),
    Divider(
    color: Colors.lightBlue,
    height:50.0,
    ),
    new ListTile(
    title: Text("Blogs", style: new TextStyle(fontSize: 16,color: Colors.black ),),
    trailing: new Icon(Icons.assignment),
    onTap: ()=> Navigator.pushReplacement(context,new  MaterialPageRoute(builder: (context) => new HomePage())),
    ),
    Divider(color: Colors.lightBlue,
    height:50.0,),
    InkWell(onTap:_signOut,child:ListTile(
      title: Text("Logout", style: new TextStyle(fontSize: 16,color: Colors.black ),),
      trailing: new Icon(Icons.call_made),
    ),
    ),
      Divider(color: Colors.lightBlue,
        height:50.0,),
      InkWell(onTap:GoogleSignOut,child:ListTile(
        title: Text("Google Logout", style: new TextStyle(fontSize: 16,color: Colors.black ),),
        trailing: new Icon(Icons.call_made),
      ),
      ),
    ],
    ),
    ),
    body:(
    Container(
      child: Column(
        children: <Widget>[
          Text('need a help',style: TextStyle(color: Colors.white),),
          Padding(padding: EdgeInsets.all(10.0)),
          RaisedButton(
               child: Text('Find',style: TextStyle(color: Colors.white),),
              color: Colors.purple,
              elevation: 10.0,
              onPressed:() {})
        ],
      ),
    )
    ),




    );
  }
}






