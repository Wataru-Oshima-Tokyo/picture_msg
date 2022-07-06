import 'package:flutter/material.dart';
import 'package:picture_msg/Services/auth.dart';
import 'package:picture_msg/shared/constants.dart';
import 'package:picture_msg/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();//so we can use the sign in class
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {//makes the sign in screen
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0.0,
        title: const Text('Sign In to Picture_msg'),
        actions: <Widget>[//button that switches between sign in and register
          FlatButton.icon(
            key: const Key("register"),
            icon: const Icon(Icons.person),
            label: const Text('Register'),
            onPressed: () => widget.toggleView(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(//where the sign in page is
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget> [
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20.0),//Email stuff
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    textInputAction: TextInputAction.next,
                    validator: (String?val){//making sure the email form is filled
                      if(val != null && val.isEmpty){
                        return "Email can't be empty";
                      }
                      return null;
                    },
                    onChanged: (val){setState(() => email = val.trim());}
                ),
                const SizedBox(height: 20.0),//Password stuff
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    validator: (String?val){//making sure the password form is filled
                      if(val != null && val.length < 6){
                        return "Enter a password with more than 6 char";
                      }
                      return null;
                    },
                    onChanged: (val){setState(() => password = val.trim());}
                ),
                const SizedBox(height: 20.0),//sign in button
                RaisedButton(
                    color: Colors.red,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        //loading screen
                        setState(() => loading = true);
                        dynamic result = await _auth.signInWithEmailAndPassword(email.trim(), password.trim());
                        //print(result);
                        if(result == null){
                          setState(() {
                            error = 'Could not sign in';
                            loading = false;
                            //print(result);
                          });
                        }
                      }
                    }
                ),
                const SizedBox(height: 15.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}