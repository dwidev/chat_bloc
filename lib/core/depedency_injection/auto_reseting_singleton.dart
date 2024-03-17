import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';

mixin AutoResetLazySingletonBloc<T extends Object, S> on BlocBase<S> {
  @override
  Future<void> close() {
    final isRegistered = getIt.isRegistered<T>(instance: this);

    if (isRegistered) {
      getIt.resetLazySingleton<T>();
    }

    return super.close();
  }
}
