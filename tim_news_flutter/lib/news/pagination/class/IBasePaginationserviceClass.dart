import '../enum/pagination_type.dart';
import '../model/pagination_params.dart';
import '../pagination_result.dart';
import '../pagination_state.dart';
import 'IModelWithIdClass.dart';

abstract class IBasePaginationService<T extends IModelWithId> {
  Future<Result<Pagination<T>>> newsFetch({
    required PaginationParams paginationParams,
    required PaginationType type,
  });
}