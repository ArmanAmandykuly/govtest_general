import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:govtest_general/ui/components/hover_card.dart';
import 'package:govtest_general/ui/components/hover_card_final.dart';
import 'package:govtest_general/ui/components/loading_circle.dart';
import 'package:govtest_general/viewmodel/govtest_viewmodel.dart';
import 'package:provider/provider.dart';

class TestBandPage extends StatefulWidget {
  const TestBandPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _TestBandPageState();
}

class _TestBandPageState extends State<TestBandPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final govtestViewModel = Provider.of<GovtestViewmodel>(
        context,
        listen: false,
      );
      if (govtestViewModel.programChosen) {
        govtestViewModel.updateTestProgram();
      } else {
        govtestViewModel.updateTest();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final govTestViewModel = Provider.of<GovtestViewmodel>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
          govTestViewModel.isLoading
              ? LoadingCircle()
              : Column(
                children: <Widget>[
                  SizedBox(
                    height: 100, // Define a fixed height
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: govTestViewModel.test.questions.length,
                      itemBuilder: (context, index) {
                        return HoverCardFinal(
                          index: index,
                          containerColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          containerBackgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: SizedBox(
                        key: ValueKey<int>(govTestViewModel.index),
                        height: 100,
                        child: Text(
                          govTestViewModel
                              .test
                              .questions[govTestViewModel.index]
                              .question,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(
                      4, // 4 answer options
                      (index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              border: Border.all(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value:
                                      govTestViewModel
                                          .test[govTestViewModel.index]
                                          .answerOptions[index] ==
                                      govTestViewModel
                                          .test
                                          .questions[govTestViewModel.index]
                                          .selectedOption,
                                  onChanged: (bool? value) {},
                                ),
                                Text(
                                  govTestViewModel
                                      .test
                                      .questions[govTestViewModel.index]
                                      .answerOptions[index],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 50,
                        ),
                        child: OutlinedButton(
                          onPressed:
                              govTestViewModel.isFirstQuestion
                                  ? null
                                  : () {
                                    govTestViewModel.prevQuestion();
                                  },
                          child: Text("Back"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 50,
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            govTestViewModel.nextQuestion(() {
                              Navigator.of(context).pushNamed("/login");
                            });
                          },
                          child:
                              govTestViewModel.isLastQuestion
                                  ? Text("Finish")
                                  : Text("Next"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
