import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/model/appcolors.dart';
import 'package:quizapp/model/question.dart';
import 'package:quizapp/utils/utils.dart';
import 'package:quizapp/widgets/round_button_widget.dart';

class CreateQuestionScreen extends StatefulWidget {
  const CreateQuestionScreen({Key? key}) : super(key: key);

  @override
  _CreateQuestionScreenState createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
   int questionId = DateTime.now()
   .microsecondsSinceEpoch; // Initialize _questionId with a value
  late String _questionText;
  final List<String> _options = [];
  int? _correctOptionIndex; // Changed type to int?
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool loading = false;

  void _addOption() {
    setState(() {
      _options.add('');
    });
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
      if (_correctOptionIndex == index) {
        _correctOptionIndex = null;
      } else if (_correctOptionIndex != null && _correctOptionIndex! > index) {
        _correctOptionIndex = _correctOptionIndex! - 1;
      }
    });
  }

  Widget _buildOptionField(int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: const TextStyle(color: AppColors.profilebgcolor),
            onChanged: (value) {
              setState(() {
                _options[index] = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Option cannot be empty';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Option ${index + 1}',
              labelStyle: const TextStyle(color: AppColors.profilebgcolor),
              // border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),
              //                   borderSide: const BorderSide(
              //                     color: AppColors.optionnotselectedcolor,
              //                     width: 2)),
              // enabledBorder: OutlineInputBorder()
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _removeOption(index),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    List<Widget> rows = [];

    for (int i = 0; i < _options.length; i += 2) {
      List<Widget> columns = [];

      for (int j = i; j < i + 2 && j < _options.length; j++) {
        columns.add(
          Expanded(
            child: _buildOptionField(j),
          ),
        );
      }

      rows.add(
        Row(
          children: columns,
        ),
      );
    }

    return Column(
      children: [
        ...rows,
        DropdownButtonFormField<int>(
          value: _correctOptionIndex,
          items: _options
              .asMap()
              .entries
              .map((entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text('Option ${entry.key + 1}'),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _correctOptionIndex = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Correct Option',
          ),
        ),
        const SizedBox(height: 20),
        RoundButton(
          onTap: _addOption,
          title: 'Add Option',
          btncolor: AppColors.optionnotselectedcolor,
          btntxtcolor: AppColors.profilebgcolor,
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        loading = true;
      });
      final int index = _correctOptionIndex ??
          -1; // If _correctOptionIndex is null, assign -1

      final question = Question(
        userId: userId,
         questionId: questionId,
        title: titleController.text,
        description: descController.text,
        question: _questionText,
        options: _options,
        correctOptionIndex: index,
      );
      _storeQuestion(question);
      setState(() {
        loading = false;
      });
    }
  }

  void _storeQuestion(Question question) async {
    final collection = FirebaseFirestore.instance.collection('question');

    final Map<String, dynamic> questionData = question.toMap();
    questionData['correctOptionIndex'] = question.correctOptionIndex;

    // Add questionId, questionTitle, and questionDescription to the question data
    // questionData['questionId'] = question.questionId;
    questionData['questionTitle'] = question.title;
    questionData['questionDescription'] = question.description;

    questionData['questionId'] = DateTime.now().microsecondsSinceEpoch;
    questionData['questionTitle'] = question.title;
    questionData['questionDescription'] = question.description;
    questionData['questionText'] = question.question;
    questionData['options'] = question.options;

    try {
      // Determine the screen to store the question based on the title
      String screen;
      if (question.title.toString().contains('art and literature')) {
        screen = 'artscreen';
      } else if (question.title.toString().contains('general knowledge')) {
        screen = 'gkscreen';
      } else if (question.title.toString().contains('science and nature')) {
        screen = 'sciencescreen';
      } else if (question.title.toString().contains('technology')) {
        screen = 'techscreen';
      } else {
        Utils().toastmessage('Invalid screen name');
        setState(() {
          loading = false;
        });
        return;
      }

      // Store the question in the appropriate screen collection
      final docRef =
          await collection.doc(screen).collection('quiz').add(questionData);

      Utils()
          .toastmessage('Question stored in Firestore with ID: ${docRef.id}');
      setState(() {
        loading = false;
      });
    } catch (e) {
      Utils().toastmessage('Failed to store question in Firestore: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.optionnotselectedcolor,
              )),
          backgroundColor: AppColors.profilebgcolor,
          title: const Text(
            'Create Question',
            style: TextStyle(color: AppColors.optionnotselectedcolor),
          )),
      // backgroundColor: AppColors.bgcolor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            Column(
              children: [
                TextFormField(
                  controller: titleController,
                  style: const TextStyle(color: AppColors.profilebgcolor),
                  onTapOutside: (event) {
                    print('onTapOutside');
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      _questionText = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: AppColors.profilebgcolor),
                  ),
                ),
                TextFormField(
                  controller: descController,
                  style: const TextStyle(color: AppColors.profilebgcolor),
                  onTapOutside: (event) {
                    print('onTapOutside');
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      _questionText = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: AppColors.profilebgcolor),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(color: AppColors.profilebgcolor),
                  onTapOutside: (event) {
                    print('onTapOutside');
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      _questionText = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Question cannot be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    labelStyle: TextStyle(color: AppColors.profilebgcolor),
                  ),
                ),
                _buildOptions(),
                const SizedBox(height: 20),
                RoundButton(
                  onTap: _submitForm,
                  title: 'Submit',
                  loading: loading,
                  btncolor: AppColors.scorecolor,
                  btntxtcolor: AppColors.optionnotselectedcolor,
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
