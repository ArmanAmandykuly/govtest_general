import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:govtest_general/ui/components/hover_card.dart';
import 'package:govtest_general/ui/components/loading_circle.dart';
import 'package:govtest_general/viewmodel/govtest_viewmodel.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final govtestViewModel = Provider.of<GovtestViewmodel>(
        context,
        listen: false,
      );
      if (!govtestViewModel.programChosen) {
        govtestViewModel.updateTest();
      } else {
        govtestViewModel.updateTestProgram();
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
                        return HoverCard(
                          index: index,
                          containerColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          containerBackgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: SizedBox(
                        height: 100,
                        child: SingleChildScrollView(
                          key: ValueKey<int>(govTestViewModel.index),
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
                  ),
                  Divider(),
                  SizedBox(
                    height: 250,
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          4, // 4 answer options
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                // Logic for selecting the answer
                                govTestViewModel.answerQuestion(
                                  govTestViewModel.index,
                                  index,
                                );
                                log(
                                  "selected:${govTestViewModel.test[govTestViewModel.index].selectedOption}",
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 8,
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
                                    Expanded(
                                      child: AnimatedDefaultTextStyle(
                                        duration: Duration(milliseconds: 500),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color:
                                              govTestViewModel
                                                          .test[govTestViewModel
                                                              .index]
                                                          .answerOptions[index] ==
                                                      govTestViewModel
                                                          .test[govTestViewModel
                                                              .index]
                                                          .selectedOption
                                                  ? Colors.blue
                                                  : Colors.black,
                                        ),
                                        child: Text(
                                          govTestViewModel
                                              .test
                                              .questions[govTestViewModel.index]
                                              .answerOptions[index],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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
                              Navigator.of(context).pushNamed("/test_band");
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
