import 'package:flutter/material.dart';
import 'package:group_lunch_app/pages/notifiers/auth_notifier.dart';
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
      create: (_) => AuthNotifier(widget.initialMode ?? AuthMode.loginMode),
      builder: (context, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    AuthNotifier model = Provider.of<AuthNotifier>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            child: Center(child: Text('LOGO')),
            color: Colors.blue,
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
            onPressed: () {
              switch (model.authMode) {
                case AuthMode.signUpMode:
                  model.signUp(
                      password: passwordController.text,
                      phoneNumber: phoneController.text);
                  break;
                case AuthMode.loginMode:
                  model.login(
                      password: passwordController.text,
                      phoneNumber: phoneController.text);
                  break;
                case AuthMode.verificationMode:
                  model.verifyCode(verifyCodeController.text);
                  break;
              }
            },
          ),
          InkWell(
            onTap: () {
              model.setAuthMode(_getAuthSwitch(model.authMode));
            },
            child: Text(
                'GO TO ${_getAuthSwitch(model.authMode).toUppercaseString()}'),
          ),
          /// For testing verification animation
          InkWell(
            onTap: () {
              model.setAuthMode(AuthMode.verificationMode);
            },
            child: Text(
                'GO TO VERIFICATION'),
          ),
        ],
      ),
    );
  }

  AuthMode _getAuthSwitch(AuthMode authMode) {
    switch (authMode) {
      case AuthMode.signUpMode:
        return AuthMode.loginMode;
      case AuthMode.loginMode:
        return AuthMode.signUpMode;
      case AuthMode.verificationMode:
        return AuthMode.loginMode;
    }
  }
}
