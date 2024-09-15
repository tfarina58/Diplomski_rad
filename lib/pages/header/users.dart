import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/pages/estates/estates.dart';
import 'package:diplomski_rad/pages/header/profile.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:rxdart/rxdart.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/sequential_field.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/interfaces/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/services/shared_preferences.dart';
import 'package:diplomski_rad/widgets/snapshot_error_field.dart';
import 'package:diplomski_rad/widgets/loading_bar.dart';

class UsersPage extends StatefulWidget {
  User? user;
  LanguageService? lang;

  List<Customer> customers = [];
  int lastAddedCustomer = 0;

  int currentPage = 0;
  int numOfPages = 0;
  String searchbarText = "";
  int offset = 0;

  String orderBy = "email";
  bool asc = true;

  int? from, to;
  bool? blocked, banned;
  bool individual = false, company = false;

  UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late TextEditingController textController;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    textController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
      String tmpUserId = sharedPreferencesService.getUserId();
      String tmpTypeOfUser = sharedPreferencesService.getTypeOfUser();
      String tmpLanguage = sharedPreferencesService.getLanguage();
      int usersPerPage = sharedPreferencesService.getUsersPerPage();

      if (tmpUserId.isEmpty) return;
      if (tmpTypeOfUser.isEmpty) return;
      if (tmpLanguage.isEmpty) return;

      LanguageService tmpLang = LanguageService.getInstance(tmpLanguage);
      Map<String, dynamic>? userMap = await UserRepository.readUserWithId(tmpUserId);
      if (userMap == null) return;

      setState(() {
        widget.user = User.toUser(userMap);
        widget.lang = tmpLang;
        widget.user!.preferences.usersPerPage = usersPerPage;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose(); // dispose the controller
    textController.dispose();
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void scrollToTop() {
    scrollController.animateTo(0, duration: const Duration(milliseconds: 350), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    textController.text = widget.searchbarText;
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));

    if (widget.lang == null || widget.user == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'UsersPage',
        lang: widget.lang!,
        userId: widget.user?.id ?? "",
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: StreamBuilder(
            initialData: widget.customers,
            stream: streamQueryBuilder(),
            builder: (context, snapshot) {
              return Column(
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
                      Expanded(flex: 40, child: getRows(width, height, snapshot),),
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
                            buttonText:
                                widget.lang!.translate('scroll_to_top'),
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
              );
            }),
      ),
    );
  }

