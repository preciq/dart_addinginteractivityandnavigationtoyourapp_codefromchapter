import 'package:addinginteractivityandnavigationtoyourapp_codefromchapter/stopwatch.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = '';
  //tracks (stores) users name that they use to login

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  //these two controllers are used to handle text properties
  //we have two because...well there are 2 text fields

  final _formKey = GlobalKey<FormState>();
  //this handles the unified properties of the entire login form
  //text field pages are considered forms, like our login page
  //it also handles the unique state of the login form itself (i.e. if we type something into the login form, it changes, right? This tracks that.)
  //we also use this to access the state of the form later, like we will when we call _validate() (which checks that the form is correctly filled out without errors)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: _buildLoginForm(),
      ),
    );
  }

  Widget _buildSuccess() {
    //displayed if login was successful, just a simple greeting saying 'Hi' to the user
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check, color: Colors.orangeAccent),
        Text('Hi $name')
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
        //A Form widget. This allows us to add a page called a "Form", in which can exist text fields for a user to fill up
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Runner'),
                  validator: (text) =>
                      text!.isEmpty ? 'Enter the runner\'s name.' : null,
                  //also adds a placeholder text for when the text field is empty
                ),
                /*
                This adds a field, specifically the name input field on the form
                It has a controller, specified at the top of the class, _nameController
                This can control the text that is acceptable by this field
                 */

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Enter the runner\'s email.';
                    }
                    final regex = RegExp('[^@]+@[^.]+..+');
                    //we specify in a regex expression that the email must have this format
                    if (!regex.hasMatch(text)) {
                      //if the regex does not match, the following text is returned
                      return 'Enter a valid email';
                    }

                    return null;
                    //if the email does match successfully, nothing is returned and the application is allowed to proceed
                  },
                ),
                /*
                Similar to the above widget but this one is for an email and has some regex validation
                 */
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _validate,
                  child: const Text('Continue'),
                ),
                //a continue button for a user to click on to sign in!
              ],
            )));
  }

  void _validate() {
    final form = _formKey.currentState;
    if (!(form?.validate() ?? false)) {
      // Return early if the form is not valid.
      return;
    }

    final name = _nameController.text;
    final email = _emailController.text;
    Navigator.of(context).push(
      //we use this to navigate to a different page
      //pushReplacement ensures we cannot go back (would be kind of weird if we could hit the back button to go back to the login page from the stopwatch page, without explicitly logging out eh)
        //meaning it removes the back button
      MaterialPageRoute(
        builder: (_) => StopWatch(name: name, email: email),
        //we specify here that once validate is called and completes successfully, the app should navigate to the Stopwatch widget
          //which is being built (rendered) here for this purpose
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  //disposes the text field controllers once we are done with them (meaning once the login screen is removed from the widget tree permenantly (i.e. if we navigate away from it) or the application is closed)
}

/*
We now have a valid login form. Unfortunately, we cannot yet login and access the stopwatch page, but it's a start
 */