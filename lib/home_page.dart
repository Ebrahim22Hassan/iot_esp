import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_esp/cubit/led_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LedCubit>(
      create: (BuildContext context) => LedCubit(7.0)..getDataB(),
      child: BlocConsumer<LedCubit, LedState>(
        listener: (BuildContext context, LedState state) {},
        builder: (BuildContext context, LedState state) {
          LedCubit cubit = BlocProvider.of(context);
          if (state is DataGetting) {
            //print("Getting Data");
          }
          return ThemeSwitchingArea(
            child: SafeArea(
              child: Scaffold(
                body: cubit.activeScreen[cubit.index],
                bottomNavigationBar: CurvedNavigationBar(
                  index: cubit.index,
                  onTap: (index) {
                    cubit.index = index;
                    cubit.changeCurrentScreen(cubit.index);
                  },
                  backgroundColor: cubit.index == 1
                      ? cubit.activeColor[cubit.sensorReading / 14]
                          .withOpacity(0.4)
                      : cubit.activeBSColor[cubit.index],
                  color: cubit.index == 1
                      ? cubit.activeColor[cubit.sensorReading / 14]
                      : cubit.activeBGColor[cubit.index],
                  animationDuration: const Duration(milliseconds: 400),
                  items: const [
                    Icon(Icons.table_chart_outlined),
                    Icon(Icons.home),
                    Icon(Icons.bar_chart),
                  ],
                ),
                // floatingActionButton: cubit.index == 0
                //     ? Container()
                //     : FloatingActionButton(
                //         onPressed: () {
                //           cubit.floatingActionButtonPressed(context);
                //         },
                //         child: Icon(cubit.activeFloatingIcon[cubit.index]),
                //       ),
              ),
            ),
          );
        },
      ),
    );
  }
}
