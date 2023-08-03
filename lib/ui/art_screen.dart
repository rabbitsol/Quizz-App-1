import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/model/appcolors.dart';
import 'package:quizapp/model/appicons.dart';
import 'package:quizapp/model/question.dart';
import 'package:quizapp/ui/edit_question_screen.dart';
import 'package:quizapp/widgets/appbar_widget.dart';

class ArtScreen extends StatefulWidget {
  const ArtScreen({super.key});

  @override
  State<ArtScreen> createState() => _ArtScreenState();
}

class _ArtScreenState extends State<ArtScreen> {
  List<Question> _questions = [];
  List<int?> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    fetchArtsQuestions();
  }

  Future<void> fetchArtsQuestions() async {
    final questions = await fetchQuestions('artscreen');
    setState(() {
      _questions = questions;
    });
  }

  Future<List<Question>> fetchQuestions(String screen) async {
    final collection = FirebaseFirestore.instance
        .collection('question')
        .doc(screen)
        .collection('quiz');

    final querySnapshot = await collection.get();
    final List<Question> questions = [];

    querySnapshot.docs.forEach((doc) {
      final questionData = doc.data();
      final question = Question(
        questionId: questionData['questionId'] ?? '',
        userId: questionData['userId'] ?? '',
        title: questionData['questionTitle'] ?? '',
        description: questionData['questionDescription'] ?? '',
        question: questionData['questionText'] ?? '',
        options: List<String>.from(questionData['options'] ?? []),
        correctOptionIndex: questionData['correctOptionIndex'] ?? 0,
      );
      questions.add(question);
      // Initialize selected option for each question as 0
      _selectedOptions.add(0);
    });

    return questions;
  }

  void updateSelectedOption(int questionIndex, int optionIndex) async {
    final collection = FirebaseFirestore.instance
        .collection('question')
        .doc('artscreen')
        .collection('quiz');

    final docSnapshot = await collection.doc(questionIndex.toString()).get();

    if (docSnapshot.exists) {
      final selectedOptionData = {
        'selectedOptionIndex': optionIndex,
      };

      await docSnapshot.reference.update(selectedOptionData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 70),
          child: const AppBarWidget(
              subjimg: AppIcons.pen, subjtitle: 'Art and Literature'),
        ),
        backgroundColor: AppColors.bgcolor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 50),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '03:00 min',
                    style: TextStyle(color: AppColors.optionnotselectedcolor),
                  )
                ],
              ),
              const Divider(
                  thickness: 2, color: AppColors.optionnotselectedcolor),
              const SizedBox(height: 10),
              // Text(widget.question),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    // return Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const SizedBox(height: 50),
                    //       const Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             '03:00 min',
                    //             style: TextStyle(
                    //                 color: AppColors.optionnotselectedcolor),
                    //           )
                    //         ],
                    //       ),
                    //       const Divider(
                    //           thickness: 2,
                    //           color: AppColors.optionnotselectedcolor),
                    //       const SizedBox(height: 10),
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          question.description,
                          style: const TextStyle(
                              color: AppColors.optionnotselectedcolor),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                          onLongPress: () {
                            setState(() {});
                          },
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  question.question,
                                  style: const TextStyle(
                                    color: AppColors.optionnotselectedcolor,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  color: AppColors.optionnotselectedcolor,
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EditQuestionScreen()));
                                    } else if (value == 'delete') {
                                      final questionId =
                                          _questions[index].questionId;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Confirm Deletion'),
                                            content: const Text(
                                                'Are you sure you want to delete this question?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Delete'),
                                                onPressed: () {
                                                  deleteQuestion(
                                                      questionId as String);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              question.options.length,
                              (optionIndex) => RadioListTile<int>(
                                title: Text(
                                  question.options[optionIndex],
                                  style: const TextStyle(
                                    color: AppColors.optionnotselectedcolor,
                                  ),
                                ),
                                value: optionIndex,
                                groupValue: _selectedOptions[index],
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedOptions[index] =
                                        value ?? 0; // Assign 0 if value is null
                                    updateSelectedOption(index, value ?? 0);
                                  });
                                },
                              ),
                            ),
                          )),
                    ]);
                  })
            ])));
  }

  Future<void> deleteQuestion(String questionId) async {
    final collection = FirebaseFirestore.instance
        .collection('question')
        .doc('artscreen')
        .collection('quiz');

    await collection.doc(questionId).delete();

    setState(() {
      _questions.removeWhere((question) => question.questionId == questionId);
    });
  }
}
