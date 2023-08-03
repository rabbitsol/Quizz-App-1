import 'package:flutter/material.dart';
import 'package:quizapp/model/appcolors.dart';

class SubjectCard extends StatelessWidget {
  final String subjecttitle;

  final String img;

  final VoidCallback tap;

  const SubjectCard(
      {super.key,
      required this.img,
      required this.subjecttitle,
      required this.tap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: SizedBox(
        height: 80,
        child: Card(
          color: AppColors.profilebgcolor,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Image.asset(
                  img,
                  height: 40,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                subjecttitle,
                style: const TextStyle(
                    fontSize: 30, color: AppColors.optionnotselectedcolor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
