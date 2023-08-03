import 'package:flutter/material.dart';
import 'package:quizapp/model/appcolors.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final Color btncolor;
  final Color btntxtcolor;
  const RoundButton(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.btncolor,
      required this.btntxtcolor,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            color: btncolor, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.optionnotselectedcolor,
                )
              : Text(
                  title,
                  style: TextStyle(
                    color: btntxtcolor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
