import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainButton extends StatelessWidget {
  final String name, sub; // 'sub' 파라미터가 이미 존재
  final IconData icon;
  final bool isInverted;
  final _blackColor = const Color(0xFF1F2123);
  final VoidCallback? onPressed;

  const MainButton({
    super.key,
    required this.name,
    required this.sub,
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
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 43),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isInverted ? _blackColor : Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 13),
              Text(
                sub,
                style: TextStyle(
                  color: isInverted ? _blackColor : Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // Spacer() 대신 사용할 수 있는 공간 조절 방법을 선택하세요.
              const SizedBox(
                height: 13,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Transform.scale(
                  scale: 2.2, // 아이콘 크기 배율 조정
                  child: Transform.translate(
                    offset: const Offset(5, 7), // 아이콘 위치 조정
                    child: Icon(
                      icon,
                      color: isInverted ? _blackColor : Colors.white,
                      size:
                          50, // Transform.scale 사용 시 size는 실제 크기에 영향을 덜 미침, scale에 의해 조정됨
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
