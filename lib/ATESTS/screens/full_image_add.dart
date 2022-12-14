import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class FullImageScreenAdd extends StatefulWidget {
  final file;

  const FullImageScreenAdd({Key? key, required this.file}) : super(key: key);

  @override
  State<FullImageScreenAdd> createState() => _FullImageScreenAddState();
}

class _FullImageScreenAddState extends State<FullImageScreenAdd> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              elevation: 0,
              backgroundColor:
                  Color.fromARGB(255, 235, 235, 235).withOpacity(0.25),
              title:
                  Text('Image Viewer', style: TextStyle(color: Colors.black))),
          backgroundColor: Color.fromARGB(255, 235, 235, 235),
          body: Container(
            height: MediaQuery.of(context).size.height * 1 - safePadding,
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.06,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Color.fromARGB(255, 186, 186, 186),
                //     ),
                //     alignment: Alignment.center,
                //     child: InkWell(
                //       onTap: () {
                //         Navigator.of(context).pop();
                //       },
                //       child: const Icon(
                //         Icons.clear,
                //         color: Colors.white,
                //         size: 40,
                //       ),
                //     ),
                //   ),
                // ),
                InteractiveViewer(
                  clipBehavior: Clip.none,
                  minScale: 1,
                  maxScale: 4,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1 -
                        safePadding -
                        kToolbarHeight,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 235, 235, 235),
                    ),
                    // child: Image.network(image),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: widget.file,

                        fit: BoxFit.contain,
                        // alignment: FractionalOffset.topCenter,
                      )),
                    ),
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height * 0.03,
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.grey,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
