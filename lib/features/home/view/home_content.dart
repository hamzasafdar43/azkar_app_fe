import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../core/constants/app_strings.dart';
import '../data/home_menu_data.dart';
import '../widgets/home_menu_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of;
    final scheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0B5D4B), Color(0xFF1B7A63)],
                ),
                boxShadow: const [BoxShadow(color: Color(0x260B5D4B), blurRadius: 18, offset: Offset(0, 8))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Icon(Icons.mosque_outlined, color: Color(0xFFF4D57C)),
                  SizedBox(width: 8),
                  Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 28),
                Text(t(context, 'today'), style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(t(context, 'goal'), style: const TextStyle(color: Color(0xFFE4F2EC), height: 1.5)),
                const SizedBox(height: 22),
                Row(children: const [
                  _HeroPill(icon: Icons.local_fire_department_outlined, label: '12 day streak'),
                  SizedBox(width: 10),
                  _HeroPill(icon: Icons.auto_awesome_outlined, label: 'Deep focus'),
                ]),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Card(
              color: scheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(children: [
                  CircularPercentIndicator(
                    radius: 34, lineWidth: 6, percent: .75, animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: scheme.primary, backgroundColor: scheme.primaryContainer,
                    center: const Text('75%', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 18),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Daily dhikr progress', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Text('Three more moments of remembrance to reach today’s goal.', style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4)),
                  ])),
                ]),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          sliver: SliverToBoxAdapter(
            child: Text('Explore', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          sliver: SliverGrid.builder(
            itemCount: menus.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: .9,
            ),
            itemBuilder: (context, index) => HomeMenuCard(menu: menus[index]),
          ),
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(color: Colors.white.withOpacity(.14), borderRadius: BorderRadius.circular(12)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: const Color(0xFFF4D57C), size: 17), const SizedBox(width: 5), Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))]),
  );
}
