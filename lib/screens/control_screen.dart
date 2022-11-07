import 'package:animated_background/animated_background.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:segment_display/segment_display.dart';
import '../cubit/led_cubit.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LedCubit, LedState>(
      listener: (BuildContext context, LedState state) {},
      builder: (BuildContext context, LedState state) {
        LedCubit cubit = BlocProvider.of(context);
        //print(state);
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.white,
                    cubit.activeColor[cubit.sensorReading / 14]
                        .withOpacity(0.5),
                    cubit.activeColor[cubit.sensorReading / 14],
                  ]),
            ),
            child: AnimatedBackground(
              behaviour: RandomParticleBehaviour(
                  options: ParticleOptions(
                baseColor: const Color(0xFFFFFFFF),
                opacityChangeRate: 0.25,
                minOpacity: 0.1,
                maxOpacity: 0.3,
                spawnMinSpeed: 60.0,
                spawnMaxSpeed: 120,
                spawnMinRadius: 5.0,
                spawnMaxRadius: 10.0,
                particleCount: cubit.motorActive ? 150 : 0,
              )),
              vsync: this,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "Smart Swimming Pool",
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.pool_outlined, size: 35),
                        ],
                      ),
                      const Divider(
                        thickness: 4,
                      ),
                      const SizedBox(
                        height: 50,
                      ),

                      /// pH Level Container
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "pH Level",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  state is DataGetting
                                      ? "---"
                                      : "${cubit.sensorReading}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 100,
                                  ),
                                ),
                                // SevenSegmentDisplay(
                                //   value: state is DataGetting
                                //       ? "---"
                                //       : "${cubit.sensorReading}",
                                //   size: 8,
                                //   characterSpacing: 10,
                                //   backgroundColor: Colors.transparent,
                                //   segmentStyle: HexSegmentStyle(
                                //     enabledColor: Colors.black,
                                //     disabledColor:
                                //         Colors.grey.withOpacity(0.05),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      /// Motor ON/OFF Container
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.55,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/speaker.svg',
                                        color: cubit.motorActive
                                            ? Colors.white
                                            : Colors.black,
                                        height: 30,
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      SizedBox(
                                        width: 65,
                                        child: Text(
                                          "Motor",
                                          style: TextStyle(
                                              height: 1.2,
                                              fontSize: 14,
                                              color: cubit.motorActive
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: 'OFF',
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              color: !cubit.motorActive
                                                  ? Colors.white
                                                  : Colors.black
                                                      .withOpacity(0.3),
                                              fontWeight: FontWeight.w500),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '/',
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.3))),
                                            TextSpan(
                                              text: 'ON',
                                              style: TextStyle(
                                                color: cubit.motorActive
                                                    ? Colors.white
                                                    : Colors.black
                                                        .withOpacity(0.3),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    Transform.scale(
                                      alignment: Alignment.center,
                                      scaleY: 0.8,
                                      scaleX: 0.85,
                                      child: CupertinoSwitch(
                                        onChanged: (val) {
                                          cubit.motorChange();
                                        },
                                        value: cubit.motorActive,
                                        activeColor:
                                            //cubit.motorActive ?
                                            Colors.white.withOpacity(0.4),
                                        //: Colors.black,
                                        trackColor: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      /// LED ON/OFF Container
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Text("Control the LED:"),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                child: ThemeSwitcher.withTheme(
                                    builder: (p0, switcher, theme) {
                                  return TextButton(
                                    onPressed: () {
                                      switcher.changeTheme(
                                          theme: theme.brightness ==
                                                  Brightness.light
                                              ? ThemeData.dark()
                                              : ThemeData.light());
                                      cubit.ledChange();
                                    },
                                    child: Text(
                                      cubit.ledON ? "LED Off" : "LED On",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: cubit.ledON
                                            ? Colors.red
                                            : Colors.lightGreen,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
