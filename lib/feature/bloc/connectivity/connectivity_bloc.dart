import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityBloc(this.connectivity) : super(ConnectivityInitial()) {
    on<ConnectivityChanged>((event, emit) {
      if (event.result == ConnectivityResult.none) {
        emit(ConnectivityLost());
      } else {
        emit(ConnectivityGained());
      }
    });

    // Listen to stream and dispatch event
    _subscription = connectivity.onConnectivityChanged.listen((result) {
      if(result.contains(ConnectivityResult.none)){
        add(ConnectivityChanged(ConnectivityResult.none));
      }else{
        add(ConnectivityChanged(result.firstWhere(
              (r) => r != ConnectivityResult.none,
          orElse: () => ConnectivityResult.none,
        )));
      }
    });
  }
  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
