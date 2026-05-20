import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/network/api_result.dart';
import 'package:expense_tracker/feature/screen/home_view/domain/entities/home_user_entities.dart';
import 'package:expense_tracker/feature/screen/home_view/domain/use_case/home_screen_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeScreenUseCase homeScreenUseCase;

  HomeBloc(this.homeScreenUseCase) : super(HomeState()) {
    on<InitialApiEvent>(_onInitialApiCall);
    add(InitialApiEvent());
  }

  Future<void> _onInitialApiCall(
    InitialApiEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await homeScreenUseCase(page: 1);
      emit(state.copyWith(isLoading: false, user: result));
    } on ApiFailure catch (e) {
      emit(NoInternetState(errorCode: e.code, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
