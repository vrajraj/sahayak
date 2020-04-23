import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'auth.dart';
import 'clipper.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken,
    );
    AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user= authResult.user;
    assert(! user.isAnonymous);
    assert (await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert (user.uid==currentUser.uid);
    return 'signInWithGoogle succeeded:$user';
  }
  void GoogleSignOut() async
  {
    await googleSignIn.signOut();
    print("user signout");
  }
//  Future<FirebaseUser> _handleSignIn() async {
//    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      idToken: gSA.idToken, accessToken: gSA.accessToken,
//    );
//    AuthResult authResult = await _auth.signInWithCredential(credential);
//    FirebaseUser user= authResult.user;
//    print("signed in" + user.displayName);
//    return user;
//  }



  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
     formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
          padded( child: new TextFormField(
            decoration: new InputDecoration(
                labelText: "Enter Email", fillColor: Colors.white),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
            onSaved: (value) => _email = value,
          ),),

          padded(child:new TextFormField(
            decoration: new InputDecoration(
              labelText: "Enter Password",
            ),
            obscureText: true,
            keyboardType: TextInputType.text,
            validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
            onSaved: (value) => _password = value,
          ),)
        ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
            new Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new MaterialButton(
                  child: new Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                  height: 50.0,
                  minWidth: 150.0,
                  color: Colors.indigoAccent,
                  splashColor: Colors.teal,
                  textColor: Colors.white,
                  onPressed: validateAndSubmit, //() {
                  //Navigator.push(context,new MaterialPageRoute(builder: (context) => new Home()),
                  //);

                  //},
                ),
                Padding(padding: EdgeInsets.only(left: 20.0)),
                new MaterialButton(
                    child: new Text("Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                    height: 50.0,
                    minWidth: 150.0,
                    color: Colors.indigoAccent,
                    splashColor: Colors.teal,
                    textColor: Colors.white,
                    onPressed: moveToRegister //() {
                  // Navigator.push(context,
                  //  new MaterialPageRoute(builder: (context) => new Home()),
                  //  );

                  //  },
                ),

              ],
            ),
          ];
      case FormType.register:
        return [
            Padding(  padding: const EdgeInsets.only(top: 40.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new MaterialButton(
                  child: new Text("Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                  height: 50.0,
                  minWidth: 100.0,
                  color: Colors.indigoAccent,
                  splashColor: Colors.teal,
                  textColor: Colors.white,
                  onPressed: validateAndSubmit, //() {
                  //Navigator.push(context,
                  //new MaterialPageRoute(builder: (context) => new Home()),
                  //);

                  //},
                ),
                Padding(padding: EdgeInsets.only(left: 15.0)),
                new MaterialButton(
                    child: new Text("Have an account? Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    height: 50.0,
                    minWidth: 150.0,
                    color: Colors.indigoAccent,
                    splashColor: Colors.teal,
                    textColor: Colors.white,
                    onPressed: moveToLogin //() {
                  // Navigator.push(context,
                  //  new MaterialPageRoute(builder: (context) => new Home()),
                  //  );

                  //  },
                ),

              ],
            ),
            
          ];
        }
    return null;
  }
    List<Widget> googleSignin(){
      return[
        Padding(padding: EdgeInsets.only(top: 15.0)),
        new Text("Forget Password ?",
          style: TextStyle(fontSize: 18.0, color: Colors.white),),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        new Text("Or",
          style: TextStyle(fontSize: 20.0, color: Colors.white),),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        SignInButton(Buttons.Google, text: "Sign up with Google",
            onPressed: () =>signInWithGoogle().whenComplete(()=>
                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      }),
                )).catchError((e) => print(e))
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        new Text("Follow On", style: TextStyle(
            color: Colors.white, fontSize: 18.0)),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.facebook,
              size: 25,
            ),
            Padding(padding: EdgeInsets.only(left: 20.0)),
            Icon(
              FontAwesomeIcons.instagram,
              size: 25,
            ),
            Padding(padding: EdgeInsets.only(left: 20.0)),
            Icon(
              FontAwesomeIcons.google,
              size: 25,
            ),
            Padding(padding: EdgeInsets.only(left: 20.0)),
            Icon(
              FontAwesomeIcons.linkedin,
              size: 25,
            ),
            Padding(padding: EdgeInsets.only(left: 20.0)),
            Icon(
              FontAwesomeIcons.whatsapp,
              size: 25,
            ),
            Padding(padding: EdgeInsets.only(left: 20.0)),
            Icon(
              FontAwesomeIcons.twitter,
              size: 25,
            ),
          ],
        ),

      ];
    }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Clipper(),
              new Container(
                padding: const EdgeInsets.all(20.0),
                child: new Form(
                  key: formKey,
                  autovalidate: true,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                    usernameAndPassword() + submitWidgets() + googleSignin(),
                  ),
                ),
              )
            ],
          ),
        ),


//        new Theme(
//          data: new ThemeData(
//              brightness: Brightness.dark,
//              inputDecorationTheme: new InputDecorationTheme(
//                // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
//                labelStyle:
//                new TextStyle(color: Colors.white, fontSize: 25.0),
//              )),
//          isMaterialAppTheme: true,
//          child: new ListView(
//            scrollDirection: Axis.vertical,
//            shrinkWrap: true,
//            children: <Widget>[
//              CircleAvatar(
//                child: Text("DocsFaces",
//                  style: TextStyle(color: Colors.white, fontSize: 25.0),),
//                backgroundColor: Colors.indigoAccent,
//                radius: 70.0,
//
//              ),
//
//            ],
//          ),
//        ),
      ]),
    );
  }
}

Widget padded({Widget child}){
  return new Padding(padding: EdgeInsets.symmetric(vertical: 8.0),
  child: child,
  );
}
