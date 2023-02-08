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
    image: "assets/images/boardingone.svg",
    desc: "Anakkos adalah aplikasi pemesanan kos berbasis digital",
  ),
  OnBoardingContents(
    title: "Cari Kos Terdekat",
    image: "assets/images/boardingtwo.svg",
    desc:
        "Anakkos membantu Anda mencari kos terdekat atau dimana saja dengan mudah",
  ),
  OnBoardingContents(
    title: "Pilih Rumah Kosmu",
    image: "assets/images/boardingthree.svg",
    desc:
        "Anakkos juga menyediakan informasi lengkap terkait kos agar Anda dapat memilih kos dengan mudah",
  ),
];
