import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final String greeting;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfilePressed;

  const HomeAppBar({
    super.key,
    required this.greeting,
    this.onMenuPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: SafeArea(

        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: onMenuPressed,
                icon: const Icon(Icons.menu),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B5D4B),
                  ),
                ),
              ),

              InkWell(
                onTap: onProfilePressed,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5F0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    color: Color(0xFF0B5D4B),
                    size: 26,
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