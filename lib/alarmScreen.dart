import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:setalarm/AlarmNotifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Alarmscreen extends StatefulWidget {
  const Alarmscreen({super.key});

  @override
  State<Alarmscreen> createState() => _AlarmscreenState();
}

class _AlarmscreenState extends State<Alarmscreen> {
  final List<DateTime> alarmList = [];

  void _addAlarm(DateTime alarmTime) {
    setState(() {
      alarmList.add(alarmTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: Padding(
            padding: const EdgeInsets.only(top: 10,right: 5),
            child: const Text(
              'Alarm',
              style: TextStyle(color: Colors.white,fontSize: 45,fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: const AnalogClock(
                  centerPointColor: Colors.white,
                  minuteHandColor: Colors.white,
                  hourHandColor: Colors.white,
                  secondHandColor: Colors.white,
                  hourNumberColor: Colors.white,
                  markingColor: Colors.white,
                  dialColor: Color.fromARGB(100, 66, 66, 66),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: alarmList.isNotEmpty
                  ? ListView.builder(
                itemCount: alarmList.length,
                itemBuilder: (context, index) {
                  final alarmTime = alarmList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                    child: ListTile(
                      tileColor: Colors.grey[700],
                      leading: const Icon(
                        Icons.alarm,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ALARM',style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),),
                          Text(
                            TimeOfDay.fromDateTime(alarmTime)
                                .format(context), // Display the alarm time
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            alarmList.removeAt(index); // Remove alarm
                          });
                        },
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No Alarms Set',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        //set aarm in floating action button
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceBetween,backgroundColor: Colors.grey[800],
                  title: const Text("ALARM",style: TextStyle(color: Colors.white,fontSize: 35),),
                  content: const Text("SET Alarm",style: TextStyle(color: Colors.white,fontSize: 25),),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final selectedDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          // If the selected time is in the past, schedule it for the next day
                          final scheduledDateTime = selectedDateTime.isBefore(now)
                              ? selectedDateTime.add(const Duration(days: 1))
                              : selectedDateTime;

                        
                          AlarmNotifiction.schedulenotification(
                            'Alarm',
                            'It\'s time!',
                            tz.TZDateTime.from(scheduledDateTime, tz.local),
                          );

                          // Add the alarm to the list
                          _addAlarm(scheduledDateTime);

                          // Show snackbar for confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Alarm set for ${pickedTime.format(context)}",
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text("Pick Time",
                          style: TextStyle(color: Colors.green,fontSize: 20)),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text("Close",
                          style: TextStyle(color: Colors.red,fontSize: 20)),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
