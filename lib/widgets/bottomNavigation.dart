import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sisfo_mobile/home/home_screen.dart';
import 'package:sisfo_mobile/profile/profile_screen.dart';
import 'package:sisfo_mobile/providers/global_config.dart';

class BottomBar extends StatelessWidget {
  final int tabIndex;
  const BottomBar({Key key, @required this.tabIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List activeTabs = [
      LineIcons.home,
      LineIcons.barcode,
      LineIcons.comment,
      LineIcons.user
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  activeTabs.length,
                  (index) => IconButton(
                      icon: Icon(activeTabs[index],
                          size: 25,
                          color:
                              tabIndex == index ? primaryYellow : Colors.white),
                      onPressed: () {
                        if (index == tabIndex) {
                          print('this screen');
                        } else if (index == 0) {
                          return Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => HomeScreen()));
                        }
                        // else if (index == 1) {
                        //   return Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (_) => ProfileScreen()));
                        // }
                        // else if (index == 2) {
                        //   return Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (_) => ProfileScreen()));
                        // }
                        else if (index == 3) {
                          return Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProfileScreen()));
                        }
                      })),
            ),
          ),
        ),
      ),
    );
  }
}
