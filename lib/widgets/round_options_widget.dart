import 'package:flutter/material.dart';
import 'package:quizapp/model/appcolors.dart';

class RoundOptions extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  // final bool loading;

  final String option;
  const RoundOptions({
    Key? key,
    required this.title,
    required this.onTap,
    required this.option,
    // this.loading = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.optionnotselectedcolor,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Row(children: [
            CircleAvatar(
              backgroundColor: AppColors.scorecolor,
              child: Text(
                option,
                style: const TextStyle(color: AppColors.optionnotselectedcolor),
              ),
            ),
            const SizedBox(width: 40),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
