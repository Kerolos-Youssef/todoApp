import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Map? model,
  context,
  bool? isDone,
  bool? isArchive,
}) {
  return Dismissible(
    key: Key(model!['id'].toString()),
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 12.w,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 37.r,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
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
                    fontSize: 24.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.w,
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
                size: 34.w,
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
                size: 30.w,
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
