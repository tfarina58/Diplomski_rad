import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/estates/estates.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/interfaces/preferences/user-preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/firebase.dart';

class UsersPage extends StatefulWidget {
  User? user;
  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};

  List<Customer> customers = [];

  int currentPage = 0;
  int numOfPages = 0;
  String searchbarText = "";

  bool blocked = false, banned = false;
  bool individual = false, company = false;
  bool updated = false;

  int? from, to;

  UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<bool> upDownFilters = [true, false];
  List<bool> isHovering = [false, false, false];

  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();

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
        widget.headerValues["userImage"] = tmpAvatarImage ?? "";
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
            getTableHeader(height),
            Divider(
              height: 30,
              thickness: 3,
              color: PalleteCommon.gradient2,
              indent: width * 0.02,
              endIndent: width * 0.02,
            ),
            getRows(width, height),
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
                widget.searchbarText = "";
              },
              child: const Icon(Icons.close),
            ),
            const SizedBox(width: 15),
          ],
          onChanged: (String value) => setState(() {
            widget.searchbarText = value;
            widget.currentPage = 0;
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
    bool banned = widget.banned,
        blocked = widget.blocked,
        individual = widget.individual,
        company = widget.company;

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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: PalleteCommon.gradient2,
                          value: blocked,
                          onChanged: (bool? value) {
                            if (value == null) return;

                            setState(() {
                              blocked = value;
                              if (value == false) banned = false;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 22,
                        ),
                        Text(widget.lang!.dictionary["blocked"]!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: PalleteCommon.gradient2,
                          value: individual,
                          onChanged: (bool? value) {
                            if (value == null) return;

                            setState(() {
                              individual = value;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 22,
                        ),
                        Text(widget.lang!.dictionary["individual"]!),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: PalleteCommon.gradient2,
                          value: banned,
                          onChanged: (bool? value) {
                            if (value == null) return;

                            setState(() {
                              banned = value;
                              if (value == true) blocked = true;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 22,
                        ),
                        Text(widget.lang!.dictionary["banned"]!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: PalleteCommon.gradient2,
                          value: company,
                          onChanged: (bool? value) {
                            if (value == null) return;

                            setState(() {
                              company = value;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 22,
                        ),
                        Text(widget.lang!.dictionary["company"]!),
                      ],
                    ),
                  ],
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
      const Expanded(flex: 1, child: SizedBox()),
    );
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
      res.add(
        const Expanded(flex: 1, child: SizedBox()),
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
          final documents = snapshot.data.docs;

          widget.customers = [];

          snapshot.data.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic>? tmpMap = doc.data() as Map<String, dynamic>?;
            if (tmpMap == null) return;

            User? tmp = User.toUser(tmpMap);
            if (tmp == null) return;

            widget.customers.add(tmp as Customer);
          }).toList();

          // TODO: find a better solution
          if (!widget.updated) {
            widget.updated = true;
            Future.delayed(
              const Duration(milliseconds: 0),
              () {
                setState(() {
                  widget.numOfPages = widget.customers.length ~/
                      widget.user!.preferences.usersPerPage;
                });
              },
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
              Row(
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
                        child: Image.asset("images/default_user.png"),
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
                              PalleteCommon.backgroundColor,
                            ),
                          ),
                          onPressed: () => goToEstatesPage(),
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
                          setState(
                            () {
                              widget.customers[i].blocked =
                                  !widget.customers[i].blocked;
                            },
                          );
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
                          setState(() {
                            widget.customers[i].banned =
                                !widget.customers[i].banned;
                          });
                        },
                        child: Icon(
                          widget.customers[i].banned ? Icons.done : Icons.close,
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
            rows.add(
              Divider(
                height: 20,
                thickness: 3,
                color: PalleteCommon.gradient2,
                indent: width * 0.02,
                endIndent: width * 0.02,
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

  Stream<QuerySnapshot<Map<String, dynamic>>> streamQueryBuilder() {
    print(widget.from);
    print(widget.to);
    print(widget.blocked);
    print(widget.banned);
    print(widget.individual);
    print(widget.company);
    CollectionReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection('users');
    Query<Map<String, dynamic>> tmpQuery;

    Stream<QuerySnapshot<Map<String, dynamic>>> baseQuery =
        users.where("typeOfUser", isNotEqualTo: "adm").snapshots();

    // Query for documents that meet the first condition
    Stream<QuerySnapshot<Map<String, dynamic>>> popupQuery;

    if (widget.banned) {
      tmpQuery = users.where("banned", isEqualTo: true);
    } else if (widget.blocked) {
      tmpQuery = users.where("blocked", isEqualTo: true);
    } else {
      tmpQuery = users.where("blocked", isEqualTo: false);
    }
    if (widget.individual && widget.company ||
        !widget.individual && !widget.company) {
      // Don't do anything
    } else {
      if (widget.individual) {
        tmpQuery = tmpQuery.where("typeOfUser", isEqualTo: "ind");
      } else if (widget.company) {
        tmpQuery = tmpQuery.where("typeOfUser", isEqualTo: "com");
      }
    }
    if (widget.from != null && widget.to != null) {
      tmpQuery = tmpQuery
          .where("numOfEstates",
              isGreaterThanOrEqualTo:
                  widget.from! > widget.to! ? widget.to : widget.from)
          .where("numOfEstates",
              isLessThanOrEqualTo:
                  widget.from! > widget.to! ? widget.from : widget.to);
    } else if (widget.from != null) {
      tmpQuery = tmpQuery.where("numOfEstates", isGreaterThan: widget.from);
    } else if (widget.to != null) {
      tmpQuery = tmpQuery.where("numOfEstates", isLessThanOrEqualTo: widget.to);
    }
    popupQuery = tmpQuery.snapshots();

    // Query for documents that meet the second condition
    /*Stream<QuerySnapshot<Map<String, dynamic>>> emailQuery =
        users.where('email', arrayContains: widget.searchbarText).snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> phoneQuery =
        users.where('phone', arrayContains: widget.searchbarText).snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> nameQuery =
        users.where('email', arrayContains: widget.searchbarText).snapshots();*/

    // Combine the two streams using the merge operator
    // !!! Base query cannot be combined with other queries !!!
    if (checkFiltersInactivity()) {
      return baseQuery;
    } else {
      return popupQuery;

      // TODO: Other streams need to be fixed
      /*Stream<QuerySnapshot<Map<String, dynamic>>> mergedStream =
          Rx.combineLatest5(
              baseQuery, popupQuery, emailQuery, phoneQuery, nameQuery,
              (a, b, c, d, e) {
        Set<String> ids = <String>{};

        for (int i = 0; i < a.docs.length; ++i) {
          if (!ids.contains(a.docs[i].id)) {
            ids.add(a.docs[i].id);
          }
        }

        for (int i = 0; i < b.docs.length; ++i) {
          if (!ids.contains(b.docs[i].id)) {
            a.docs.add(b.docs[i]);
            ids.add(b.docs[i].id);
          }
        }

        for (int i = 0; i < c.docs.length; ++i) {
          if (!ids.contains(c.docs[i].id)) {
            a.docs.add(c.docs[i]);
            ids.add(c.docs[i].id);
          }
        }

        for (int i = 0; i < d.docs.length; ++i) {
          if (!ids.contains(d.docs[i].id)) {
            a.docs.add(d.docs[i]);
            ids.add(d.docs[i].id);
          }
        }

        for (int i = 0; i < e.docs.length; ++i) {
          if (!ids.contains(e.docs[i].id)) {
            a.docs.add(e.docs[i]);
            ids.add(e.docs[i].id);
          }
        }

        print("Count: ${a.docChanges.length}");
        print("---------------------------");

        return a;
      });
      
      return mergedStream;*/
    }
  }

  bool checkFiltersInactivity() {
    return !widget.banned &&
        !widget.blocked &&
        !widget.individual &&
        !widget.company &&
        (widget.from == null || widget.from == 0) &&
        (widget.to == null || widget.to == 0);
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

  void goToEstatesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EstatesPage(
          showEmptyCard: false,
        ),
      ),
    );
  }
}
