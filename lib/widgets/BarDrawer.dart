import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/SettingsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/Values.dart';
import 'package:permission_handler/permission_handler.dart';


// ignore: must_be_immutable
class BarDrawer extends StatelessWidget {
  Box<Bar> bars;
  Box<dynamic> vals;
  Bar bar;

  BarDrawer({
    Key? key,
    required this.bars,
    required this.vals,
    required this.bar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bar = bars.get(vals.get('last')) ?? bar;
    
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DrawerHeader(
            padding: EdgeInsets.only(right: 0, left: 8, top: 8),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Drink counter', style: TextStyle(fontSize: Values.fontSize)),
                  Align(
                    alignment: Alignment.topCenter,
                    child: IconButton(
                      icon: Icon(Icons.settings), 
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsWidget())),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Color(bar.color),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bars.length,
              itemBuilder: (BuildContext context, int index) {
                Bar curBar = bars.getAt(index) ?? Bar();
                return Dismissible(
                  direction: (DismissDirection.horizontal),
                  key: ValueKey(curBar),
                  onDismissed: (direction) {
                      bars.delete(curBar.key);
                      if (bar == curBar) {
                          try {
                            bar = bars.getAt(index) ?? Bar.empty();
                          } catch (e) {
                            try {
                              bar = bars.getAt(index-1) ?? Bar.empty();
                            } catch (e) {
                              bar = Bar.empty();
                            }
                          }
                          
                          vals.put('last', bar.key);
                          //bar.save();
                      }
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete ${curBar.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                  Navigator.of(context).pop(true);
                              },
                              child: Text('Confirm')),
                          ],
                        );
                      });
                  },
                  background: Container(
                    color: Colors.redAccent,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(curBar.color),
                      maxRadius: 15,
                    ),
                    //tileColor: (curBar != bar) ? Colors.white : Colors.black12,
                    tileColor: (curBar == bar) ? Theme.of(context).backgroundColor : Theme.of(context).scaffoldBackgroundColor,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          bars.values.elementAt(index).name,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: Values.fontSizeMSmall,
                            //color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                        print('Switching...');
                        print(bars.getAt(index)?.key);
                        vals.put('last', bars.getAt(index)?.key ?? bar.key);
                        Navigator.pop(context);
                    },
                  ),
                );
              }),
          ),
          
          Container(
            height: 70,
            padding: EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              
              children: [
                
                Expanded(
                  flex: 30,
                  child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => AddBarForm(bars: bars, bar: bar, vals: vals),
                      );

                    },
                    child: Text('+ Add bar',
                      style: TextStyle(fontSize: Values.fontSize)
                    ),
                  ),
                ),
                
                
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                
                
                Expanded(
                  flex: 10,
                  child: ElevatedButton(
                    onPressed: () async {
                      int errorCode = 0;
                      PermissionStatus cameraStatus = await Permission.camera.status;
                      if (!cameraStatus.isGranted) Permission.camera.request();

                      try {
                        String qrString = await FlutterBarcodeScanner.scanBarcode('#ff0000', 'Cancel', true, ScanMode.QR);
                        errorCode++;// 1
                        print(qrString);
                        bar = new Bar.fromString(string: qrString, encoded: true);
                        errorCode++;// 2
                        bars.add(bar);
                        errorCode++;// 3
                        vals.put('last', bars.keyAt(bars.length-1));
                        errorCode++;// 4
                      } catch (e) {
                        print('Tried and Caught: Bardrawer:174: ${e.toString()}\nError code: $errorCode');
                      }

                      Navigator.pop(context);
                    },
                    child: Icon(Icons.qr_code_rounded, size: Values.fontSize),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//  @override
//  void dispose() {
//    bars.close();
//    vals.close();
//    super.dispose();
//  }
}
