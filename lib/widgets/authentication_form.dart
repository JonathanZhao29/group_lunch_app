part of 'widgets.dart';

class AuthenticationForm extends StatelessWidget {
  AuthenticationForm(
      {required this.formKey,
      required this.phoneController,
      required this.passwordController,
      required this.verifyCodeController,
      required this.confirmPasswordController,
      Key? key})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController verifyCodeController;

  @override
  Widget build(BuildContext context) {
    AuthNotifier model = Provider.of<AuthNotifier>(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          AnimatedTextField(
            textController: phoneController,
            show: model.authMode != AuthMode.verificationMode,
            keyboardType: TextInputType.phone,
            hintText: 'Phone Number',
            fromRight: false,
          ),
          AnimatedTextField(
            textController: passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            show: model.authMode != AuthMode.verificationMode,
            hintText: 'Password',
          ),
          AnimatedTextField(
              textController: confirmPasswordController,
              show: model.authMode == AuthMode.signUpMode,
              hintText: 'Confirm Password'),
          AnimatedTextField(
            textController: verifyCodeController,
            keyboardType: TextInputType.number,
            show: model.authMode == AuthMode.verificationMode,
            hintText: 'Verification Code',
            fromRight: false,
          ),
        ],
      ),
    );
  }
}
