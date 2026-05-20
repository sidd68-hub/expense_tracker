part of 'home_bloc.dart';

class HomeState extends Equatable {
  final bool? isLoading;
  final List<User>? user;

  const HomeState({this.isLoading, this.user});

  HomeState copyWith({bool? isLoading, List<User>? user}) {
    return HomeState(
        isLoading: isLoading ?? this.isLoading, user: user ?? this.user);
  }

  @override
  List<Object?> get props => [isLoading, user];
}

class NoInternetState extends HomeState {
  final int? errorCode;
  final String? errorMessage;

  const NoInternetState({this.errorCode, this.errorMessage});

  @override
  List<Object?> get props => [errorCode, errorMessage];
}
