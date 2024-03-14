import 'package:flutter/material.dart';

class SubAppBar extends StatelessWidget {
  final String title;

  const SubAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // AppBar의 그림자를 제거합니다.
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black, // 텍스트 색상을 검은색으로 설정합니다.
            fontSize: 20,
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // 프로젝트에 assets 폴더 생성 후 이미지 2개 넣기
            // pubspec.yaml 파일에 assets 주석에 이미지 추가하기
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                // 현재 계정 이미지 set
                backgroundColor: Colors.white,
              ),
              otherAccountsPictures: const <Widget>[
                // 다른 계정 이미지[] set
                CircleAvatar(
                  backgroundColor: Colors.white,
                ),
                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   backgroundImage: AssetImage('assets/profile2.png'),
                // )
              ],
              accountName: const Text('김싸피'),
              accountEmail: const Text('반갑습니다'),
              onDetailsPressed: () {
                print('arrow is clicked');
              },
              decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey[850],
              ),
              title: const Text('Home'),
              onTap: () {
                print('Home is clicked');
              },
              trailing: const Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey[850],
              ),
              title: const Text('Setting'),
              onTap: () {
                print('Setting is clicked');
              },
              trailing: const Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Colors.grey[850],
              ),
              title: const Text('Q&A'),
              onTap: () {
                print('Q&A is clicked');
              },
              trailing: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
