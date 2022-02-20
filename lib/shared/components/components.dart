import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:mars_alam_todo/provider/my_provider.dart';
import 'package:provider/provider.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit as void Function(String)?,
      onChanged: onChange as void Function(String)?,
      onTap: onTap as void Function()?,
      validator: validate as String? Function(String?)?,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed as void Function()?,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        // AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  var monProviderN = Provider.of<MyProvider>(context, listen: false);
                  monProviderN.updateSheet(context,model);
                  print('update');
                  // AppCubit.get(context).updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.update,
                  color: Colors.green,
                )),
            IconButton(
              onPressed: () {
                // var monProviderY = Provider.of<MyProvider>(context, listen: true);
                var monProviderN = Provider.of<MyProvider>(context, listen: false);
                monProviderN.deleteRecordFromDatabase(model['id']);
                // AppCubit.get(context).updateData(status: 'archive', id: model['id']);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );

Widget tasksBuilder(List<Map> tasks) => ConditionalBuilderRec(
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {}, child: buildTaskItem(tasks[index], context)),
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
        itemCount: tasks.length,
      ),
      condition: tasks.isNotEmpty,
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
