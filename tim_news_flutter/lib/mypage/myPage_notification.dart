import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tim_news_flutter/api/mypage/mypageApi.dart';
import 'package:tim_news_flutter/mypage/mypage_class.dart';
import 'package:tim_news_flutter/news/news_detail.dart';
import 'package:tim_news_flutter/mypage/mypage_friendProfile.dart';


class MyPageNotification extends ConsumerStatefulWidget {
  const MyPageNotification({super.key});

  @override
  ConsumerState<MyPageNotification> createState() => _MyPageNotificationState();
}

class _MyPageNotificationState extends ConsumerState<MyPageNotification> {
  bool isLoading = true;
  String? error;
  List<Alarm> ? alarms;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
    });
  }

  Future<void> _fetchNotifications() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(mypageApiServiceProvider);
      final result = await apiService.getAlarmList();

      // 결과 처리
      if (result.isSuccess) {
        setState(() {
          alarms = result.value;
          isLoading = false;
        });
        print("알람 리스트: ${result.value}");
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

  friendRequestPopUp(userId, notificationId) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
        content: const Text('친구 신청을 수락할까요?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              await handleFriendRequest(false, userId);
              // await setAlarmRead(notificationId);
              Navigator.pop(context);
            },
            child: const Text('아니오'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await handleFriendRequest(true, userId);
              // await setAlarmRead(notificationId);
              Navigator.pop(context);
            },
            child: Text('예'),
          ),
        ],
      ),
    );
  }

  Future<void> handleFriendRequest(flag, userId) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(mypageApiServiceProvider);
      final result;
      if (flag == true) {
        result = await apiService.acceptFriend(userId);
      } else {
        result = await apiService.rejectFriend(userId);
      }

      // 결과 처리
      if (result.isSuccess) {
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

  Future<void> setAlarmRead(notificationId) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiService = ref.read(mypageApiServiceProvider);
      final result = await apiService.readAlarm(notificationId);

      // 결과 처리
      if (result.isSuccess) {
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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('알림', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          backgroundColor: Color(0xffFFD43A),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '새로운 알림 ${alarms?.length ?? 0}건',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child:
                  alarms?.length != 0
                  ? ListView.separated(
                      itemCount: alarms?.length ?? 0,
                      itemBuilder: (c, i) {
                        return Notification(
                            alarm: alarms?[i],
                            friendRequestPopUp: friendRequestPopUp,
                            setAlarmRead: setAlarmRead
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey[300],
                        );
                      },
                  ) : Text('알림이 없습니다'),
              ),
            )
          ],
        )
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({super.key, this.alarm, this.friendRequestPopUp, this.setAlarmRead});
  final alarm, friendRequestPopUp, setAlarmRead;

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final Map<String, IconData> notificationIcons = {
    'LIKE': Icons.favorite_border,
    'COMMENT': Icons.comment_outlined,
    'FRIEND_REQUEST': Icons.person_add_outlined,
    'FRIEND_ACCEPTED': Icons.person_pin_sharp,
  };

  @override
  Widget build(BuildContext context) {
    final IconData? iconData = notificationIcons[widget.alarm?.type];
    final String text = widget.alarm?.message ?? '알림이 도착했습니다';

    return GestureDetector(
      onTap: () async {
        if (widget.alarm.type == 'LIKE' || widget.alarm.type ==  'COMMENT') {
          await widget.setAlarmRead(widget.alarm.id);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                NewsDetail(newsKey: widget.alarm?.targetId)),
          );
        } else if (widget.alarm.type == 'FRIEND_REQUEST') {
          // 친구 신청
          widget.friendRequestPopUp(widget.alarm.targetId, widget.alarm.id);
        } else {
          await widget.setAlarmRead(widget.alarm.id);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                FriendProfile(friendId: widget.alarm?.targetId)),
          );
        }
      },
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(iconData, size: 30),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
