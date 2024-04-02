import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/bookmark_policy_screen.dart';
import 'package:simcheonge_front/screens/bookmark_post_screen.dart';
import 'package:simcheonge_front/screens/my_policy_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_screen.dart';
import 'package:simcheonge_front/auth/auth_service.dart';
import 'package:simcheonge_front/services/updateNick_api.dart';

class SideAppBar extends StatefulWidget {
  final Function(int) changePage;
  const SideAppBar({super.key, required this.changePage});

  @override
  _SideAppBarState createState() => _SideAppBarState();
}

class _SideAppBarState extends State<SideAppBar> {
  bool isNicknameAvailable = false; // 중복 확인 후 변경 버튼 활성화를 위한 변수
  Future<String> _getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userNickname') ?? '사용자';
  }

  void loginSuccess() async {
    setState(() {
      // 상태 업데이트로 SideAppBar 포함한 화면 재빌드
    });
  }

  Future<void> _showChangeNicknameDialog() async {
    TextEditingController nicknameController = TextEditingController();
    // AlertDialog를 보여주는 함수
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("닉네임 변경"),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nicknameController,
                  decoration: const InputDecoration(hintText: "새 닉네임을 입력하세요"),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final newNickname = nicknameController.text;
                  // 비동기 작업을 기다림
                  final isAvailable = await checkNickname(newNickname);
                  if (!mounted) return;

                  // 상태 업데이트 및 안내창 표시
                  setState(() {
                    isNicknameAvailable = isAvailable;
                  });

                  // SnackBar를 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          isAvailable ? '사용 가능한 닉네임입니다.' : '이미 존재하는 닉네임입니다.'),
                    ),
                  );
                },
                child: const Text('중복 확인'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
            ),
            TextButton(
              onPressed: isNicknameAvailable
                  ? () async {
                      final success =
                          await updateNickname(nicknameController.text);
                      if (!mounted) return;

                      if (success) {
                        // 닉네임 SharedPreferences에 저장
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(
                            'userNickname', nicknameController.text);
                        Navigator.of(context).pop(); // 팝업 닫기
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("닉네임이 수정되었습니다.")),
                        );
                        setState(() {}); // 상태 업데이트로 UI 갱신
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("닉네임 변경에 실패했습니다.")),
                        );
                      }
                    }
                  : null, // isNicknameAvailable이 false면 버튼 비활성화
              child: const Text('변경'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme(
        data: Theme.of(context).copyWith(
          // ExpansionTile의 divider 색상을 투명하게 설정
          dividerColor: Colors.transparent,
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
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(107, 127, 212, 1),
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

                            widget.changePage(5);
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
                            widget.changePage(6);
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
                            widget.changePage(7);
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
                            widget.changePage(8);
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
                            widget.changePage(9);
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
                      leading: const Icon(FontAwesomeIcons.userPen,
                          color: Colors.grey),
                      title:
                          const Text('내 정보 관리', style: TextStyle(fontSize: 20)),
                      children: <Widget>[
                        ListTile(
                          title: const Text('닉네임 변경',
                              style: TextStyle(fontSize: 15)),
                          onTap: () {
                            Navigator.pop(context); // Drawer 닫기
                            _showChangeNicknameDialog(); // 닉네임 변경 다이얼로그 표시
                          },
                        ),
                        ListTile(
                          title: const Text('비밀번호 변경',
                              style: TextStyle(fontSize: 15)),
                          onTap: () {
                            // 비밀번호 변경 로직
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color.fromRGBO(107, 127, 212, 1),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  '로그아웃',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
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
