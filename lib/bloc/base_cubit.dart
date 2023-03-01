import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_state.dart';

abstract class BaseCubit extends Cubit<BaseState> {
  bool isUpdate = false;

  BaseCubit(BaseState state) : super(state);

  LoadedState? get latestLoadedState {
    if (state is LoadedState) {
      return state as LoadedState;
    }
    return null;
  }
}
