import 'package:drinkscounter/Settings.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrinkTile extends StatelessWidget {
  final Drink drink;
  final Key key;
  final Function min;
  final Function plus;
  final Function delete;
  
  DrinkTile({
    required this.drink,
    required this.key,
    required this.min,
    required this.plus,
    required this.delete,
  });
  
  @override
  Widget build(BuildContext context) {
    double fontsize = Settings.fontSize-5;
    return Card(
      //margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: Text(
                drink.name,
                style: TextStyle(fontSize: fontsize),
                maxLines: 2,
              )
            ),

            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Text(drink.price.toStringAsFixed(2),
                style: TextStyle(fontSize: fontsize))),
            Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Icon(Icons.remove),
                      onPressed: () {
                        min();
                      }),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        //border: Border.all()
                      ),
                      child: Text(
                        drink.amount.toString(),
                        style: TextStyle(fontSize: fontsize)),
                    ),
                    TextButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        plus();
                      },
                      
                    )
                  ],
                ),
              ),
            ),
//            Flexible(
//
//              child: IconButton(
//                icon: Icon(Icons.delete),
//                onPressed: () {
//                  delete();
//                },
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}

