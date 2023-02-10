import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/helper/firebase_service.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:project_anakkos_app/widget/snackbar_widget.dart';
import 'package:provider/provider.dart';

class EditProfileGoogle extends StatefulWidget {
  const EditProfileGoogle({Key? key}) : super(key: key);

  @override
  State<EditProfileGoogle> createState() => _EditProfileGoogleState();
}

class _EditProfileGoogleState extends State<EditProfileGoogle> {
  final _document = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoad = ValueNotifier<bool>(false);
  PlatformFile? _pickedImage;

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
          SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _document.get(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  _fullNameController.text = data['full_name'];

                  return Container(
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
                                        : data['photo_profile'] != ''
                                            ? NetworkImage(
                                                    data['photo_profile'])
                                                as ImageProvider
                                            : null,
                                    child: data['photo_profile'] != '' ||
                                            _pickedImage != null
                                        ? null
                                        : Text(
                                            SharedCode()
                                                .getInitials(data['full_name']),
                                            style:
                                                textTheme.headline2!.copyWith(
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
                            validator: (value) =>
                                SharedCode().nameValidator(value),
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
                              data['email'],
                              style: textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _isLoad.value = true;
                                _pickedImage != null
                                    ? await FirebaseService()
                                        .editProfileWithImage(
                                          context,
                                          name: _fullNameController.text,
                                          fileName: _pickedImage!.name,
                                          filePath: _pickedImage!.path!,
                                        )
                                        .then(
                                          (value) => value
                                              ? Navigator.pop(context)
                                              : null,
                                        )
                                    : await FirebaseService()
                                        .editProfile(
                                          context,
                                          name: _fullNameController.text,
                                        )
                                        .then(
                                          (value) => value
                                              ? Navigator.pop(context)
                                              : null,
                                        );
                                _isLoad.value = false;
                              }
                            },
                            child: Text('Edit'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: LoadingAnimation(),
                  );
                }
              },
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
