import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_pantry/pages/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[900],
        body: const Center(
            child: SpinKitDoubleBounce(
              color: Colors.white,
              size: 90.0,
            )
        )
    );
  }
}