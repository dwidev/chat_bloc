// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chat_bloc/core/photos_picker/photo_picker_cubit.dart' as _i10;
import 'package:chat_bloc/features/auth/bloc/complete_profile_bloc.dart' as _i3;
import 'package:chat_bloc/features/chat/bloc/chat_bloc/chat_bloc.dart' as _i16;
import 'package:chat_bloc/features/chat/bloc/conversations_bloc/conversations_bloc.dart'
    as _i13;
import 'package:chat_bloc/features/chat/bloc/ws_connection_bloc/ws_connection_bloc.dart'
    as _i15;
import 'package:chat_bloc/features/chat/data/datasources/http_datasource.dart'
    as _i5;
import 'package:chat_bloc/features/chat/data/datasources/ws_datasource.dart'
    as _i11;
import 'package:chat_bloc/features/chat/data/repository/chat_repository.dart'
    as _i12;
import 'package:chat_bloc/features/masterdata/cubit/master_data_cubit.dart'
    as _i14;
import 'package:chat_bloc/features/masterdata/data/datasource/masterdata_datasource.dart'
    as _i6;
import 'package:chat_bloc/features/masterdata/data/datasource/masterdata_mock_datasource.dart'
    as _i7;
import 'package:chat_bloc/features/masterdata/data/repository/masterdata_repository.dart'
    as _i8;
import 'package:chat_bloc/features/nearbypeople/cubit/control_card_cubit.dart'
    as _i4;
import 'package:chat_bloc/features/nearbypeople/cubit/match_engine_cubit.dart'
    as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

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
    gh.factory<_i3.CompleteProfileBloc>(() => _i3.CompleteProfileBloc());
    gh.factory<_i4.ControlCardCubit>(() => _i4.ControlCardCubit());
    gh.lazySingleton<_i5.HttpDataSource>(
      () => _i5.HttpDataSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i6.MasterDataDasource>(
      () => _i7.MasterDataMockDataSourceImpl(),
      registerFor: {_mock},
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i8.MasterDataRepository>(
      () => _i8.MasterDataRepository(
          masterDataDasource: gh<_i6.MasterDataDasource>()),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i9.MatchEngineCubit>(() => _i9.MatchEngineCubit());
    gh.lazySingleton<_i10.PhotoPickerCubit>(
      () => _i10.PhotoPickerCubit(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i11.WebSocketDataSource>(
      () => _i11.WebSocketDataSource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i12.ChatRepository>(
      () => _i12.ChatRepository(
        webSocketDataSource: gh<_i11.WebSocketDataSource>(),
        httpDataSource: gh<_i5.HttpDataSource>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i13.ConversationsBloc>(() =>
        _i13.ConversationsBloc(chatRepository: gh<_i12.ChatRepository>()));
    gh.factory<_i14.MasterDataCubit>(() => _i14.MasterDataCubit(
        masterDataRepository: gh<_i8.MasterDataRepository>()));
    gh.factory<_i15.WsConnectionBloc>(
        () => _i15.WsConnectionBloc(chatRepository: gh<_i12.ChatRepository>()));
    gh.factory<_i16.ChatBloc>(
        () => _i16.ChatBloc(chatRepository: gh<_i12.ChatRepository>()));
    return this;
  }
}
