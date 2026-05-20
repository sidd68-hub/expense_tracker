import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/di/injector.dart';
import 'package:expense_tracker/feature/bloc/connectivity/connectivity_bloc.dart';
import 'package:expense_tracker/feature/bloc/connectivity/connectivity_state.dart';
import 'package:expense_tracker/main.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ConnectivityBloc>(),
      child: BlocListener<ConnectivityBloc, ConnectivityState>(
        listener: (context, state) {
          if (state is ConnectivityLost && !_dialogShown) {
            _dialogShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: navigatorKey.currentContext!,
                barrierDismissible: false,
                builder: (_) =>
                    AlertDialog(
                      title: const Text("No Internet"),
                      content: const Text(
                          "You are offline. Please check your connection."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _dialogShown = false;
                            Navigator.of(navigatorKey.currentContext!).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
              );
            });
          } else if (state is ConnectivityGained && _dialogShown) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
              _dialogShown = false;
            }
          }
        },
        child: widget.child,
      ),
    );
  }
}