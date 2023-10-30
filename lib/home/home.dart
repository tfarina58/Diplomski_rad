import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/firebase.dart';

class HomePage extends StatefulWidget {
  User? user;
  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};

  HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
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
        widget.headerValues["avatarImage"] = tmpAvatarImage ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lang == null || widget.user == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'HomePage',
        headerValues: widget.headerValues,
        lang: widget.lang!,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView.separated(
            itemCount: _feedItems.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              final item = _feedItems[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AvatarImage(item.user.imageUrl),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: item.user.fullName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: " @${item.user.userName}",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ]),
                              )),
                              Text('· 5m',
                                  style: Theme.of(context).textTheme.subtitle1),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.more_horiz),
                              )
                            ],
                          ),
                          if (item.content != null) Text(item.content!),
                          if (item.imageUrl != null)
                            Container(
                              height: 200,
                              margin: const EdgeInsets.only(top: 8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(item.imageUrl!),
                                  )),
                            ),
                          _ActionsRow(item: item)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String url;
  const _AvatarImage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(url))),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final FeedItem item;
  const _ActionsRow({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.grey, size: 18),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.grey),
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mode_comment_outlined),
            label: Text(
                item.commentsCount == 0 ? '' : item.commentsCount.toString()),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.repeat_rounded),
            label: Text(
                item.retweetsCount == 0 ? '' : item.retweetsCount.toString()),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            label: Text(item.likesCount == 0 ? '' : item.likesCount.toString()),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.share_up),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class FeedItem {
  final String? content;
  final String? imageUrl;
  final LocalUser user;
  final int commentsCount;
  final int likesCount;
  final int retweetsCount;

  FeedItem(
      {this.content,
      this.imageUrl,
      required this.user,
      this.commentsCount = 0,
      this.likesCount = 0,
      this.retweetsCount = 0});
}

class LocalUser {
  final String fullName;
  final String imageUrl;
  final String userName;

  LocalUser(
    this.fullName,
    this.userName,
    this.imageUrl,
  );
}

final List<LocalUser> _users = [
  LocalUser(
    "John Doe",
    "john_doe",
    "https://picsum.photos/id/1062/80/80",
  ),
  LocalUser(
    "Jane Doe",
    "jane_doe",
    "https://picsum.photos/id/1066/80/80",
  ),
  LocalUser(
    "Jack Doe",
    "jack_doe",
    "https://picsum.photos/id/1072/80/80",
  ),
  LocalUser(
    "Jill Doe",
    "jill_doe",
    "https://picsum.photos/id/133/80/80",
  )
];

final List<FeedItem> _feedItems = [
  FeedItem(
    content:
        "A son asked his father (a programmer) why the sun rises in the east, and sets in the west. His response? It works, don’t touch!",
    user: _users[0],
    imageUrl: "https://picsum.photos/id/1000/960/540",
    likesCount: 100,
    commentsCount: 10,
    retweetsCount: 1,
  ),
  FeedItem(
      user: _users[1],
      imageUrl: "https://picsum.photos/id/1001/960/540",
      likesCount: 10,
      commentsCount: 2),
  FeedItem(
      user: _users[0],
      content:
          "How many programmers does it take to change a light bulb? None, that’s a hardware problem.",
      likesCount: 50,
      commentsCount: 22,
      retweetsCount: 30),
  FeedItem(
      user: _users[1],
      content:
          "Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the Universe trying to produce bigger and better idiots. So far, the Universe is winning.",
      imageUrl: "https://picsum.photos/id/1002/960/540",
      likesCount: 500,
      commentsCount: 202,
      retweetsCount: 120),
  FeedItem(
    user: _users[2],
    content: "Good morning!",
    imageUrl: "https://picsum.photos/id/1003/960/540",
  ),
  FeedItem(
    user: _users[1],
    imageUrl: "https://picsum.photos/id/1004/960/540",
  ),
  FeedItem(
    user: _users[3],
    imageUrl: "https://picsum.photos/id/1005/960/540",
  ),
  FeedItem(
    user: _users[0],
    imageUrl: "https://picsum.photos/id/1006/960/540",
  ),
];
