import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyingwolf/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Variable used to store Username and Password
  String? userName, password;

  //Variable used to store Error Message if auth fails
  String? errorMessage;

  //Variable used to show and hide error text on UI
  bool _showErrorText = false;

  //Key used to verify validators
  GlobalKey<FormState> _key1 = GlobalKey();

//Styling used for Login Button
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(
    fontSize: 20,
  ));

//Build Widget for Login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flyingwolf',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                logoImage(),
                SizedBox(
                  height: 20.0,
                ),
                form(),
                SizedBox(
                  height: 10.0,
                ),
                showErrorText(),
                SizedBox(
                  height: 40.0,
                ),
                signInButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Form Widget containing infos for username and password
  Widget form() {
    return Container(
      child: Form(
        key: _key1,
        child: Column(
          children: [
            userNameTextFormField(),
            SizedBox(
              height: 30.0,
            ),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

//LogoImage
  Widget logoImage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Container(
          width: double.infinity,
          child: Image(
            image: AssetImage("assets/logo.jpg"),
          ),
        ),
      ),
    );
  }

//usernameUI
  Widget userNameTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Material(
        borderRadius: BorderRadius.circular(2.0),
        elevation: 1.0,
        child: TextFormField(
          inputFormatters: [new LengthLimitingTextInputFormatter(10)],
          keyboardType: TextInputType.phone,
          cursorColor: Colors.blue,
          validator: (input) => input!.isEmpty
              ? 'Enter Username'
              : (input.length < 3 && input.isNotEmpty)
                  ? 'Username too short'
                  : (input.length < 10 && input.isNotEmpty)
                      ? 'Invalid Username'
                      : null,
          // if (input == null || input.length < ) {
          //   return 'Enter Phone';
          // }

          decoration: InputDecoration(
            //errorStyle: TextAlignVertical.center,
            prefixIcon: Icon(Icons.phone, color: Colors.blue, size: 20),
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          onSaved: (input) => userName = input,
        ),
      ),
    );
  }

//passwordUI
  Widget passwordTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Material(
        borderRadius: BorderRadius.circular(2.0),
        elevation: 1.0,
        child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            cursorColor: Colors.blue,
            validator: (input) {
              if (input!.isEmpty) {
                return 'Enter Password';
              }
            },
            decoration: InputDecoration(
              //errorStyle: TextAlignVertical.center,
              prefixIcon: Icon(Icons.lock, color: Colors.blue, size: 20),
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            onSaved: (input) => password = input),
      ),
    );
  }

//Signin Buttonui
  Widget signInButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: 150.0,
        child: ElevatedButton(
          style: style,
          onPressed: () {
            _sendToHomePage();
          },
          child: const Text('Login'),
        ),
      ),
    );
  }

//Errortext UI
  Widget showErrorText() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(left: 12.0, top: 12),
          child: _showErrorText
              ? Text(
                  errorMessage.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20),
                )
              : Text("")),
    );
  }

//Navigation to home and key saving
  _sendToHomePage() async {
    if (_key1.currentState!.validate()) {
      _key1.currentState!.save();

      List userDetails = [];
      userDetails.add(userName.toString());
      userDetails.add(password.toString());

      errorMessage = signInAuth(userDetails);
      if (errorMessage == "Invalid Username and password") {
        setState(() {
          _showErrorText = true;
        });
      } else if (errorMessage == "successful") {
        final SharedPreferences sharedPreference =
            await SharedPreferences.getInstance();
        sharedPreference.setString(
          'username',
          userName.toString(),
        );
        setState(() {
          _showErrorText = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      print(errorMessage);
    }

    //print(message);
  }

//Hardcoded login account details
  signInAuth(List userInput) {
    var user1 = ['9898989898', 'password123'];
    var user2 = ['9876543210', 'password123'];
    if (userInput[0] == user1[0] && userInput[1] == user1[1]) {
      return "successful";
    } else if (userInput[0] == user2[0] && userInput[1] == user2[1]) {
      return "successful";
    } else {
      return 'Invalid Username and password';
    }
  }
}
