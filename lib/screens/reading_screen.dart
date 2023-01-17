import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_esp/cubit/led_cubit.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LedCubit(7.0)..getJson(),
      child: BlocConsumer<LedCubit, LedState>(
        listener: (BuildContext context, LedState state) {},
        builder: (BuildContext context, LedState state) {
          LedCubit cubit = BlocProvider.of(context);
          return Scaffold(
            body: state is JsonGet
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Colors.white,
                            const Color(0xFF1086D4).withOpacity(0.5),
                            const Color(0xFF1086D4),
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
                            const Color(0xFF1086D4).withOpacity(0.5),
                            const Color(0xFF1086D4),
                          ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        itemCount: cubit.itemCount,
                        itemBuilder: (context, index) {
                          return readingBuilder(cubit, index - 1, context);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget readingBuilder(LedCubit cubit, int index, context) {
    Map<String, dynamic>? row;
    List<String>? dates;
    if (index != -1) {
      row = cubit.ldrValues![index];
      dates = row!['date'].split('T');
    }
    return index == -1
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey,
                margin: const EdgeInsets.only(
                  left: 10.0,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Time',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey,
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'pH Reading',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    dates![0],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey,
                margin: const EdgeInsets.only(
                  left: 10.0,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    dates[1].substring(0, 8),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey,
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${row!['value'].toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
