import 'package:flutter/material.dart';
import 'package:govtest_general/viewmodel/govtest_viewmodel.dart';
import 'package:provider/provider.dart';

class HoverCardFinal extends StatelessWidget {
  final int index;
  final Color containerColor;
  final Color containerBackgroundColor;

  const HoverCardFinal({
    Key? key,
    required this.index,
    required this.containerColor,
    required this.containerBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GovtestViewmodel>(
      builder: (context, govTestViewModel, child) {
        bool isAnswered = govTestViewModel.test.questions[index].isAnswered;
        return InkWell(
          onTap: () {
            govTestViewModel.index = index;
          },
          child: Card(
            color:
                !govTestViewModel.test[index].isAnswered ||
                        govTestViewModel.test[index].answer ==
                            govTestViewModel.test[index].selectedOption
                    ? Colors.red
                    : Colors.green,
            child: Center(
              child: Text("$index", style: TextStyle(color: containerColor)),
            ),
          ),
        );
      },
    );
  }
}
