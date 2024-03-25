import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainButton extends StatelessWidget {
  final String name, descrip; // 'sub' 제거
  final IconData icon;
  final bool isInverted;
  final _blackColor = const Color(0xFF1F2123);
  final VoidCallback? onPressed;

  const MainButton({
    super.key,
    required this.name,
    required this.descrip,
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
          color: isInverted ? Colors.white : _blackColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            // 이름 텍스트: 좌측 상단에 위치
            Positioned(
              top: 8,
              left: 20,
              child: Text(
                name,
                style: TextStyle(
                  color: isInverted ? _blackColor : Colors.white,
                  fontSize: 33, // 텍스트 크기 조정
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 45,
              child: Text(
                descrip,
                style: TextStyle(
                  color: isInverted ? _blackColor : Colors.white,
                  fontSize: 18, // 텍스트 크기 조정
                  fontWeight: FontWeight.w400,
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
