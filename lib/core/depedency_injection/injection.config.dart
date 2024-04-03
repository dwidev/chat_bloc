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
    as _i28;
import 'package:matchloves/core/local_storage_manager/local_storage_adapter.dart'
    as _i18;
import 'package:matchloves/core/local_storage_manager/local_storage_manager.dart'
    as _i8;
import 'package:matchloves/core/photos_picker/photo_picker_cubit.dart' as _i13;
import 'package:matchloves/features/auth/data/datasources/auth_localstorage_datasource.dart'
    as _i17;
import 'package:matchloves/features/auth/data/datasources/firebase_datasource.dart'
    as _i15;
import 'package:matchloves/features/auth/data/datasources/http_datasource.dart'
    as _i16;
import 'package:matchloves/features/auth/data/repository/authentication_repository_impl.dart'
    as _i20;
import 'package:matchloves/features/auth/domain/repository/authentication_repository.dart'
    as _i19;
import 'package:matchloves/features/auth/domain/usecase/sign_with_google.dart'
    as _i24;
import 'package:matchloves/features/auth/presentation/bloc/authentication_bloc.dart'
    as _i26;
import 'package:matchloves/features/auth/presentation/bloc/complete_profile_bloc.dart'
    as _i3;
import 'package:matchloves/features/chat/bloc/chat_bloc/chat_bloc.dart' as _i27;
import 'package:matchloves/features/chat/bloc/conversations_bloc/conversations_bloc.dart'
    as _i22;
import 'package:matchloves/features/chat/bloc/ws_connection_bloc/ws_connection_bloc.dart'
    as _i25;
import 'package:matchloves/features/chat/data/datasources/http_datasource.dart'
    as _i7;
import 'package:matchloves/features/chat/data/datasources/ws_datasource.dart'
    as _i14;
import 'package:matchloves/features/chat/data/repository/chat_repository.dart'
    as _i21;
import 'package:matchloves/features/masterdata/cubit/master_data_cubit.dart'
    as _i23;
import 'package:matchloves/features/masterdata/data/datasource/masterdata_datasource.dart'
    as _i9;
import 'package:matchloves/features/masterdata/data/datasource/masterdata_mock_datasource.dart'
    as _i10;
import 'package:matchloves/features/masterdata/data/repository/masterdata_repository.dart'
    as _i11;
import 'package:matchloves/features/nearbypeople/cubit/control_card_cubit.dart'
    as _i4;
import 'package:matchloves/features/nearbypeople/cubit/match_engine_cubit.dart'
    as _i12;

const String _mock = 'mock';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
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
    await gh.factoryAsync<_i8.LocalStorageAdapter>(
      () => registerModule.sharedPreference,
      instanceName: 'shared_preference',
      preResolve: true,
    );
    await gh.factoryAsync<_i8.LocalStorageAdapter>(
      () => registerModule.mockPref,
      instanceName: 'mock_storage',
      preResolve: true,
    );
    gh.lazySingleton<_i9.MasterDataDasource>(
      () => _i10.MasterDataMockDataSourceImpl(),
      registerFor: {_mock},
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i11.MasterDataRepository>(
      () => _i11.MasterDataRepository(
          masterDataDasource: gh<_i9.MasterDataDasource>()),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i12.MatchEngineCubit>(() => _i12.MatchEngineCubit());
    gh.lazySingleton<_i13.PhotoPickerCubit>(
      () => _i13.PhotoPickerCubit(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i14.WebSocketDataSource>(
      () => _i14.WebSocketDataSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i15.AuthFirebaseDataSource>(() =>
        _i15.AuthFirebaseDataSourceImpl(firebaseAuth: gh<_i6.FirebaseAuth>()));
    gh.lazySingleton<_i16.AuthHTTPDataSource>(
        () => _i16.AuthHTTPDataSourceImpl(dio: gh<_i5.Dio>()));
    gh.lazySingleton<_i17.AuthLocalStorageDataSource>(() =>
        _i17.AuthLocalStorageDataSourceImpl(
            adapter:
                gh<_i18.LocalStorageAdapter>(instanceName: 'mock_storage')));
    gh.lazySingleton<_i19.AuthenticationRepository>(
        () => _i20.AuthenticationRepositoryImpl(
              authFirebaseDataSource: gh<_i15.AuthFirebaseDataSource>(),
              authHTTPDataSource: gh<_i16.AuthHTTPDataSource>(),
              authLocalStorageDataSource: gh<_i17.AuthLocalStorageDataSource>(),
            ));
    gh.lazySingleton<_i21.ChatRepository>(
      () => _i21.ChatRepository(
        webSocketDataSource: gh<_i14.WebSocketDataSource>(),
        httpDataSource: gh<_i7.HttpDataSource>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i22.ConversationsBloc>(() =>
        _i22.ConversationsBloc(chatRepository: gh<_i21.ChatRepository>()));
    gh.factory<_i23.MasterDataCubit>(() => _i23.MasterDataCubit(
        masterDataRepository: gh<_i11.MasterDataRepository>()));
    gh.lazySingleton<_i24.SignWithGoogle>(() => _i24.SignWithGoogle(
        authenticationRepository: gh<_i19.AuthenticationRepository>()));
    gh.factory<_i25.WsConnectionBloc>(
        () => _i25.WsConnectionBloc(chatRepository: gh<_i21.ChatRepository>()));
    gh.factory<_i26.AuthenticationBloc>(() =>
        _i26.AuthenticationBloc(signWithGoogle: gh<_i24.SignWithGoogle>()));
    gh.factory<_i27.ChatBloc>(
        () => _i27.ChatBloc(chatRepository: gh<_i21.ChatRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i28.RegisterModule {}
