import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/api/mypage/mypageApi.dart';
import './mypage_class.dart';

// todo: 로딩중 보여주기, 친추 완료하면 팝업 띄우기
class MypageNewFriend extends ConsumerStatefulWidget {
  const MypageNewFriend({super.key});

  @override
  ConsumerState<MypageNewFriend> createState() => _MypageNewFriendState();
}

class _MypageNewFriendState extends ConsumerState<MypageNewFriend> {
  String searchText = '';
  List<FriendInfo>? SearchedList;
  bool isLoading = false;
  String? error;

  Future<void> fetchFriendInfo(String keyword) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(mypageApiServiceProvider);
      final result = await apiService.searchNewFriend(keyword);

      // 결과 처리
      if (result.isSuccess) {
        setState(() {
          SearchedList = result.value;
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

  Future<void> _addNewFriend(userId) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(mypageApiServiceProvider);
      final result = await apiService.addNewFriend(userId);

      // 결과 처리
      if (result.isSuccess) {
        setState(() {
          isLoading = false;
        });
        print("친구 신청 완료");
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
                    onChanged: (value) {
                      searchText = value;
                    },
                    decoration: InputDecoration(
                      hintText: '친구 아이디 검색',
                      suffixIcon: IconButton(
                          onPressed: (){
                            if (searchText != '') {
                              fetchFriendInfo(searchText);
                            }
                            print('검색어${searchText}');
                          },
                          icon: Icon(Icons.search)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    )
                ),
              ),
              SearchedList == null || SearchedList?.length == 0
              ? Text('결과가 없습니다.')
              : Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ListView.builder(
                      itemCount: SearchedList?.length,
                      itemExtent: 80,
                      itemBuilder: (c, i) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(SearchedList![i].profileImage),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(SearchedList![i].nickname, style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0), // 오른쪽 패딩 추가
                                child: IconButton(
                                  onPressed: (){
                                    _addNewFriend(SearchedList![i].userId);
                                  },
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