import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// [FCard] that contains a login form with a username and password field.
///
/// Features:
/// - Validation, the fields must not be empty.
/// - Show/hide password button.
/// - Loading indicator when the form is submitted.
class SLoginForm extends StatefulWidget {
  /// Initial username value.
  final String? initialUsername;

  /// Initial password value.
  final String? initialPassword;

  /// Callback for when the form is submitted.
  final Future<void> Function({required String username, required String password}) onSubmit;

  /// Create a new [SLoginForm].
  const SLoginForm({
    required this.onSubmit,
    this.initialUsername,
    this.initialPassword,
    super.key,
  });

  @override
  State<SLoginForm> createState() => _SLoginFormState();
}

class _SLoginFormState extends State<SLoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  var _loading = false;

  /// Callback for when the login button is pressed, or the password field is submitted.
  Future<void> _onPressedLogin() async {
    // Ensure that no other operation is in progress and that the form is valid.
    if (_loading || _formKey.currentState?.validate() != true) {
      return;
    }

    // Enable loading indicator.
    setState(() => _loading = true);

    // Invoke the callback.
    await widget.onSubmit(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Disable loading indicator.
    setState(() => _loading = false);
  }

  /// Callback for when the "Which credentials should I use?" button is pressed.
  Future<void> _onPressedWhichCredentials() {
    return sShowPlatformMessageDialog(
      context: context,
      title: SLocalizations.of(context)!.whichCredentials,
      content: SLocalizations.of(context)!.whichCredentialsMsg,
    );
  }

  /// Validator for the username and password fields.
  String? _onValidateInput(String? input) {
    if (input == null || input.isEmpty) {
      return SLocalizations.of(context)!.fieldMustNotBeEmpty;
    }

    return null;
  }

  @override
  void initState() {
    if (widget.initialUsername != null) {
      _usernameController.text = widget.initialUsername!;
    }

    if (widget.initialPassword != null) {
      _passwordController.text = widget.initialPassword!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FCard.raw(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SLocalizations.of(context)!.login,
                style: FTheme.of(context).cardStyle.contentStyle.titleTextStyle,
              ),
              Text(
                SLocalizations.of(context)!.loginMsg,
                style: FTheme.of(context).cardStyle.contentStyle.subtitleTextStyle,
              ),
              const SizedBox(
                height: 15,
              ),
              FTextFormField(
                controller: _usernameController,
                label: Text(SLocalizations.of(context)!.username),
                autofillHints: const [AutofillHints.username],
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validator: _onValidateInput,
                autocorrect: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FTextFormField(
                controller: _passwordController,
                label: Text(SLocalizations.of(context)!.password),
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.send,
                validator: _onValidateInput,
                obscureText: _obscureText,
                autocorrect: false,
                onSubmit: (_) => _onPressedLogin(),
                suffixBuilder: (context, style, child) => Padding(
                  padding: FTheme.of(context).textFieldStyle.clearButtonPadding,
                  child: FButton.icon(
                    onPress: () => setState(() => _obscureText = !_obscureText),
                    style: FTheme.of(context).textFieldStyle.clearButtonStyle,
                    child: Icon(_obscureText ? FIcons.eye : FIcons.eyeOff),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FButton.raw(
                onPress: _onPressedLogin,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: _loading
                        ? LoadingIndicator(
                            indicatorType: Indicator.ballPulseSync,
                            colors: [
                              FTheme.of(context).colors.primaryForeground,
                            ],
                          )
                        : Text(
                            SLocalizations.of(context)!.logIn,
                            style: FTheme.of(context).buttonStyles.primary.contentStyle.textStyle.maybeResolve({}),
                          ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    FTappable(
                      onPress: _onPressedWhichCredentials,
                      child: Text(
                        SLocalizations.of(context)!.whichCredentials,
                        style: FTheme.of(context).typography.sm,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      SConstants.schoolName.toUpperCase(),
                      style: STheme.smallCaptionStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
