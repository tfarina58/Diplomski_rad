import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/estates/estates.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';

class UsersPage extends StatefulWidget {
  List<User> users = [
    Individual.getUser1(),
    Individual.getUser2(),
    Individual.getUser3()
  ];

  UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool blocked = false, banned = false;

    List<String> checkboxesTitles = ["Blocked", "Banned"];

    List<bool> upDownFilters = [true, false];
    List<String> upDownFiltersTitles = [
      "Name",
      "Email",
      "Phone",
      "Estates",
      "Blocked",
      "Banned"
    ];

    List<bool> isHovering = [false, false, false];

    return Scaffold(
      appBar: HeaderComponent(currentPage: 'UsersPage'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SearchBar(
                  hintText: "Hint Text",
                  trailing: [
                    GestureDetector(
                      onTap: () {
                        print("Info");
                      },
                      child: Icon(Icons.info),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        print("Search");
                      },
                      child: Icon(Icons.search),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                GradientButton(
                  buttonText: "Additional filters",
                  callback: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return getAdditionalFilters(
                            width, height, blocked, banned);
                      },
                    );
                  },
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                GradientButton(
                  colors: PalleteSuccess.getGradients(),
                  callback: () {},
                  buttonText: "Apply filters",
                ),
              ],
            ),
            SizedBox(
              height: height * 0.075,
            ),
            // Table header
            getTableHeader(height, upDownFiltersTitles),

            Divider(
              height: 30,
              thickness: 3,
              color: PalleteCommon.gradient2,
              indent: width * 0.02,
              endIndent: width * 0.02,
            ),
            ...getRows(width, height),
            SizedBox(
              height: height * 0.2,
            ),
          ],
        ),
      ),
    );
  }

  Widget getAdditionalFilters(
      double width, double height, bool blocked, bool banned) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(
        width * 0.3,
        height * 0.3,
        width * 0.3,
        height * 0.3,
      ),
      backgroundColor: PalleteCommon.backgroundColor,
      alignment: Alignment.center,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Phone number starts with: "),
                  const SizedBox(
                    width: 16,
                  ),
                  StringField(
                    maxWidth: 200,
                    labelText: "+123",
                    callback: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Number of estates: "),
                  const SizedBox(
                    width: 16,
                  ),
                  StringField(
                    maxWidth: 200,
                    labelText: "From",
                    callback: () {},
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  StringField(
                    maxWidth: 200,
                    labelText: "To",
                    callback: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: PalleteCommon.gradient2,
                    value: blocked,
                    onChanged: (bool? value) {
                      // print(value);
                      if (value == null) return;

                      setState(() {
                        blocked = value;
                      });
                      print(blocked);
                    },
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  Text(
                    "Blocked",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: PalleteCommon.gradient2,
                    value: banned,
                    onChanged: (bool? value) {
                      // print(value);
                      if (value == null) return;

                      setState(() {
                        banned = value;
                      });
                      print(blocked);
                    },
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  Text(
                    "Banned",
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Apply filters"),
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                    Size(width * 0.15, height * 0.05),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    PalleteCommon.gradient2,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getTableHeader(double height, List<String> upDownFiltersTitles) {
    List<Widget> res = [];

    res.add(
      const Expanded(flex: 1, child: SizedBox()),
    );
    res.add(
      Expanded(
        flex: 2,
        child: SizedBox(
          height: height * 0.08,
          child: const Center(
            child: Text("Image"),
          ),
        ),
      ),
    );
    res.add(
      const Expanded(flex: 1, child: SizedBox()),
    );

    for (int i = 0; i < upDownFiltersTitles.length; ++i) {
      res.add(
        Expanded(
          flex: i < upDownFiltersTitles.length - 2 ? 2 : 1,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(upDownFiltersTitles[i]),
            ),
          ),
        ),
      );
      res.add(
        const Expanded(flex: 1, child: SizedBox()),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        // Image
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("User's image"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Name
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("User's full name / company name"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Email
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("Email"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Phone
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("Phone number"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Estates
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("Number of estates"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Blocked
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("Blocked"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Banned
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("Banned"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  List<Widget> getRows(double width, double height) {
    List<Widget> res = [];

    for (int i = 0; i < widget.users.length; ++i) {
      res.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            // Image
            Expanded(
              flex: 2,
              child: SizedBox(
                height: height * 0.08,
                child: Center(
                  child: Image.asset("images/chick.jpg"),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            // Name
            Expanded(
              flex: 2,
              child: SizedBox(
                height: height * 0.08,
                child: Center(
                  child: Text(
                      "${(widget.users[i] as Individual).firstname} ${(widget.users[i] as Individual).lastname}"),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            // Email
            Expanded(
              flex: 2,
              child: SizedBox(
                height: height * 0.08,
                child: Center(
                  child: Text((widget.users[i] as Individual).email),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            // Phone
            Expanded(
              flex: 2,
              child: SizedBox(
                height: height * 0.08,
                child: Center(
                  child: Text((widget.users[i] as Individual).phone),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            // Estates
            Expanded(
              flex: 2,
              child: InkWell(
                onHover: (value) {},
                child: SizedBox(
                  height: height * 0.08,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          PalleteCommon.highlightColor),
                    ),
                    onPressed: () => goToEstatesPage(),
                    child: const Text("3"),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            // Blocked
            Expanded(
              flex: 1,
              child: SizedBox(
                height: height * 0.08,
                child: InkWell(
                  onHover: (value) {},
                  onTap: () {},
                  child: Icon(
                    Icons.done,
                    color: PalleteCommon.gradient2,
                    size: 32,
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            // Banned
            Expanded(
              flex: 1,
              child: SizedBox(
                height: height * 0.08,
                child: InkWell(
                  onHover: (value) {},
                  onTap: () {},
                  child: Icon(
                    Icons.close,
                    color: PalleteCommon.gradient2,
                    size: 32,
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      );

      res.add(
        Divider(
          height: 20,
          thickness: 3,
          color: PalleteCommon.gradient2,
          indent: width * 0.02,
          endIndent: width * 0.02,
        ),
      );
    }

    return res;
  }

  void goToEstatesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EstatesPage(),
      ),
    );
  }
}
