import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationAppBar({
    Key? key,
    // Mark as required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(245, 241, 241, 1.0).withOpacity(0.4),
      width: MediaQuery.of(context).size.width, // Fills the screen horizontally
      height: preferredSize.height, // Sets height as defined in `preferredSize`
      child: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Text(
                'Notifications', // Display the passed userId
                style: GoogleFonts.poppins(
                  color: Color.fromRGBO(31, 31, 31, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Back icon at the bottom left
          Positioned(
            bottom: 20,
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              color: Color.fromRGBO(31, 31, 31, 1),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
