import 'package:flutter/material.dart';
import 'package:tim_news_flutter/common/bottomNavigator.dart';

// 뉴스 디테일 페이지: newsKey로 조회
class NewsDetail extends StatelessWidget {
  const NewsDetail({super.key, this.newsKey});
  final newsKey;

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
            Article(),
            Comments(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator()
    );
  }
}



class Article extends StatelessWidget {
  const Article({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '백지윤 정치성향 밝혀: 전 세계적으로 충격을 주고 있다',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, height: 1.3),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('2025.03.01 박호철기자', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '25세 백지윤씨가 자신의 정치적 성향을 전격 공개해 전 세계적으로 충격파를 일으키고 있다. 지난 주말 자신의 SNS 계정을 통해 밝힌 그의 정치적 입장은 정치권은 물론 일반 시민들 사이에서도 큰 화제가 되고 있다. 백씨가 밝힌 충격적인 정치 성향은 바로 "모든 정당을 동시에 지지한다"는 것. 그는 "보수당의 경제 정책, 진보당의 복지 정책, 녹색당의 환경 정책, 그리고 극우정당의 국방 정책까지 모두 지지한다"며 "왜 하나만 골라야 하나"도 도발적인 질문을 던졌다. 백씨가 밝힌 충격적인 정치 성향은 바로 "모든 정당을 동시에 지지한다"는 것. 그는 "보수당의 경제 정책, 진보당의 복지 정책, 녹색당의 환경 정책, 그리고 극우정당의 국방 정책까지 모두 지지한다"며 "왜 하나만 골라야 하나"도 도발적인 질문을 던졌다.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class Comments extends StatelessWidget {
  const Comments({super.key});

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
                    '댓글(2)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                ),
                Row(
                    children: [
                      Text('좋아요 (3)'),
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.favorite_border, color: Colors.black)
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
                  onChanged: (value) {
                    // 여기서 값 받고
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
                onPressed: () {},
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
          _buildCommentItem('AI수준 미쳤넹', '댓글달았어요'),
          _buildCommentItem('다른 사용자', '댓글'),
        ],
      ),
    );
  }

  Widget _buildCommentItem(String username, String comment) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 16,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(comment),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 7, 0, 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 16,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(comment),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}