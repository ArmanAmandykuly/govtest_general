import 'package:flutter/material.dart';
import 'package:govtest_general/ui/components/loading_circle.dart';
import 'package:govtest_general/viewmodel/govtest_viewmodel.dart';
import 'package:provider/provider.dart';

class SelectTestPage extends StatefulWidget {
  const SelectTestPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _SelectTestPageState();
}

class _SelectTestPageState extends State<SelectTestPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final govtestViewModel = Provider.of<GovtestViewmodel>(
        context,
        listen: false,
      );
      govtestViewModel.updateTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final govtestViewModel = Provider.of<GovtestViewmodel>(context);

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
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       DrawerHeader(child: Text('Sidebar')),
      //       ListTile(
      //         title: Text('Платежи'),
      //         onTap: () {
      //           Navigator.of(context).pushNamed("/payments");
      //         },
      //       ),
      //       ListTile(
      //         title: Text('Тех. поддержка'),
      //         onTap: () {
      //           Navigator.of(context).pushNamed("/tech_support");
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body:
          govtestViewModel.topics == null
              ? LoadingCircle()
              : Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        OutlinedButton(
                          onPressed:
                              !govtestViewModel.programAvailability1
                                  ? null
                                  : () {
                                    Navigator.of(context).pushNamed("/test");
                                    govtestViewModel.setProgramSilent(1);
                                  },
                          child: Text("Program 1"),
                        ),
                        OutlinedButton(
                          onPressed:
                              !govtestViewModel.programAvailability2
                                  ? null
                                  : () {
                                    Navigator.of(context).pushNamed("/test");
                                    govtestViewModel.setProgramSilent(2);
                                  },
                          child: Text("Program 2"),
                        ),
                        OutlinedButton(
                          onPressed:
                              !govtestViewModel.programAvailability3
                                  ? null
                                  : () {
                                    govtestViewModel.setProgramSilent(3);
                                    Navigator.of(context).pushNamed("/test");
                                  },
                          child: Text("Program 3"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Container(
                          width:
                              constraints.maxWidth *
                              0.8, // 80% of parent's width
                          height: 2,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            govtestViewModel.topics
                                ?.map(
                                  (topic) => OutlinedButton(
                                    onPressed:
                                        !topic.isAvailable
                                            ? null
                                            : () {
                                              govtestViewModel.test.topic =
                                                  topic.topicId.toString();
                                              govtestViewModel.isLoading = true;
                                              Navigator.pushNamed(
                                                context,
                                                "/test",
                                              );
                                            },
                                    child: Text(topic.topic),
                                  ),
                                )
                                .toList() ??
                            [
                              OutlinedButton(
                                onPressed: null,
                                child: Text("No topics available"),
                              ),
                            ], // Wrap in a list
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
