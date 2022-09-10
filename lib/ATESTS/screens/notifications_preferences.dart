import 'package:flutter/material.dart';

class NotificationsPreferences extends StatefulWidget {
  const NotificationsPreferences({Key? key}) : super(key: key);

  @override
  State<NotificationsPreferences> createState() =>
      _NotificationsPreferencesState();
}

class _NotificationsPreferencesState extends State<NotificationsPreferences> {
  bool messageVotes = true;
  bool pollVotes = true;
  bool messagePollComments = true;
  bool commentReplies = true;
  bool commentAndRepliesLikesAndDislikes = true;
  bool mentions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    child: Material(
                      shape: const CircleBorder(),
                      color: Colors.white,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor: Colors.grey.withOpacity(0.5),
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 50), () {
                            Navigator.pop(context);
                          });
                        },
                        child: const Icon(Icons.arrow_back,
                            color: Color.fromARGB(255, 80, 80, 80)),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Notifications Preferences',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show Message Votes',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Switch(
                    value: messageVotes,
                    activeColor: Colors.black,
                    onChanged: (val) {
                      setState(() {
                        messageVotes = !messageVotes;
                      });
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show Poll Votes',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Switch(
                    value: pollVotes,
                    activeColor: Colors.black,
                    onChanged: (val) {
                      setState(() {
                        pollVotes = !pollVotes;
                      });
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show comments received from messages and polls',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Switch(
                    value: messagePollComments,
                    activeColor: Colors.black,
                    onChanged: (val) {
                      setState(() {
                        messagePollComments = !messagePollComments;
                      });
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show replies received from comments',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Switch(
                    value: commentReplies,
                    activeColor: Colors.black,
                    onChanged: (val) {
                      setState(() {
                        commentReplies = !commentReplies;
                      });
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show likes and dislikes from comments and replies',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Switch(
                    value: commentAndRepliesLikesAndDislikes,
                    activeColor: Colors.black,
                    onChanged: (val) {
                      setState(() {
                        commentAndRepliesLikesAndDislikes =
                            !commentAndRepliesLikesAndDislikes;
                      });
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show Mentions',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Switch(
                    value: mentions,
                    activeColor: Colors.black,
                    onChanged: (val) {
                      setState(() {
                        mentions = !mentions;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
