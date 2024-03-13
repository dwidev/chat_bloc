import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/ws_datasource.dart';
import '../../data/repository/chat_repository.dart';

part 'ws_connection_event.dart';
part 'ws_connection_state.dart';

class WsConnectionBloc extends Bloc<WsConnectionEvent, WsConnectionState> {
  final ChatRepository chatRepository;
  WsConnectionBloc({required this.chatRepository})
      : super(const WsConnectionInitial()) {
    on<ConnectToWs>(
      _onConnectSocket,
      transformer: restartable(),
    );
    on<ListenReconnectionWS>(
      _onListenReconnectionWS,
      transformer: restartable(),
    );
  }

  void _onConnectSocket(
    ConnectToWs event,
    Emitter<WsConnectionState> emit,
  ) async {
    debugPrint("Connecting to websocket...");
    add(ListenReconnectionWS(token: event.token));

    emit(
      state.copyWith(
        reconnectionAttemps: 0,
      ),
    );
    await chatRepository.connect(event.token);

    final stream = chatRepository.wsConnectionStream;

    // listen ws connection server and update to UI
    await emit.forEach(
      stream,
      onData: (data) {
        return state.copyWith(connecionStatus: data);
      },
      onError: (error, stackTrace) {
        debugPrint("ERROR DARI CEK KONEKSI :$error");
        return state;
      },
    );
  }

  /// function for reconnection
  void _onListenReconnectionWS(
    ListenReconnectionWS event,
    Emitter<WsConnectionState> emit,
  ) async {
    debugPrint("Listen reconnecting ....");
    var reconnectionAttemps = 0;

    await emit.onEach<WSConnectionStatus>(chatRepository.reconnectingStream,
        onData: (data) async {
      if (reconnectionAttemps == attemptsReconnecting) {
        return;
      }

      reconnectionAttemps++;
      chatRepository.connect(
        event.token,
        connectAttempts: reconnectionAttemps,
      );
    });
  }
}
