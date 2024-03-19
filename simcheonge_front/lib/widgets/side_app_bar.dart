import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simcheonge_front/screens/bookmark_policy_screen.dart';
import 'package:simcheonge_front/screens/bookmark_post_screen.dart';
import 'package:simcheonge_front/screens/my_policy_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_screen.dart';

class SideAppBar extends StatelessWidget {
  const SideAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor:
                Colors.transparent), // ExpansionTile의 divider 색상을 투명하게 설정
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      child: UserAccountsDrawerHeader(
                        accountName: const Text(
                          '김싸피님',
                          style: TextStyle(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyPostScreen(),
                              ),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyPostCommentScreen(),
                              ),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyPolicyCommentScreen(),
                              ),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BookmarkPolicyScreen(),
                              ),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BookmarkPostScreen(),
                              ),
                            );
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
                            print('정보 관리 항목 1 클릭됨');
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
