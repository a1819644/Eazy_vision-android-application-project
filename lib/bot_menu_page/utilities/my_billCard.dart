import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class billCard extends StatelessWidget {
  // replace the actual amount with a variable which could be updated by the api call.
  // int wateramount = 0;
  String picAddress, billType, amount, toDate, fromDate;
  billCard({Key? key,
    required this.picAddress,
    required this.billType,
    required this.amount,
    required this.toDate,
    required this.fromDate}): super(key: key);


  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(image:AssetImage(picAddress),
                            fit: BoxFit.fill)
                    ),
                  ),
                ),
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          billType,
                          style: TextStyle(color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                    collapsed:  Text(
                      '\$ ' + amount,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,),
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your shared bill is ',
                            ),
                            Text('\$ '+ amount),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Start Date '),
                            Text(fromDate),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Due Date',
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            Text(toDate),
                          ],
                        ),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
