// class Water extends StatelessWidget {
//
//   // replace the actual amount with a variable which could be updated by the api call.
//   // int wateramount = 0;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Card(
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 80,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       // color: Colors.orange,
//                       // shape: BoxShape.rectangle,assets/images/logo.jpg
//                         image: DecorationImage(image:AssetImage('assets/images/water.jpg'),
//                             fit: BoxFit.fill)
//                     ),
//                   ),
//                 ),
//                 ScrollOnExpand(
//                   scrollOnExpand: true,
//                   scrollOnCollapse: false,
//                   child: ExpandablePanel(
//                     theme: const ExpandableThemeData(
//                       headerAlignment: ExpandablePanelHeaderAlignment.center,
//                       tapBodyToCollapse: true,
//                     ),
//                     header: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           "Water Bill",
//                           style: Theme.of(context).textTheme.bodyText2,
//                         )),
//                     collapsed: const Text(
//                       'Amount \$ 25',
//                       softWrap: true,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     expanded: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const <Widget>[
//                         //for (var _ in Iterable.generate(5))
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 10),
//                           child: Text(
//                             //loremIpsum,
//                             'Due Date 2022 Aug 25th',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(),
//                           child:Text('Your shared bill \$ 25',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(),
//                           child:Text('Total amount of the bill \$ 80',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                       ],
//                     ),
//                     builder: (_, collapsed, expanded) {
//                       return Padding(
//                         padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                         child: Expandable(
//                           collapsed: collapsed,
//                           expanded: expanded,
//                           theme: const ExpandableThemeData(crossFadePoint: 0),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
// class Gas extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Card(
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 80,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       // color: Colors.orange,
//                       // shape: BoxShape.rectangle,
//                         image: DecorationImage(image:AssetImage('assets/images/gas2.jpg'),
//                             fit: BoxFit.fill)
//                     ),
//                   ),
//                 ),
//                 ScrollOnExpand(
//                   scrollOnExpand: true,
//                   scrollOnCollapse: false,
//                   child: ExpandablePanel(
//                     theme: const ExpandableThemeData(
//                       headerAlignment: ExpandablePanelHeaderAlignment.center,
//                       tapBodyToCollapse: true,
//                     ),
//                     header: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           "Gas Bill",
//                           style: Theme.of(context).textTheme.bodyText2,
//                         )),
//                     collapsed: const Text(
//                       'Amount \$ 25',
//                       softWrap: true,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     expanded: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const <Widget>[
//                         //for (var _ in Iterable.generate(5))
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 10),
//                           child: Text(
//                             //loremIpsum,
//                             'Due Date 2022 Aug 25th',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(),
//                           child:Text('Your shared bill \$ 25',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(),
//                           child:Text('Total amount of the bill \$ 80',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                       ],
//                     ),
//                     builder: (_, collapsed, expanded) {
//                       return Padding(
//                         padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                         child: Expandable(
//                           collapsed: collapsed,
//                           expanded: expanded,
//                           theme: const ExpandableThemeData(crossFadePoint: 0),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
// class Eletricity extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Card(
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 80,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       // color: Colors.orange,
//                       // shape: BoxShape.rectangle,
//                         image: DecorationImage(image:AssetImage('assets/images/socket1.jpg'),
//                             fit: BoxFit.fill)
//                     ),
//                   ),
//                 ),
//                 ScrollOnExpand(
//                   scrollOnExpand: true,
//                   scrollOnCollapse: false,
//                   child: ExpandablePanel(
//                     theme: const ExpandableThemeData(
//                       headerAlignment: ExpandablePanelHeaderAlignment.center,
//                       tapBodyToCollapse: true,
//                     ),
//                     header: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           "Electricity Bill",
//                           style: Theme.of(context).textTheme.bodyText2,
//                         )),
//                     collapsed: const Text(
//                       'Amount \$ 25',
//                       softWrap: true,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     expanded: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const <Widget>[
//                         //for (var _ in Iterable.generate(5))
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 10),
//                           child: Text(
//                             //loremIpsum,
//                             'Due Date 2022 Aug 25th',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(),
//                           child:Text('Your shared bill \$ 25',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(),
//                           child:Text('Total amount of the bill \$ 80',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                       ],
//                     ),
//                     builder: (_, collapsed, expanded) {
//                       return Padding(
//                         padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                         child: Expandable(
//                           collapsed: collapsed,
//                           expanded: expanded,
//                           theme: const ExpandableThemeData(crossFadePoint: 0),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
// class Internet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Card(
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 80,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       // color: Colors.orange,
//                       // shape: BoxShape.rectangle,
//                         image: DecorationImage(image:AssetImage('assets/images/ie2.jpg'),
//                             fit: BoxFit.fill)
//                     ),
//                   ),
//                 ),
//                 ScrollOnExpand(
//                   scrollOnExpand: true,
//                   scrollOnCollapse: false,
//                   child: ExpandablePanel(
//                     theme: const ExpandableThemeData(
//                       headerAlignment: ExpandablePanelHeaderAlignment.center,
//                       tapBodyToCollapse: true,
//                     ),
//                     header: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           "Internet Bill",
//                           style: Theme.of(context).textTheme.bodyText2,
//                         )),
//                     collapsed: const Text(
//                       'Amount \$ 25',
//                       softWrap: true,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     expanded: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const <Widget>[
//                         //for (var _ in Iterable.generate(5))
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 10),
//                           child: Text(
//                             //loremIpsum,
//                             'Due Date 2022 Aug 25th',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(),
//                           child:Text('Your shared bill \$ 25',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(),
//                           child:Text('Total amount of the bill \$ 80',
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                       ],
//                     ),
//                     builder: (_, collapsed, expanded) {
//                       return Padding(
//                         padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                         child: Expandable(
//                           collapsed: collapsed,
//                           expanded: expanded,
//                           theme: const ExpandableThemeData(crossFadePoint: 0),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }