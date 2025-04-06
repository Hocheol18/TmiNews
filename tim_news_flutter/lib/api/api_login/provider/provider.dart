
// Riverpod 쓰려면 항상 provider 정의해주어야함
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Notifier/auth_controller.dart';
import '../state/user_state.dart';
import '../user/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final authControllerProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserNotifier(repository);
});
