import 'package:flutter/material.dart';

class OnBoardingContents {
  final String title;
  final String image;
  final String desc;

  OnBoardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnBoardingContents> contents = [
  OnBoardingContents(
    title: "Register & Login",
    image: "assets/lottie/login.json",
    desc: "Anakkos adalah aplikasi pemesanan kos berbasis digital",
  ),
  OnBoardingContents(
    title: "Cari Kos Terdekat",
    image: "assets/lottie/location.json",
    desc:
        "Anakkos membantu Anda mencari kos terdekat atau dimana saja dengan mudah",
  ),
  OnBoardingContents(
    title: "Pilih Rumah Kosmu",
    image: "assets/lottie/search.json",
    desc:
        "Anakkos juga menyediakan informasi lengkap terkait kos agar Anda dapat memilih kos dengan mudah",
  ),
];
