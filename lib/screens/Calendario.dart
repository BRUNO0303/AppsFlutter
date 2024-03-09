import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calendario extends StatefulWidget{
  const Calendario({Key? key, required this.title}): super(key:key);
  final String title;
  @override
  State<Calendario> createState()  => _CalendarioState();
}


class _CalendarioState extends State<Calendario>{
  FirebaseFirestore db = FirebaseFirestore.instance;
  List <Meeting> meetings = [];
  final _inicio = DateTime.now();
  TimeOfDay _tInicio = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  DateTime _startDate = DateTime.now();
  DateTime _datePicked = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _isAllDayBox = false;
  Color _colorPicked = Color.fromRGBO(0, 0, 0, 1);
  Color _dateColor = Color.fromRGBO(0,0,0,1);

  final _textEventoController = TextEditingController();
  final _textStartTime = TextEditingController();
  final _textEndTime = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadMeetings();
    _textStartTime.text = "${DateFormat.yMd("es").format(_startDate)} ${DateFormat.Hm("es").format(_startDate)}";
    _textEndTime.text = "${DateFormat.yMd("es").format(_endDate)} ${DateFormat.Hm("es").format(_endDate)}";
  }

  Future<void> _saveMeeting() async{
    final colRef = db.collection("Meetings");
    QuerySnapshot qS = await colRef.get();
    QueryDocumentSnapshot lastMeeting = qS.docs.last;
    String id = lastMeeting.reference.id;
    int n = int.parse(id.replaceAll("M", ""));

    db.collection("Meetings").doc("M${n+1}").set({
      'Evento':_textEventoController.text,
      'TodoDia':_isAllDayBox,
      'color':_dateColor.value.toString(),
      'inicio':_startDate,
      'fin':_endDate
    }).then((value) => print("Evento agregado"))
    .catchError((error)=>print(error));
  }

  Future<void> _loadMeetings() async {
    meetings = [];
    final colRef = db.collection("Meetings");
    QuerySnapshot qS = await colRef.get();
    List allMeetings = qS.docs.map((doc)=>doc.data()).toList();
    for (int i=0;i<allMeetings.length;i++) {
      Timestamp inicio = allMeetings[i]?["inicio"];
      Timestamp fin = allMeetings[i]?["fin"];
      String nE = (allMeetings[i]?["Evento"] ?? "");
      DateTime d = DateTime.fromMillisecondsSinceEpoch(inicio.seconds * 1000);
      DateTime h = DateTime.fromMillisecondsSinceEpoch(fin.seconds * 1000);
      Color c = Color(int.parse(allMeetings[i]["color"]));
      bool tD = allMeetings[i]["TodoDia"];
      setState(() {
        meetings.add(Meeting(nE, d, h, c, tD));
      });
    }
  }

  void _changeColor(Color color) => setState(() => _dateColor = color);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1,
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        dataSource: MeetingDataSource(meetings),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addMeeting(context);
          _loadMeetings();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _dialogColorBuilder(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Elige!', style: TextStyle(color: _dateColor),),
                  content: SingleChildScrollView(
                    child: HueRingPicker(
                      portraitOnly: true,
                      pickerColor: _colorPicked,
                      onColorChanged: (value) => setState((){
                        _dateColor=_colorPicked;
                      }),
                      enableAlpha: true,
                      displayThumbColor: true,
                    ),
                  ),

                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        setState(() => _dateColor = _colorPicked);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              })
          ;
        }
    );
  }

  Future<void> _dialogBuilder(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context,setState){
            return AlertDialog(
              title: Text('Nuevo evento',style: TextStyle(color: _dateColor),),
              content: Column(
                children: <Widget> [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _textEventoController,
                      decoration: const InputDecoration(labelText: "Introduzca nombre del evento"),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top:20),
                    child: Text(
                      "Fecha de inicio",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Text(
                      _textStartTime.text,
                    ),
                  ),
                  TextButton(
                    child: const Text( "Seleccionar fecha inicio"),
                    onPressed: () {
                      _selectStartDate(context).then( (value) =>
                          setState((){
                            _selectStartTime(context).then((value) =>
                            setState((){
                              _startDate=_datePicked.add(Duration(hours:_tInicio.hour,minutes: _tInicio.minute));
                              _textStartTime.text = "${DateFormat.yMd("es").format(_startDate)} ${DateFormat.Hm("es").format(_startDate)}";
                            })
                            );
                          }),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Fecha final",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Text(
                      _textEndTime.text,
                    ),
                  ),
                  TextButton(
                    child: const Text( "Seleccionar fecha final"),
                    onPressed: () {
                      _selectStartDate(context).then( (value) =>
                          setState((){
                            _selectStartTime(context).then((value) =>
                                setState((){
                                  _endDate=_datePicked.add(Duration(hours:_tInicio.hour,minutes: _tInicio.minute));
                                  _textEndTime.text = "${DateFormat.yMd("es").format(_endDate)} ${DateFormat.Hm("es").format(_endDate)}";
                                })
                            );
                          }),
                      );
                    },
                  ),
                  TextButton(
                      child: Text("Elige un color",style: TextStyle(color: _dateColor)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titlePadding: const EdgeInsets.all(0),
                              contentPadding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: MediaQuery.of(context).orientation == Orientation.portrait
                                    ? const BorderRadius.vertical(
                                  top: Radius.circular(500),
                                  bottom: Radius.circular(100),
                                )
                                    : const BorderRadius.horizontal(right: Radius.circular(500)),
                              ),
                              content: SingleChildScrollView(
                                child: HueRingPicker(
                                  pickerColor: _dateColor,
                                  onColorChanged: _changeColor,
                                  enableAlpha: true,
                                  displayThumbColor: false,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Aceptar'),
                                  onPressed: (){
                                    setState((){
                                      _changeColor(_dateColor);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Es de todo el día",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Checkbox(
                      value: _isAllDayBox,
                      onChanged: (value) => setState(() {
                        _isAllDayBox = !_isAllDayBox;
                      }
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Aceptar'),
                  onPressed: () {
                    _saveMeeting().then((value) => setState((){
                      _loadMeetings();
                    }));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
  void _addMeeting(context){
    _dialogBuilder(context);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _inicio,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        _datePicked = picked;
      });
    }
  }
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _tInicio,
        initialEntryMode: TimePickerEntryMode.dial,
        );
    if (picked != null) {
      setState(() {
        _tInicio = picked;
      });
    }
  }


}

class Meeting {
  Meeting(this.nombreEvento,this.desde,this.hasta,this.fondo,this.todoDia);
  String nombreEvento;
  DateTime desde;
  DateTime hasta;
  Color fondo;
  bool todoDia;
}

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index){
    return appointments![index].desde;
  }

  @override
  DateTime getEndTime(int index){
    return appointments![index].hasta;
  }

  @override
  String getSubject(int index){
    return appointments![index].nombreEvento;
  }

  @override
  Color getColor(int index){
    return appointments![index].fondo;
  }

  @override
  bool isAllDay(int index){
    return appointments![index].todoDia;
  }
}