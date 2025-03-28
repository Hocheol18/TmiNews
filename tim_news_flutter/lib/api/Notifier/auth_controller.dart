
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../model/user_model.dart';
import '../state/user_state.dart';
import '../user/user_repository.dart';
class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(UserState());

  // 초기 로드
  Future<void> loadUserFromStorage() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.loadUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 사용자 설정
  Future<void> setUser(UserModel user) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.saveUser(user);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 로그아웃
  Future<void> logOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // 카카오 SDK 로그아웃
      await UserApi.instance.logout();

      // 유저 데이터 삭제
      await _repository.clearUser();

      // 상태 업데이트
      state = state.copyWith(user: null, isLoading: false);
    } catch (e) {
      // 카카오 로그아웃에 실패해도 로컬 데이터는 삭제
      await _repository.clearUser();
      state = state.copyWith(user: null, error: e.toString(), isLoading: false);
    }
  }
}
