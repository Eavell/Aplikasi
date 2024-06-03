import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => PerkenalanSatu()),
      // );
    });
    return Container(
      constraints: BoxConstraints.expand(), // Set constraints to expand
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.85, 0.08),
          end: Alignment(0.09, 0.98),
          colors: [Colors.lightBlue[100]!, Colors.lightBlue[300]!],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/Splash.png', // Make sure to add the image to your assets folder and update pubspec.yaml accordingly
            width: 180, // Set the width of the image
            height: 180, // Set the height of the image
          ),
        ],
      ),
    );
  }
}
