import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:smartmeter/pages/notifications.dart';

import 'notification_service.dart';

String userFirstName = "Hope";
const String collapedAppBarTitle = 'Power Outage Meter';

var top = 0.0;
var appbarThreshold = 110.0;

class MySliverAppBar extends StatefulWidget {
  const MySliverAppBar({Key? key}) : super(key: key);

  @override
  _MySliverAppBarState createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);
    Size size = MediaQuery.of(context).size;

    return SliverAppBar(
      centerTitle: true,
      leadingWidth: size.width / 4,
      collapsedHeight: size.height / 11.5,
      expandedHeight: size.height / 7.5,
      backgroundColor: Colors.white,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 19),
        child: CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage('images/hope.jpg'),
        ),
      ),

      //----------------------------------------------------------------------------
      actions: [
        // Using Consumer to make the badge reactive to changes
        Consumer<NotificationService>(
          builder: (context, notificationService, child) {
            return IconBadge(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
                  ),
                );
              },
              icon: Icon(CupertinoIcons.bell, color: Colors.grey[700]),
              itemCount: notificationService.unreadCount,
              badgeColor: notificationService.unreadCount > 0
                  ? Colors.green
                  : Colors.red,
              hideZero: false,
              top: size.height / 100,
              right: size.width / 45,
              itemColor: Colors.white,
            );
          },
        ),
        SizedBox(width: size.width / 30), // Add some spacing
      ],

      //----------------------------------------------------------------------------
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          top = constraints.biggest.height;

          return FlexibleSpaceBar(
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: Text(
                top < appbarThreshold
                    ? collapedAppBarTitle
                    : 'Welcome, $userFirstName',
                style: GoogleFonts.poppins(
                  fontSize: top < appbarThreshold ? 20 : 15,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(31, 31, 31, 1),
                ),
              ),
            ),
            titlePadding: top < appbarThreshold
                ? EdgeInsets.fromLTRB(
                    size.width / 4.0,
                    0.0,
                    0.0,
                    size.height / 30,
                  )
                : EdgeInsets.fromLTRB(size.width / 14, 0.0, 0.0, 0.0),
          );
        },
      ),
    );
  }
}
