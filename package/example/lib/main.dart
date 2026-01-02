import 'package:flutter/material.dart';
import 'package:graceful_http_request/graceful_http_request.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graceful HTTP Request Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool isLoading = false;
  String? result;
  String? errorMessage;

  Future<void> _makeRequest() async {
    setState(() {
      isLoading = true;
      result = null;
      errorMessage = null;
    });

    try {
      final data = await execute<String>(
        request: () async {
          await Future.delayed(const Duration(milliseconds: 100));
          return 'Request completed successfully!';
        },
        waitingThreshold: const Duration(milliseconds: 500),
        maxWaitTime: const Duration(seconds: 2),
        onWaiting: () {
          setState(() {
            isLoading = true;
          });
        },
      );

      setState(() {
        result = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _makeSlowRequest() async {
    setState(() {
      isLoading = true;
      result = null;
      errorMessage = null;
    });

    try {
      final data = await execute<String>(
        request: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          return 'Slow request completed successfully!';
        },
        waitingThreshold: const Duration(milliseconds: 500),
        maxWaitTime: const Duration(seconds: 2),
        onWaiting: () {
          setState(() {
            isLoading = true;
          });
        },
      );

      setState(() {
        result = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graceful HTTP Request Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )
              else if (result != null)
                Text(
                  result!,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                )
              else
                const Text(
                  'Press a button to make a request',
                  style: TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: isLoading ? null : _makeRequest,
                child: const Text('Fast Request'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : _makeSlowRequest,
                child: const Text('Slow Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
