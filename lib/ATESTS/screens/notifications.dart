import 'package:flutter/material.dart';

import 'notifications_preferences.dart';
import 'settings.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsPreferences()),
                          );
                        });
                      },
                      child: const Icon(Icons.notifications_active,
                          color: Color.fromARGB(255, 80, 80, 80)),
                    ),
                  ),
                ),
                Text(
                  'Notifications',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Container(
                  height: 40,
                  // width: MediaQuery.of(context).size.width * 0.135,
                  // alignment: Alignment.centerRight,
                  child: Material(
                    shape: const CircleBorder(),
                    color: Colors.white,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      splashColor: Colors.grey.withOpacity(0.5),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 50), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsScreen()),
                          );
                        });
                      },
                      child: const Icon(Icons.settings,
                          color: Color.fromARGB(255, 80, 80, 80)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
