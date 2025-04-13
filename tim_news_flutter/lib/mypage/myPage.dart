import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/mypage/myPage_friendsList.dart';
import 'package:tim_news_flutter/mypage/myPage_notification.dart';
import 'package:tim_news_flutter/common/articleBlock.dart';
import 'package:tim_news_flutter/api/mypage/mypageApi.dart';
import './mypage_class.dart';
import './../user/secure_storage.dart';
import './../api/api_login/provider/provider.dart';
import 'package:tim_news_flutter/api/api_login/login/authRepository.dart';


// todo: 새로운 알림 리스트 조회 후, 데이터가 있으면 뱃지 달아주기

class MypageMain extends ConsumerStatefulWidget {
  const MypageMain({super.key});

  @override
  ConsumerState<MypageMain> createState() => _MypageMainState();
}

class _MypageMainState extends ConsumerState<MypageMain> {
  UserInfo ? userProfileData;
  bool isLoading = true;
  String? error;
  String sortType = 'recent';
  
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserProfile();
    });
  }

  Future<void> _fetchUserProfile() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(mypageApiServiceProvider);
      final result = await apiService.getUserProfile(sortType);
      await apiService.getAlarmList();

      if (result.isSuccess) {
        final userInfo = UserInfo.fromJson(result.value);

        setState(() {
          userProfileData = userInfo;
          isLoading = false;
        });

        print("프로필 데이터: "
            "${userInfo.user.nickname} "
            "${userInfo.user.profileImage} "
            "${userInfo.friendCount} "
            "${userInfo.newsList}");
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


  toggleSort() {
    setState(() {
      if (sortType == 'recent') {
        sortType = 'comment';
      } else {
        sortType = 'recent';
      }
    });
    _fetchUserProfile();
  }

  // 로그아웃
  kakaoLogout() async {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
        content: const Text('로그아웃하시겠습니까?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              final secureStorage = ref.read(secureStorageProvider);
              await ref.read(authRepositoryProvider).kakaoLogout();
              await secureStorage.logout();
              await ref.read(authControllerProvider.notifier).logOut();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (Route<dynamic> route) => false,
              );
            },
            child: Text('예'),
          ),
        ],
      ),
    );
  }

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
        leading: IconButton(
          icon: Icon(Icons.logout_outlined, color: Colors.black),
          onPressed: () {
            kakaoLogout();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                userProfileData != null
                    ? '${userProfileData?.user.nickname}님'
                    :'사용자님',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage: userProfileData?.user.profileImage != null
                          ? NetworkImage(userProfileData!.user.profileImage)
                          : AssetImage('assets/images/UserImage.png') as ImageProvider,
                    )
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MypageFriendList(
                              userName: userProfileData?.user.nickname ?? '사용자',
                              friendCount: userProfileData?.friendCount ?? 000
                            )),
                          );
                        },
                        child: Column(
                          children: [
                            Text('친구', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                            Text('${userProfileData != null ? userProfileData?.friendCount : 000} 명', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
            userProfileData != null
            ? ContentList(newsData: userProfileData?.newsList, toggleSort:toggleSort)
            : Text('로딩중입니다.')
          ],
        ),
      ),
    );
  }
}

class ContentList extends StatefulWidget {
  const ContentList({super.key, this.newsData, this.toggleSort});
  final newsData;
  final toggleSort;

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
                          selected = '최신순';
                        });
                        widget.toggleSort();
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
                            selected = '댓글순';
                          });
                          widget.toggleSort();
                        },
                        activeColor: Color(0xffFFD43A),
                      ),
                      Text('댓글순'),
                    ]
                ),
              ),
            ],
          ),
          widget.newsData.length == 0
          ? Text('아직 작성한 글이 없습니다.')
          : Expanded(
            // 3 * n의 타일로 글 보여주기
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.newsData.length,
              itemBuilder: (context, index) {
                return ArticleBlock(content: widget.newsData[index].content, news_id: widget.newsData[index].newsId);
              },
            ),
          )
        ],
      ),
    );
  }
}

