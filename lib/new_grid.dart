import 'package:flutter/material.dart';

class NewGrid extends StatelessWidget {
  const NewGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: GridView.builder(
        itemCount: 16,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.red,
            child: Text('0'),
          );
        },
      ),
    );
  }
}
