import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 67.0;

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green, // Warna latar belakang hijau
      child: SafeArea(
        child: Container(
          height: appBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan logo
            children: [
              Image.asset(
                'assets/logoputih.png', // Ganti dengan path gambar logo Anda
                height: 50.0,
                // width: 50.0, // Atur lebar logo jika diperlukan
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 100.0;

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/loginappbar.png', // Replace with your PNG image path
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Container(
          height: appBarHeight,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
