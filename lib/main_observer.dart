import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubitObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("CubitObserver $transition");
    super.onTransition(bloc, transition);
  }
}
