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

  InputDecoration _inputDecoration(String label, {String? error}) => InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        labelText: label,
        errorText: error,
      );

  @override
  Widget build(BuildContext context) {
    AuthNotifier model = Provider.of<AuthNotifier>(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          ScaleSlideInAnimation(
            show: model.authMode != AuthMode.verificationMode,
            fromRight: false,
            child: IntlPhoneField(
              decoration: _inputDecoration('Phone Number'),
              initialCountryCode: 'US',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (phoneNumber){
                phoneController.text = phoneNumber.countryCode + phoneNumber.number;
              },
              disableLengthCheck: model.authMode == AuthMode.verificationMode,
            ),
          ),
          ScaleSlideInAnimation(
            show: model.authMode != AuthMode.verificationMode,
            child: TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: _inputDecoration('Password'),
              maxLength: 60,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if(model.authMode == AuthMode.verificationMode) return null;
                if(value == null || value.isEmpty) return 'Password required';
                if(model.authMode == AuthMode.signUpMode && value.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
          ),
          ScaleSlideInAnimation(
            show: model.authMode == AuthMode.signUpMode,
            child: TextFormField(
              controller: confirmPasswordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: _inputDecoration('Confirm Password'),
              maxLength: 60,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if(model.authMode != AuthMode.signUpMode) return null;
                if(value == null || value.isEmpty) return 'Confirm your password';
                if(value != passwordController.text) return 'Passwords don\'t match';
                return null;
              },
            ),
          ),
          ScaleSlideInAnimation(
            show: model.authMode == AuthMode.verificationMode,
            fromRight: false,
            child: TextFormField(
              controller: verifyCodeController,
              keyboardType: TextInputType.number,
              obscureText: false,
              decoration: _inputDecoration('Verification Code'),
              maxLength: 6,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if(model.authMode != AuthMode.verificationMode) return null;
                if(value == null || value.isEmpty) return 'Enter Verification Code';
                if(value.length != 6) return 'Verification Code contains 6 characters';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
