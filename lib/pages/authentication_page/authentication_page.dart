import 'package:flutter/material.dart';
import 'package:group_lunch_app/pages/authentication_page/auth_notifier.dart';
import 'package:group_lunch_app/shared/utils.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({this.initialMode, Key? key}) : super(key: key);
  final AuthMode? initialMode;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyCodeController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthNotifier(widget.initialMode ?? AuthMode.welcomeMode),
      builder: (context, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    AuthNotifier model = Provider.of<AuthNotifier>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TappableTwistInAnimation(
            child: Container(
              width: 100,
              height: 100,
              child: Center(child: Text('LOGO')),
              color: Colors.blue,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("Group Lunch App")),
          AuthenticationForm(
            formKey: _formKey,
            phoneController: phoneController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            verifyCodeController: verifyCodeController,
          ),
          MaterialButton(
            child: model.busy
                ? CircularProgressIndicator()
                : Text(model.authMode.toUppercaseString()),
            color: Colors.amber,
            onPressed: model.busy ? () => print('model busy = ${model.busy}') : () => _onButtonPressed(model),
          ),
          InkWell(
            onTap: () {
              _formKey.currentState?.reset();
              model.setAuthMode(_getAuthSwitch(model.authMode));
            },
            child: Text(
                'GO TO ${_getAuthSwitch(model.authMode).toUppercaseString()}'),
          ),
        ],
      ),
    );
  }

  void _onButtonPressed(AuthNotifier model) async {
    if (model.authMode == AuthMode.welcomeMode || _formKey.currentState != null && _formKey.currentState!.validate()) {
      bool shouldShowDialog = false;
      String titleText = '';
      String messageText = '';
      switch (model.authMode) {
        case AuthMode.signUpMode:
          var result = await model.signUp(
              password: passwordController.text,
              phoneNumber: phoneController.text);
          print('signUp: result = $result');
          if (!(result is bool)) {
            shouldShowDialog = true;
            titleText = 'Sign Up';
            messageText = result;
          }
          break;
        case AuthMode.loginMode:
          shouldShowDialog = !(await model.login(
              password: passwordController.text,
              phoneNumber: phoneController.text));
          if (shouldShowDialog) {
            titleText = 'Login';
            messageText = 'Invalid Credentials';
          }
          break;
        case AuthMode.verificationMode:
          var result = await model.verifyCode(verifyCodeController.text);
          if (result is String) {
            shouldShowDialog = true;
            titleText = 'Verification';
            messageText = result;
          }
          break;
        case AuthMode.welcomeMode:
          print('welcome button pressed');
          model.setAuthMode(AuthMode.loginMode);
          break;
      }
      if (shouldShowDialog) await showInfoDialog(context, titleText, messageText);
    }
  }

  AuthMode _getAuthSwitch(AuthMode authMode) {
    switch (authMode) {
      case AuthMode.signUpMode:
        return AuthMode.verificationMode;
      case AuthMode.loginMode:
        return AuthMode.signUpMode;
      case AuthMode.verificationMode:
        return AuthMode.welcomeMode;
      case AuthMode.welcomeMode:
        return AuthMode.loginMode;
    }
  }
}
