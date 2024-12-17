import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaAccountsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: CircleAvatar(
            backgroundImage: AssetImage('assets/icons/telegram.png'),
          ),
          onPressed: () {
            // launch(
            //     'https://t.me/ETHIOAMAZONSHOPP'); // Replace with your Facebook channel URL
          },
        ),
        IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/icons/tiktok_color.png'),
          ),
          onPressed: () {
            // launch(
            //     'https://www.tiktok.com/@ethioamazonshop?_t=8h83Cp9UISr&_r=1'); // Replace with your TikTok channel URL
          },
        ),
        // IconButton(
        //   icon: CircleAvatar(
        //     backgroundImage: AssetImage(
        //         'assets/icons/youtube_color.png'), // Replace with your YouTube logo image
        //   ),
        //   onPressed: () {
        //     launch(
        //         'https://www.youtube.com/'); // Replace with your YouTube channel URL
        //   },
        // ),
        IconButton(
          icon: CircleAvatar(
            backgroundImage: AssetImage(
                'assets/icons/instagram_color.png'), // Replace with your Instagram logo image
          ),
          onPressed: () {
            // launch(
            //     'https://instagram.com/abukkisreview?igshid=OGQ5ZDc2ODk2ZA=='); // Replace with your Instagram channel URL
          },
        ),
        IconButton(
          icon: CircleAvatar(
            backgroundImage: AssetImage('assets/icons/instagram_color.png'),
          ),
          onPressed: () {
            // launch(
            //     'https://www.facebook.com/profile.php?id=61550482735458&mibextid=ZbWKwL'); // Replace with your Facebook channel URL
          },
        ),
      ],
    );
  }
}
