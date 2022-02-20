import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mars_alam_todo/provider/my_provider.dart';
import 'package:mars_alam_todo/shared/components/components.dart';
import 'package:mars_alam_todo/shared/components/constants.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'new_tasks_screen.dart';

class HomeScreen extends StatelessWidget {
  // Variables
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var monProviderY = Provider.of<MyProvider>(context, listen: true);
    var monProviderN = Provider.of<MyProvider>(context, listen: false);

    // void onPress(var monProviderY) {
    //   if (monProviderY.change) {
    //     print('change1');
    //     monProviderY.change = false;
    //   } else {
    //     print('change2');
    //   }
    //
    //   if (monProviderY.isBottomSheetShawn) {
    //     print('work it');
    //     if (formKey.currentState!.validate()) {
    //       print('yes');
    //       monProviderN.insertToDatabase(
    //           date: dateController.text,
    //           time: timeController.text,
    //           title: titleController.text);
    //       Navigator.pop(context);
    //     }
    //   } else {
    //     print('yes2');
    //     scaffoldKey.currentState!
    //         .showBottomSheet(
    //           (context) => Container(
    //             color: Colors.white,
    //             padding: const EdgeInsets.all(20),
    //             child: Form(
    //               key: formKey,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   defaultFormField(
    //                     prefix: Icons.title,
    //                     validate: (String? val) {
    //                       if (val!.isEmpty) {
    //                         return 'title is empty';
    //                       }
    //                       return null;
    //                     },
    //                     controller: titleController,
    //                     label: 'Task Title',
    //                     type: TextInputType.text,
    //                   ),
    //                   const SizedBox(height: 15),
    //                   defaultFormField(
    //                     prefix: Icons.watch_later_outlined,
    //                     validate: (String? val) {
    //                       if (val!.isEmpty) {
    //                         return 'time is empty';
    //                       }
    //                       return null;
    //                     },
    //                     controller: timeController,
    //                     label: 'Task Time',
    //                     type: TextInputType.datetime,
    //                     onTap: () {
    //                       showTimePicker(
    //                               context: context,
    //                               initialTime: TimeOfDay.now())
    //                           .then((value) {
    //                         timeController.text =
    //                             value!.format(context).toString();
    //                       });
    //                     },
    //                   ),
    //                   const SizedBox(height: 15),
    //                   defaultFormField(
    //                     prefix: Icons.calendar_today,
    //                     validate: (String? val) {
    //                       if (val!.isEmpty) {
    //                         return 'Date is empty';
    //                       }
    //                       return null;
    //                     },
    //                     controller: dateController,
    //                     label: 'Task Date',
    //                     type: TextInputType.datetime,
    //                     onTap: () {
    //                       showDatePicker(
    //                               context: context,
    //                               initialDate: DateTime.now(),
    //                               firstDate: DateTime.now(),
    //                               lastDate: DateTime.parse('2025-12-12'))
    //                           .then((value) {
    //                         dateController.text =
    //                             DateFormat.yMMMd().format(value!);
    //                       });
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           elevation: 20,
    //         )
    //         .closed
    //         .then((value) {
    //       print('yes3');
    //       monProviderN.changeBottomSheetState(isShow: false, icon: Icons.edit);
    //     });
    //     monProviderN.changeBottomSheetState(isShow: true, icon: Icons.add);
    //   }
    // }

    return Scaffold(
      key: monProviderY.scaffoldKey,
      appBar: AppBar(
        title: const Text('our title'),
      ),
      body: const NewTasksScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => monProviderN.onPress2(context),
        child: Icon(monProviderY.fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          // monProviderY.change = false;
          // print('chan = ${monProviderY.change}');
          // cubit.changeIndex(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'archived'),
        ],
      ),
    );
  }
}
