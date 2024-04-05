// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:matchloves/core/depedency_injection/register_module.dart'
    as _i32;
import 'package:matchloves/core/local_storage_manager/local_storage_adapter.dart'
    as _i17;
import 'package:matchloves/core/local_storage_manager/local_storage_manager.dart'
    as _i7;
import 'package:matchloves/core/photos_picker/photo_picker_cubit.dart' as _i12;
import 'package:matchloves/features/auth/data/datasources/auth_localstorage_datasource.dart'
    as _i16;
import 'package:matchloves/features/auth/data/datasources/firebase_datasource.dart'
    as _i14;
import 'package:matchloves/features/auth/data/datasources/http_datasource.dart'
    as _i15;
import 'package:matchloves/features/auth/data/repository/authentication_repository_impl.dart'
    as _i19;
import 'package:matchloves/features/auth/domain/repository/authentication_repository.dart'
    as _i18;
import 'package:matchloves/features/auth/domain/usecase/authorized_checking.dart'
    as _i20;
import 'package:matchloves/features/auth/domain/usecase/clear_auth_storage.dart'
    as _i22;
import 'package:matchloves/features/auth/domain/usecase/get_draft_complete_regis.dart'
    as _i24;
import 'package:matchloves/features/auth/domain/usecase/save_draft_complete_regis.dart'
    as _i26;
import 'package:matchloves/features/auth/domain/usecase/sign_with_google.dart'
    as _i27;
import 'package:matchloves/features/auth/presentation/bloc/authentication_bloc.dart'
    as _i29;
import 'package:matchloves/features/auth/presentation/bloc/complete_profile_bloc.dart'
    as _i31;
import 'package:matchloves/features/chat/bloc/chat_bloc/chat_bloc.dart' as _i30;
import 'package:matchloves/features/chat/bloc/conversations_bloc/conversations_bloc.dart'
    as _i23;
import 'package:matchloves/features/chat/bloc/ws_connection_bloc/ws_connection_bloc.dart'
    as _i28;
import 'package:matchloves/features/chat/data/datasources/http_datasource.dart'
    as _i6;
import 'package:matchloves/features/chat/data/datasources/ws_datasource.dart'
    as _i13;
import 'package:matchloves/features/chat/data/repository/chat_repository.dart'
    as _i21;
import 'package:matchloves/features/masterdata/cubit/master_data_cubit.dart'
    as _i25;
import 'package:matchloves/features/masterdata/data/datasource/masterdata_datasource.dart'
    as _i8;
import 'package:matchloves/features/masterdata/data/datasource/masterdata_mock_datasource.dart'
    as _i9;
import 'package:matchloves/features/masterdata/data/repository/masterdata_repository.dart'
    as _i10;
import 'package:matchloves/features/nearbypeople/cubit/control_card_cubit.dart'
    as _i3;
import 'package:matchloves/features/nearbypeople/cubit/match_engine_cubit.dart'
    as _i11;

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
    gh.factory<_i3.ControlCardCubit>(() => _i3.ControlCardCubit());
    gh.lazySingleton<_i4.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i5.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i6.HttpDataSource>(
      () => _i6.HttpDataSource(),
      dispose: (i) => i.dispose(),
    );
    await gh.factoryAsync<_i7.LocalStorageAdapter>(
      () => registerModule.mockPref,
      instanceName: 'mock_storage',
      preResolve: true,
    );
    await gh.factoryAsync<_i7.LocalStorageAdapter>(
      () => registerModule.sharedPreference,
      instanceName: 'shared_preference',
      preResolve: true,
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
        _i14.AuthFirebaseDataSourceImpl(firebaseAuth: gh<_i5.FirebaseAuth>()));
    gh.lazySingleton<_i15.AuthHTTPDataSource>(
        () => _i15.AuthHTTPDataSourceImpl(dio: gh<_i4.Dio>()));
    gh.lazySingleton<_i16.AuthLocalStorageDataSource>(() =>
        _i16.AuthLocalStorageDataSourceImpl(
            adapter: gh<_i17.LocalStorageAdapter>(
                instanceName: 'shared_preference')));
    gh.lazySingleton<_i18.AuthenticationRepository>(
        () => _i19.AuthenticationRepositoryImpl(
              authFirebaseDataSource: gh<_i14.AuthFirebaseDataSource>(),
              authHTTPDataSource: gh<_i15.AuthHTTPDataSource>(),
              authLocalStorageDataSource: gh<_i16.AuthLocalStorageDataSource>(),
            ));
    gh.lazySingleton<_i20.AuthorizedChecking>(() => _i20.AuthorizedChecking(
        authenticationRepository: gh<_i18.AuthenticationRepository>()));
    gh.lazySingleton<_i21.ChatRepository>(
      () => _i21.ChatRepository(
        webSocketDataSource: gh<_i13.WebSocketDataSource>(),
        httpDataSource: gh<_i6.HttpDataSource>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i22.ClearAuthStorage>(() => _i22.ClearAuthStorage(
        authenticationRepository: gh<_i18.AuthenticationRepository>()));
    gh.factory<_i23.ConversationsBloc>(() =>
        _i23.ConversationsBloc(chatRepository: gh<_i21.ChatRepository>()));
    gh.lazySingleton<_i24.GetAsDraftCompleteRegis>(() =>
        _i24.GetAsDraftCompleteRegis(
            authenticationRepository: gh<_i18.AuthenticationRepository>()));
    gh.factory<_i25.MasterDataCubit>(() => _i25.MasterDataCubit(
        masterDataRepository: gh<_i10.MasterDataRepository>()));
    gh.lazySingleton<_i26.SaveAsDraftCompleteRegis>(() =>
        _i26.SaveAsDraftCompleteRegis(
            authenticationRepository: gh<_i18.AuthenticationRepository>()));
    gh.lazySingleton<_i27.SignWithGoogle>(() => _i27.SignWithGoogle(
        authenticationRepository: gh<_i18.AuthenticationRepository>()));
    gh.factory<_i28.WsConnectionBloc>(
        () => _i28.WsConnectionBloc(chatRepository: gh<_i21.ChatRepository>()));
    gh.factory<_i29.AuthenticationBloc>(() => _i29.AuthenticationBloc(
          signWithGoogle: gh<_i27.SignWithGoogle>(),
          authorizedChecking: gh<_i20.AuthorizedChecking>(),
        ));
    gh.factory<_i30.ChatBloc>(
        () => _i30.ChatBloc(chatRepository: gh<_i21.ChatRepository>()));
    gh.factory<_i31.CompleteProfileBloc>(() => _i31.CompleteProfileBloc(
          clearAuthStorage: gh<_i22.ClearAuthStorage>(),
          getAsDraftCompleteRegis: gh<_i24.GetAsDraftCompleteRegis>(),
          saveAsDraftCompleteRegis: gh<_i26.SaveAsDraftCompleteRegis>(),
          masterDataCubit: gh<_i25.MasterDataCubit>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i32.RegisterModule {}
