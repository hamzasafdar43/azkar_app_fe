import 'package:flutter/material.dart';
import './azkar_card.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Noor Ala Noor – Azkar"),
        centerTitle: true,
      ),
      body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/background_image.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Top Card
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/image/moon_icon.png",
                      height: 50,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "الصلوات على النبي\nصلى الله عليه وسلم",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      AzkarCard(
                        icon: "assets/image/moon_icon.png",
                        title: "أذكار الصباح",
                        subtitle: "Morning Azkar",
                      ),

                      const SizedBox(width: 16),

                      AzkarCard(
                        icon: "assets/image/moon_icon.png",
                        title: "أذكار المساء",
                        subtitle: "Evening Azkar",
                      ),
                    ],
                  ),


                  const SizedBox(height: 16),



                  Row(
                    children: [
                      AzkarCard(
                        icon: "assets/image/moon_icon.png",
                        title: "أذكار بعد الصلاة",
                        subtitle: "After Prayer Azkar",
                      ),

                      const SizedBox(width: 16),

                      AzkarCard(
                        icon: "assets/image/moon_icon.png",
                        title: "أذكار النوم",
                        subtitle: "Sleep Azkar",
                      ),
                    ],
                  )

                ],
              ),
            )





          ],
        ),
      ),
    ),
    );
  }


}