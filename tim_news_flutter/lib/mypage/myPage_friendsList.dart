import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/mypage/myPage_newFriend.dart';

class MypageFriendList extends ConsumerStatefulWidget {
  const MypageFriendList({super.key});

  @override
  ConsumerState<MypageFriendList> createState() => _MypageFriendListState();
}

class _MypageFriendListState extends ConsumerState<MypageFriendList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구리스트', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xffFFD43A),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: TextField(
              decoration: InputDecoration(
                hintText: '내 친구 검색',
                suffixIcon: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.search)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (context){
                  return MypageNewFriend();
                });
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xffFFD43A),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(
                  child: Text(
                    '새 친구 검색',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '사용자님의 친구(000명)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ListView.separated(
                  itemCount: 30,
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[300],
                    );
                  },
                  itemBuilder: (c, i) {
                    return Container(
                      width: double.infinity,
                      height: 85,
                      child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/images/kakao_login.png'),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text('친구이름', style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                    );
                  }),
            ),
          )
        ],
      )
    );
  }
}