import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graceful_http_request_example/state/request_cubit.dart';

class RequestStatusWidget extends StatelessWidget {
  const RequestStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestCubit, RequestState>(
      builder: (context, state) {
        if (state.isLoading && !state.isWaiting) {
          return const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Starting request...'),
            ],
          );
        }

        if (state.isWaiting) {
          return const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Waiting for response...'),
              Text(
                'Request is taking longer than expected',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          );
        }

        if (state.result != null) {
          return Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 16),
              Text(
                state.result!,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        if (state.error != null) {
          return Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                state.error!,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        return const Text(
          'Press a button to execute a request',
          style: TextStyle(fontSize: 16),
        );
      },
    );
  }
}
