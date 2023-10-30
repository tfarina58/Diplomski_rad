import 'dart:async';

import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/estates/estates.dart';
import 'package:diplomski_rad/profile/profile.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:rxdart/rxdart.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:async/async.dart';

class UsersPage extends StatefulWidget {
  User? user;
  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};

  List<Customer> customers = [];

  int currentPage = 0;
  int numOfPages = 0;
  String searchbarText = "";

  String orderBy = "phone";
  bool asc = true;

  int? from, to;
  bool? blocked, banned;
  bool individual = false, company = false;
  bool updated = false;

  UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<bool> upDownFilters = [true, false];
  List<bool> isHovering = [false, false, false];

  late ScrollController scrollController;
  late BehaviorSubject<QuerySnapshot<Map<String, dynamic>>>
      mergedStreamController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    mergedStreamController =
        BehaviorSubject<QuerySnapshot<Map<String, dynamic>>>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tmpUserId = prefs.getString("userId");
      String? tmpTypeOfUser = prefs.getString("typeOfUser");
      String? tmpAvatarImage = prefs.getString("avatarImage");
      String? tmpLanguage = prefs.getString("language");

      if (tmpUserId == null || tmpUserId.isEmpty) return;
      if (tmpTypeOfUser == null || tmpTypeOfUser.isEmpty) return;
      if (tmpLanguage == null || tmpLanguage.isEmpty) return;

      LanguageService tmpLang = LanguageService.getInstance(tmpLanguage);
      Map<String, dynamic>? userMap =
          await UserRepository.readUserWithId(tmpUserId);
      if (userMap == null) return;

      setState(() {
        widget.user = User.toUser(userMap);
        widget.lang = tmpLang;
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage ?? "";
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 350), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (widget.lang == null || widget.user == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'UsersPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            getPageHeader(width, height),
            SizedBox(
              height: height * 0.075,
            ),
            // Table header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Expanded(flex: 40, child: getTableHeader(height)),
                const Expanded(child: SizedBox()),
              ],
            ),
            Divider(
              height: 30,
              thickness: 3,
              color: PalleteCommon.gradient2,
              indent: width * 0.025,
              endIndent: width * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Expanded(flex: 40, child: getRows(width, height)),
                const Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  getNumOfUsersSelection(),
                  const Expanded(flex: 1, child: SizedBox()),
                  getPagination(width, height),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 1,
                    child: GradientButton(
                      buttonText: widget.lang!.dictionary["scroll_to_top"]!,
                      callback: () {
                        scrollToTop();
                      },
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
          ],
        ),
      ),
    );
  }

  Widget getPageHeader(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SearchBar(
          hintText: "john.doe@mail.com",
          leading: const Icon(Icons.search),
          trailing: [
            Tooltip(
              message: widget.lang!.dictionary["search_text"]!,
              triggerMode: TooltipTriggerMode.tap,
              child: const Icon(Icons.info),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.searchbarText = "";
                });
              },
              child: const Icon(Icons.close),
            ),
            const SizedBox(width: 15),
          ],
          onChanged: (String value) => setState(() {
            widget.searchbarText = value;
            widget.currentPage = 0;
            widget.numOfPages = widget.customers.length ~/
                widget.user!.preferences.usersPerPage;
          }),
        ),
        SizedBox(
          width: width * 0.02,
        ),
        GradientButton(
          buttonText: widget.lang!.dictionary["additional_filters"]!,
          callback: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return getAdditionalFilters(width, height);
              },
            );
          },
        ),
      ],
    );
  }

  Widget getAdditionalFilters(double width, double height) {
    int? from = widget.from, to = widget.to;
    bool? banned = widget.banned, blocked = widget.blocked;
    bool individual = widget.individual, company = widget.company;

    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(
        width * 0.3,
        height * 0.3,
        width * 0.3,
        height * 0.3,
      ),
      backgroundColor: PalleteCommon.backgroundColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Column(
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
                    Text(
                      "${widget.lang!.dictionary['number_of_estates']!}: ",
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    StringField(
                      presetText: from != null ? from.toString() : '',
                      inputType: TextInputType.number,
                      maxWidth: 200,
                      labelText: widget.lang!.dictionary["from"]!,
                      callback: (dynamic value) {
                        setState(() {
                          if (value == null) from = null;
                          from = int.parse(value);
                        });
                      },
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    StringField(
                      presetText: to != null ? to.toString() : '',
                      inputType: TextInputType.number,
                      maxWidth: 200,
                      labelText: widget.lang!.dictionary["to"]!,
                      callback: (dynamic value) {
                        setState(() {
                          if (value == null) to = null;
                          to = int.parse(value);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownField(
                      maxWidth: 200,
                      labelText: widget.lang!.dictionary["blocked"]!,
                      callback: (String? value) {
                        setState(() {
                          if (value == null) return;

                          if (value == "True") {
                            blocked = true;
                          } else if (value == "False") {
                            blocked = false;
                          } else {
                            blocked = null;
                          }

                          // if (blocked == false) banned = false;
                        });
                      },
                      choices: const ["-", "True", "False"],
                      selected: blocked == true
                          ? "True"
                          : blocked == false
                              ? "False"
                              : "-",
                    ),
                    DropdownField(
                      maxWidth: 200,
                      labelText: widget.lang!.dictionary["individual"]!,
                      callback: (String? value) {
                        setState(() {
                          if (value == null) return;

                          if (value == "True") {
                            individual = true;
                          } else {
                            individual = false;
                          }
                        });
                      },
                      choices: const ["True", "False"],
                      selected: individual == true ? "True" : "False",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownField(
                      maxWidth: 200,
                      labelText: widget.lang!.dictionary["banned"]!,
                      callback: (String? value) {
                        setState(() {
                          if (value == null) return;

                          if (value == "True") {
                            banned = true;
                          } else if (value == "False") {
                            banned = false;
                          } else {
                            banned = null;
                          }

                          // if (banned == true) blocked = true;
                        });
                      },
                      choices: const ["-", "True", "False"],
                      selected: banned == true
                          ? "True"
                          : banned == false
                              ? "False"
                              : "-",
                    ),
                    DropdownField(
                      maxWidth: 200,
                      labelText: widget.lang!.dictionary["company"]!,
                      callback: (String? value) {
                        setState(() {
                          if (value == null) return;

                          if (value == "True") {
                            company = true;
                          } else if (value == "False") {
                            company = false;
                          }
                        });
                      },
                      choices: const ["True", "False"],
                      selected: company == true ? "True" : "False",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.from = from;
                widget.to = to;
                widget.blocked = blocked;
                widget.banned = banned;
                widget.individual = individual;
                widget.company = company;
              });
              Navigator.pop(context);
            },
            style: ButtonStyle(
              fixedSize: MaterialStatePropertyAll(
                Size(width * 0.15, height * 0.05),
              ),
              backgroundColor: const MaterialStatePropertyAll(
                PalleteCommon.gradient2,
              ),
            ),
            child: Text(widget.lang!.dictionary["apply_filters"]!),
          ),
        ],
      ),
    );
  }

  Widget getTableHeader(double height) {
    List<Widget> res = [];

    res.add(
      Expanded(
        flex: 1,
        child: SizedBox(
          height: height * 0.08,
          child: const Center(
            child: Text("#"),
          ),
        ),
      ),
    );
    res.add(
      Expanded(
        flex: 2,
        child: SizedBox(
          height: height * 0.08,
          child: Center(
            child: Text(widget.lang!.dictionary["image"]!),
          ),
        ),
      ),
    );
    res.add(
      const Expanded(flex: 1, child: SizedBox()),
    );

    List<String> filterTitles = [
      "Name",
      "Email",
      "Phone",
      "Estates",
      "Type",
      "Blocked",
      "Banned",
    ];

    for (int i = 0; i < filterTitles.length; ++i) {
      res.add(
        Expanded(
          flex: i < filterTitles.length - 2 ? 2 : 1,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(filterTitles[i]),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("#"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Image
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(widget.lang!.dictionary["image"]!),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Name
        Expanded(
          flex: 3,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(widget.lang!.dictionary["name"]!),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Email
        Expanded(
          flex: 3,
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
          flex: 3,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(widget.lang!.dictionary["phone_number"]!),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Estates
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(widget.lang!.dictionary["number_of_estates"]!),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Banned
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(widget.lang!.dictionary["type"]!),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Blocked
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(widget.lang!.dictionary["blocked"]!),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Banned
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height * 0.08,
            child: Center(
              child: Text(widget.lang!.dictionary["banned"]!),
            ),
          ),
        ),

        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  StreamBuilder getRows(double width, double height) {
    return StreamBuilder(
      stream: streamQueryBuilder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: PalleteCommon.gradient2,
            semanticsLabel: "Loading",
            backgroundColor: PalleteCommon.backgroundColor,
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        } else {
          widget.customers = [];

          snapshot.data.map((doc) {
            User? tmp = User.toUser(doc);
            if (tmp == null) return;

            widget.customers.add(tmp as Customer);
          }).toList();

          // TODO: find a solution
          if (!widget.updated) {
            widget.updated = true;
            Future.delayed(const Duration(milliseconds: 0), () {
              setState(() {
                widget.numOfPages = widget.customers.length ~/
                    widget.user!.preferences.usersPerPage;
              });
            });
          }

          if (widget.customers.isEmpty) {
            return SizedBox(
              height: height * 0.4,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: Center(
                      child: Text(
                        "No users to display",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            );
          }

          List<Widget> rows = [];

          for (int i =
                  widget.currentPage * widget.user!.preferences.usersPerPage;
              i <
                      (widget.currentPage + 1) *
                          widget.user!.preferences.usersPerPage &&
                  i < widget.customers.length;
              ++i) {
            rows.add(
              InkWell(
                onHover: (_) {},
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        userId: widget.customers[i].id,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: height * 0.08,
                        child: Center(
                          child: Text((i + 1).toString()),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                    // Image
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: height * 0.08,
                        child: Center(
                          child: widget.customers[i].avatarImage.isNotEmpty
                              ? Image.network(widget.customers[i].avatarImage)
                              : Image.asset("images/default_user.png"),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                    // Name
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: height * 0.08,
                        child: Center(
                          child: Text(
                            (widget.customers[i] is Individual)
                                ? "${(widget.customers[i] as Individual).firstname} ${(widget.customers[i] as Individual).lastname}"
                                : "${(widget.customers[i] as Company).ownerFirstname} ${(widget.customers[i] as Company).ownerLastname}",
                          ),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                    // Email
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: height * 0.08,
                        child: Center(
                          child: Text(widget.customers[i].email),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                    // Phone
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: height * 0.08,
                        child: Center(
                          child: Text(widget.customers[i].phone),
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
                                PalleteCommon.gradient1,
                              ),
                            ),
                            onPressed: () =>
                                goToEstatesPage(widget.customers[i].id),
                            child: Text(
                              widget.customers[i].numOfEstates.toString(),
                            ),
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
                        child: Tooltip(
                          message: widget.customers[i] is Individual
                              ? widget.lang!.dictionary["individual"]!
                              : widget.lang!.dictionary["company"]!,
                          child: Icon(
                            widget.customers[i] is Individual
                                ? Icons.person
                                : Icons.location_city,
                            color: PalleteCommon.gradient2,
                            size: 32,
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
                          onTap: () {
                            changeBlockedValue(widget.customers[i]);
                          },
                          child: Icon(
                            widget.customers[i].blocked
                                ? Icons.done
                                : Icons.close,
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
                          onTap: () {
                            changeBannedValue(widget.customers[i]);
                          },
                          child: Icon(
                            widget.customers[i].banned
                                ? Icons.done
                                : Icons.close,
                            color: PalleteCommon.gradient2,
                            size: 32,
                          ),
                        ),
                      ),
                    ),

                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
              ),
            );
            rows.add(
              const Divider(
                height: 20,
                thickness: 3,
                color: PalleteCommon.gradient2,
              ),
            );
          }

          return Column(
            children: rows,
          );
        }
      },
    );
  }

  bool checkSearchbarTextMatching(Map<String, dynamic> hashUser) {
    if ((hashUser["email"] as String).contains(widget.searchbarText)) {
      return true;
    } else if ((hashUser["phone"] as String).contains(widget.searchbarText)) {
      return true;
    } else if ((hashUser["typeOfUser"] as String) == "ind" &&
        ("${hashUser["firstname"] as String} ${hashUser["lastname"] as String}")
            .contains(widget.searchbarText)) {
      return true;
    } else if ((hashUser["typeOfUser"] as String) == "com" &&
        ("${hashUser["ownerFirstname"] as String} ${hashUser["ownerLastname"] as String}")
            .contains(widget.searchbarText)) {
      return true;
    }
    return false;
  }

  bool checkNumOfEstatesRange(int numOfEstates) {
    if (widget.from != null && widget.to != null) {
      int from = widget.from! > widget.to! ? widget.to! : widget.from!;
      int to = widget.from! > widget.to! ? widget.from! : widget.to!;
      return from <= numOfEstates && numOfEstates <= to;
    } else if (widget.from != null) {
      return widget.from! <= numOfEstates;
    } else if (widget.to != null) {
      return numOfEstates <= widget.to!;
    }
    return true;
  }

  Stream<List<Map<String, dynamic>>> streamQueryBuilder() {
    CollectionReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection('users');

    // Combine the two streams using the merge operator
    if (checkFiltersInactivity()) {
      Stream<QuerySnapshot<Map<String, dynamic>>> indQuery = users
          .where("typeOfUser", isEqualTo: "ind")
          .orderBy(widget.orderBy, descending: !widget.asc)
          .snapshots();

      Stream<QuerySnapshot<Map<String, dynamic>>> comQuery = users
          .where("typeOfUser", isEqualTo: "com")
          .orderBy(widget.orderBy, descending: !widget.asc)
          .snapshots();

      return Rx.combineLatest2(indQuery, comQuery,
          (QuerySnapshot<Map<String, dynamic>> snapshot1,
              QuerySnapshot<Map<String, dynamic>> snapshot2) {
        List<Map<String, dynamic>> list = [];

        // Merge sort by widget.orderBy, already sorted by widget.asc
        int i = 0, j = 0;
        while (i < snapshot1.docs.length && j < snapshot2.docs.length) {
          int comparation = (snapshot1.docs[i][widget.orderBy] as String)
              .compareTo(snapshot2.docs[j][widget.orderBy] as String);

          if (widget.asc && comparation < 0 || !widget.asc && comparation > 0) {
            Map<String, dynamic> tmpHashUser = snapshot1.docs[i].data();
            tmpHashUser["id"] = snapshot1.docs[i].id;
            if (checkSearchbarTextMatching(tmpHashUser) &&
                checkNumOfEstatesRange(tmpHashUser["numOfEstates"] as int)) {
              list.add(tmpHashUser);
            }
            ++i;
          } else {
            Map<String, dynamic> tmpHashUser = snapshot2.docs[j].data();
            tmpHashUser["id"] = snapshot2.docs[j].id;
            if (checkSearchbarTextMatching(tmpHashUser) &&
                checkNumOfEstatesRange(tmpHashUser["numOfEstates"])) {
              list.add(tmpHashUser);
            }
            ++j;
          }
        }

        while (i < snapshot1.docs.length) {
          Map<String, dynamic> tmpHashUser = snapshot1.docs[i].data();
          tmpHashUser["id"] = snapshot1.docs[i].id;
          if (checkSearchbarTextMatching(tmpHashUser) &&
              checkNumOfEstatesRange(tmpHashUser["numOfEstates"])) {
            list.add(tmpHashUser);
          }
          ++i;
        }

        while (j < snapshot2.docs.length) {
          Map<String, dynamic> tmpHashUser = snapshot2.docs[j].data();
          tmpHashUser["id"] = snapshot2.docs[j].id;
          if (checkSearchbarTextMatching(tmpHashUser) &&
              checkNumOfEstatesRange(tmpHashUser["numOfEstates"])) {
            list.add(tmpHashUser);
          }
          ++j;
        }
        return list;
      });
    } else {
      Stream<QuerySnapshot<Map<String, dynamic>>> popupQuery;
      Query<Map<String, dynamic>>? tmpQuery;

      // Because of STUPID Firebase API limitations, I am not allowed to set more than 1 inequality statement
      // The one and only inequality statement is reserved for 'numOfEstates' field
      // Admin is automatically removed from the list since its values "blocked" and "banned" are null (not defined)

      if (widget.individual && widget.company ||
          !widget.individual && !widget.company) {
        // tmpQuery = users.where("typeOfUser", isNotEqualTo: "amd");
      } else if (widget.individual && !widget.company) {
        tmpQuery = users.where("typeOfUser", isEqualTo: "ind");
      } else if (!widget.individual && widget.company) {
        tmpQuery = users.where("typeOfUser", isEqualTo: "com");
      }

      if (widget.banned == true) {
        tmpQuery = (tmpQuery ?? users).where("banned", isEqualTo: true);
      } else if (widget.blocked == true) {
        tmpQuery = (tmpQuery ?? users).where("blocked", isEqualTo: true);
      } else if (widget.blocked == false) {
        tmpQuery = (tmpQuery ?? users).where("blocked", isEqualTo: false);
      }

      // If an inequality statement is used for a certain user attribute, the result can only be ordered by (orderBy() function) the same attribute.
      // This limits the use of Firebase Storage API, hence some operations need to be done on the app's front-end.
      // In this case, "numOfEstates" is the attribute that needs to be filtered on the front-end...

      /*if (widget.from != null && widget.to != null) {
        tmpQuery = (tmpQuery ?? users)
            .where("numOfEstates",
                isGreaterThanOrEqualTo:
                    widget.from! > widget.to! ? widget.to : widget.from)
            .where("numOfEstates",
                isLessThanOrEqualTo:
                    widget.from! > widget.to! ? widget.from : widget.to);
      } else if (widget.from != null) {
        tmpQuery = (tmpQuery ?? users)
            .where("numOfEstates", isGreaterThan: widget.from);
      } else if (widget.to != null) {
        tmpQuery = (tmpQuery ?? users)
            .where("numOfEstates", isLessThanOrEqualTo: widget.to);
      }*/
      popupQuery = (tmpQuery ?? users)
          .orderBy(widget.orderBy, descending: !widget.asc)
          .snapshots();

      return Rx.combineLatest([popupQuery],
          (List<QuerySnapshot<Map<String, dynamic>>> elem) {
        List<Map<String, dynamic>> list = [];
        for (int i = 0; i < elem[0].docs.length; ++i) {
          if (elem[0].docs[i]["typeOfUser"] == "adm") continue;

          Map<String, dynamic> tmpHashUser = elem[0].docs[i].data();
          tmpHashUser["id"] = elem[0].docs[i].id;

          // Checking if there is a substring in name + surname, email or phone number equal to widget.searchbarText
          if (checkSearchbarTextMatching(tmpHashUser) &&
              checkNumOfEstatesRange(tmpHashUser["numOfEstates"])) {
            list.add(tmpHashUser);
          }
        }
        return list;
      });
    }
  }

  void changeBlockedValue(Customer customer) async {
    Map<String, dynamic> res =
        await UserRepository.blockUser(customer.id, !customer.blocked);
    if (!res["success"]) return;

    // TODO: change banned value if blocked == false

    setState(() {
      customer.blocked = res["value"];
    });
  }

  void changeBannedValue(Customer customer) async {
    Map<String, dynamic> res =
        await UserRepository.banUser(customer.id, !customer.banned);
    if (!res["success"]) return;

    // TODO: change blocked value if banned == true

    setState(() {
      customer.banned = res["value"];
    });
  }

  bool checkFiltersInactivity() {
    return widget.banned == null &&
        widget.blocked == null &&
        (!widget.individual && !widget.company ||
            widget.individual && widget.company) &&
        widget.from == null &&
        widget.to == null;
  }

  Widget getNumOfUsersSelection() {
    return Expanded(
      flex: 1,
      child: DropdownField(
        labelText: widget.lang!.dictionary["users_per_page"]!,
        maxWidth: 200,
        callback: (int value) {
          setState(() {
            widget.user!.preferences.usersPerPage = value;
            widget.numOfPages = widget.customers.length ~/
                widget.user!.preferences.usersPerPage;
            widget.currentPage = 0;
          });
        },
        choices: const [5, 10, 15, 25, 50, 100, 200],
        selected: widget.user!.preferences.usersPerPage,
      ),
    );
  }

  Widget getPagination(double width, double height) {
    List<Widget> res = [];

    if (widget.numOfPages == 0) {
      return const Expanded(
        flex: 1,
        child: SizedBox(),
      );
    }

    res.add(
      Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            setState(() {
              widget.currentPage = 0;
            });
          },
          child: SizedBox(
            height: width * 0.04,
            child: Center(
              child: Text(
                "1",
                style: widget.currentPage == 0
                    ? const TextStyle(
                        color: PalleteCommon.gradient2,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )
                    : const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    if (widget.currentPage >= 1) {
      res.add(
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                widget.currentPage = widget.currentPage - 1;
              });
            },
            child: SizedBox(
              height: width * 0.04,
              child: const Center(
                child: Text(
                  "<<",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (widget.currentPage != 0 && widget.currentPage != widget.numOfPages) {
      res.add(
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              height: width * 0.04,
              child: Center(
                child: Text(
                  (widget.currentPage + 1).toString(),
                  style: const TextStyle(
                    color: PalleteCommon.gradient2,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (widget.currentPage <= widget.numOfPages - 1) {
      res.add(
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                widget.currentPage = widget.currentPage + 1;
              });
            },
            child: SizedBox(
              height: width * 0.04,
              child: const Center(
                child: Text(
                  ">>",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
    res.add(
      Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            setState(() {
              widget.currentPage = widget.numOfPages;
            });
          },
          child: SizedBox(
            height: width * 0.04,
            child: Center(
              child: Text(
                (widget.numOfPages + 1).toString(),
                style: widget.currentPage == widget.numOfPages
                    ? const TextStyle(
                        color: PalleteCommon.gradient2,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )
                    : const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: res,
      ),
    );
  }

  void goToEstatesPage(String? userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EstatesPage(
          showEmptyCard: false,
          userId: userId,
        ),
      ),
    );
  }
}
