import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

import '../cubit/led_cubit.dart';

class RGBScreen extends StatelessWidget {
  const RGBScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LedCubit, LedState>(
      listener: (BuildContext context, LedState state) {},
      builder: (BuildContext context, LedState state) {
        LedCubit cubit = BlocProvider.of(context);
        return state is PhotoToked
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Control Your RGB LED",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 33,
                      ),
                    ),
                    CircleColorPicker(
                      colorCodeBuilder: (context, Color cc) {
                        return Text(
                          'RGB: ${cc.red},${cc.green},${cc.blue}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        );
                      },
                      size: const Size(300, 300),
                      strokeWidth: 10,
                      thumbSize: 36,
                      onChanged: (cc) {
                        cubit.rgbColorChanged(cc.red, cc.green, cc.blue);
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }
}
