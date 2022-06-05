part of 'widgets.dart';

class AuthenticationForm extends StatelessWidget {
  AuthenticationForm(
      {required this.formKey,
      required this.phoneController,
      required this.passwordController,
      required this.verifyCodeController,
      Key? key})
      : super(key: key);

  GlobalKey<FormState> formKey;
  TextEditingController phoneController;
  TextEditingController passwordController;
  TextEditingController verifyCodeController;

  @override
  Widget build(BuildContext context) {
    AuthNotifier model = Provider.of<AuthNotifier>(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'Phone Number'),
          ),
          TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          TextFormField(
            controller: verifyCodeController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: 'Verification Code'),
          ),
        ],
      ),
    );
  }
}
