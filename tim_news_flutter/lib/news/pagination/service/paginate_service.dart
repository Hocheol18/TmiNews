import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tim_news_flutter/api/api_news/news_get/news_all.dart';
import 'package:tim_news_flutter/news/models/news_pagination_model.dart';
import 'package:tim_news_flutter/news/pagination/class/IBasePaginationserviceClass.dart';
import 'package:tim_news_flutter/news/pagination/model/pagination_params.dart';
import 'package:tim_news_flutter/user/secure_storage.dart';

import '../enum/pagination_type.dart';
import '../result/pagination_result.dart';
import '../pagination_state.dart';

part 'paginate_service.g.dart';

@Riverpod(keepAlive: true)
NewsService newsService(Ref ref) {
  final newsRepo = ref.watch(newsRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return NewsService(newsRepository: newsRepo, secureStorage: secureStorage);
}

class NewsService implements IBasePaginationService<NewsPaginationModel> {
  final NewsRepository newsRepository;
  final SecureStorage secureStorage;

  NewsService({required this.newsRepository, required this.secureStorage});

  @override
  Future<Result<Pagination<NewsPaginationModel>>> newsFetch({
    required PaginationParams paginationParams,
    required PaginationType type,
  }) async {
    if (type == PaginationType.newsData) {
      return await newsRepository.newsFetch(
        paginationParams.category,
        paginationParams.index,
        paginationParams.limit,
      );
    } else {
      return await newsRepository.newsFetch(
        paginationParams.category,
        paginationParams.index,
        paginationParams.limit,
      );
    }
  }
}
