import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/led_cubit.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LedCubit, LedState>(
      listener: (BuildContext context, LedState state) {},
      builder: (BuildContext context, LedState state) {
        LedCubit cubit = BlocProvider.of(context);
        print(state);
        return state is DataGetting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Control Your Object",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 33,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 5),
                        ),
                        child: Image.network(
                            "https://www.pngmart.com/files/21/Internet-Of-Things-IOT-Vector-PNG-Picture.png"),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                const Text(
                                  "Minutes",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow
                                        .withOpacity(cubit.sensorReading / 100),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "${cubit.minutes}%",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Brightness Level",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.withOpacity(
                                          cubit.sensorReading / 100),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      "${cubit.sensorReading}%",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Text("Control the LED"),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: ThemeSwitcher.withTheme(
                                builder: (p0, switcher, theme) {
                              return TextButton(
                                onPressed: () {
                                  switcher.changeTheme(
                                      theme:
                                          theme.brightness == Brightness.light
                                              ? ThemeData.dark()
                                              : ThemeData.light());
                                  cubit.ledChange();
                                },
                                child: Text(cubit.ledON ? "LED Off" : "LED On"),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }
}
