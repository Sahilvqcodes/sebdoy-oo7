import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ytplayer;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'dart:core';

import '../camera/camera_screen.dart';
import '../camera/preview.dart';
import '../methods/firestore_methods.dart';
import '../methods/storage_methods.dart';
import '../models/user.dart';
import '../utils/utils.dart';
import '../provider/user_provider.dart';
import 'filter_arrays.dart';
import 'full_image_add.dart';

// import '../models/user.dart';

// import '../providers/user_provider.dart';
// import '../resources/firestore_methods.dart';
// import '../resources/storage_methods.dart';
// import '../utils/utils.dart';

// import 'filter_screen_lists.dart';
// import 'full_image_add.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  YoutubePlayerController? controller;
  final TextEditingController _pollController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  late TextfieldTagsController keywordMessageController;

  List<TextEditingController>? _cont = [];
  static const List<String> _pickLanguage = <String>[];

  final int _optionTextfieldMaxLength = 25;
  final int _pollQuestionTextfieldMaxLength = 300;
  final int _messageTitleTextfieldMaxLength = 600;
  double? _distanceToField;

  bool _isVideoFile = false;
  bool done = false;
  File? _videoFile;
  bool _isLoading = false;
  var messages = 'true';
  var global = 'true';
  Uint8List? _file;
  var selected = 0;
  String? videoUrl = '';
  bool textfield1selected = false;
  bool textfield1selected2 = false;
  bool textfield1selected3 = false;
  int i = 2;
  String proxyurl = 'abc';
  bool emptyTittle = false;
  bool emptyOptionOne = false;
  bool emptyOptionTwo = false;
  bool emptyPollQuestion = false;
  String country = '';
  String oneValue = '';
  User? user;
  var add = "true";
  List<String> myTags = [];
  List<String> myTagsLowerCase = [];
  List<String> myTagsPoll = [];
  KeyboardVisibilityController? _keyboardVisibilityController;
  StreamSubscription<bool>? keyboardSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width * 0.85;
  }

  @override
  void initState() {
    super.initState();
    keywordMessageController = TextfieldTagsController();
    _keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        _keyboardVisibilityController!.onChange.listen((isVisible) {
      print('aaaa');
      print(_keyboardVisibilityController!.isVisible);
      print('abc');

      if (!isVisible) {
        print('bbbb');

        /*  setState(() {
          textfield1selected3 = false;
          textfield1selected2 = false;
          textfield1selected = false;
        });
*/
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    getValueM();
    getValueG();
    controller = YoutubePlayerController(
      initialVideoId: '${videoUrl}',
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    controller!.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };
    controller!.onExitFullscreen = () {
      log('Exited Fullscreen');
    };
  }

  _selectYoutube(BuildContext context) async {
    // bool greyHover = false;
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              // height: MediaQuery.of(context).size.height * 0.43,
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: const EdgeInsets.fromLTRB(10, 45, 10, 0),
              child: Column(
                children: [
                  SimpleDialogOption(
                    padding: const EdgeInsets.only(
                        top: 20, left: 5, right: 5, bottom: 2),
                    child: const Text("Upload YouTube Video",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.transparent,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            const Shadow(
                                offset: const Offset(0, -5),
                                color: Colors.black)
                          ],
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                        )),
                    onPressed: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 12.0, left: 12, top: 20, bottom: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 248, 248, 248),
                        // color: Color.fromARGB(255, 241, 239, 239),
                        border: Border.all(
                          width: 0,
                          color: const Color.fromARGB(255, 133, 133, 133),
                        ),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25.0),
                        ),
                      ),
                      // decoration: BoxDecoration(
                      //   color: Color.fromARGB(255, 246, 245, 245),
                      //   // color: Color.fromARGB(255, 241, 239, 239),
                      //   border: Border.all(
                      //     width: 0.8,
                      //     color: Color.fromARGB(255, 226, 226, 226),
                      //   ),
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(15.0),
                      //   ),
                      // ),
                      child: TextField(
                        // textAlign: TextAlign.center,

                        onChanged: (t) {
                          videoUrl = ytplayer.YoutubePlayer.convertUrlToId(
                              _videoUrlController.text)!;
                          print('this is the video id:');
                          print(videoUrl);

                          setState(() {
                            videoUrl;
                          });

                          if (videoUrl != null) {
                            print('video id not null');

                            setState(() {
                              controller = YoutubePlayerController(
                                initialVideoId: '${videoUrl}',
                                params: const YoutubePlayerParams(
                                  showControls: true,
                                  showFullscreenButton: true,
                                  desktopMode: false,
                                  privacyEnhanced: true,
                                  useHybridComposition: true,
                                ),
                              );
                            });
                          }
                        },
                        onSubmitted: (t) {
                          if (_videoUrlController.text.length == 0) {
                            setState(() {
                              selected = 0;
                            });
                          } else {
                            print(videoUrl);
                          }
                        },
                        controller: _videoUrlController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          hintText: "Paste YouTube URL",
                          prefixIcon:
                              Icon(Icons.link, size: 16, color: Colors.grey),
                          prefixIconColor: Color.fromARGB(255, 136, 136, 136),

                          contentPadding:
                              const EdgeInsets.only(left: 16, top: 14),

                          border: InputBorder.none,
                          // fillColor: Colors.grey,
                          // filled: true,
                          // counterText: '',
                        ),
                        style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: Container(
                      color: Colors.white,
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.format_clear,
                                    color: const Color.fromARGB(
                                        255, 139, 139, 139),
                                  ),
                                  Container(width: 8),
                                  const Text('Clear URL',
                                      style: TextStyle(
                                          letterSpacing: 0.2, fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              clearVideoUrl();
                              // greyHover = !greyHover;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          _videoUrlController.text.length == 0
                              ? setState(() {
                                  selected = 0;
                                  //  clearVideoUrl();
                                  clearVideoUrl();
                                })
                              : print(selected);
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check,
                                color: const Color.fromARGB(255, 139, 139, 139),
                              ),
                              Container(width: 8),
                              const Text('Done',
                                  style: const TextStyle(
                                      letterSpacing: 0.2, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: -50,
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 139, 139, 139),
                  radius: 43.5,
                  child: FittedBox(
                    child: Icon(
                      Icons.ondemand_video,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ).then((value) => _videoUrlController.text.length == 0 || videoUrl == null
        ? setState(() {
            selected = 0;
          })
        : print('not null'));
  }

  _selectVideo(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              // height: MediaQuery.of(context).size.height * 0.43,
              height: 290,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: const EdgeInsets.fromLTRB(10, 45, 10, 0),
              child: Column(
                children: [
                  SimpleDialogOption(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 5),
                    child: const Text("Upload Video",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.transparent,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(offset: Offset(0, -5), color: Colors.black)
                          ],
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                        )),
                    onPressed: () {},
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          var file = await openCamera(
                            context: context,
                            cameraFileType: CameraFileType.video,
                            add: add,
                          );
                          print(file);
                          if (file != null) {
                            setState(() {
                              _file = (file as File).readAsBytesSync();
                              _videoFile = (file as File);
                              _isVideoFile = true;
                            });
                          }
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                color: const Color.fromARGB(255, 139, 139, 139),
                              ),
                              Container(width: 8),
                              const Text('Open camera',
                                  style: TextStyle(
                                      letterSpacing: 0.2, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          File file = await pickVideo(
                            ImageSource.gallery,
                          );
                          setState(() {
                            _file = (file as File).readAsBytesSync();
                            _videoFile = (file as File);
                            _isVideoFile = true;
                          });
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.collections,
                                color: const Color.fromARGB(255, 139, 139, 139),
                              ),
                              Container(width: 8),
                              const Text('Choose from gallery',
                                  style: const TextStyle(
                                      letterSpacing: 0.2, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          _file == null
                              ? setState(() {
                                  selected = 0;
                                })
                              : null;

                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.cancel,
                                color: const Color.fromARGB(255, 139, 139, 139),
                              ),
                              Container(width: 8),
                              const Text('Cancel',
                                  style: const TextStyle(
                                      letterSpacing: 0.2, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: -50,
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 139, 139, 139),
                  radius: 43.5,
                  child: const FittedBox(
                    child: Icon(
                      Icons.video_library,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ).then((value) => _file == null
        ? setState(() {
            selected = 0;
          })
        : print('not null'));
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              // height: MediaQuery.of(context).size.height * 0.43,
              height: 290,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: const EdgeInsets.fromLTRB(10, 45, 10, 0),
              child: Column(
                children: [
                  SimpleDialogOption(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 5),
                    child: const Text("Upload Image",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.transparent,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            const Shadow(
                                offset: Offset(0, -5), color: Colors.black)
                          ],
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                        )),
                    onPressed: () {},
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          Uint8List? file = await openCamera(
                            context: context,
                            cameraFileType: CameraFileType.image,
                            add: add,
                          );
                          // Uint8List file = await pickImage(
                          //   ImageSource.camera,
                          // );
                          // setState(() {
                          //   _file = file;
                          // });
                          // Uint8List? file = await openCamera(context: context);
                          // Uint8List file = await pickImage(
                          //   ImageSource.camera,
                          // );
                          print(file);
                          if (file != null) {
                            setState(() {
                              _file = file;
                              _isVideoFile = false;
                            });
                          }
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                color: Color.fromARGB(255, 139, 139, 139),
                              ),
                              Container(width: 8),
                              const Text('Open camera',
                                  style: TextStyle(
                                      letterSpacing: 0.2, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          Uint8List file = await pickImage(
                            ImageSource.gallery,
                          );
                          setState(() {
                            _file = file;
                            _isVideoFile = false;
                          });
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.collections,
                                color: const Color.fromARGB(255, 139, 139, 139),
                              ),
                              Container(width: 8),
                              const Text('Choose from gallery',
                                  style: TextStyle(
                                      letterSpacing: 0.2, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          print(selected);
                          _file == null
                              ? setState(() {
                                  selected = 0;
                                })
                              : null;
                          print(selected);
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.cancel,
                                color: const Color.fromARGB(255, 139, 139, 139),
                              ),
                              Container(width: 8),
                              const Text('Cancel',
                                  style: const TextStyle(
                                      letterSpacing: 0.2, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: -50,
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: const CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 139, 139, 139),
                  radius: 43.5,
                  child: const FittedBox(
                    child: const Icon(
                      Icons.collections,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ).then((value) => _file == null
        ? setState(() {
            selected = 0;
          })
        : print('not null'));
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void clearVideoUrl() {
    setState(() {
      _videoUrlController.clear();
    });
  }

  Future<void> getValueG() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selected_radio3') != null) {
      setState(() {
        global = prefs.getString('selected_radio3')!;
      });
    }
  }

  Future<void> setValueG(String valueg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      global = valueg.toString();
      prefs.setString('selected_radio3', global);
    });
  }

  Future<void> getValueM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selected_radio4') != null) {
      setState(() {
        messages = prefs.getString('selected_radio4')!;
      });
    }

    setState(() {
      oneValue = prefs.getString('selected_radio') ?? '';

      var countryIndex = long.indexOf(oneValue);
      if (countryIndex >= 0) {
        // country = short[countryIndex];

        // country = user.country

        print('abc');
        print(country);

        prefs.setString('cont', country);
      }
    });
  }

  Future<void> setValueM(String valuem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      messages = valuem.toString();
      prefs.setString('selected_radio4', messages);
    });
  }

  //
  //MESSAGE
  //
  void postImage(
    String uid,
    String username,
    String profImage,
    String mCountry,
  ) async {
    try {
      if (selected == 3) {
        if (_videoUrlController.text.length == 0) {
          setState(() {
            selected = 0;
          });
        }
      }
      emptyTittle = _titleController.text.trim().isEmpty;
      setState(() {});
      // if (_titleController.text.length != 0) {
      //   setState(() {
      //     emptyTittle = false;
      //   });
      // setState(() {
      //   _isLoading = true;
      // });
      if (!emptyTittle) {
        String photoUrl = "";
        if (_file == null) {
          photoUrl = "";
        } else {
          photoUrl = await StorageMethods()
              .uploadImageToStorage('posts', _file!, true);
        }

        // String videoUrl = "";
        // if (_videoFile == null) {
        //   videoUrl = "";
        // } else {
        //   videoUrl = await StorageMethods()
        //       .uploadImageToStorage('posts', _file!, true);
        // }

        if (country == '') {
          country = user!.country;
        } else {}

        String res = await FirestoreMethods().uploadPost(
            uid,
            username,
            profImage,
            country,
            global,
            _titleController.text,
            _bodyController.text,
            videoUrl!,
            //proxyurl,
            photoUrl,
            selected,
            myTags,
            myTagsLowerCase);
        if (res == "success") {
          setState(() {
            _isLoading = false;
          });
          showSnackBar('Posted!', context);
          // Navigator.of(context).pop();
          // clearImage();
        } else {
          // setState(() {
          //   _isLoading = true;
          // });
          showSnackBar(res, context);
        }
        // } else {
        //   setState(() {
        //     emptyTittle = true;
        //   });
        // }
        // Navigator.pop(context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

//
//POLL
//
  void postImagePoll(
      String uid, String username, String profImage, String mCountry) async {
    try {
      // Validates poll question text field
      emptyPollQuestion = _pollController.text.trim().isEmpty;

      // Validates Poll Option 1 and 2 text fields
      emptyOptionOne = _cont![0].text.trim().isEmpty;
      emptyOptionTwo = _cont![1].text.trim().isEmpty;

      setState(() {});

      // If Poll question and Poll option 1 and 2 are not empty the post poll
      if (!emptyPollQuestion && !emptyOptionOne && !emptyOptionTwo) {
        if (country == '') {
          country = user!.country;
        }

        String res = await FirestoreMethods().uploadPoll(
            uid,
            username,
            profImage,
            country,
            global,
            _pollController.text.trim(),
            _cont?[0].text.trim() ?? '',
            _cont?[1].text.trim() ?? '',
            _cont?[2].text.trim() ?? '',
            _cont?[3].text.trim() ?? '',
            _cont?[4].text.trim() ?? '',
            _cont?[5].text.trim() ?? '',
            _cont?[6].text.trim() ?? '',
            _cont?[7].text.trim() ?? '',
            _cont?[8].text.trim() ?? '',
            _cont?[9].text.trim() ?? '',
            myTagsPoll,
            myTagsLowerCase);
        if (res == "success") {
          setState(() {
            _isLoading = false;
          });
          showSnackBar('Posted!', context);
          // Navigator.of(context).pop();
        } else {
          // setState(() {
          //   _isLoading = true;
          // });
          showSnackBar(res, context);
        }
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    controller!.close();
    _titleController.dispose;
    _bodyController.dispose;
    _videoUrlController.dispose;
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    user = Provider.of<UserProvider>(context).getUser;
    print(messages);

    // if (messages == 'true') {
    return WillPopScope(
      onWillPop: () async {
        print('ENTERED ON WILLPOP');
        if (textfield1selected == true || textfield1selected2 == true) {
          setState(() {
            textfield1selected = false;
            textfield1selected2 = false;
          });
        }
        return false;
      },
      child: YoutubePlayerControllerProvider(
        controller: controller!,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 65,
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            actions: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: [
                          global == 'true'
                              ? const Padding(
                                  padding: EdgeInsets.only(bottom: 1.0),
                                  child: Text(
                                    'Global',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 1.0),
                                      child: Text(
                                        'National',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 1.0),
                                      child: user != null && user?.country != ""
                                          ? Container(
                                              width: 24,
                                              height: 14,
                                              child: Image.asset(
                                                  'icons/flags/png/${user?.country}.png',
                                                  width: 24,
                                                  height: 14,
                                                  package: 'country_icons'),
                                            )
                                          : Row(),
                                    ),
                                  ],
                                ),
                          AnimatedToggleSwitch<String>.rollingByHeight(
                              height: 32,
                              current: global,
                              values: const [
                                'true',
                                'false',
                              ],
                              onChanged: (valueg) =>
                                  setValueG(valueg.toString()),
                              iconBuilder: rollingIconBuilderStringThree,
                              borderRadius: BorderRadius.circular(25.0),
                              borderWidth: 0,
                              indicatorSize: const Size.square(1.8),
                              innerColor:
                                  const Color.fromARGB(255, 228, 228, 228),
                              indicatorColor:
                                  const Color.fromARGB(255, 157, 157, 157),
                              borderColor:
                                  const Color.fromARGB(255, 135, 135, 135),
                              iconOpacity: 1),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1.0),
                            child: Text(
                              messages == 'true' ? 'Messages' : 'Polls',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          AnimatedToggleSwitch<String>.rollingByHeight(
                              height: 32,
                              current: messages,
                              values: const [
                                'true',
                                'false',
                              ],
                              onChanged: (valuem) =>
                                  setValueM(valuem.toString()),
                              iconBuilder: rollingIconBuilderStringTwo,
                              borderRadius: BorderRadius.circular(25.0),
                              borderWidth: 0,
                              indicatorSize: const Size.square(1.8),
                              innerColor:
                                  const Color.fromARGB(255, 228, 228, 228),
                              indicatorColor:
                                  const Color.fromARGB(255, 157, 157, 157),
                              borderColor:
                                  const Color.fromARGB(255, 135, 135, 135),
                              iconOpacity: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: messages == 'true'
              ? SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _isLoading
                          ? const LinearProgressIndicator()
                          : const Padding(padding: EdgeInsets.only(top: 0)),
                      // const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.92,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 219, 219, 219),
                              width: 1.5),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            emptyTittle == true
                                ? Column(
                                    children: [
                                      Container(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.error,
                                              size: 16,
                                              color: Color.fromARGB(
                                                  255, 220, 105, 96)),
                                          Container(width: 4),
                                          const Text(
                                              'Message title cannot be blank.',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 220, 105, 96))),
                                        ],
                                      ),
                                      Container(height: 4),
                                    ],
                                  )
                                : Container(),
                            emptyTittle ? Container() : Container(height: 10),
                            // Card(
                            //   elevation: textfield1selected == false ? 3 : 0,
                            Stack(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  decoration: BoxDecoration(
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Color.fromARGB(255, 176, 176, 176),
                                    //     blurRadius: 2,
                                    //     offset: Offset(2, 4), // Shadow position
                                    //   ),
                                    // ],
                                    color: const Color.fromARGB(
                                        255, 248, 248, 248),
                                    border: Border.all(
                                        color: textfield1selected == false
                                            ? Colors.grey
                                            : Colors.blueAccent,
                                        width: textfield1selected != false
                                            ? 1.5
                                            : 0.5),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(5.0),
                                    ),
                                  ),
                                  child: WillPopScope(
                                    onWillPop: () async {
                                      print('POP');
                                      return false;
                                    },
                                    child: TextField(
                                      minLines: 3,
                                      maxLength:
                                          _messageTitleTextfieldMaxLength,
                                      onChanged: (val) {
                                        setState(() {});
                                      },
                                      onEditingComplete: () {
                                        print('complete');
                                      },
                                      onTap: () {
                                        setState(() {
                                          textfield1selected = true;
                                          textfield1selected2 = false;
                                        });
                                      },
                                      onSubmitted: (t) {
                                        setState(() {
                                          textfield1selected = false;
                                          textfield1selected2 = false;
                                        });
                                      },
                                      controller: _titleController,
                                      decoration: InputDecoration(
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15.0),
                                          child: Icon(Icons.create,
                                              color: textfield1selected == false
                                                  ? Colors.grey
                                                  : Colors.blueAccent),
                                        ),
                                        hintText: "Message title ...",
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(
                                            top: 10,
                                            right: 6,
                                            left: 10,
                                            bottom: 10),
                                        hintStyle: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                            fontSize: 15),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        // fillColor: Colors.white,
                                        // filled: true,
                                        counterText: '',
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 6,
                                  child: Text(
                                    '${_titleController.text.length}/$_messageTitleTextfieldMaxLength',
                                    style: const TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // ),
                            Container(height: 10),
                            // Card(
                            //   elevation: textfield1selected2 == false ? 3 : 0,
                            Stack(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 248, 248, 248),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    border: Border.all(
                                        color: textfield1selected2 == false
                                            ? Colors.grey
                                            : Colors.blueAccent,
                                        width: textfield1selected2 != false
                                            ? 1.5
                                            : 0.5),
                                  ),
                                  child: TextField(
                                    minLines: 3,
                                    onTap: () {
                                      setState(() {
                                        textfield1selected = false;
                                        textfield1selected2 = true;
                                      });
                                    },
                                    onSubmitted: (t) {
                                      setState(() {
                                        textfield1selected = false;
                                        textfield1selected2 = false;
                                      });
                                    },
                                    controller: _bodyController,
                                    decoration: InputDecoration(
                                      suffixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: Icon(Icons.create,
                                            color: textfield1selected2 == false
                                                ? Colors.grey
                                                : Colors.blueAccent),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 10.0,
                                          left: 10,
                                          right: 10,
                                          bottom: 10),
                                      hintText: "Additional text (optional)",
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                          fontSize: 15),
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                      // fillColor: Colors.white,
                                      // filled: true,
                                      counterText: '',
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                                const Positioned(
                                  bottom: 5,
                                  right: 3,
                                  child: Text(
                                    'unlimited',
                                    style: TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // ),
                            Container(height: 10),
                            Column(
                              children: [
                                // Container(
                                //   // width: MediaQuery.of(context).size.width * 0.8,
                                //   alignment: Alignment.center,
                                //   child: Text('Select one:',
                                //       style: TextStyle(
                                //         fontSize: 15,
                                //         letterSpacing: 0.6,
                                //       )),
                                // ),
                                // SizedBox(height: 4),
                                // Card(
                                //   elevation: 3,
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 248, 248, 248),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(5.0),
                                    ),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _icon(0, icon: Icons.do_not_disturb),
                                      _icon(1, icon: Icons.collections),
                                      _icon(2, icon: Icons.video_library),
                                      _icon(3, icon: Icons.ondemand_video),
                                    ],
                                  ),
                                ),
                                // ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _file != null
                                ? Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          _isVideoFile &&
                                                                  _videoFile !=
                                                                      null
                                                              ? PreviewPictureScreen(
                                                                  previewOnly:
                                                                      true,
                                                                  filePath:
                                                                      _videoFile!
                                                                          .path,
                                                                  cameraFileType:
                                                                      CameraFileType
                                                                          .video,
                                                                  add: add,
                                                                )
                                                              : FullImageScreenAdd(
                                                                  file: MemoryImage(
                                                                      _file!),
                                                                )),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 248, 248, 248),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,

                                                // child: AspectRatio(
                                                //   aspectRatio: 487 / 451,

                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child:
                                                      _isVideoFile &&
                                                              _videoFile != null
                                                          ? FutureBuilder(
                                                              future:
                                                                  _getVideoThumbnail(
                                                                file:
                                                                    _videoFile!,
                                                              ),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          File>
                                                                      snapshot) {
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .none:
                                                                    print(
                                                                        'ConnectionState.none');
                                                                    break;
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                    break;
                                                                  case ConnectionState
                                                                      .active:
                                                                    print(
                                                                        'ConnectionState.active');
                                                                    break;
                                                                  case ConnectionState
                                                                      .done:
                                                                    print(
                                                                        'ConnectionState.done');
                                                                    break;
                                                                }

                                                                return snapshot
                                                                            .data !=
                                                                        null
                                                                    ? Stack(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        children: [
                                                                          Image.file(
                                                                              snapshot.data!),
                                                                          const Center(
                                                                            child:
                                                                                Icon(
                                                                              Icons.play_circle_outline,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      );
                                                              },
                                                            )
                                                          : Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      MemoryImage(
                                                                          _file!),
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  // alignment: FractionalOffset.topCenter,
                                                                ),
                                                              ),
                                                            ),
                                                ),
                                                // ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    _isVideoFile
                                                        ? _selectVideo(context)
                                                        : _selectImage(context);
                                                  },
                                                  icon: const Icon(
                                                      Icons.change_circle,
                                                      color: Colors.grey),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    clearImage();
                                                    selected = 0;
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(height: 10),
                                    ],
                                  )
                                : _videoUrlController.text.isEmpty
                                    ? Container()
                                    : LayoutBuilder(
                                        builder: (context, constraints) {
                                          if (kIsWeb &&
                                              constraints.maxWidth > 800) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Expanded(child: player),
                                                const SizedBox(
                                                  width: 500,
                                                ),
                                              ],
                                            );
                                          }
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Container(
                                                    width: 250,
                                                    child: Stack(
                                                      children: [
                                                        player,
                                                        Positioned.fill(
                                                          child:
                                                              YoutubeValueBuilder(
                                                            controller:
                                                                controller,
                                                            builder: (context,
                                                                value) {
                                                              return AnimatedCrossFade(
                                                                crossFadeState: value.isReady
                                                                    ? CrossFadeState
                                                                        .showSecond
                                                                    : CrossFadeState
                                                                        .showFirst,
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                secondChild: Container(
                                                                    child: const SizedBox
                                                                        .shrink()),
                                                                firstChild:
                                                                    Material(
                                                                  child:
                                                                      DecoratedBox(
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            NetworkImage(
                                                                          YoutubePlayerController
                                                                              .getThumbnail(
                                                                            videoId:
                                                                                controller!.initialVideoId,
                                                                            quality:
                                                                                ThumbnailQuality.medium,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        _selectYoutube(context);
                                                      },
                                                      icon: const Icon(
                                                          Icons.change_circle,
                                                          color: Colors.grey),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        clearVideoUrl();
                                                        setState(() {
                                                          selected = 0;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                            _videoUrlController.text.isEmpty
                                ? Container(height: 0)
                                : Container(height: 10),
                            Autocomplete<String>(
                              optionsViewBuilder:
                                  (context, onSelected, options) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Material(
                                      elevation: 4.0,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxHeight: 200),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final dynamic option =
                                                options.elementAt(index);
                                            return TextButton(
                                              onPressed: () {
                                                onSelected(option);
                                              },
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 15.0),
                                                  child: Text(
                                                    '$option',
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 74, 137, 92),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                return _pickLanguage.where((String option) {
                                  return option.contains(
                                      textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (String selectedTag) {
                                keywordMessageController.addTag = selectedTag;
                              },
                              fieldViewBuilder:
                                  (context, ttec, tfn, onFieldSubmitted) {
                                return Container(
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 248, 248, 248),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    border: Border.all(
                                        color: textfield1selected3 == false
                                            ? Colors.grey
                                            : Colors.blue,
                                        width: textfield1selected3 != false
                                            ? 1.5
                                            : 0.5),
                                  ),
                                  child: TextFieldTags(
                                    textEditingController: ttec,
                                    focusNode: tfn,
                                    //  textfieldTagsController: keywordMessageController,
                                    initialTags: const [],
                                    textSeparators: const [' ', ','],
                                    letterCase: LetterCase.normal,
                                    inputfieldBuilder: (context, tec, fn, error,
                                        onChanged, onSubmitted) {
                                      return ((context, sc, tags, onTagDelete) {
                                        myTags = tags;
                                        List<String> tagsLower = tags;
                                        tagsLower = tagsLower
                                            .map((tagLower) =>
                                                tagLower.toLowerCase())
                                            .toList();
                                        myTagsLowerCase = tagsLower;
                                        return Row(
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: tags.length < 3
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1.4),
                                              child: SingleChildScrollView(
                                                controller: sc,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children:
                                                        tags.map((String tag) {
                                                      return Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                                color: Colors
                                                                    .grey),
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 3, right: 3),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                                vertical: 4.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              child: Text(
                                                                tag,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 4.0),
                                                            InkWell(
                                                              child: const Icon(
                                                                Icons.cancel,
                                                                size: 15.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onTap: () {
                                                                onTagDelete(
                                                                    tag);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }).toList()),
                                              ),
                                            ),
                                            Flexible(
                                              child: TextField(
                                                controller: tec,
                                                focusNode: fn,
                                                enabled: tags.length < 3,
                                                onTap: () {
                                                  setState(() {
                                                    textfield1selected = false;
                                                    textfield1selected2 = false;
                                                    textfield1selected3 = true;
                                                  });
                                                },
                                                onSubmitted: (t) {
                                                  onSubmitted;
                                                  setState(() {
                                                    textfield1selected = false;
                                                    textfield1selected2 = false;
                                                    textfield1selected3 = false;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 10,
                                                          right: 0,
                                                          bottom: 10),
                                                  hintText: tags.isNotEmpty
                                                      ? ''
                                                      : "Add up to 3 keywords...",
                                                  hintStyle: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                  errorText: error,
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: onChanged,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.key,
                                                      color:
                                                          textfield1selected3 ==
                                                                  false
                                                              ? Colors.grey
                                                              : Colors.blue),
                                                  Text(
                                                    '${tags.length}/3',
                                                    style: const TextStyle(
                                                      // fontStyle: FontStyle.italic,
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                            Container(height: 10),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PhysicalModel(
                              color: _titleController.text.length != 0
                                  ? Colors.blueAccent
                                  : Colors.blueAccent.withOpacity(0.45),
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () async {
                                  performLoggedUserAction(
                                      context: context,
                                      action: () {
                                        postImage(
                                          user?.uid ?? '',
                                          user?.username ?? '',
                                          user?.photoUrl ?? '',
                                          user?.country ?? '',
                                        );
                                      });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 260,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14.0),
                                        child: Icon(
                                          Icons.send,
                                          color:
                                              _titleController.text.length != 0
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 245, 245, 245),
                                        ),
                                      ),
                                      global == 'true'
                                          ? const SizedBox(
                                              width: 16,
                                            )
                                          : const SizedBox(
                                              width: 8,
                                            ),
                                      global == 'true' &&
                                              _titleController.text.length != 0
                                          ? const Expanded(
                                              child: Text(
                                                'Send Message Globally',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.25,
                                                    letterSpacing: 1.2),
                                              ),
                                            )
                                          : global == 'false' &&
                                                  _titleController
                                                          .text.length !=
                                                      0
                                              ? const Expanded(
                                                  child: Text(
                                                    'Send Message Nationally',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        letterSpacing: 1),
                                                  ),
                                                )
                                              : global == 'true'
                                                  ? const Expanded(
                                                      child: Text(
                                                        'Send Message Globally',
                                                        style: TextStyle(
                                                            color: Color
                                                                .fromARGB(
                                                                    255,
                                                                    245,
                                                                    245,
                                                                    245),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            letterSpacing: 1),
                                                      ),
                                                    )
                                                  : const Expanded(
                                                      child: Text(
                                                        'Send Message Nationally',
                                                        style: TextStyle(
                                                            color: Color
                                                                .fromARGB(
                                                                    255,
                                                                    245,
                                                                    245,
                                                                    245),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.25,
                                                            letterSpacing: 1.2),
                                                      ),
                                                    ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Container(
                    // minHeight: 500,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      children: [
                        // _isLoading
                        //     ? const LinearProgressIndicator()
                        //     : const Padding(padding: EdgeInsets.only(top: 0)),
                        // const Divider(),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.92,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Color.fromARGB(255, 219, 219, 219),
                                    width: 1.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  emptyPollQuestion == true
                                      ? Column(
                                          children: [
                                            Container(height: 6),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.error,
                                                    size: 16,
                                                    color: Color.fromARGB(
                                                        255, 220, 105, 96)),
                                                Container(width: 4),
                                                Text(
                                                  'Poll question cannot be blank.',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 220, 105, 96),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  Padding(
                                    padding: emptyPollQuestion == true
                                        ? const EdgeInsets.only(
                                            bottom: 20.0, top: 10)
                                        : const EdgeInsets.only(
                                            bottom: 20.0, top: 20),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.81,
                                      // color: Colors.orange,

                                      child: WillPopScope(
                                        onWillPop: () async {
                                          print('POP');
                                          return false;
                                        },
                                        child: Stack(
                                          children: [
                                            TextField(
                                              maxLength:
                                                  _pollQuestionTextfieldMaxLength,
                                              onChanged: (val) {
                                                setState(() {
                                                  // emptyPollQuestion = false;
                                                });
                                              },
                                              controller: _pollController,
                                              onTap: () {
                                                setState(() {
                                                  textfield1selected = true;
                                                  textfield1selected2 = false;
                                                  textfield1selected3 = false;
                                                });
                                              },
                                              onSubmitted: (t) {
                                                setState(() {
                                                  textfield1selected = false;
                                                  textfield1selected2 = false;
                                                  textfield1selected3 = false;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                // filled: true,
                                                // fillColor: Color.fromARGB(
                                                //     255, 241, 241, 241),
                                                hintText: "Poll question ...",
                                                // border: InputBorder.none,
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 0,
                                                    left: 4,
                                                    right: 45,
                                                    bottom: 8),
                                                isDense: true,

                                                hintStyle: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                // fillColor: Colors.white,
                                                // filled: true,
                                                counterText: '',
                                              ),
                                              maxLines: null,
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              right: 0,
                                              child: Text(
                                                '${_pollController.text.length}/$_pollQuestionTextfieldMaxLength',
                                                style: TextStyle(
                                                  // fontStyle: FontStyle.italic,
                                                  fontSize: 12,
                                                  color: _pollController
                                                              .text.length ==
                                                          _pollQuestionTextfieldMaxLength
                                                      ? Color.fromARGB(
                                                          255, 220, 105, 96)
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        emptyOptionOne || emptyOptionTwo
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.error,
                                                        size: 16,
                                                        color: Color.fromARGB(
                                                            255, 220, 105, 96)),
                                                    Container(width: 6),
                                                    Text(
                                                        'First two poll options cannot be blank.',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    220,
                                                                    105,
                                                                    96))),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: i,
                                            itemBuilder: (context, index) {
                                              _cont!
                                                  .add(TextEditingController());
                                              int ic = index + 1;
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    top: 6,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      TextField(
                                                        maxLength:
                                                            _optionTextfieldMaxLength,
                                                        onChanged: (val) {
                                                          setState(() {});
                                                          // setState(() {
                                                          //   emptyOptionOne ==
                                                          //           true
                                                          //       ? emptyOptionOne =
                                                          //           false
                                                          //       : null;
                                                          //   emptyOptionTwo ==
                                                          //           true
                                                          //       ? emptyOptionTwo =
                                                          //           false
                                                          //       : null;
                                                          // });
                                                        },
                                                        controller:
                                                            _cont![index],
                                                        onTap: () {
                                                          setState(() {
                                                            textfield1selected =
                                                                false;
                                                            textfield1selected2 =
                                                                true;
                                                            textfield1selected3 =
                                                                false;
                                                          });
                                                        },
                                                        onSubmitted: (t) {
                                                          setState(() {
                                                            textfield1selected =
                                                                false;
                                                            textfield1selected2 =
                                                                false;
                                                            textfield1selected3 =
                                                                false;
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          counter: Container(),
                                                          labelText: index ==
                                                                      0 ||
                                                                  index == 1
                                                              ? "Option #$ic"
                                                              : "Option #$ic (optional)",
                                                          labelStyle:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                          suffixIcon: i == 2
                                                              ? Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .transparent)
                                                              : InkWell(
                                                                  // customBorder:
                                                                  //     const CircleBorder(),

                                                                  onTap: () {
                                                                    print(
                                                                        index);
                                                                    print(i);

                                                                    if (i > 2) {
                                                                      setState(
                                                                          () {
                                                                        i = i -
                                                                            1;
                                                                        print(
                                                                            i);

                                                                        _cont![index]
                                                                            .clear();
                                                                      });

                                                                      if (index !=
                                                                          i) {
                                                                        print(
                                                                            'abc');
                                                                        print(_cont![i]
                                                                            .text);
                                                                        if (_cont![i -
                                                                                1]
                                                                            .text
                                                                            .isEmpty) {
                                                                          _cont![i - 1].text =
                                                                              _cont![i].text;
                                                                        }

                                                                        print(_cont![i -
                                                                                1]
                                                                            .text);
                                                                        _cont![i]
                                                                            .clear();
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            14),
                                                                    child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                          // hintText: "Option #$ic",
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .blue,
                                                                    width: 2.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                          // fillColor: Colors.white,
                                                          // filled: true,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                      Positioned(
                                                        bottom: 12,
                                                        right: 6,
                                                        child: Text(
                                                          '${_cont![index].text.length}/$_optionTextfieldMaxLength',
                                                          style: TextStyle(
                                                            // fontStyle: FontStyle.italic,
                                                            fontSize: 12,
                                                            color: _cont![index]
                                                                        .text
                                                                        .length ==
                                                                    _optionTextfieldMaxLength
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        220,
                                                                        105,
                                                                        96)
                                                                : Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ],
                                    ),
                                  ),
                                  i == 10
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 19),
                                          child: Text('MAXIMUM OPTIONS REACHED',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 85, 85, 85),
                                                  fontSize: 13)),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, bottom: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  splashColor: Colors.blue
                                                      .withOpacity(0.3),
                                                  onTap: () {
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 150),
                                                        () {
                                                      setState(() {
                                                        print(i = i + 1);
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          color: Colors.blue,
                                                          size: 27,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text('ADD OPTION',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            )),
                                                        // onPressed: () {
                                                        //   setState(() {
                                                        //     // i = i + 1;
                                                        //     print(i = i + 1);
                                                        //   });
                                                        // },
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.92,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // color: Color.fromARGB(255, 219, 219, 219),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Color.fromARGB(255, 219, 219, 219),
                                    width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Autocomplete<String>(
                                    optionsViewBuilder:
                                        (context, onSelected, options) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Material(
                                            elevation: 4.0,
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 200),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: options.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final dynamic option =
                                                      options.elementAt(index);
                                                  return TextButton(
                                                    onPressed: () {
                                                      onSelected(option);
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 15.0),
                                                        child: Text(
                                                          '$option',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    74,
                                                                    137,
                                                                    92),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<String>.empty();
                                      }
                                      return _pickLanguage
                                          .where((String option) {
                                        return option.contains(textEditingValue
                                            .text
                                            .toLowerCase());
                                      });
                                    },
                                    onSelected: (String selectedTag) {
                                      keywordMessageController.addTag =
                                          selectedTag;
                                    },
                                    fieldViewBuilder:
                                        (context, ttec, tfn, onFieldSubmitted) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 46,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // Color.fromARGB(255, 248, 248, 248),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              border: Border.all(
                                                  color: textfield1selected3 ==
                                                          false
                                                      ? Colors.grey
                                                      : Colors.blue,
                                                  width: textfield1selected3 !=
                                                          false
                                                      ? 2
                                                      : 1),
                                            ),
                                            child: TextFieldTags(
                                              textEditingController: ttec,
                                              focusNode: tfn,
                                              // textfieldTagsController:
                                              //     keywordMessageController,
                                              initialTags: const [],
                                              textSeparators: const [' ', ','],
                                              letterCase: LetterCase.normal,
                                              inputfieldBuilder: (context,
                                                  tec,
                                                  fn,
                                                  error,
                                                  onChanged,
                                                  onSubmitted) {
                                                return ((context, sc, tags,
                                                    onTagDelete) {
                                                  myTagsPoll = tags;
                                                  List<String> tagsLower = tags;
                                                  tagsLower = tagsLower
                                                      .map((tagLower) =>
                                                          tagLower
                                                              .toLowerCase())
                                                      .toList();
                                                  myTagsLowerCase = tagsLower;
                                                  return Row(
                                                    children: [
                                                      Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: tags
                                                                        .length <
                                                                    3
                                                                ? MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.4),
                                                        child:
                                                            SingleChildScrollView(
                                                          controller: sc,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: tags
                                                                  .map((String
                                                                      tag) {
                                                                return Container(
                                                                  height: 28,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                          borderRadius: BorderRadius
                                                                              .all(
                                                                            Radius.circular(20.0),
                                                                          ),
                                                                          color:
                                                                              Colors.grey),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 3,
                                                                      right: 3),
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                      vertical:
                                                                          4.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      InkWell(
                                                                        child:
                                                                            Text(
                                                                          tag,
                                                                          style:
                                                                              const TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              4.0),
                                                                      InkWell(
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .cancel,
                                                                          size:
                                                                              17.0,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          onTagDelete(
                                                                              tag);
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              }).toList()),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: TextField(
                                                          controller: tec,
                                                          focusNode: fn,
                                                          enabled:
                                                              tags.length < 3,
                                                          onTap: () {
                                                            setState(() {
                                                              textfield1selected =
                                                                  false;
                                                              textfield1selected2 =
                                                                  false;
                                                              textfield1selected3 =
                                                                  true;
                                                            });
                                                          },
                                                          onSubmitted: (t) {
                                                            onSubmitted;
                                                            setState(() {
                                                              textfield1selected =
                                                                  false;
                                                              textfield1selected2 =
                                                                  false;
                                                              textfield1selected3 =
                                                                  false;
                                                            });
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0,
                                                                    left: 10,
                                                                    right: 0,
                                                                    bottom: 10),
                                                            hintText: tags
                                                                    .isNotEmpty
                                                                ? ''
                                                                : "Add up to 3 keywords...",
                                                            hintStyle:
                                                                const TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        15),
                                                            errorText: error,
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          onChanged: onChanged,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5,
                                                                right: 5),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(Icons.key,
                                                                color: textfield1selected3 ==
                                                                        false
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .blue),
                                                            tags.length == 3
                                                                ? Text(
                                                                    '${tags.length}/3',
                                                                    style:
                                                                        const TextStyle(
                                                                      // fontStyle: FontStyle.italic,
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    '${tags.length}/3',
                                                                    style:
                                                                        const TextStyle(
                                                                      // fontStyle: FontStyle.italic,
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                          child: Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              splashColor: Colors.black.withOpacity(0.3),
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  performLoggedUserAction(
                                      context: context,
                                      action: () {
                                        postImagePoll(
                                          user?.uid ?? '',
                                          user?.username ?? '',
                                          user?.photoUrl ?? '',
                                          user?.country ?? '',
                                        );
                                      });
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 225,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 14.0,
                                      ),
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                        width: user?.isPending == "true" &&
                                                global == "false"
                                            ? 11
                                            : user?.country == "" &&
                                                    global == "false"
                                                ? 10
                                                : global == 'true'
                                                    ? 16.5
                                                    : 11),
                                    Text(
                                      user?.isPending == "true" &&
                                              global == "false"
                                          ? 'Verification Pending'
                                          : user?.country == "" &&
                                                  global == "false"
                                              ? 'Nationality Unknown'
                                              : global == 'true'
                                                  ? 'Send Poll Globally'
                                                  : 'Send Poll Nationally',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          letterSpacing: 1),
                                    )
                                  ],
                                ),
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
    );
  }

  Widget _icon(int index, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkResponse(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected == index ? Colors.blueAccent : Colors.grey,
            ),
          ],
        ),
        onTap: () => setState(
          () {
            selected = index;
            print('this is the index:');
            print(index);
            index == 1 ? _selectImage(context) : null;
            index == 2 ? _selectVideo(context) : null;
            index == 3 ? _selectYoutube(context) : null;

            index == 0 || index == 2 || index == 3 ? clearImage() : null;
            index == 0 || index == 1 || index == 2 ? clearVideoUrl() : null;
          },
        ),
      ),
    );
  }

  Widget rollingIconBuilderStringTwo(
      String messages, Size iconSize, bool foreground) {
    IconData data = Icons.poll;
    if (messages == 'true') data = Icons.message;
    return Icon(data, size: iconSize.shortestSide, color: Colors.white);
  }

  Widget rollingIconBuilderStringThree(
      String global, Size iconSize, bool foreground) {
    IconData data = Icons.flag;
    if (global == 'true') data = Icons.public;
    return Icon(data, size: iconSize.shortestSide, color: Colors.white);
  }

  Future<File> _getVideoThumbnail({required File file}) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}.png';

    final thumbnail = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    return File(filePath).writeAsBytes(thumbnail!);
  }
}
