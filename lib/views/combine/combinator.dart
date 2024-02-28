import 'package:combinators/services/bloc/crud/combination_item_crud_bloc.dart';
import 'package:combinators/views/combine/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CombinationPage extends StatefulWidget {
  final String groupName;
  final int groupId;

  const CombinationPage(
      {super.key, required this.groupName, required this.groupId});

  @override
  State<CombinationPage> createState() => _CombinationPageState();
}

class _CombinationPageState extends State<CombinationPage> {
  late double height;
  late double width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CombinationAppBar(context: context, groupName: widget.groupName, groupId: widget.groupId),
      body: BlocBuilder<CombinationItemDbBloc, CombinationItemDbState>(
        buildWhen: (previous, current) => true,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          // Colors.blueAccent,
                          Theme.of(context).primaryColor,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(Size(
                          width * 0.4,
                          height * 0.1,
                        )),
                      ),
                      child: Text(
                        'Random combination',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                    Center(
                      child: FloatingActionButton(
                        onPressed: () {
                          // 버튼을 눌렀을 때 실행할 코드를 여기에 작성하세요.
                        },
                        child: const Icon(Icons.add),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
