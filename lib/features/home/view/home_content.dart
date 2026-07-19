import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../widgets/home_menu_card.dart';
import '../data/home_menu_data.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              width: 300,
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],

              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Progress" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold , color: AppColors.primary),),
                    Text("You'r almost at your daily goal."),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 48,
                          lineWidth: 8,
                          percent: 0.75, // 75%
                          animation: true,
                          animationDuration: 1000,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: AppColors.primary,
                          backgroundColor: Colors.grey.shade200,
                          center: const Text(
                            "75%",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFED65B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.local_fire_department,
                                    color: Color(0xFF8A5A00),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 4,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Streak" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold , color : AppColors.primary),),
                                    Text("12 Days" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w400 , color : Colors.black),),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFB0F0D6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.star_outline,
                                    color: Color(0xFF8A5A00),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 4,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Focus" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold , color : AppColors.primary),),
                                    Text("Deep" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w400 , color : Colors.black),),
                                  ],
                                )
                              ],
                            )
                          ],
                        )

                      ],
                    )
                  ],

                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menus.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return HomeMenuCard(
                  menu: menus[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}