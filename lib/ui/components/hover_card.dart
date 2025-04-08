import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:govtest_general/viewmodel/govtest_viewmodel.dart';
import 'package:provider/provider.dart';

class HoverCard extends StatelessWidget {
  final int index;
  final Color containerColor;
  final Color containerBackgroundColor;

  const HoverCard({
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
            color: isAnswered ? containerColor : containerBackgroundColor,
            child: Center(
              child: Text(
                "$index",
                style: TextStyle(
                  color: isAnswered ? containerBackgroundColor : containerColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
