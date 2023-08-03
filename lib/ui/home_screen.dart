import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapp/model/appcolors.dart';
import 'package:quizapp/model/appicons.dart';
import 'package:quizapp/ui/art_screen.dart';
import 'package:quizapp/ui/create_question_screen.dart';
import 'package:quizapp/ui/gk_screen.dart';
import 'package:quizapp/ui/science_screen.dart';
import 'package:quizapp/ui/splash_screen.dart';
import 'package:quizapp/ui/tech_screen.dart';
import 'package:quizapp/widgets/round_button_widget.dart';
import 'package:quizapp/widgets/subject_card_widget.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbFirestore = FirebaseFirestore.instance.collection('questions');

  List<String> messages = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> signOutAndNavigateToLogin() async {
    await auth.signOut().catchError((error) {
      print(error.toString());
    });
    await GoogleSignIn().signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  bool loading = false;

  // late Task task;

  @override
  void dispose() {
    super.dispose();
  }

  final Map<String, Widget> screenMap = {
    // 'General Knowledge': GkScreen(),
    // 'Science and Nature': ScienceScreen(),
    // 'Technology': TechScreen(),
    'Art and Literature': ArtScreen(),
  };

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.bgcolor,
          body: ListView(children: [
            Column(children: [
              Material(
                elevation: 15,
                borderRadius: const BorderRadius.vertical(
                    // top: Radius.circular(40),
                    bottom: Radius.circular(50)),
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                      color: AppColors.profilebgcolor,
                      borderRadius: BorderRadius.vertical(
                          // top: Radius.circular(40),
                          bottom: Radius.circular(50))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateQuestionScreen()));
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: AppColors.optionnotselectedcolor,
                          )),
                      const Text(
                        'Quiz App',
                        style: TextStyle(
                            color: AppColors.optionnotselectedcolor,
                            fontSize: 40),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: InkWell(
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 151, 173, 194),
                                child: Icon(
                                  Icons.person_2_rounded,
                                  color: AppColors.optionnotselectedcolor,
                                  size: 35,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                      // width: MediaQuery.of(context).size.width * 0.25,
                      child: Card(
                        color: AppColors.scorecolor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(children: [
                                Text(
                                  'Question Count',
                                  style: TextStyle(
                                      color: AppColors.optionnotselectedcolor,
                                      fontSize: 8),
                                ),
                                Text(
                                  '230',
                                  style: TextStyle(
                                      color: AppColors.optionnotselectedcolor,
                                      fontSize: 27),
                                )
                              ]),
                              VerticalDivider(
                                thickness: 1,
                                color: AppColors.optionnotselectedcolor,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Your Ranking',
                                    style: TextStyle(
                                        color: AppColors.optionnotselectedcolor,
                                        fontSize: 8),
                                  ),
                                  Text(
                                    '1250',
                                    style: TextStyle(
                                        color: AppColors.optionnotselectedcolor,
                                        fontSize: 27),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SubjectCard(
                        img: AppIcons.pen,
                        subjecttitle: 'Art and Literature',
                        tap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ArtScreen()));
                        }),
                    SubjectCard(
                        img: AppIcons.gk,
                        subjecttitle: 'General Knowledge',
                        tap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const GkScreen()));
                        }),
                    SubjectCard(
                        img: AppIcons.science,
                        subjecttitle: 'Science and Nature',
                        tap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const ScienceScreen()));
                        }),
                    SubjectCard(
                        img: AppIcons.tech,
                        subjecttitle: 'Technology',
                        tap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const TechScreen()));
                        }),

                    // SizedBox(
                    //   height: 200,
                    //   child: StreamBuilder<QuerySnapshot>(
                    //     stream: FirebaseFirestore.instance
                    //         .collection('questions')
                    //         .snapshots(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasError) {
                    //         return Text('Error: ${snapshot.error}');
                    //       }

                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return CircularProgressIndicator();
                    //       }

                    //       // Data has been fetched successfully
                    //       final List<DocumentSnapshot> documents =
                    //           snapshot.data!.docs;
                    //       return Expanded(
                    //         child: ListView.builder(
                    //           shrinkWrap: true,
                    //           itemCount: documents.length,
                    //           itemBuilder: (context, index) {
                    //             final questionData = documents[index].data()
                    //                 as Map<String, dynamic>;

                    //             // Extract the required data from questionData and display it
                    //             final questionTitle =
                    //                 questionData['questionTitle'];
                    //             return Padding(
                    //               padding: const EdgeInsets.only(bottom: 10.0),
                    //               child: Card(
                    //                 elevation: 5,
                    //                 child: ListTile(
                    //                   onTap: () {
                    //                     // Check if the title exists in the screen map
                    //                     if (screenMap
                    //                         .containsKey(questionTitle)) {
                    //                       // Navigate to the corresponding screen
                    //                       Navigator.push(
                    //                         context,
                    //                         MaterialPageRoute(
                    //                             builder: (context) =>
                    //                                 screenMap[questionTitle]!),
                    //                       );
                    //                     }
                    //                   },
                    //                   tileColor: AppColors.profilebgcolor,
                    //                   // leading: Image.asset(AppIcons.gk),
                    //                   title: Text(questionTitle,
                    //                       style: const TextStyle(
                    //                           color: AppColors
                    //                               .optionnotselectedcolor)),
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),

                    const SizedBox(height: 50),
                    RoundButton(
                      title: 'UPGRADE',
                      onTap: () {},
                      btncolor: AppColors.optionnotselectedcolor,
                      btntxtcolor: AppColors.bgcolor,
                    )
                  ],
                ),
              ),
            ]),
          ]),
        ));
  }
}
