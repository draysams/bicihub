import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered, this.isMe});

  final String message, time;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? new BorderRadius.only(
            topRight: new Radius.circular(5.0),
            bottomLeft: new Radius.circular(10.0),
            bottomRight: new Radius.circular(5.0),
          )
        : new BorderRadius.only(
            topLeft: new Radius.circular(5.0),
            bottomLeft: new Radius.circular(5.0),
            bottomRight: new Radius.circular(10.0),
          );
    return new Column(
      crossAxisAlignment: align,
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
            boxShadow: [
              new BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: new Stack(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(right: 48.0),
                child: new Text(message),
              ),
              new Positioned(
                bottom: 0.0,
                right: 0.0,
                child: new Row(
                  children: <Widget>[
                    new Text(time,
                        style: new TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    new SizedBox(width: 3.0),
                    new Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

enum BubbleColor {
  blue,
  gray,
  green,
}

class ConversationBubble extends StatelessWidget {
  const ConversationBubble({this.text, this.mapImage, this.color});

  final String text;
  final String mapImage;
  final BubbleColor color;

  @override
  Widget build(BuildContext context) {
    final bool isSelf = color == BubbleColor.blue ? true : false;
    final bool isButton = text == "Yes" || text == "No" || text == "Don't know";
    Widget returnWidget;
    !isButton ? returnWidget = new Container(
      decoration: new BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(18.0)),
        color: color == BubbleColor.blue
            ? CupertinoColors.activeBlue
            : CupertinoColors.lightBackgroundGray,
      ),
      width: !isSelf ? 230.0 : null,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: mapImage == null ?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: new Text(
          text,
          style: new TextStyle(
            color: color == BubbleColor.blue
                ? CupertinoColors.white
                : CupertinoColors.black,
            letterSpacing: -0.4,
            fontSize: 14.0,
            fontWeight: color == BubbleColor.blue
                ? FontWeight.w300
                : FontWeight.w400,
          ),
        )):
        new Image.network(
          mapImage,
          width: 500.0,
          height: 210.0,
        ),
    ): 
    returnWidget = new Container(
      decoration: new BoxDecoration(
        border: new Border.all(color: CupertinoColors.activeGreen),
        borderRadius: const BorderRadius.all(const Radius.circular(18.0)),
        color: CupertinoColors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: mapImage == null ?
        new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        child: new Text(
          text,
          style: new TextStyle(
            color: CupertinoColors.inactiveGray,
            letterSpacing: -0.4,
            fontSize: 14.0,
            fontWeight: color == BubbleColor.blue
                ? FontWeight.w300
                : FontWeight.w400,
          ),
        )):
        new Image.network(
          mapImage,
          width: 500.0,
          height: 200.0,
        ),
    );

    return returnWidget;
  }
}

class ConversationButton extends StatelessWidget {
  const ConversationButton({this.text, this.color});

  final String text;
  final BubbleColor color;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(color: CupertinoColors.activeGreen),
        borderRadius: const BorderRadius.all(const Radius.circular(18.0)),
        color: CupertinoColors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: new Text(
        text,
        style: new TextStyle(
          color: color == BubbleColor.green
              ? CupertinoColors.inactiveGray
              : CupertinoColors.white,
          letterSpacing: -0.4,
          fontSize: 14.0,
          fontWeight: color == BubbleColor.blue
              ? FontWeight.w300
              : FontWeight.w400,
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({this.text, this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        gradient: new LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: <Color>[
            color,
            new Color.fromARGB(
              color.alpha,
              (color.red - 60).clamp(0, 255),
              (color.green - 60).clamp(0, 255),
              (color.blue - 60).clamp(0, 255),
            ),
          ],
        ),
      ),
      margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      child: new Text(
        text,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ConversationRow extends StatelessWidget {
  const ConversationRow({this.avatar, this.text});

  final Avatar avatar;
  final String text;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (avatar != null)
      children.add(avatar);

    final bool isSelf = avatar == null;
    children.add(
      new ConversationBubble(
        text: text,
        color: isSelf
          ? BubbleColor.blue
          : BubbleColor.gray,
      ),
    );
    return new SafeArea(
      child: new Row(
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isSelf ? CrossAxisAlignment.center : CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: const Text('Transfeed'),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new ListView(
        children: <Widget>[
          
        ]..addAll(buildConversation()),
      ),
      ),
    );
  }
}

List<Widget> buildConversation() {
 return <Widget>[
    const ConversationRow(
      text: "My Xanadu doesn't look right",
    ),
    const ConversationRow(
      avatar: const Avatar(
        text: 'KL',
        color: const Color(0xFFFD5015),
      ),
      text: "We'll rush you a new one.\nIt's gonna be incredible",
    ),
    const ConversationRow(
      text: 'Awesome thanks!',
    ),
    const ConversationRow(
      avatar: const Avatar(
        text: 'SJ',
        color: const Color(0xFF34CAD6),
      ),
      text: "We'll send you our\nnewest Labrador too!",
    ),
    const ConversationRow(
      text: 'Yay',
    ),
    const ConversationRow(
      avatar: const Avatar(
        text: 'KL',
        color: const Color(0xFFFD5015),
      ),
      text: "Actually there's one more thing...",
    ),
    const ConversationRow(
      text: "What's that?",
    ),
  ];
}