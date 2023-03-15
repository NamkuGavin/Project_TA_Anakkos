import 'package:flutter/material.dart';

import '../common/color_values.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  SearchBar({Key? key, this.controller, this.onChanged}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: ColorValues.primaryBlue)),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        child: TextField(
          controller: widget.controller,
          onChanged: (value) {
            setState(() {
              widget.onChanged!.call(value);
            });
          },
          cursorColor: ColorValues.primaryBlue,
          // style: AppTextStyles.appTitlew400s12(ColorValues().darkGreyColor),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            // suffixIconColor: ColorValues().greyColor,
            hintText: "Cari lokasi kos",
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade100,
            hoverColor: ColorValues.primaryBlue,
            contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
