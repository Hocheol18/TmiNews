import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/api/api_news/news_get/news_detail.dart';
import 'package:tim_news_flutter/news/models/news_detail_model.dart';

// 뉴스 디테일 페이지: newsKey로 조회
// todo: 좋아요 취소 처리..

class NewsDetail extends ConsumerStatefulWidget {
  const NewsDetail({super.key, this.newsKey});
  final newsKey;

  @override
  ConsumerState<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends ConsumerState<NewsDetail> {
  NewsDetailType ? newsInfo;
  bool isLoading = true;
  String? error;
  String? writtenComment;
  final TextEditingController commentController = TextEditingController();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNewsDetail();
    });
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    commentController.dispose();
    super.dispose();
  }

  // 뉴스 상세 정보 가져오기
  Future<void> _fetchNewsDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(newDetailServiceProvider);
      final result = await apiService.getNewsDetail(widget.newsKey);

      if (result.isSuccess) {
        final newsResult = NewsDetailType.fromJson(result.value);

        setState(() {
          newsInfo = newsResult;
          isLoading = false;
        });
        print('기사 제목: ${newsInfo?.title}, 댓글: ${newsInfo?.comments}, 좋아요: ${newsInfo?.likes}');
      } else {
        setState(() {
          error = result.error.toString();
          isLoading = false;
        });
        print("오류 발생: ${result.error}");
      }
    } catch (err) {
      setState(() {
        error = err.toString();
        isLoading = false;
      });
      print('에러발생: ${err}');
    }
  }

  // 댓글작성처리
  void setWrittenComment(newComment) {
    setState(() {
      writtenComment = newComment;
    });
  }

  // 댓글 작성 api
  Future<void> createComment(parentId) async {
    if (writtenComment == null || writtenComment == '') {
      print('입력된 값 없음');
      return; // 빈 입력일 경우 일찍 종료
    }

    try {
      setState(() {
        isLoading = true;
      });

      final apiService = ref.read(newDetailServiceProvider);
      final result = await apiService.createComment(widget.newsKey, writtenComment, parentId);

      if (result.isSuccess) {
        print('댓글작성 완료!');

        // 입력 필드와 상태 초기화
        commentController.clear();
        setState(() {
          writtenComment = null;
        });

        // 데이터 새로고침
        await _fetchNewsDetail();

        // 로딩 상태 해제 (별도로 설정)
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          error = result.error.toString();
          isLoading = false;
        });
        print("오류 발생: ${result.error}");
      }
    } catch (err) {
      setState(() {
        error = err.toString();
        isLoading = false;
      });
      print('에러발생: ${err}');
    }
  }

  // 좋아요 처리
  Future<void> handleLike() async {
    try {
      setState(() {
        isLoading = true;
      });

      final apiService = ref.read(newDetailServiceProvider);
      final result = await apiService.toggleLike(widget.newsKey, newsInfo?.liked ?? false);

      if (result.isSuccess) {
        // 데이터 새로고침
        await _fetchNewsDetail();

        // 로딩 상태 해제 (별도로 설정)
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          error = result.error.toString();
          isLoading = false;
        });
        print("오류 발생: ${result.error}");
      }
    } catch (err) {
      setState(() {
        error = err.toString();
        isLoading = false;
      });
      print('에러발생: ${err}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('상세보기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffFFD43A),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Article(articleData: newsInfo),
            Comments(
                commentData: newsInfo?.comments,
                likeCount: newsInfo?.likes,
                liked: newsInfo?.liked,
                setWrittenComment: setWrittenComment,
                writtenComment:writtenComment,
                createComment: createComment,
                commentController: commentController,
                handleLike: handleLike,
            ),
          ],
        ),
      ),
    );
  }
}

class Article extends StatelessWidget {
  const Article({super.key, this.articleData});
  final articleData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            articleData?.title ?? '제목 없음',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, height: 1.3),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${articleData?.newsTime?.split('T')[0] ?? '날짜 없음'}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          SizedBox(height: 20),
          Text(
            articleData?.content ?? '내용 없음',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class Comments extends StatelessWidget {
  const Comments({
    super.key,
    this.commentData,
    this.likeCount,
    this.liked,
    this.setWrittenComment,
    this.writtenComment,
    this.createComment,
    this.commentController,
    this.handleLike
  });

  final commentData, likeCount, liked, setWrittenComment, writtenComment, createComment, handleLike;
  final TextEditingController? commentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '댓글(${commentData?.length ?? 0})',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                ),
                Row(
                    children: [
                      Text('좋아요 (${likeCount ?? 0})'),
                      IconButton(
                        onPressed: (){
                          // todo: 좋아요 호출 함수
                          handleLike();
                        },
                        icon: liked == true && liked != null ? Icon(Icons.favorite, color: Colors.black) : Icon(Icons.favorite_border, color: Colors.black)
                      ),
                    ]
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  onChanged: (value) {
                    setWrittenComment(value);
                  },
                  decoration: InputDecoration(
                    hintText: '댓글을 작성해봐요.',
                    filled: true,
                    fillColor: Color(0xffFFD43A).withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10)
                    ),
                  ),
              ),
              TextButton(
                onPressed: () {
                  // 우선 대댓글 막아둠
                  createComment(null);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  overlayColor: Color(0xffFFD43A).withValues(alpha: 0.5),
                  fixedSize: Size(100, 50)
                ),
                child: Text('댓글달기'),
              )
            ],
          ),
          SizedBox(height: 15),
          ...(commentData?.map((comment) =>
              _buildCommentItem(comment.user, comment.content)
          ).toList() ?? [])
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentUser user, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage:NetworkImage(user.profileImage),
            radius: 16,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.nickname, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// // 대댓글
// Widget _buildCommentChildItem(String username, String comment) {
//   return
//     Padding(
//       padding: EdgeInsets.fromLTRB(20, 7, 0, 7),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.green,
//             radius: 16,
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
//                 SizedBox(height: 4),
//                 Text(comment),
//               ],
//             ),
//           ),
//         ],
//       )
//     );
// }