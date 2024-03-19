import 'package:flutter/material.dart';
import 'package:simcheonge_front/screens/search_filter.dart';
import 'dart:ui';

class Bird {
  final String name;

  Bird({required this.name});
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Bird> _filteredBirds = [];
  final List<Bird> _allBirds = [
    Bird(name: "청년 월세 지원"),
    Bird(name: "Eurasian Hoopoe"),
    Bird(name: "Changeable Hawk-eagle"),
    Bird(name: "Brahminy Starling"),
    Bird(name: "Blue-tailed Bee-eater"),
    Bird(name: "Indian Peafowl"),
    Bird(name: "Common Kingfisher1"),
    Bird(name: "Common Kingfishe2r"),
    Bird(name: "Common Kingfishe4r"),
    Bird(name: "Common Kingfishe5r"),
    Bird(name: "Common Kingfishe3r"),
    Bird(name: "Common Kingfisher6"),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_searchListener);
    _filteredBirds = _allBirds;
  }

  @override
  void dispose() {
    _controller.removeListener(_searchListener);
    _controller.dispose();
    super.dispose();
  }

  void _searchListener() {
    final query = _controller.text;
    if (query.isEmpty) {
      setState(() {
        _filteredBirds = _allBirds;
      });
    } else {
      setState(() {
        _filteredBirds = _allBirds
            .where(
                (bird) => bird.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '검색어를 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // TODO: 음성 검색 기능 구현
                  },
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchListener();
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('필터',
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('검색결과',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBirds.length,
              itemBuilder: (BuildContext context, int index) {
                final bird = _filteredBirds[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    title: Text(
                      bird.name,
                      style: const TextStyle(fontSize: 19),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: 아이템 클릭 시 수행할 작업
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 사용자 정의 화면 전환 애니메이션을 위한 함수
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const FilterScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
