import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DataHandler/appData.dart';

class EarnigTabPage extends StatelessWidget {
  const EarnigTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text(
                  'Total Earning',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "${Provider.of<AppData>(context, listen: false).earnings}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: 'Brand Bold'),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            ),
          ),
          onPressed: () {
            /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );*/
          },
          child: Row(
            children: [
              Image.asset('images/uberx.png', width: 70),
              SizedBox(width: 16),
              Text(
                'Total Trips',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "5",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 2.0, thickness: 2.0),
      ],
    );
  }
}
