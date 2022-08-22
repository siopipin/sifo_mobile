import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List activeTabs = [
      {'icon': LineIcons.home, 'label': 'home'},
      {'icon': LineIcons.bookmark, 'label': 'KRS'},
      {'icon': LineIcons.graduationCap, 'label': 'Nilai'},
      {'icon': LineIcons.user, 'label': 'Profile'},
    ];
    final watchHome = context.watch<HomeProvider>();

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
            color: config.colorPrimary,
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
                              if (index == 0) {
                                watchHome.setIndex = 0;
                              } else if (index == 1) {
                                watchHome.setIndex = 1;
                              } else if (index == 2) {
                                watchHome.setIndex = 2;
                              } else if (index == 3) {
                                watchHome.setIndex = 3;
                              }
                            },
                            child: Icon(activeTabs[index]['icon'],
                                size: 25,
                                color: watchHome.index == index
                                    ? config.colorSecondary
                                    : Colors.white),
                          ),
                          Text(
                            activeTabs[index]['label'],
                            style: TextStyle(
                                color: watchHome.index == index
                                    ? config.colorSecondary
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
