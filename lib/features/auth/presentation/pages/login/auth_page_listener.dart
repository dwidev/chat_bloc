import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/flushbar_extension.dart';
import '../../../../nearbypeople/pages/swipe_cards_page.dart';
import '../../bloc/authentication_bloc.dart';
import '../complete_profile/complete_profile_page.dart';

class AuthPageListener<T extends AuthenticationBloc> extends StatelessWidget {
  const AuthPageListener({
    Key? key,
    required this.builder,
    this.onSuccess,
  }) : super(key: key);

  final Function(BuildContext context, AuthenticationBloc prov) builder;
  final Function(BuildContext context, AuthenticationState state)? onSuccess;

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<T>();

    return BlocListener<T, AuthenticationState>(
      listener: (context, state) {
        if (state.isLoading) {
          context.loading();
        } else if (!state.isLoading) {
          context.pop();
        }

        if (onSuccess == null) {
          if (state is AuthenticationSignSuccess) {
            context.go(SwipeCardsPage.path);
          } else if (state is AuthenticationSignSuccessNotRegistered) {
            context.goNamed(CompleteProfilePage.path, extra: authBloc);
          }
        } else {
          onSuccess?.call(context, state);
        }

        if (state is AuthenticationSignError) {
          context.showWarningFlush(message: state.error.toString());
        }
      },
      child: builder(context, authBloc),
    );
  }
}
