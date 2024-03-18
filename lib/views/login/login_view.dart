import 'package:flutter/material.dart';
import 'package:grocery_app/views/login/components/login_form.dart';

import '../../gen/assets.gen.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   // image: AssetImage(Assets.images.background.path),
                //   // Replace with your background image asset
                //   fit: BoxFit.fill,
                // ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LoginForm(),
              )
            )
          ],
        )
      ),
    );
  }
}
