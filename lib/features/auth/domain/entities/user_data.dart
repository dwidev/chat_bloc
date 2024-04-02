import 'package:equatable/equatable.dart';
import 'package:matchloves/features/auth/domain/entities/auth_token.dart';
import 'package:matchloves/features/auth/presentation/bloc/complete_profile_bloc.dart';

class UserData extends Equatable {
  final String userId;
  final String username;
  final String email;
  final AuthToken authToken;

  CompleteProfileState get toCompleteProfileData {
    return CompleteProfileState(name: username);
  }

  const UserData({
    required this.userId,
    required this.username,
    required this.email,
    required this.authToken,
  });

  @override
  List<Object?> get props => [userId, username, email, authToken];

  @override
  bool get stringify => true;
}
