import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/widget/custom_text_field.dart';
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileSeller extends StatefulWidget {
  const EditProfileSeller({Key? key}) : super(key: key);

  @override
  State<EditProfileSeller> createState() => _EditProfileSellerState();
}

class _EditProfileSellerState extends State<EditProfileSeller> {
  final _usernameController = TextEditingController();
  final _noHpController = TextEditingController();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgetAppbar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 75.h,
                  ),
                  inputWidget(),
                  SizedBox(
                    height: 50.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  inputWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: GoogleFonts.roboto(
            fontSize: 13,
          ),
        ),
        SizedBox(
          height: 7.h,
        ),
        CustomTextField(
          isEnable: true,
          isreadOnly: false,
          controller: _usernameController,
          inputType: TextInputType.name,
          validator: (value) => SharedCode().emptyValidator(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Text(
          'Nomor Telepon',
          style: GoogleFonts.roboto(
            fontSize: 13,
          ),
        ),
        SizedBox(
          height: 7.h,
        ),
        CustomTextField(
          isEnable: true,
          isreadOnly: false,
          controller: _noHpController,
          inputType: TextInputType.emailAddress,
          validator: (value) => SharedCode().emailValidator(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Text(
          'Email',
          style: GoogleFonts.roboto(
            fontSize: 13,
          ),
        ),
        SizedBox(
          height: 7.h,
        ),
        CustomTextField(
          isEnable: true,
          isreadOnly: false,
          controller: _emailController,
          inputType: TextInputType.emailAddress,
          validator: (value) => SharedCode().emailValidator(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
      ],
    );
  }

  widgetAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'update');
          },
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black)),
      title:
          Text("Edit Profile", style: GoogleFonts.roboto(color: Colors.black)),
      actions: [
        Padding(
          padding: EdgeInsets.all(12),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorValues.primaryBlue,
                foregroundColor: Colors.white,
                minimumSize: Size(0.w, 50.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Save',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(width: 5.w),
                  Icon(Icons.save)
                ],
              )),
        ),
      ],
    );
  }
}