  Widget getPageHeader(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SearchBar(
          controller: textController,
          hintText: widget.lang!.translate('search_text'),
          leading: const Icon(Icons.search),
          trailing: [
            GestureDetector(
              onTap: () {
                widget.searchbarText = "";
                widget.offset = 0;
                textController.text = "";
                textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: textController.text.length),
                );
              },
              child: const Icon(Icons.close),
            ),
            const SizedBox(width: 15),
          ],
          onChanged: (String value) {
            setState(() {
              textController.selection = TextSelection.fromPosition(
                TextPosition(offset: textController.text.length),
              );
              widget.searchbarText = value;
              widget.currentPage = 0;
            });
          },
        ),
        SizedBox(
          width: width * 0.02,
        ),
        GradientButton(
          buttonText: widget.lang!.translate('additional_filters'),
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
                    Text("${widget.lang!.translate('number_of_estates')}: ",),
                    const SizedBox(width: 16,),
                    StringField(
                      presetText: from != null ? from.toString() : '',
                      inputType: TextInputType.number,
                      maxWidth: 200,
                      labelText: widget.lang!.translate('from'),
                      callback: (dynamic value) {
                        setState(() {
                          if (value == null) from = null;
                          from = int.parse(value);
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    StringField(
                      presetText: to != null ? to.toString() : '',
                      inputType: TextInputType.number,
                      maxWidth: 200,
                      labelText: widget.lang!.translate('to'),
                      callback: (dynamic value) {
                        setState(() {
                          if (value == null) to = null;
                          to = int.parse(value);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownField(
                      maxWidth: 200,
                      labelText: widget.lang!.translate('blocked'),
                      callback: (String? value) {
                        setState(() {
                          if (value == null) return;

                          if (value == widget.lang!.translate('show')) {
                            blocked = true;
                          } else if (value ==
                              widget.lang!.translate('dont_show')) {
                            blocked = false;
                          } else {
                            blocked = null;
                          }

                          // if (blocked == false) banned = false;
                        });
                      },
                      choices: [
                        "-",
                        widget.lang!.translate('show'),
                        widget.lang!.translate('dont_show')
                      ],
                      selected: blocked == true
                          ? widget.lang!.translate('show')
                          : blocked == false
                              ? widget.lang!.translate('dont_show')
                              : "-",
                    ),
                    SequentialField(
                      maxWidth: 200,
                      labelText: widget.lang!.translate('individual'),
                      callback: (int? value) {
                        setState(() {
                          if (value == null) return;

                          if (value == 0) {
                            individual = true;
                          } else {
                            individual = false;
                          }
                        });
                      },
                      choices: [
                        widget.lang!.translate('show'),
                        widget.lang!.translate('dont_show')
                      ],
                      selected: individual == true ? 0 : 1,
                    ),
                  ],
                ),
                const SizedBox(height: 26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownField(
                      maxWidth: 200,
                      labelText: widget.lang!.translate('banned'),
                      callback: (String? value) {
                        setState(() {
                          if (value == null) return;

                          if (value == widget.lang!.translate('show')) {
                            banned = true;
                          } else if (value == widget.lang!.translate('dont_show')) {
                            banned = false;
                          } else {
                            banned = null;
                          }

                          // if (banned == true) blocked = true;
                        });
                      },
                      choices: [
                        "-",
                        widget.lang!.translate('show'),
                        widget.lang!.translate('dont_show')
                      ],
                      selected: banned == true
                          ? widget.lang!.translate('show')
                          : banned == false
                              ? widget.lang!.translate('dont_show')
                              : "-",
                    ),
                    SequentialField(
                      maxWidth: 200,
                      labelText: widget.lang!.translate('company'),
                      callback: (int? value) {
                        setState(() {
                          if (value == null) return;

                          if (value == 0) {
                            company = true;
                          } else if (value == 1) {
                            company = false;
                          }
                        });
                      },
                      choices: [
                        widget.lang!.translate('show'),
                        widget.lang!.translate('dont_show')
                      ],
                      selected: company == true ? 0 : 1,
                    ),
                  ],
                ),
                const SizedBox(height: 26,),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.from = from;
                widget.to = to;
                widget.blocked = blocked;
                widget.banned = banned;
                widget.individual = individual;
                widget.company = company;
                widget.currentPage = 0;
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
            child: Text(widget.lang!.translate('apply_filters')),
          ),
        ],
      ),
    );
  }

  Widget getTableHeader(double height) {
    return Column(
      children: [
        getUpArrow(height),
        getCenterRow(height),
        getDownArrow(height),
      ],
    );
  }

  Widget getUpArrow(double height) {
    Map<String, List<int>> hash = {
      "name": [6, 3],
      "email": [10, 3],
      "phone": [14, 3],
      "numOfEstates": [18, 2],
      "typeOfUser": [21, 1],
      "blocked": [23, 1],
      "banned": [25, 1],
    };
    height = height * 0.03;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: hash[widget.orderBy]![0],
          child: SizedBox(height: height),
        ),
        Expanded(
          flex: hash[widget.orderBy]![1],
          child: SizedBox(
            height: height,
            child: widget.asc
                ? const Icon(Icons.arrow_upward, size: 16)
                : const SizedBox(),
          ),
        ),
        Expanded(
            flex: 27 - hash[widget.orderBy]![0] - hash[widget.orderBy]![1],
            child: SizedBox(height: height)),
      ],
    );
  }

  Widget getCenterRow(double height) {
    height = height * 0.06;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height,
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
            height: height,
            child: Center(
              child: Text(widget.lang!.translate('image')),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Name
        Expanded(
          flex: 3,
          child: SizedBox(
            height: height,
            child: InkWell(
              onHover: (value) {},
              onTap: () {
                setState(() {
                  if (widget.orderBy == "name") {
                    widget.asc = !widget.asc;
                  } else {
                    widget.asc = true;
                    widget.orderBy = "name";
                  }
                });
              },
              child: const Center(
                child: Text("Name"),
              ),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Email
        Expanded(
          flex: 3,
          child: SizedBox(
            height: height,
            child: InkWell(
              onHover: (value) {},
              onTap: () {
                setState(() {
                  if (widget.orderBy == "email") {
                    widget.asc = !widget.asc;
                  } else {
                    widget.asc = true;
                    widget.orderBy = "email";
                  }
                });
              },
              child: const Center(
                child: Text("Email"),
              ),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Phone
        Expanded(
          flex: 3,
          child: SizedBox(
            height: height,
            child: InkWell(
              onHover: (value) {},
              onTap: () {
                setState(() {
                  if (widget.orderBy == "phone") {
                    widget.asc = !widget.asc;
                  } else {
                    widget.asc = true;
                    widget.orderBy = "phone";
                  }
                });
              },
              child: Center(
                child: Text(widget.lang!.translate('phone_number')),
              ),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Estates
        Expanded(
          flex: 2,
          child: SizedBox(
            height: height,
            child: InkWell(
              onHover: (value) {},
              onTap: () {
                setState(() {
                  if (widget.orderBy == "numOfEstates") {
                    widget.asc = !widget.asc;
                  } else {
                    widget.asc = true;
                    widget.orderBy = "numOfEstates";
                  }
                });
              },
              child: Center(
                child: Text(widget.lang!.translate('number_of_estates')),
              ),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Banned
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height,
            child: InkWell(
              onHover: (value) {},
              onTap: () {
                setState(() {
                  if (widget.orderBy == "typeOfUser") {
                    widget.asc = !widget.asc;
                  } else {
                    widget.asc = true;
                    widget.orderBy = "typeOfUser";
                  }
                });
              },
              child: Center(
                child: Text(widget.lang!.translate('type')),
              ),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Blocked
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height,
            child: InkWell(
              onHover: (value) {},
              onTap: () {
                setState(() {
                  if (widget.orderBy == "blocked") {
                    widget.asc = !widget.asc;
                  } else {
                    widget.asc = true;
                    widget.orderBy = "blocked";
                  }
                });
              },
              child: Center(
                child: Text(widget.lang!.translate('blocked')),
              ),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Banned
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height,
            child: InkWell(
              onHover: (value) {},
              onTap: () {
                setState(() {
                  if (widget.orderBy == "banned") {
                    widget.asc = !widget.asc;
                  } else {
                    widget.asc = true;
                    widget.orderBy = "banned";
                  }
                });
              },
              child: Center(
                child: Text(widget.lang!.translate('banned')),
              ),
            ),
          ),
        ),

        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget getDownArrow(double height) {
    Map<String, List<int>> hash = {
      "name": [6, 3],
      "email": [10, 3],
      "phone": [14, 3],
      "numOfEstates": [18, 2],
      "typeOfUser": [21, 1],
      "blocked": [23, 1],
      "banned": [25, 1],
    };
    height = height * 0.03;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: hash[widget.orderBy]![0],
          child: SizedBox(height: height),
        ),
        Expanded(
          flex: hash[widget.orderBy]![1],
          child: SizedBox(
            height: height,
            child: !widget.asc
                ? const Icon(Icons.arrow_downward, size: 16)
                : const SizedBox(),
          ),
        ),
        Expanded(
            flex: 27 - hash[widget.orderBy]![0] - hash[widget.orderBy]![1],
            child: SizedBox(height: height)),
      ],
    );
  }

  Widget getRows(double width, double height, AsyncSnapshot<List<Customer>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: SizedBox(
          width: height * 0.15,
          height: height * 0.15,
          child: LoadingBar(dimensionLength: width > height ? height * 0.5 : width * 0.5),
        ),
      );
    } else if (snapshot.hasError) {
      return SnapshotErrorField(text: 'Error: ${snapshot.error}');
    } else {
      if (snapshot.data == null) {
        widget.customers = [];
      } else {
        widget.customers = snapshot.data!;
      }
      widget.numOfPages = widget.customers.length ~/ widget.user!.preferences.usersPerPage;

      if (widget.customers.isEmpty) {
        return SizedBox(
          height: height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                child: Center(
                  child: Text(
                    widget.lang!.translate('no_users_to_display'),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      }

      List<Widget> rows = [];

      for (int i = widget.currentPage * widget.user!.preferences.usersPerPage;
      i < (widget.currentPage + 1) * widget.user!.preferences.usersPerPage && i < widget.customers.length; ++i) {
        rows.add(
          InkWell(
            onHover: (_) {},
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userId: widget.customers[i].id,
                    enableEditing: false,
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
                      child: Text((i + 1).toString()), // TODO: set correct # number
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
                          backgroundColor: MaterialStatePropertyAll(PalleteCommon.gradient1,),
                        ),
                        onPressed: () => goToEstatesPage(widget.customers[i].id),
                        child: Text(widget.customers[i].numOfEstates.toString(),),
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
                          ? widget.lang!.translate('individual')
                          : widget.lang!.translate('company'),
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
                        widget.customers[i].blocked ? Icons.done : Icons.close,
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
                      onTap: () => banningConfirmationWindow(width, height, i),
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
  }

  bool checkFilterMatching(Customer customer) {
    int points = 0;

    // Searchbar filtering
    if (widget.searchbarText.isEmpty) {
      points++;
    } else if (customer.email.contains(widget.searchbarText)) {
      points++;
    } else if (customer.phone.contains(widget.searchbarText)) {
      points++;
    } else if ((customer is Individual) &&
        ("${customer.firstname} ${customer.lastname}").contains(widget.searchbarText)) {
      points++;
    } else if ((customer is Company) &&
        ("${customer.ownerFirstname} ${customer.ownerLastname}").contains(widget.searchbarText)) {
      points++;
    } else {
      return false;
    }

    if (widget.from == null ||
        widget.from != null && widget.from! <= customer.numOfEstates) {
      points++;
    }
    if (widget.to == null ||
        widget.to != null && widget.to! >= customer.numOfEstates) {
      points++;
    }
    if (widget.blocked == null || widget.blocked == customer.blocked) {
      points++;
    }
    if (widget.banned == null || widget.banned == customer.banned) {
      points++;
    }
    if (!widget.individual && !widget.company ||
        widget.individual && widget.company) {
      points += 2;
    } else {
      if (widget.individual && customer is Individual) {
        points += 2;
      } else if (widget.company && customer is Company) {
        points += 2;
      }
    }

    return points == 7;
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

  Stream<List<Customer>> streamQueryBuilder() {
    CollectionReference<Map<String, dynamic>> users = FirebaseFirestore.instance.collection('users');

    // Combine the two streams using the merge operator
    Stream<QuerySnapshot<Map<String, dynamic>>> indQuery = users.where("typeOfUser", isEqualTo: "ind").snapshots();
    Stream<QuerySnapshot<Map<String, dynamic>>> comQuery = users.where("typeOfUser", isEqualTo: "com").snapshots();

    return Rx.combineLatest2(indQuery, comQuery, (QuerySnapshot<Map<String, dynamic>> snapshot1, QuerySnapshot<Map<String, dynamic>> snapshot2) {
      Map<String, dynamic> userMap;
      Customer customer;
      List<Customer> array1 = [];
      for (int i = 0; i < snapshot1.docs.length; ++i) {
        userMap = snapshot1.docs[i].data();
        userMap["id"] = snapshot1.docs[i].id;

        customer = User.toUser(userMap) as Customer;
        if (!checkFilterMatching(customer)) continue;

        array1.add(customer);
      }

      List<Customer> array2 = [];
      for (int i = 0; i < snapshot2.docs.length; ++i) {
        userMap = snapshot2.docs[i].data();
        userMap["id"] = snapshot2.docs[i].id;

        customer = User.toUser(userMap) as Customer;
        if (!checkFilterMatching(customer)) continue;

        array2.add(customer);
      }

      array1 = mergeSort(array1);
      array2 = mergeSort(array2);
      
      return mergeArrays(array1, array2);
    });
  }

  List<Customer> mergeArrays(List<Customer> array1, List<Customer> array2) {
    List<Customer> list = [];

    int i = 0, j = 0;
    while (i < array1.length && j < array2.length) {
      int comparation = compare(array1[i], array2[j]);

      if (!widget.asc && comparation > 0 || widget.asc && comparation < 0) {
        list.add(array1[i]);
        i++;
      } else {
        list.add(array2[j]);
        j++;
      }
    }

    while (i < array1.length) {
      list.add(array1[i]);
      i++;
    }

    while (j < array2.length) {
      list.add(array2[j]);
      j++;
    }

    return list;
  }

  int compare(Customer customer1, Customer customer2) {
    if (widget.orderBy == 'name') {
      String name1, name2;

      if (customer1 is Company) {
        name1 = "${customer1.ownerFirstname} ${customer1.ownerLastname}";
      } else {
        name1 =
            "${(customer1 as Individual).firstname} ${(customer1).lastname}";
      }

      if (customer2 is Company) {
        name2 = "${customer2.ownerFirstname} ${customer2.ownerLastname}";
      } else {
        name2 = "${(customer2 as Individual).firstname} ${customer2.lastname}";
      }

      return name1.compareTo(name2);
    } else if (widget.orderBy == 'email') {
      return (customer1.email).compareTo(customer2.email);
    } else if (widget.orderBy == 'phone') {
      return (customer1.phone).compareTo(customer2.phone);
    } else if (widget.orderBy == 'numOfEstates') {
      return (customer1.numOfEstates.toString()).compareTo(customer2.numOfEstates.toString());
    } else if (widget.orderBy == 'typeOfUser') {
      return ((customer1 is Individual ? 'ind' : 'com')).compareTo((customer2 is Individual ? 'ind' : 'com'));
    } else if (widget.orderBy == 'blocked') {
      return (customer1.blocked.toString()).compareTo(customer2.blocked.toString());
    } else if (widget.orderBy == 'banned') {
      return (customer1.banned.toString()).compareTo(customer2.banned.toString());
    } else {
      return 0;
    }
  }

  List<Customer> mergeSort(List<Customer> array) {
    // Stop recursion if array contains only one element
    if (array.length <= 1) {
      return array;
    }

    // split in the middle of the array
    int splitIndex = array.length ~/ 2;

    // recursively call merge sort on left and right array
    List<Customer> leftArray = mergeSort(array.sublist(0, splitIndex));
    List<Customer> rightArray = mergeSort(array.sublist(splitIndex));

    return merge(leftArray, rightArray);
  }

  List<Customer> merge(List<Customer> leftArray, List<Customer> rightArray) {
    List<Customer> result = [];
    int i = 0;
    int j = 0;

    while (i < leftArray.length && j < rightArray.length) {
      int comparation = compare(leftArray[i], rightArray[j]);

      if (!widget.asc && comparation > 0 || widget.asc && comparation < 0) {
        result.add(leftArray[i]);
        i++;
      } else {
        result.add(rightArray[j]);
        j++;
      }
    }

    while (i < leftArray.length) {
      result.add(leftArray[i]);
      i++;
    }

    while (j < rightArray.length) {
      result.add(rightArray[j]);
      j++;
    }

    return result;
  }

  void changeBlockedValue(Customer customer) async {
    if (customer.banned) return;
    
    bool res = await UserRepository.blockUser(customer.id, !customer.blocked);
    if (res) return;

    // TODO: change banned value if blocked == false

    setState(() {
      customer.blocked = !customer.blocked;
    });
  }

  void changeBannedValue(Customer customer) async {
    if (customer.banned) return;
    bool? res = await UserRepository.banUser(customer);
    if (res == null) return; 
    else if (!res) return;

    setState(() {
      customer.banned = true;
    });

    Navigator.pop(context);
  }

  Widget getNumOfUsersSelection() {
    return Expanded(
      flex: 1,
      child: DropdownField(
        labelText: widget.lang!.translate('users_per_page'),
        maxWidth: 200,
        callback: (int value) async {
          setState(() {
            widget.user!.preferences.usersPerPage = value;
            widget.currentPage = 0;
          });

          UserRepository.updateUser(widget.user!.id, {"usersPerPage": value});
          await SharedPreferencesService(await SharedPreferences.getInstance()).setUsersPerPage(value);
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

  void goToEstatesPage(String? customerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EstatesPage(
          showEmptyCard: false,
          searchedCustomerId: customerId,
        ),
      ),
    );
  }

  void banningConfirmationWindow(double width, double height, int index) {
    if (widget.customers[index].banned) return;

    showDialog(context: context, builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.fromLTRB(
          width * 0.28,
          height * 0.3,
          width * 0.28,
          height * 0.3,
        ),
        backgroundColor: PalleteCommon.backgroundColor,
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, 0),
                  child: Text(
                    "${widget.lang!.translate('ban_user_text_1')}${widget.customers[index].email}${widget.lang!.translate('ban_user_text_2')}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: PalleteCommon.gradient2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: GradientButton(
                        colors: PalleteDanger.getGradients(),
                        buttonText: widget.lang!.translate('delete_estate'),
                        callback: () => changeBannedValue(widget.customers[index]),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: GradientButton(
                        buttonText: widget.lang!.translate('cancel'),
                        callback: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
            ],
          ),
        ),
      );
    });
  }
}
