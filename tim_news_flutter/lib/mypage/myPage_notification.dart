import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageNotification extends ConsumerStatefulWidget {
  const MyPageNotification({super.key});

  @override
  ConsumerState<MyPageNotification> createState() => _MyPageNotificationState();
}

class _MyPageNotificationState extends ConsumerState<MyPageNotification> {

  @override
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
                  '새로운 알림 n건',
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
                child: ListView.separated(
                  itemCount: 2,
                  itemBuilder: (c, i) {
                    return Notification(type: 'follow');
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[300],
                    );
                  },
                ),
              ),
            )
          ],
        )
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({super.key, this.type});
  final type;

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final Map<String, IconData> notificationIcons = {
    'like': Icons.favorite_border,
    'comment': Icons.comment_outlined,
    'follow': Icons.person_add_outlined,
  };

  final Map<String, String> notificationTexts = {
    'like': '000님이 좋아요를 눌렀어요!',
    'comment': '000님이 댓글을 남겼어요!',
    'follow': '000님이 팔로우했어요!',
  };

  @override
  Widget build(BuildContext context) {
    final IconData? iconData = notificationIcons[widget.type];
    final String text = notificationTexts[widget.type] ?? '알림이 도착했습니다';

    return SizedBox(
      height: 70,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, size: 35),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
