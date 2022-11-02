import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_esp/cubit/led_cubit.dart';

import 'model.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  var db = DbConnect();

  Future getData() async {
    return db.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LedCubit>(
      create: (BuildContext context) => LedCubit()..getDataB(),
      child: BlocConsumer<LedCubit, LedState>(
        listener: (BuildContext context, LedState state) {},
        builder: (BuildContext context, LedState state) {
          LedCubit cubit = BlocProvider.of(context);
          if (state is DataGetting) {
            print("Geting Data");
          }
          return ThemeSwitchingArea(
            child: Scaffold(
              appBar: AppBar(
                leading: const Icon(Icons.lightbulb_outline_sharp),
                title: const Text("IoT"),
                centerTitle: true,
              ),
              body: cubit.activeScreen[cubit.index],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.index,
                onTap: (index) {
                  cubit.changeCurrentScreen(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "Control",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.color_lens_outlined),
                    label: "RGB",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.photo),
                    label: "Graph",
                  ),
                ],
              ),
              floatingActionButton: cubit.index == 0
                  ? Container()
                  : FloatingActionButton(
                      onPressed: () {
                        cubit.floatingActionButtonPressed(context);
                      },
                      child: Icon(cubit.activeFloatingIcon[cubit.index]),
                    ),
            ),
          );
        },
      ),
    );
  }
}
