import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/helper/firebase_service.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:project_anakkos_app/widget/snackbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileApps extends StatefulWidget {
  const EditProfileApps({Key? key}) : super(key: key);

  @override
  State<EditProfileApps> createState() => _EditProfileAppsState();
}

class _EditProfileAppsState extends State<EditProfileApps> {
  final _fullNameController = TextEditingController();
  String name = "";
  String email = "";
  String imageProfile = "";
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoad = ValueNotifier<bool>(false);
  PlatformFile? _pickedImage;

  Future loadProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isLoad.value = true;
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_user").toString(),
        password: pref.getString("pass_user").toString());
    setState(() {
      _fullNameController.text = result.data.name;
      name = result.data.name;
      email = result.data.email;
      imageProfile = result.data.pfp;
    });
    _isLoad.value = false;
  }

  editProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isLoad.value = true;
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_user").toString(),
        password: pref.getString("pass_user").toString());
    await ApiService().editProfile(
        id_user: result.data.id,
        token: result.token,
        name: _fullNameController.text);
    _isLoad.value = false;
    setState(() {
      Navigator.pop(context, 'update');
    });
  }

  editProfile_withImage(File file) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isLoad.value = true;
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_user").toString(),
        password: pref.getString("pass_user").toString());
    await ApiService().editProfile_withImage(
        id_user: result.data.id,
        token: result.token,
        name: _fullNameController.text,
        file: file);
    _isLoad.value = false;
    setState(() {
      Navigator.pop(context, 'update');
    });
  }

  Future _selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _pickedImage = result.files.first;
      });
    } else {
      showSnackBar(context, title: 'Tidak ada gambar yang dipilih');
    }
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: TextStyle(
            color: Color(0XFF363940),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _selectImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0XFFE7E7E7),
                            radius: 50,
                            backgroundImage: _pickedImage != null
                                ? FileImage(
                                    File(
                                      _pickedImage!.path!,
                                    ),
                                  )
                                : imageProfile != ''
                                    ? NetworkImage(imageProfile)
                                        as ImageProvider
                                    : null,
                            child: imageProfile != '' || _pickedImage != null
                                ? null
                                : Text(
                                    SharedCode().getInitials(name),
                                    style: textTheme.headline2!.copyWith(
                                      color: Colors.black,
                                      fontSize: 22,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 3,
                            child: CircleAvatar(
                              radius: 12,
                              child: Icon(Icons.edit_rounded, size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'Nama Lengkap',
                    style: textTheme.bodyText1!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  _textFormTransaction(
                    textTheme,
                    hint: 'Masukkan nama lengkap',
                    controller: _fullNameController,
                    validator: (value) => SharedCode().nameValidator(value),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Email',
                    style: textTheme.bodyText1!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      email,
                      style: textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _pickedImage != null
                            ? editProfile_withImage(
                                File(_pickedImage!.path.toString()))
                            : editProfile();
                      }
                    },
                    child: Text('Edit'),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isLoad,
            builder: (context, value, _) => Visibility(
              visible: value,
              child: LoadingAnimation(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFormTransaction(
    TextTheme textTheme, {
    required String hint,
    required TextEditingController controller,
    TextInputType textInputType = TextInputType.text,
    String? Function(String?)? validator,
    bool withIcon = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: textTheme.bodyText1!.copyWith(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Color(0XFFE7E7E7),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Color(0XFFE7E7E7),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: ColorValues.primaryBlue,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: hint,
        hintStyle: textTheme.bodyText1,
        prefixIcon: withIcon
            ? Icon(
                Icons.date_range_outlined,
                color: ColorValues.primaryBlue,
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),
      ),
    );
  }
}
