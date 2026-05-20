import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/widgets/exception_dialog.dart';
import 'package:expense_tracker/feature/screen/home_view/presentation/bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is NoInternetState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('No Internet')));
              }
            },
            builder: (context, state) {
              return (state.isLoading == true)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.user?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Text(
                                  "Hello ${state.user?[index].firstName}");
                            }),
                        ElevatedButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(InitialApiEvent());
                            },
                            child: Text("Hit the api"))
                      ],
                    );
            },
          )),
    );
  }
}
