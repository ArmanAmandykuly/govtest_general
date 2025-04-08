import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:govtest_general/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    var authViewModel = Provider.of<AuthViewModel>(context);

    var url = 'https://wa.me/+77755972332';

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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              TextField(
                readOnly: true,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: authViewModel.auth.currentUser!.uid),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied to clipboard!')),
                  );
                },
                decoration: InputDecoration(
                  labelText: "Ваш ID",
                  hintText: authViewModel.auth.currentUser?.uid,
                ),
              ),
              OutlinedButton(onPressed: () async {}, child: Text("Pay")),
            ],
          ),
        ),
      ),
    );
  }
}
