import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/led_cubit.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LedCubit(7.0)..getJson(),
      child: BlocConsumer<LedCubit, LedState>(
        listener: (BuildContext context, LedState state) {},
        builder: (BuildContext context, LedState state) {
          LedCubit cubit = BlocProvider.of(context);
          // print(cubit.data);
          // print('*****************');
          return Scaffold(
            body: state is JsonGet
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Colors.white,
                            const Color(0xFFC421A0).withOpacity(0.5),
                            const Color(0xFFC421A0),
                          ]),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Colors.white,
                            const Color(0xFFC421A0).withOpacity(0.5),
                            const Color(0xFFC421A0),
                          ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text(
                              "Graph",
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: LineGraph(
                              features: [
                                Feature(
                                  title: "pH Sensor Graph",
                                  color: Colors.red,
                                  data: List.from(cubit.data.reversed),
                                ),
                              ],
                              size:
                                  Size(cubit.data.length * 80.toDouble(), 400),
                              labelX: List.from(cubit.time.reversed),
                              labelY: const [
                                '20%',
                                '40%',
                                '60%',
                                '80%',
                                '100%'
                              ],
                              graphColor: Colors.black,
                              graphOpacity: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
