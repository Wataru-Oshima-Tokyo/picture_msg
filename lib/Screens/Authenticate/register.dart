import 'package:flutter/material.dart';
import 'package:picture_msg/Services/auth.dart';
import 'package:picture_msg/shared/constants.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  const Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();//so we can use the sign in class
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';
  String fullName = '';
  String age = '';
  String gender ='';
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0.0,
        title: Center(
          child: const Text("PictureMSG",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(//where the sign in page is
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget> [
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 20.0),//Name stuff
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Full Name'),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (String?val){//making sure the email form is filled
                        if(val != null && val.isEmpty){
                          return "Name can't be empty";
                        }
                        return null;
                      },

                      onChanged: (val){setState(() => fullName = val.trim());}
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Phone number'),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (String?val){//making sure the email form is filled
                        if(val != null && val.isEmpty){
                          return "User name can't be empty";
                        }
                        return null;
                      },
                      onChanged: (val){setState(() => phoneNumber = val.trim());}
                  ),
                  const SizedBox(height: 20.0),//Email stuff
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
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
                      keyboardType: TextInputType.visiblePassword,
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
                  const SizedBox(height: 20.0),//Email stuff
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  // ),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Age'),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (String?val){//making sure the email form is filled
                        if(val != null && val.isEmpty){
                          return "Age can't be empty";
                        }
                        return null;
                      },
                      onChanged: (val){setState(() => age = val.trim());}
                  ),
                  const SizedBox(height: 20.0),//Password stuff
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Gender'),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      validator: (String?val){//making sure the password form is filled
                        if(val != null && val.isEmpty){
                          return "Gender can't be empty";
                        }
                        return null;
                      },
                      onChanged: (val){setState(() => gender = val.trim());}
                  ),
                  const SizedBox(height: 20.0),//sign in button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          color: Colors.red,
                          child: const Text(
                            'Back',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => widget.toggleView()
                      ),
                      SizedBox(width: 16),
                      RaisedButton(
                          color: Colors.red,
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async{
                            if(_formKey.currentState!.validate()){
                              //loading screen
                              setState(() => loading = true);
                              dynamic result = await _auth.registerWithEmailAndPassword(email.trim(), password.trim(), fullName.trim(), age.trim(), gender.trim(),phoneNumber.trim());
                              if(result == null){
                                setState(() {
                                  error = 'Please supply a valid email';
                                  loading = false;
                                });
                              }
                            }
                          }
                      ),
                    ],

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
      ),
    );
  }
}