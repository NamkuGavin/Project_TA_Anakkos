import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/widget/custom_text_field.dart';
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _usernameController = TextEditingController();
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
            onPressed: () async {
              final provider =
                  await Provider.of<GoogleProvider>(context, listen: false);
              await provider.updateUser(
                  _usernameController.text, _emailController.text);
              Navigator.pop(context, 'update');
            },
            child: Text("Save"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorValues.primaryBlue,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }
}
