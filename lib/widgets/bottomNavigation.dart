import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sisfo_mobile/home/home_screen.dart';
import 'package:sisfo_mobile/krs/krs_screen.dart';
import 'package:sisfo_mobile/nilai/nilai_screen.dart';
import 'package:sisfo_mobile/profile/profile_screen.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class BottomBar extends StatelessWidget {
  final int tabIndex;
  final String label;
  const BottomBar({Key key, @required this.tabIndex, @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List activeTabs = [
      {'icon': LineIcons.home, 'label': 'home'},
      {'icon': LineIcons.bookmark, 'label': 'KRS'},
      {'icon': LineIcons.graduation_cap, 'label': 'Nilai'},
      {'icon': LineIcons.user, 'label': 'Profile'},
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
            padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  activeTabs.length,
                  (index) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(index);
                              if (index == tabIndex) {
                                print('this screen');
                              } else if (index == 0) {
                                return Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()));
                              } else if (index == 1) {
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => KrsScreen()));
                              } else if (index == 2) {
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NilaiScreen()));
                              } else if (index == 3) {
                                return Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProfileScreen()));
                              }
                            },
                            child: Icon(activeTabs[index]['icon'],
                                size: 25,
                                color: tabIndex == index
                                    ? primaryYellow
                                    : Colors.white),
                          ),
                          Text(
                            activeTabs[index]['label'],
                            style: TextStyle(
                                color: tabIndex == index
                                    ? primaryYellow
                                    : Colors.white70,
                                fontSize: 11),
                          )
                        ],
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
