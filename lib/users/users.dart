import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/estates/estates.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/interfaces/preferences/user-preferences.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';

class UsersPage extends StatefulWidget {
  List<Customer> customers = Individual.getAllCustomers();
  User user = Admin(
    firstname: "Admin",
    email: "admin.diplomski_rad@gmail.com",
    phone: "+385994716110",
    preferences: UserPreferences(),
  );

  int currentPage = 0;
  String searchbarText = "";

  bool blocked = false, banned = false;
  bool individual = false, company = false;

  int? from, to;

  UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<bool> upDownFilters = [true, false];
  List<String> upDownFiltersTitles = [
    "Name",
    "Email",
    "Phone",
    "Estates",
    "Type",
    "Blocked",
    "Banned"
  ];

  List<bool> isHovering = [false, false, false];

  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
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

    int numOfPages =
        widget.customers.length ~/ widget.user.preferences!.usersPerPage;

    return Scaffold(
      appBar: HeaderComponent(currentPage: 'UsersPage'),
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
                  getPagination(width, height, numOfPages),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 1,
                    child: GradientButton(
                      buttonText: "Scroll to top",
                      callback: () {
                        setState(() {
                          scrollToTop();
                        });
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
            const Tooltip(
              message:
                  "Here you can search for names, emails and phone numbers",
              triggerMode: TooltipTriggerMode.tap,
              child: Icon(Icons.info),
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
            // scrollToTop();
          }),
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
                return getAdditionalFilters(width, height);
              },
            );
          },
        ),
      ],
    );
  }

  Widget getAdditionalFilters(double width, double height) {
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
                const Text("Number of estates: "),
                const SizedBox(
                  width: 16,
                ),
                StringField(
                  presetText: widget.from != null ? widget.from.toString() : "",
                  inputType: TextInputType.number,
                  maxWidth: 200,
                  labelText: "From",
                  callback: (dynamic value) {
                    setState(() {
                      widget.from = int.parse(value);
                    });
                    print(widget.from);
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                StringField(
                  presetText: widget.to != null ? widget.to.toString() : "",
                  inputType: TextInputType.number,
                  maxWidth: 200,
                  labelText: "To",
                  callback: (dynamic value) {
                    setState(() {
                      widget.to = int.parse(value);
                    });
                    print(widget.to);
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
                      value: widget.blocked,
                      onChanged: (bool? value) {
                        if (value == null) return;

                        setState(() {
                          widget.blocked = value;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    const Text("Blocked"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: PalleteCommon.gradient2,
                      value: widget.individual,
                      onChanged: (bool? value) {
                        if (value == null) return;

                        setState(() {
                          widget.individual = value;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    const Text("Individual"),
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
                      value: widget.banned,
                      onChanged: (bool? value) {
                        if (value == null) return;

                        setState(() {
                          widget.banned = value;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    const Text("Banned"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: PalleteCommon.gradient2,
                      value: widget.company,
                      onChanged: (bool? value) {
                        if (value == null) return;

                        setState(() {
                          widget.company = value;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    const Text("Company"),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(
                  Size(width * 0.15, height * 0.05),
                ),
                backgroundColor: const MaterialStatePropertyAll(
                  PalleteCommon.gradient2,
                ),
              ),
              child: const Text("Apply filters"),
            ),
          ],
        ),
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
            child: const Center(
              child: Text("Image"),
            ),
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        // Name
        Expanded(
          flex: 3,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("Name"),
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
            child: const Center(
              child: Text("Phone"),
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
        // Banned
        Expanded(
          flex: 1,
          child: SizedBox(
            height: height * 0.08,
            child: const Center(
              child: Text("Type"),
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
    int cnt = 0;

    for (int i = widget.user.preferences!.usersPerPage * widget.currentPage;
        i < widget.customers.length &&
            cnt < widget.user.preferences!.usersPerPage;
        ++i) {
      if (!checkDisplayCriteria(widget.customers[i])) {
        continue;
      }

      res.add(
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
                  child: Image.asset("images/chick.jpg"),
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
                          PalleteCommon.highlightColor),
                    ),
                    onPressed: () => goToEstatesPage(),
                    child: const Text("3"),
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
                      ? "Individual"
                      : "Company",
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
                  onTap: () {
                    setState(() {
                      widget.customers[i].banned = !widget.customers[i].banned;
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

      res.add(
        Divider(
          height: 20,
          thickness: 3,
          color: PalleteCommon.gradient2,
          indent: width * 0.02,
          endIndent: width * 0.02,
        ),
      );
      cnt++;
    }

    return res;
  }

  bool checkDisplayCriteria(Customer customer) {
    if (customer is Individual) {
      if (!customer.email.contains(widget.searchbarText) &&
          !("${customer.firstname} ${customer.lastname}")
              .contains(widget.searchbarText) &&
          !customer.phone.contains(widget.searchbarText)) {
        return false;
      }
      /*if (widget.blocked != customer.blocked) return false;
      if (widget.banned != customer.banned) return false;
      if (widget.individual == false && widget.company == true) return false;*/
      return true;
    } else if (customer is Company) {
      if (!customer.email.contains(widget.searchbarText) &&
          !("${(customer).ownerFirstname} ${(customer).ownerLastname}")
              .contains(widget.searchbarText) &&
          !customer.phone.contains(widget.searchbarText)) {
        return false;
      }
      /*if (widget.blocked != customer.blocked) return false;
      if (widget.banned != customer.banned) return false;
      if (widget.individual == true && widget.company == false) return false;*/
      return true;
    }
    return false;
  }

  Widget getNumOfUsersSelection() {
    return Expanded(
      flex: 1,
      child: DropdownField(
        labelText: "Users per page",
        maxWidth: 200,
        callback: (int value) {
          widget.user.preferences ??= UserPreferences();

          setState(() {
            widget.user.preferences!.usersPerPage = value;
          });
        },
        choices: const [5, 10, 15, 25, 50, 100, 200],
        selected: widget.user.preferences != null
            ? widget.user.preferences!.usersPerPage
            : 10,
      ),
    );
  }

  Widget getPagination(double width, double height, int numOfPages) {
    List<Widget> res = [];

    if (numOfPages == 0) {
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
              scrollToTop();
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
                scrollToTop();
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
    if (widget.currentPage != 0 && widget.currentPage != numOfPages) {
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
    if (widget.currentPage <= numOfPages - 1) {
      res.add(
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                widget.currentPage = widget.currentPage + 1;
                scrollToTop();
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
              widget.currentPage = numOfPages;
              scrollToTop();
            });
          },
          child: SizedBox(
            height: width * 0.04,
            child: Center(
              child: Text(
                (numOfPages + 1).toString(),
                style: widget.currentPage == numOfPages
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
        builder: (context) => EstatesPage(),
      ),
    );
  }
}
