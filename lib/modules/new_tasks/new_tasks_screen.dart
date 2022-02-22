import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return AppCubit.get(context).newTasks.length > 0
            ? ListView.separated(
                itemBuilder: (context, index) => buildTaskItem(
                  model: AppCubit.get(context).newTasks[index],
                  context: context,
                  isDone: AppCubit.get(context).isDone = true,
                  isArchive: AppCubit.get(context).isArchive = true,
                ),
                separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1.6.h,
                  color: Colors.grey[400],
                ),
                itemCount: AppCubit.get(context).newTasks.length,
              )
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.highlight_off,
                        size: 100.w,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 26.w,
                        ),
                        child: Text(
                          'No tasks Yet! Add new Tasks',
                          style: TextStyle(
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
      listener: (context, state) {},
    );
  }
}
