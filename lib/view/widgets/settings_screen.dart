import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_ninja_spectrum/view/widgets/custom-drawer-widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../auth_ui/welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitchedNotification = false;
  bool isSwitchedDarklight = false;
  String dropdownvalue = 'Malayalam';
  var languages = [
    'Malayalam',
    'English',
    'Hindi',
  ];
  User? user = FirebaseAuth.instance.currentUser;
  final currentUser = FirebaseAuth.instance;
  late String userName = '';
  late String imageUrl;
  late String userEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer()),
        backgroundColor: const Color(0xFF1F41BB),
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 0,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      drawer: DrawerWidget(),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Card(
                  color: Color(0xFFF3F4F6),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("uId",
                              isEqualTo: currentUser.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: SizedBox(
                                  width: 25.w,
                                  height: 25.h,
                                  child:
                                      CircularProgressIndicator())); // Loading state
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return Text("No data found");
                          // No data found
                        }
                        final userData = snapshot.data!.docs.first.data()
                            as Map<String, dynamic>;
                        userName = userData['username'] as String;
                        imageUrl = userData['userImg'
                            ''] as String;
                        userEmail = userData['email'] as String;
                        return ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 0,top: 10,bottom: 10),
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.network('$imageUrl')),
                          ),
                          title: Text('$userName',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                height: 0,
                                fontFamily: 'Poppins',
                              )),
                          subtitle: Text("$userEmail", style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 0,
                            fontFamily: 'Poppins',
                          )),
                        );
                      }),
                ),
                Card(
                  color: Color(0xFFF3F4F6),
                  child: ListTile(
                    leading: Icon(
                      Icons.privacy_tip_outlined,
                      size: 30,
                      color: const Color(0xFF4A4A5F),
                    ),
                    title: Text('Privacy and policy',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 0,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                Card(
                  color: Color(0xFFF3F4F6),
                  child: ListTile(
                    leading: Icon(Icons.notifications,
                        size: 30, color: const Color(0xFF4A4A5F)),
                    title: Text('Notification',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 0,
                          fontFamily: 'Poppins',
                        )),
                    trailing: Transform.scale(
                      scale:
                          0.9, // Adjust the scale factor to change the switch size
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            isSwitchedNotification = value;
                          });
                          print(
                              'Switch Button is ${isSwitchedNotification ? 'ON' : 'OFF'}');
                        },
                        value: isSwitchedNotification,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.yellow,
                        inactiveThumbColor: Colors.redAccent,
                        inactiveTrackColor: Colors.orange,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Color(0xFFF3F4F6),
                  child: ListTile(
                    leading: Icon(Icons.dark_mode,
                        size: 30, color: const Color(0xFF4A4A5F)),
                    title: Text('Dark/Light Mode',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 0,
                          fontFamily: 'Poppins',
                        )),
                    trailing: Transform.scale(
                      scale:
                          0.9, // Adjust the scale factor to change the switch size
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            isSwitchedDarklight = value;
                          });
                          print(
                              'Switch Button is ${isSwitchedDarklight ? 'ON' : 'OFF'}');
                        },
                        value: isSwitchedDarklight,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.yellow,
                        inactiveThumbColor: Colors.redAccent,
                        inactiveTrackColor: Colors.orange,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Color(0xFFF3F4F6),
                  child: ListTile(
                      leading: Icon(Icons.language,
                          size: 30, color: const Color(0xFF4A4A5F)),
                      title: Text('Language',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 0,
                            fontFamily: 'Poppins',
                          )),
                      trailing: DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: languages.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      )),
                ),
                Card(
                  color: Color(0xFFF3F4F6),
                  child: ListTile(
                    leading: Icon(Icons.password,
                        size: 30, color: Color(0xFF4A4A5F)),
                    title: Text('Change Password',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 0,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                Card(
                  color: Color(0xFFF3F4F6),
                  child: ListTile(
                    leading: Icon(Icons.delete,
                        size: 30, color: Color(0xFF4A4A5F)),
                    title: Text('Delete Account',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 0,
                          fontFamily: 'Poppins',
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.off(() => const WelcomeScreen());
                  },
                  child: Card(
                    color: Color(0xFFF3F4F6),
                    child: ListTile(
                      leading: Icon(Icons.logout,
                          size: 30, color: Color(0xFF4A4A5F)),
                      title: Text(
                        'Log Out',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 0,
                            fontFamily: 'Poppins',
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
