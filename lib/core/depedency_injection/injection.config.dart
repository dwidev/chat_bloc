// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:matchloves/core/depedency_injection/register_module.dart'
    as _i25;
import 'package:matchloves/core/photos_picker/photo_picker_cubit.dart' as _i12;
import 'package:matchloves/features/auth/data/datasources/firebase_datasource.dart'
    as _i14;
import 'package:matchloves/features/auth/data/datasources/http_datasource.dart'
    as _i15;
import 'package:matchloves/features/auth/data/repository/authentication_repository_impl.dart'
    as _i17;
import 'package:matchloves/features/auth/domain/repository/authentication_repository.dart'
    as _i16;
import 'package:matchloves/features/auth/domain/usecase/sign_with_google.dart'
    as _i21;
import 'package:matchloves/features/auth/presentation/bloc/authentication_bloc.dart'
    as _i23;
import 'package:matchloves/features/auth/presentation/bloc/complete_profile_bloc.dart'
    as _i3;
import 'package:matchloves/features/chat/bloc/chat_bloc/chat_bloc.dart' as _i24;
import 'package:matchloves/features/chat/bloc/conversations_bloc/conversations_bloc.dart'
    as _i19;
import 'package:matchloves/features/chat/bloc/ws_connection_bloc/ws_connection_bloc.dart'
    as _i22;
import 'package:matchloves/features/chat/data/datasources/http_datasource.dart'
    as _i7;
import 'package:matchloves/features/chat/data/datasources/ws_datasource.dart'
    as _i13;
import 'package:matchloves/features/chat/data/repository/chat_repository.dart'
    as _i18;
import 'package:matchloves/features/masterdata/cubit/master_data_cubit.dart'
    as _i20;
import 'package:matchloves/features/masterdata/data/datasource/masterdata_datasource.dart'
    as _i8;
import 'package:matchloves/features/masterdata/data/datasource/masterdata_mock_datasource.dart'
    as _i9;
import 'package:matchloves/features/masterdata/data/repository/masterdata_repository.dart'
    as _i10;
import 'package:matchloves/features/nearbypeople/cubit/control_card_cubit.dart'
    as _i4;
import 'package:matchloves/features/nearbypeople/cubit/match_engine_cubit.dart'
    as _i11;

const String _mock = 'mock';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.CompleteProfileBloc>(() => _i3.CompleteProfileBloc());
    gh.factory<_i4.ControlCardCubit>(() => _i4.ControlCardCubit());
    gh.lazySingleton<_i5.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i6.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i7.HttpDataSource>(
      () => _i7.HttpDataSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i8.MasterDataDasource>(
      () => _i9.MasterDataMockDataSourceImpl(),
      registerFor: {_mock},
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i10.MasterDataRepository>(
      () => _i10.MasterDataRepository(
          masterDataDasource: gh<_i8.MasterDataDasource>()),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i11.MatchEngineCubit>(() => _i11.MatchEngineCubit());
    gh.lazySingleton<_i12.PhotoPickerCubit>(
      () => _i12.PhotoPickerCubit(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i13.WebSocketDataSource>(
      () => _i13.WebSocketDataSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i14.AuthFirebaseDataSource>(() =>
        _i14.AuthFirebaseDataSourceImpl(firebaseAuth: gh<_i6.FirebaseAuth>()));
    gh.lazySingleton<_i15.AuthHTTPDataSource>(
        () => _i15.AuthHTTPDataSourceImpl(dio: gh<_i5.Dio>()));
    gh.lazySingleton<_i16.AuthenticationRepository>(
        () => _i17.AuthenticationRepositoryImpl(
              authFirebaseDataSource: gh<_i14.AuthFirebaseDataSource>(),
              authHTTPDataSource: gh<_i15.AuthHTTPDataSource>(),
            ));
    gh.lazySingleton<_i18.ChatRepository>(
      () => _i18.ChatRepository(
        webSocketDataSource: gh<_i13.WebSocketDataSource>(),
        httpDataSource: gh<_i7.HttpDataSource>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i19.ConversationsBloc>(() =>
        _i19.ConversationsBloc(chatRepository: gh<_i18.ChatRepository>()));
    gh.factory<_i20.MasterDataCubit>(() => _i20.MasterDataCubit(
        masterDataRepository: gh<_i10.MasterDataRepository>()));
    gh.lazySingleton<_i21.SignWithGoogle>(() => _i21.SignWithGoogle(
        authenticationRepository: gh<_i16.AuthenticationRepository>()));
    gh.factory<_i22.WsConnectionBloc>(
        () => _i22.WsConnectionBloc(chatRepository: gh<_i18.ChatRepository>()));
    gh.factory<_i23.AuthenticationBloc>(() =>
        _i23.AuthenticationBloc(signWithGoogle: gh<_i21.SignWithGoogle>()));
    gh.factory<_i24.ChatBloc>(
        () => _i24.ChatBloc(chatRepository: gh<_i18.ChatRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i25.RegisterModule {}
