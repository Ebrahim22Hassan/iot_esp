import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iot_esp/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then(
        (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomePage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset('assets/images/UTM-LOGO-FULL.png')),
          const Text(
            'Capstone Project',
            style: TextStyle(fontSize: 45),
          ),
          const Text(
            'Group: P2G06',
            style: TextStyle(fontSize: 40),
          ),
          const Text(
            'Smart Swimming Pool',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SpinKitSpinningLines(
            color: Colors.deepOrange,
          )
        ],
      ),
    );
  }
}
