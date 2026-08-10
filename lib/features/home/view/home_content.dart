import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../data/home_menu_data.dart';
import '../widgets/home_menu_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            sliver: SliverToBoxAdapter(child: _JourneyCard()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
            sliver: SliverGrid.builder(
              itemCount: menus.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.42,
              ),
              itemBuilder: (context, index) => HomeMenuCard(menu: menus[index]),
            ),
          ),
        ],
      );
}

class _JourneyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 128,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(colors: [Color(0xFF00634F), Color(0xFF004D3D)]),
          boxShadow: const [BoxShadow(color: Color(0x2800493B), blurRadius: 12, offset: Offset(0, 5))],
        ),
        child: Row(children: [
          CircularPercentIndicator(
            radius: 45,
            lineWidth: 7,
            percent: .75,
            animation: true,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color(0xFFF3C85B),
            backgroundColor: const Color(0xFF3B8979),
            center: const Column(mainAxisSize: MainAxisSize.min, children: [
              Text('75%', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700)),
              Text('Daily Goal', style: TextStyle(color: Color(0xFFD9EEE7), fontSize: 9)),
            ]),
          ),
          const SizedBox(width: 18),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Today's Journey", style: TextStyle(color: Color(0xFFF7D875), fontWeight: FontWeight.w700, fontSize: 16)),
            SizedBox(height: 3),
            Text('Great job! Keep going.', style: TextStyle(color: Color(0xFFD9EEE7), fontSize: 12)),
            Spacer(),
            Row(children: [
              _JourneyStat(icon: Icons.local_fire_department_rounded, label: 'Streak', value: '12 Days'),
              SizedBox(width: 16),
              _JourneyStat(icon: Icons.star_rounded, label: 'Focus', value: 'Deep'),
            ]),
          ])),
        ]),
      );
}

class _JourneyStat extends StatelessWidget {
  const _JourneyStat({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFFF7D875), size: 15)),
    const SizedBox(width: 5),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFFD9EEE7), fontSize: 9)), Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))]),
  ]);
}
