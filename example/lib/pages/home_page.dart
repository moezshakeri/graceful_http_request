import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graceful_http_request_example/state/request_cubit.dart';
import 'package:graceful_http_request_example/widgets/request_status_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Graceful HTTP Request Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RequestStatusWidget(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.read<RequestCubit>().executeRequest(RequestType.fast);
                },
                child: const Text('Execute Fast Request'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<RequestCubit>().executeRequest(RequestType.slow);
                },
                child: const Text('Execute Slow Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
