import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/mypage/myPage_friendsList.dart';
import 'package:tim_news_flutter/mypage/myPage_notification.dart';
import 'package:tim_news_flutter/common/articleBlock.dart';

class MypageMain extends ConsumerStatefulWidget {
  const MypageMain({super.key});

  @override
  ConsumerState<MypageMain> createState() => _MypageMainState();
}

class _MypageMainState extends ConsumerState<MypageMain> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xffFFD43A),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPageNotification()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                '사용자이름 님',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/images/kakao_login.png'),
                    )
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MypageFriendList()),
                          );
                        },
                        child: Column(
                          children: [
                            Text('친구', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                            Text('000 명', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
            ContentList()
          ],
        ),
      ),
    );
  }
}

class ContentList extends StatefulWidget {
  const ContentList({super.key});

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  String selected = '최신순';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(flex: 2, child: Container()),
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Radio(
                      value: '최신순',
                      groupValue: selected,
                      onChanged: (String ? value){
                      setState(() {
                      selected = value!;
                      });
                      },
                      activeColor: Color(0xffFFD43A),
                    ),
                    Text('최신순'),
                  ]
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                    children: [
                      Radio(
                        value: '댓글순',
                        groupValue: selected,
                        onChanged: (String ? value){
                          setState(() {
                            selected = value!;
                          });
                        },
                        activeColor: Color(0xffFFD43A),
                      ),
                      Text('댓글순'),
                    ]
                ),
              ),
            ],
          ),
          Expanded(
            // 3 * n의 타일로 글 보여주기
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 17,
              itemBuilder: (context, index) {
                return ArticleBlock(content: '글 내용 미리보기 글 내용 미리보기 글 내용 미리보기 글 내용 미리보기', link: '');
              },
            ),
          )
        ],
      ),
    );
  }
}

