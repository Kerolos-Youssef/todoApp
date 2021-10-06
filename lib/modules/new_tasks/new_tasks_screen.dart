import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        return AppCubit.get(context).newtasks.length > 0
            ? ListView.separated(
                itemBuilder: (context, index) => buildTaskItem(
                  height: h,
                  width: w,
                  model: AppCubit.get(context).newtasks[index],
                  context: context,
                  isDone: AppCubit.get(context).isDone = true,
                  isArchive: AppCubit.get(context).isArchive = true,
                ),
                separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[400],
                ),
                itemCount: AppCubit.get(context).newtasks.length,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.highlight_off,
                      size: w * 0.3,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: w * 0.06,
                        end: w * 0.06,
                      ),
                      child: Text(
                        'No tasks Yet! Add new Tasks',
                        style: TextStyle(
                          fontSize: w * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
      listener: (context, state) {},
    );
  }
}
