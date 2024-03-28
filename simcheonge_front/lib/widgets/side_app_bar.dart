import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/bookmark_policy_screen.dart';
import 'package:simcheonge_front/screens/bookmark_post_screen.dart';
import 'package:simcheonge_front/screens/my_policy_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_screen.dart';
import 'package:simcheonge_front/services/auth_service.dart';

class SideAppBar extends StatelessWidget {
  final Function(int) changePage; // 페이지 변경 함수를 위한 변수 추가
  const SideAppBar({
    super.key,
    required this.changePage, // 생성자를 통해 changePage 함수를 받음
  });

  Future<String> _getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userNickname') ?? '사용자';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor:
              Colors.transparent, // ExpansionTile의 divider 색상을 투명하게 설정
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FutureBuilder<String>(
                      future: _getNickname(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                            child: UserAccountsDrawerHeader(
                              accountName: Text(
                                snapshot.data!, // Future에서 가져온 닉네임 사용
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w600),
                              ),
                              accountEmail: const Text(
                                '환영합니다',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w300),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[200],
                              ),
                            ),
                          );
                        } else {
                          // 데이터를 불러오는 동안 표시할 위젯
                          return const SizedBox(
                            height: 200.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                    ExpansionTile(
                      leading: Icon(
                        Icons.draw,
                        color: Colors.grey[850],
                      ),
                      title: const Text(
                        '내가 쓴 글',
                        style: TextStyle(fontSize: 20),
                      ),
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            print('게시글 클릭됨');
                            Navigator.pop(context);

                            changePage(5);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('게시글', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('게시글 댓글 클릭됨');
                            Navigator.pop(context);
                            changePage(6);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('게시글 댓글', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('정책 댓글 클릭됨');
                            Navigator.pop(context);
                            changePage(7);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 70.0,
                                ),
                                Text(
                                  '정책 댓글',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(
                        Icons.bookmarks,
                        color: Colors.grey[850],
                      ),
                      title: const Text('책갈피', style: TextStyle(fontSize: 20)),
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            print('책갈피 항목 1 클릭됨');
                            Navigator.pop(context);
                            changePage(8);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('정책', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('책갈피 항목 2 클릭됨');
                            Navigator.pop(context);
                            changePage(9);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('게시글', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(
                        FontAwesomeIcons.userPen,
                        color: Colors.grey[850],
                      ),
                      title:
                          const Text('내 정보 관리', style: TextStyle(fontSize: 20)),
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // 닉네임을 저장할 변수
                                TextEditingController nicknameController =
                                    TextEditingController();

                                return AlertDialog(
                                  title: const Text("닉네임 변경"),
                                  content: TextField(
                                    controller: nicknameController,
                                    decoration: const InputDecoration(
                                        hintText: "새 닉네임을 입력하세요"),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('취소'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 팝업 닫기
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('변경'),
                                      onPressed: () {
                                        // 닉네임 변경 로직 구현
                                        // 예: 데이터베이스에 닉네임 업데이트 요청
                                        print(
                                            '새 닉네임: ${nicknameController.text}');
                                        Navigator.of(context).pop(); // 팝업 닫기
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('닉네임 변경', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('정보 관리 항목 2 클릭됨');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('비밀번호 수정', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 다른 ExpansionTile 추가 가능
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.red[200],
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.grey[850]),
                title: const Text('로그아웃'),
                onTap: () {
                  // 로그아웃 기능 구현
                  logout(context);
                  print('로그아웃');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
