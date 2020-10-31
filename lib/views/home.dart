import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ios_widget_demo/core/model/emoji_model.dart';
import 'package:ios_widget_demo/core/model/emoji_provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<EmojiDetails> emojiData = EmojiProvider.all();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Emojibook'),
      ),
      child: Container(
        color: CupertinoColors.activeBlue.withOpacity(0.05),
        child: ListView(
          children: [
            Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var emoji in emojiData) ...[
                      EmojiItemView(emoji: emoji),
                      Divider(),
                    ]
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class EmojiItemView extends StatelessWidget {
  final EmojiDetails emoji;
  const EmojiItemView({
    Key key,
    this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return EmojiDetailPage(emoji: emoji);
          }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Text(
          "${emoji.emoji}  ${emoji.name}",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

class EmojiDetailPage extends StatelessWidget {
  final EmojiDetails emoji;
  const EmojiDetailPage({
    Key key,
    this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: MediaQuery.of(context).size.height * .65,
        child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.activeGreen,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${emoji.emoji}  ${emoji.name}",
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: CupertinoColors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${emoji.description}",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: CupertinoColors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    CupertinoButton(
                      color: Colors.white,
                      child: Text(
                        'Set Widget Emoji',
                        style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                        ),
                      ),
                      onPressed: () async {
                        store('emoji', emoji?.emoji);
                        store('name', emoji?.name);
                        store('description', emoji?.description);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  static const platform = const MethodChannel('emoji.widget');

  store(String key, String value) async {
    try {
      await platform.invokeMethod(
        'setItem',
        <String, dynamic>{
          "key": key,
          "value": value,
        },
      );
    } on PlatformException catch (e) {
      print('${e.message}');
    }
  }
}
