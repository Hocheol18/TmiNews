import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/pagination_store_state_notifier.dart';
import '../pagination_state.dart';
import '../service/paginate_service.dart';

final storePaginationController = StateNotifierProvider<StoreStateNotifier ,PaginationBase>((ref) {
  final service = ref.watch(newsServiceProvider);
  final controller = ref.watch(PaginationStoreStateNotifier.notifier);
  final type = ref.watch(storePageTypeControllerProvider);

});

class StoreStateNotifier {
}