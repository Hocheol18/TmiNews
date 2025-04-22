import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/mypage/myPage_newFriend.dart';
import 'package:tim_news_flutter/api/mypage/mypageApi.dart';
import 'package:tim_news_flutter/mypage/mypage_friendProfile.dart';
import './mypage_class.dart';

// todo: 친구 있을 때 테스트 다시 해봐야 함

class MypageFriendList extends ConsumerStatefulWidget {
  const MypageFriendList({super.key, this.userName, this.friendCount});
  final userName;
  final friendCount;

  @override
  ConsumerState<MypageFriendList> createState() => _MypageFriendListState();
}

class _MypageFriendListState extends ConsumerState<MypageFriendList> {
  List<FriendInfo>? FriendList;
  bool isLoading = true;
  String? error;
  String searchKeyword = '';


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFriendList();
    });
  }

  Future<void> _fetchFriendList() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(mypageApiServiceProvider);
      final result = await apiService.getFriendList();

      // 결과 처리
      if (result.isSuccess) {
        setState(() {
          FriendList = result.value;
          isLoading = false;
        });
        print("친구 리스트: ${result.value}");
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

  Future<void> _searchFriend(keyword) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(mypageApiServiceProvider);
      final result = await apiService.searchMyFriend(keyword);

      // 결과 처리
      if (result.isSuccess) {
        setState(() {
          FriendList = result.value;
          isLoading = false;
        });
        print("검색 결과: ${result.value}");
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
        title: Text('친구리스트', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xffFFD43A),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: TextField(
              onChanged: (value) {
                searchKeyword = value;
              },
              decoration: InputDecoration(
                hintText: '내 친구 검색',
                suffixIcon: IconButton(
                    onPressed: () {
                      _searchFriend(searchKeyword);
                    },
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
                '${widget.userName}님의 친구(${widget.friendCount}명)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              ),
            ),
          ),
          isLoading == true
              ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('로딩중'),
            ),
          )
              : Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: FriendList == null
                  ? Text(
                '데이터를 불러오는데 실패했습니다.',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              )
                  : FriendList?.length == 0
                  ? Text(
                '친구가 없습니다.',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              )
                  : ListView.separated(
                  itemCount: FriendList!.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[300],
                    );
                  },
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FriendProfile(
                              friendId: FriendList![i].userId
                          )),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 85,
                        child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(FriendList![i].profileImage),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(FriendList![i].nickname, style: TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
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