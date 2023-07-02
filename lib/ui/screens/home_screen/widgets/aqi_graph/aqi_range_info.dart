import 'dart:developer';
import 'dart:ui';

import 'package:aura/resources/app_colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class AqiRangeInfo extends StatelessWidget {
  const AqiRangeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Transform.translate(
        offset: const Offset(0, 40),
        child: Opacity(
          opacity: 1,
          child: ClipSmoothRect(
            radius: SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: AppColors.primary.withOpacity(0.1),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 5,
                      backgroundColor: AppColors.goodRange,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0).copyWith(left: 10),
                        child: const Text(
                          "Good",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child: InkWell(
                        splashColor: Colors.red,
                        onTap: () => log("Asking for help!!"),
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 18,
                          cornerSmoothing: 0.8,
                        ),
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            // color: Colors.white12,
                            color: AppColors.secondary.withOpacity(0.2),
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 18,
                                cornerSmoothing: 0.8,
                              ),
                            ),
                          ),
                          child: const Icon(
                            EvaIcons.questionMarkCircleOutline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



//  if (followIndicator) {
//       return Positioned(
//         left: -20,
//         bottom: 45,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               color: Colors.grey.withOpacity(0.3),
//               alignment: Alignment.center,
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Moderate",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }