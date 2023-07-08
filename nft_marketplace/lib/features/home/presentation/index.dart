import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:nft_marketplace/features/contract/application/nft_provider.dart';
import 'package:nft_marketplace/features/create_nft/presentation/index.dart';
import 'package:nft_marketplace/features/home/presentation/custom_search.dart';
import 'package:nft_marketplace/features/profile/presenatation/index.dart';
import 'package:nft_marketplace/utils/color.dart';
import 'package:nft_marketplace/utils/constants.dart';
import 'package:nft_marketplace/utils/fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final nft = context.watch<NftProvider>();
    return Scaffold(
      backgroundColor: plainColor,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontFamily: titleFont),
        ),
        backgroundColor: brandColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          (currentIndex == 0)
              ? IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: CustomSearchDelegate([]));
                  },
                  icon: const Icon(Icons.search))
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: ActionChip(
                onPressed: () {},
                backgroundColor: themeColor,
                label: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Icon(Icons.wallet),
                    ),
                    RichText(
                        text:TextSpan(
                            text: nft.balance.toStringAsFixed(4),
                            children: <TextSpan>[
                          TextSpan(
                              text: " ETH",
                              style: TextStyle(
                                  color: brandColor,
                                  fontWeight: FontWeight.bold))
                        ]))
                  ],
                )),
          )
        ],
      ),
      body: currentIndex == 0
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (1 / 1.4),
                crossAxisCount: 2,
              ),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return const Text(
                  'NFT here',
                );
              })
          : currentIndex == 1
              ? const CreateNft()
              : const Profile(),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(bottomMenu[0]['icon']),
            title: Text(bottomMenu[0]['label']),
            activeColor: brandColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(bottomMenu[1]['icon']),
            title: Text(bottomMenu[1]['label']),
            activeColor: brandColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(bottomMenu[2]['icon']),
            title: Text(bottomMenu[2]['label']),
            activeColor: brandColor,
            textAlign: TextAlign.center,
          )
        ],
        onItemSelected: (index) async {
          if(index == 2){
            await nft.getMyProfile();
          }
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
