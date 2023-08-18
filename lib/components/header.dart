import 'package:diplomski_rad/auth/login/login.dart';
import 'package:diplomski_rad/home/home.dart';
import 'package:diplomski_rad/settings/settings.dart';
import 'package:diplomski_rad/estates/estates.dart';
import 'package:diplomski_rad/users/users.dart';
import 'package:diplomski_rad/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderComponent extends StatelessWidget implements PreferredSizeWidget {
  String? currentPage;
  User user = Individual.getUser1();
  // List<HeaderPages> listOfPages = []; TODO

  HeaderComponent({Key? key, this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PalleteCommon.backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: PalleteCommon.borderColor,
          height: 4.0,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 25,
              child: null,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                ),
                child: const SizedBox(
                  width: 150,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Diplomski rad",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UsersPage(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
                      child: Text(
                        "Users",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EstatesPage(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
                      child: Text(
                        "Estates",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  /*InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
                      child: Text(
                        "Settings",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),*/
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
                      child: Text(
                        "Sign Out",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        // child: Icon(Icons.person),
                        child: Image(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

getCurrentPage(BuildContext context) {
  // print(ModalRoute.of(context)!.settings);
  ModalRoute.of(context)!.settings.name;
}
