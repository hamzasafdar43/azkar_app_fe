import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.greeting, this.onMenuPressed, this.onProfilePressed});
  final String greeting;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfilePressed;

  @override
  Widget build(BuildContext context) => Container(
    color: Theme.of(context).colorScheme.surface,
    child: SafeArea(bottom: false, child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _ActionButton(icon: Icons.menu_rounded, onTap: onMenuPressed),
          const Spacer(),
          _ActionButton(icon: Icons.notifications_none_rounded, onTap: null),
          const SizedBox(width: 10),
          InkWell(onTap: onProfilePressed, borderRadius: BorderRadius.circular(22), child: CircleAvatar(radius: 19, backgroundColor: const Color(0xFF00634F), child: const Icon(Icons.person_rounded, color: Colors.white))),
        ]),
        const SizedBox(height: 10),
        Text('Assalamu Alaikum', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0xFF9E7422), fontWeight: FontWeight.w700)),
        Text('Azkar', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: const Color(0xFF074A3C), fontWeight: FontWeight.w800, height: 1)),
        const SizedBox(height: 5),
        Text('Remember Allah, and He will\nremember you.', style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.35)),
      ]),
    )),
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFFFFFAEC), shape: BoxShape.circle), child: Icon(icon, size: 20, color: const Color(0xFF315047))));
}
