import 'package:flutter/material.dart';
import 'package:mars_alam_todo/provider/my_provider.dart';
import 'package:mars_alam_todo/shared/components/components.dart';
import 'package:mars_alam_todo/shared/components/constants.dart';
import 'package:provider/provider.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var monProvider = Provider.of<MyProvider>(context,listen: true);
    print('ttttttttttttt'+monProvider.isBottomSheetShawn.toString());
    // newTasks.add(model);
    return tasksBuilder(monProvider.newTasks);
  }
}
