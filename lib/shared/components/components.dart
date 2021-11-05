import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  bool isPassword = false,
  String? Function(String?)? onSubmit,
  String? Function(String?)? onChange,
  void Function()? onTab,
  required String? Function(String?)? validate,
  required String label,
  required Icon prefix,
  Icon? suffix,
  void Function()? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      onTap: onTab,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefix,
        suffixIcon: suffix != null
            ? IconButton(
                icon: suffix,
                onPressed: suffixPressed,
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem({
  double? height,
  double? width,
  Map? model,
  context,
  bool? isDone,
  bool? isArchive,
}) {
  return Dismissible(
    key: Key(model!['id'].toString()),
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: height! * 0.01,
        horizontal: width! * 0.01,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: width * 0.11,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontSize: width * 0.044,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: width * 0.025,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.07,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontSize: width * 0.05,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width * 0.08,
          ),
          Visibility(
            visible: isDone!,
            child: IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
                AppCubit.get(context)
                    .changeTaskStatus(isDone: false, isArchive: true);
              },
              icon: Icon(
                Icons.done,
                color: Colors.green,
                size: width * 0.1,
              ),
            ),
          ),
          Visibility(
            visible: isArchive!,
            child: IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archive',
                  id: model['id'],
                );
                AppCubit.get(context)
                    .changeTaskStatus(isDone: true, isArchive: false);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black26,
                size: width * 0.09,
              ),
            ),
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task deleted Successfully'),
        ),
      );
    },
    confirmDismiss: (DismissDirection direction) async {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: const Text("Are you sure you wish to delete this task?"),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("DELETE")),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL"),
              ),
            ],
          );
        },
      );
    },
    background: Container(
      color: Colors.red,
      child: Icon(
        Icons.delete_rounded,
      ),
    ),
  );
}
