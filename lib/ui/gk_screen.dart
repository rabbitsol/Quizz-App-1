// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:quizapp/model/appcolors.dart';
// import 'package:quizapp/model/appicons.dart';
// import 'package:quizapp/model/question.dart';
// import 'package:quizapp/widgets/appbar_widget.dart';

// class GkScreen extends StatefulWidget {
//   const GkScreen({super.key});

//   @override
//   State<GkScreen> createState() => _GkScreenState();
// }

// class _GkScreenState extends State<GkScreen> {
//   List<Question> _questions = [];
//   List<int?> _selectedOptions = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchArtsQuestions();
//   }

//   Future<void> fetchArtsQuestions() async {
//     final questions = await fetchQuestions('gkscreen');
//     setState(() {
//       _questions = questions;
//     });
//   }

//   Future<List<Question>> fetchQuestions(String screen) async {
//     final collection = FirebaseFirestore.instance
//         .collection('questions')
//         .doc(screen)
//         .collection('questions');

//     final querySnapshot = await collection.get();
//     final List<Question> questions = [];

//     querySnapshot.docs.forEach((doc) {
//       final questionData = doc.data();
//       final question = Question(
//         userId: questionData['userId'] ?? '',
//         title: questionData['questionTitle'] ?? '',
//         description: questionData['questionDescription'] ?? '',
//         question: questionData['questionText'] ?? '',
//         options: List<String>.from(questionData['options'] ?? []),
//         correctOptionIndex: questionData['correctOptionIndex'] ?? 0,
//       );
//       questions.add(question);
//       // Initialize selected option for each question as 0
//       _selectedOptions.add(0);
//     });

//     return questions;
//   }

//   void updateSelectedOption(int questionIndex, int optionIndex) async {
//     final collection = FirebaseFirestore.instance
//         .collection('questions')
//         .doc('gkscreen')
//         .collection('questions');

//     final docSnapshot = await collection.doc(questionIndex.toString()).get();

//     if (docSnapshot.exists) {
//       final selectedOptionData = {
//         'selectedOptionIndex': optionIndex,
//       };

//       await docSnapshot.reference.update(selectedOptionData);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size(MediaQuery.of(context).size.width, 70),
//         child: const AppBarWidget(
//             subjimg: AppIcons.gk, subjtitle: 'General Knowledge'),
//       ),
//       backgroundColor: AppColors.bgcolor,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const SizedBox(height: 30),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 '03:00 min',
//                 style: TextStyle(color: AppColors.optionnotselectedcolor),
//               )
//             ],
//           ),
//           const Divider(thickness: 2, color: AppColors.optionnotselectedcolor),
//           const SizedBox(height: 10),

//           const SizedBox(height: 10),
//           // Text(widget.question),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: _questions.length,
//             itemBuilder: (context, index) {
//               final question = _questions[index];
//               final selectedOption = _selectedOptions.length > index
//                   ? _selectedOptions[index]
//                   : 0; // Check if a value exists at the index

//               return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: Text(
//                         question.description,
//                         style: const TextStyle(
//                             color: AppColors.optionnotselectedcolor),
//                       ),
//                     ),
//                     ListTile(
//                       title: Text(
//                         question.question,
//                         style: const TextStyle(
//                             color: AppColors.optionnotselectedcolor),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: List.generate(
//                           question.options.length,
//                           (optionIndex) => RadioListTile<int>(
//                             title: Text(
//                               question.options[optionIndex],
//                               style: const TextStyle(
//                                 color: AppColors.optionnotselectedcolor,
//                               ),
//                             ),
//                             value: optionIndex,
//                             groupValue:
//                                 selectedOption, // Use the selectedOption variable
//                             onChanged: (int? value) {
//                               setState(() {
//                                 _selectedOptions[index] = value ?? 0;
//                                 updateSelectedOption(index, value ?? 0);
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ]);
//             },
//           ),
//         ]),
//       ),
//     );
//   }
// }
