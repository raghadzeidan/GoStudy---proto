import 'package:flutterapp/firebase/FirebaseAPI.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Tips/TipDialog.dart';
import 'package:flutter/material.dart';
import '../HomeMain.dart';
import 'package:provider/provider.dart';
import '../Extra/cards.dart';
import 'coursesResources.dart';
import 'dialog_helper.dart';
import 'enterTimeDialog.dart';
import 'fireBase/TimeCard.dart';
import 'fireBase/fireBase_api.dart';
import 'package:intl/intl.dart';

class enterTimeButton extends StatefulWidget {
  final double bevel;
  final Offset blurOffset;

  enterTimeButton({
    Key key,
    this.bevel = 10.0,
  })  : this.blurOffset = Offset(bevel / 2, bevel / 2),
        super(key: key);

  @override
  enterTimeState createState() => enterTimeState();
}

DateTime getDate() {
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  return date;
}

class enterTimeState extends State<enterTimeButton> {
  static String course ;
  static String resource ;
  DateTime date = getDate();
  //String date =  TipDialogState.getDate();
  String uid=  FirebaseAPI().getUid();
  int hours; int minutes; int seconds;
  String docId = null ;
  bool _isPressed = false;


  String format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  void _onPointerDown() {
    setState(() {
      _isPressed = true;
      setState(() async {

        course = ShowHideDropdownState.selectedValue;
        resource = ShowHideDropdownState.resource;
        hours = TimerService.currentDurationTime.inHours;
        minutes = TimerService.currentDurationTime.inMinutes;
        seconds = TimerService.currentDurationTime.inSeconds;
        print( "check seconds  $seconds ");

         if(course== "Select course" || resource == "Select resource" ){//|| duration == "00:00:00"){
           await DialogHelperMissingData.showError(context);
         }
         else {
           await DialogHelperTime.enterTime(context);
           if (TimeConfirmationDialog.toEnterTime == true) {
             TimeCard newTime = new TimeCard(
                 course, resource, uid,docId, date, hours, minutes, seconds);
             TimeDataBase().addTime(newTime);
           }
         }});
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _onPointerDown();
      },
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: MediaQuery.of(context).size.height/20,
        width: 150,
        //padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(227, 237, 247, 1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: _isPressed
              ? null
              : [
            BoxShadow(
              blurRadius: 30,
              offset: -widget.blurOffset,
              color: Colors.white,
            ),
            BoxShadow(
              blurRadius: 30,
              offset: Offset(10.5, 10.5),
              color: Color.fromRGBO(214, 223, 230, 1),
            )
          ],
        ),
        child: Center(
          child: Text(
            "Enter time",
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          ),

        ),
      ),
    );
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }


}