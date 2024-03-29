import 'package:driver_apps/AllWidgets/HistoryItem.dart';
import 'package:driver_apps/DataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico de corridas',
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return HistoryItem(
            history: Provider.of<AppData>(context, listen: false)
                .tripHistoryDataList[index],
          );
        },

        //Não esta a receber valor ******************************

        separatorBuilder: (BuildContext context, int index) =>
            Divider(thickness: 3.0, height: 3.0),
        itemCount: Provider.of<AppData>(context, listen: false)
            .tripHistoryDataList
            .length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
