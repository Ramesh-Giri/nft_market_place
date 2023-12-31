import 'package:flutter/material.dart';
import 'package:nft_marketplace/utils/color.dart';
import 'package:nft_marketplace/utils/config.dart';
import 'package:nft_marketplace/utils/constants.dart';
import 'package:nft_marketplace/utils/fonts.dart';
import 'package:status_alert/status_alert.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({super.key});

  @override
  State<Subscribe> createState() => _SubscribeState();

  static const routeName = '/subscribe';
}

class _SubscribeState extends State<Subscribe> {
  bool favorite = false;
  int days = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    favorite = !favorite;
                    if (favorite == true) {
                      StatusAlert.show(
                        context,
                        duration: const Duration(seconds: 2),
                        title: 'Added to Favorites',
                        configuration: const IconConfiguration(
                            icon: Icons.favorite, size: 50),
                      );
                    }
                  });
                },
                icon: Icon((favorite == true)
                    ? Icons.favorite
                    : Icons.favorite_outline)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share))
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(
                    bottom: 10.0, right: 10.0, left: 10.0),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                magTitle,
                style: TextStyle(
                    color: themeColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: titleFont),
              ),
            ),
            Text(
              'Expires after: 0' " days",
              style: TextStyle(
                  fontFamily: bodyFont,
                  fontSize: 15,
                  color: dangerColor,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'NFT HERE',
                style: TextStyle(fontSize: 16, fontFamily: bodyFont),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    "Created by: ",
                    style: TextStyle(fontFamily: bodyFont),
                  ),
                  const Spacer(),
                  ActionChip(
                    label: Text(
                      "Author here",
                      style: TextStyle(
                          color: plainColor,
                          fontSize: 16,
                          fontFamily: bodyFont,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {

                    },
                    backgroundColor: brandColor,
                  )
                ],
              ),
            )
          ],
        )),
        bottomNavigationBar: Container(
          color: themeColor,
          padding: const EdgeInsets.only(bottom: 40.0, right: 20.0, left: 20.0),
          child: Row(
            children: [
              Text(
                "0.0067 ETH",
                style: TextStyle(
                    color: plainColor,
                    fontSize: 16,
                    fontFamily: bodyFont,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(
                    Icons.arrow_right_rounded,
                    color: plainColor,
                    size: 50,
                  ),
                  label: Text(
                    "Subscribe",
                    style: TextStyle(
                        fontFamily: buttonFont,
                        fontSize: 20,
                        color: plainColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  showDialog() {
    StatusAlert.show(context,
        duration: const Duration(seconds: 5),
        title: 'NFT Magazine',
        subtitle: 'Cannot subscribe to your own NFT',
        titleOptions: StatusAlertTextConfiguration(
            style: const TextStyle(
                color: plainColor, fontWeight: FontWeight.bold, fontSize: 20)),
        subtitleOptions: StatusAlertTextConfiguration(
            style: const TextStyle(color: plainColor)),
        configuration:
            const IconConfiguration(icon: Icons.cancel, color: brandColor),
        maxWidth: 260,
        backgroundColor: darkColor);
  }
}
