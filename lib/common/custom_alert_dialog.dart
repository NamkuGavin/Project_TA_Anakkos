import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String status;
  final dynamic onButtonPressed;

  const CustomAlertDialog(
      {Key? key,
      required this.title,
      required this.content,
      required this.status,
      this.onButtonPressed = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    String buttonText = 'Tutup';
    Color color;
    switch (status) {
      case 'warning':
        color = Colors.orange.shade700;
        buttonText = 'Yes';
        break;
      case 'success':
        color = Colors.green;
        buttonText = 'Ok';
        break;
      default:
        color = Colors.red;
        break;
    }

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 40.0),
          margin: const EdgeInsets.only(top: 35.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              Text(
                content,
                style: const TextStyle(fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                  onPressed: onButtonPressed == 0
                      ? () => Navigator.of(context).pop()
                      : onButtonPressed,
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 48.0)),
                    backgroundColor: MaterialStateProperty.all(color),
                    elevation: MaterialStateProperty.all(0.0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
        Positioned(
          left: 5.0,
          right: 5.0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                child: Icon(
                  Icons.warning_rounded,
                  color: color,
                  size: 50.0,
                )),
          ),
        ),
      ],
    );
  }
}
