import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_providers/sa_providers.dart';
import 'package:simple_shadow/simple_shadow.dart';

/// The login screen of the application.
class SLoginScreen extends ConsumerStatefulWidget {
  /// Create a new [SLoginScreen].
  const SLoginScreen({super.key});

  @override
  ConsumerState<SLoginScreen> createState() => _SLoginScreenState();
}

class _SLoginScreenState extends ConsumerState<SLoginScreen> {
  var _showWelcomeMessage = true;

  /// Callback to switch from the welcome message to the login form.
  void _onPressedToLogin() {
    setState(() => _showWelcomeMessage = false);
  }

  /// Callback for when the login button is pressed.
  Future<void> _onPressedLogin({required String username, required String password}) async {
    // Log in the user.
    final res = await ref.read(sAuthProvider.notifier).login(
          username: username,
          password: password,
        );

    // Show a toast if an error occurred.
    res.fold(
      (l) => sShowDataExceptionToast(
        context: context,
        exception: l,
      ),
      (r) => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final initialUsername = ref.read(sLocalSettingsProvider).username;
    final initialPassword = ref.read(sLocalSettingsProvider).password;

    // If there are user credentials stored, skip the welcome message.
    if (initialPassword.isNotEmpty || initialUsername.isNotEmpty) {
      _showWelcomeMessage = false;
    }

    return MeshGradient(
      options: MeshGradientOptions(
        noiseIntensity: 0.1,
      ),
      points: [
        MeshGradientPoint(
          position: const Offset(
            0.9,
            0.1,
          ),
          color: isDarkMode ? const Color.fromARGB(255, 251, 0, 46) : const Color.fromARGB(255, 251, 0, 46),
        ),
        MeshGradientPoint(
          position: const Offset(
            0.1,
            0.3,
          ),
          color: isDarkMode ? const Color.fromARGB(255, 5, 0, 106) : const Color.fromARGB(255, 69, 18, 255),
        ),
        MeshGradientPoint(
          position: const Offset(
            0.7,
            0.3,
          ),
          color: isDarkMode ? const Color.fromARGB(160, 0, 37, 123) : const Color.fromARGB(255, 0, 255, 198),
        ),
        MeshGradientPoint(
          position: const Offset(
            0.4,
            0.8,
          ),
          color: isDarkMode ? const Color.fromARGB(255, 41, 0, 111) : const Color.fromARGB(255, 140, 0, 255),
        ),
        MeshGradientPoint(
          position: const Offset(
            0.2,
            0.8,
          ),
          color: isDarkMode ? const Color.fromARGB(255, 149, 0, 27) : const Color.fromARGB(255, 251, 0, 46),
        ),
      ],
      child: GestureDetector(
        // Unfocus the keyboard when tapping outside of a text field.
        onTap: FocusScope.of(context).unfocus,
        child: FScaffold(
          style: FTheme.of(context).scaffoldStyle.copyWith(
                backgroundColor: Colors.transparent,
              ),
          child: Center(
            child: AnimatedSwitcherPlus.flipY(
              duration: const Duration(milliseconds: 300),
              child: _showWelcomeMessage
                  ? buildWelcomeMessage(context)
                  : SingleChildScrollView(
                      child: SLoginForm(
                        onSubmit: _onPressedLogin,
                        initialUsername: initialUsername,
                        initialPassword: initialPassword,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build the welcome message and a button to open the login form.
  Widget buildWelcomeMessage(BuildContext context) {
    return SimpleShadow(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/logo_black.svg',
            width: 150,
            height: 150,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            SLocalizations.of(context)!.welcome,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'MsMadi',
              color: Colors.white,
              fontSize: 64,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FButton(
            intrinsicWidth: true,
            onPress: _onPressedToLogin,
            child: Text(SLocalizations.of(context)!.logIn),
          ),
        ],
      ),
    );
  }
}
