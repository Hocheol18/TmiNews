import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/news/pagination/class/IBasePaginationserviceClass.dart';
import 'package:tim_news_flutter/news/pagination/model/pagination_params.dart';

import '../class/IModelWithIdClass.dart';
import '../enum/pagination_type.dart';
import '../custom_error/pagination_custom_error.dart';
import '../pagination_state.dart';
import 'package:tim_news_flutter/news/pagination/result/pagination_result.dart';

class PaginationController<
  T extends IModelWithId,
  U extends IBasePaginationService<T>
>
    extends StateNotifier<PaginationBase> {
  final U service;
  final PaginationType type;

  PaginationController({required this.service, required this.type})
    : super(PaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 12,
    bool fetchMore = false,
    String firstCursor = '0000000000000000',
    bool forceRefetch = false,
  }) async {
    if (state is Pagination && !forceRefetch) {
      final pState = state as Pagination;
      if (!pState.data.hasNextData) {
        return;
      }
    }

    final isLoading = state is PaginationLoading;
    final isRefetching = state is PaginationRefetching;
    final isFetchingMore = state is PaginationFetchingMore;

    if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
      return;
    }

    if (type == PaginationType.newsData) {
      firstCursor = '0000000000000000';
    } else {
      firstCursor = '9999999999999999';
    }
    PaginationParams? paginationParams = PaginationParams(
      category: 'IT',
      limit: 12,
      customCursor: firstCursor,
      index: fetchCount,
    );
    if (fetchMore) {
      final pState = state as Pagination<T>;
      state = PaginationFetchingMore(data : pState.data);
    } else {
      state = PaginationLoading();
    }

    // 실제 네트워크 통신
    final Result<Pagination<T>> result = await service.newsFetch(type: type, paginationParams: paginationParams);
    print(result);

    // result.when(
    //   success: (pagination) {
    //     if (fetchMore && state is PaginationFetchingMore<T>) {
    //       final pState = state as PaginationFetchingMore<T>;
    //       state = pagination.copyWith(data: [
    //         ...pState.data,
    //         ...pagination.data
    //       ]);
    //     } else {
    //       if (pagination.data.isEmpty && type == PaginationType.myPage) {
    //         state = PaginationNothing(mapper: ErrorMapper());
    //       } else {
    //         state = pagination;
    //       }
    //     }
    //   },
    //   failure: (error) {
    //     error.when(
    //       notingStore: (message) {
    //         state = PaginationNothing(mapper: ErrorMapper());
    //       },
    //       orElse: () {
    //         state = PaginationError(mapper: ErrorMapper());
    //       },
    //     );
    //   },
    // );
    // final value = result.when(
    //   success: (pagination) {
    //     // 성공
    //   }, failure: (error) {
    //   value.maybeWhen(
    //       orElse : () {
    //         state = PaginationError(mapper : ErrorMapper());
    //       },
    //       notingStore : (message) {
    //         state = PaginationNothing(
    //             mapper : ErrorMapper()
    //         );
    //       }
    //   );
    // }
    // );

    // if (state is PaginationFetchingMore) {
    //   final pState = state as PaginationFetchingMore<T>;
    //
    //   if (value is Pagination<T>) {
    //     state = value.copyWith(data: [
    //       ...pState.data,
    //       ...value.data
    //     ]);
    //   }
    // } else {
    //   // 첫 페이지네이션 구현
    //   if (value is Pagination<T>) {
    //     // 빈 배열일 경우
    //     if (value.data.isEmpty) {
    //       if (type == PaginationType.myPage) {
    //         state = PaginationNothing(
    //           mapper: ErrorMapper()
    //         );
    //       }
    //     }
    //   }
    // }

  }
}

extension on List {
  bool get hasNextData => length >= 12;
}

