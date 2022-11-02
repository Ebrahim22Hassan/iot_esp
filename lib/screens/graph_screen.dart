import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/led_cubit.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LedCubit, LedState>(
      listener: (BuildContext context, LedState state) {},
      builder: (BuildContext context, LedState state) {
        LedCubit cubit = BlocProvider.of(context);
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Control Your Graph",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 33,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: LineGraph(
                  features: [
                    Feature(
                      title: "LDR Graph",
                      color: Colors.orangeAccent,
                      data: List.from(cubit.data.reversed),
                    ),
                  ],
                  size: Size((cubit.data.length * 200).toDouble(), 400),
                  labelX: List.from(cubit.time.reversed),
                  labelY: const ['20%', '40%', '60%', '80%', '100%'],
                  graphColor: Colors.blue,
                  graphOpacity: 0.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
