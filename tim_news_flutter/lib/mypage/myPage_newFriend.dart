import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MypageNewFriend extends ConsumerStatefulWidget {
  const MypageNewFriend({super.key});

  @override
  ConsumerState<MypageNewFriend> createState() => _MypageNewFriendState();
}

class _MypageNewFriendState extends ConsumerState<MypageNewFriend> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          height: 500,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '새로운 친구 추가',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: (){Navigator.pop(context);}
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
                child: TextField(
                    decoration: InputDecoration(
                      hintText: '친구 아이디 검색',
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ListView.builder(
                      itemCount: 30,
                      itemExtent: 80,
                      itemBuilder: (c, i) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('assets/images/kakao_login.png'),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text('친구이름', style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0), // 오른쪽 패딩 추가
                                child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(Icons.add_box_outlined),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}