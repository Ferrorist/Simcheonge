import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainButton extends StatelessWidget {
  final String name; // 'sub' 제거
  final IconData icon;
  final bool isInverted;
  final _blackColor = const Color(0xFF1F2123);
  final VoidCallback? onPressed;

  const MainButton({
    super.key,
    required this.name,
    required this.icon,
    required this.isInverted,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isInverted
              ? const Color.fromARGB(255, 247, 247, 247)
              : _blackColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            // 이름 텍스트: 좌측 상단에 위치
            Positioned(
              top: 12,
              left: 23,
              child: Text(
                name,
                style: TextStyle(
                  color: isInverted ? _blackColor : Colors.white,
                  fontSize: 32, // 텍스트 크기 조정
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // 아이콘: 우측 하단에 위치, 일부 잘린 상태로 표시
            Positioned(
              right: -4, // 아이콘을 우측으로 이동시켜 잘리게 함
              bottom: -5, // 아이콘을 하단으로 이동시켜 잘리게 함
              child: Icon(
                icon,
                color: isInverted ? _blackColor : Colors.white,
                size: 100, // 아이콘 크기 조정
              ),
            ),
          ],
        ),
      ),
    );
  }
}
