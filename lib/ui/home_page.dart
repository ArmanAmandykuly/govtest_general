import 'package:flutter/material.dart';
import 'package:govtest_general/ui/components/menu_button.dart';
import 'package:govtest_general/viewmodel/auth_viewmodel.dart';
import 'package:govtest_general/viewmodel/govtest_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final govtestViewModel = Provider.of<GovtestViewmodel>(
      context,
      listen: false,
    );

    if (authViewModel.auth.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, "/login");
      });
    }

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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Sidebar')),
            ListTile(
              title: Text('Платежи'),
              onTap: () {
                Navigator.of(context).pushNamed("/payments");
              },
            ),
            ListTile(
              title: Text('Тех. поддержка'),
              onTap: () {
                Navigator.of(context).pushNamed("/tech_support");
              },
            ),
          ],
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            menuButton(
              Image.asset('lib/icons/police-hat.png', color: Colors.blue),
              "Правоохранительная служба",
              () {
                govtestViewModel.setServiceSilent("lawenf");
                govtestViewModel.isLoading = true;
                Navigator.pushNamed(context, "/select_test");
              },
            ),
            SizedBox(height: 20),
            menuButton(
              FittedBox(child: Icon(Icons.account_balance, color: Colors.blue)),
              "Административная служба",
              () {
                govtestViewModel.setServiceSilent("admin");
                Navigator.pushNamed(context, "/select_test");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
