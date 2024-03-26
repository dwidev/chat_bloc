import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../environtments/flavors.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDepedencies({required EnvFlavors environment}) => getIt.init(
      environment: environment.name,
    );
