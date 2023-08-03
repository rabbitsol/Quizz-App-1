import 'package:flutter/material.dart';
import 'package:quizapp/model/appcolors.dart';

class AppBarWidget extends StatelessWidget {
  final String subjimg;

  final String subjtitle;

  const AppBarWidget(
      {super.key, required this.subjimg, required this.subjtitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.profilebgcolor,
      leading: GestureDetector(
          onTap: () {},
          child: Image.asset(
            subjimg,
            height: 20,
          )),
      title: Text(
        subjtitle,
        style: const TextStyle(color: AppColors.optionnotselectedcolor),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.optionnotselectedcolor,
            ))
      ],
    );
  }
}
