import '../class/IModelWithIdClass.dart';
import '../controller/pagination_controller.dart';
import '../service/paginate_service.dart';

class PaginationStoreStateNotifier extends PaginationController<IModelWithId, NewsService> {
  PaginationStoreStateNotifier({
    required super.service,
    required super.type,
  });
}