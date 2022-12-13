import 'package:flutter/material.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';

class DetailKost extends StatefulWidget {
  final KostDummyModel model;
  DetailKost({Key? key, required this.model}) : super(key: key);

  @override
  State<DetailKost> createState() => _DetailKostState();
}

class _DetailKostState extends State<DetailKost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorValues.primaryPurple,
        mini: true,
        onPressed: () {
          SharedCode.navigatorPop(context);
        },
        child: Icon(Icons.arrow_back_rounded, size: 17),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Column(
        children: [
          Container(
              width: double.infinity,
              child: Image.asset(widget.model.picture_kost, fit: BoxFit.cover)),
        ],
      ),
    );
  }
}
