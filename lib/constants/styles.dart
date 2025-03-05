import 'package:flutter/material.dart';

TextStyle userDetails() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
}

GestureDetector featureCard(color, icon, feature, route) {
  return GestureDetector(
    onTap: route,
    child: Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(45),
        boxShadow: [
          BoxShadow(
            color: Colors.white54.withOpacity(0.1),
            spreadRadius: 0.1,
            blurRadius: 0.1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: icon,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            feature,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}

Widget aida(action, {animation, animation2, animation3}) {
  return GestureDetector(
    onTap: action,
    child: Hero(
      tag: 'aida',
      child: Container(
        height: 85,
        width: 85,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 143, 143, 1.0),
            borderRadius: BorderRadius.circular(42)),
        child: Stack(children: [
          Center(
            child: Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(220, 20, 60, 1.0),
                  borderRadius: BorderRadius.circular(31)),
            ),
          ),
          Center(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 199, 199, 1.0),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ]),
      ),
    ),
  );
}

Widget aidaActive(action, Widget widget) {
  return GestureDetector(
    onTap: action,
    child: Hero(
      tag: 'aida',
      child: Stack(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 143, 143, 1.0),
                borderRadius: BorderRadius.circular(42)),
            child: Stack(children: [
              Center(
                child: Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(31)),
                ),
              ),
              Center(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 199, 199, 1.0),
                      borderRadius: BorderRadius.circular(20)),
                  child: widget,
                ),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}

Widget alertCard(BuildContext context, label, action, color, icon) {
  return GestureDetector(
    onTap: action,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(22.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white54.withOpacity(0.1),
            spreadRadius: 0.1,
            blurRadius: 0.1,
          ),
        ],
      ),
      child: Wrap(
        spacing: 12.0,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 26,
            child: icon,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

GestureDetector buttonStyle(action, String text, icon) {
  return GestureDetector(
    //if user click this button. user can upload image from camera
    onTap: action,
    child: Container(
      height: 50,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.redAccent, borderRadius: BorderRadius.circular(18.0)),
      child: Center(
        child: Wrap(
          spacing: 4.0,
          crossAxisAlignment: WrapCrossAlignment.end,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

GestureDetector buttonStyle2(action, String label, width) {
  return GestureDetector(
    onTap: action,
    child: Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      width: width,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(32)),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    ),
  );
}

GestureDetector buttonStyle3(action, label, width) {
  return GestureDetector(
    onTap: action,
    child: Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 14.0),
      width: width,
      decoration: BoxDecoration(
          border: Border.all(
              width: 3.0, style: BorderStyle.solid, color: Colors.red),
          borderRadius: BorderRadius.circular(32)),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 28,
          ),
        ),
      ),
    ),
  );
}

TextFormField kTextField(
    controller, icon1, color, color2, color3, String hint, input) {
  return TextFormField(
    controller: controller,
    keyboardType: input,
    style: const TextStyle(color: Colors.black87),
    cursorColor: color,
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(
              color: Colors.black45,
              width: 0.84,
            ),
            gapPadding: 5.0),
        hintText: hint,
        label: Text(hint),
        hintStyle: TextStyle(color: color2, fontStyle: FontStyle.italic),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.black45,
            width: 0.84,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        )),
  );
}

TextFormField kButtonTextField(
    icon1, icon2, action, color, color2, color3, String hint, input, readonly,
    {controller}) {
  return TextFormField(
    readOnly: readonly,
    controller: controller,
    keyboardType: input,
    style: const TextStyle(color: Colors.black87),
    cursorColor: color,
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(
              color: Colors.black45,
              width: 0.84,
            ),
            gapPadding: 5.0),
        hintText: hint,
        label: Text(hint),
        suffixIcon: IconButton(
          onPressed: action,
          icon: icon2,
        ),
        hintStyle: TextStyle(color: color2, fontStyle: FontStyle.italic),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.black45,
            width: 0.84,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        )),
  );
}

GestureDetector buttonStyle5({action, action1, label, width}) {
  return GestureDetector(
    onTap: action,
    child: Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.only(bottom: 8.0, left: 10.0),
      width: width,
      decoration: BoxDecoration(
          color: Color.fromRGBO(220, 20, 60, 1.0),
          border: Border.all(
            width: 3.0,
            style: BorderStyle.solid,
            color: Color.fromRGBO(220, 20, 60, 1.0),
          ),
          borderRadius: BorderRadius.circular(32)),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(252, 247, 248, 1.0),
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
