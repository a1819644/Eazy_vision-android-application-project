import 'dart:convert';
import 'package:http/http.dart' as http;

//add new collection for bills for new group
Future<GroupCollection> addCollection() async {
  final response = await http.post(Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/addingNewCollectionForBillsForNewGroup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'groupId': "groupId",
      'userID': "userID",
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print(jsonDecode(response.body)['result']);
    return GroupCollection.fomJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create bill.');
  }
}

class GroupCollection{
  final String result;
  //final int amount;

  const GroupCollection({required this.result});
  factory GroupCollection.fomJson(Map<String, dynamic> json) {
    return GroupCollection(
      result:json['result'],
      // amount:json['amount'],
    );
  }
}

//get group members/retrive group members
Future<GroupMember> getMember() async {
  final response = await http.post(Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/retriveGroupMembers'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'groupId': "groupId",
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print(jsonDecode(response.body)['result']);
    return GroupMember.fomJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create bill.');
  }
}

class MemberList{
  String index;
  String name;

  MemberList({required this.index, required this.name});

}

class GroupMember{
  List<MemberList> member = [MemberList(index:"0",name:"Member1")];
  //final int amount;

  GroupMember({required this.member});
  factory GroupMember.fomJson(Map<String, dynamic> json) {
    return GroupMember(
      member:json['result'],
    );
  }
}

//add new water bill for the group from the admin user
Future<BillResult> addWaterBill(String groupId, int amount) async {
  final response = await http.post(Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/createBillsForWater'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'value': amount,
      'groupId': groupId,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print(jsonDecode(response.body)['result']);
    return BillResult.fomJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to added bill.');
  }
}

class BillResult{
  final String result;
  //final int amount;

  const BillResult({required this.result});
  factory BillResult.fomJson(Map<String, dynamic> json) {
    return BillResult(
      result:json['result'],
      // amount:json['amount'],
    );
  }
}

//add new gas bill for the group from the admin user
Future<BillResult> addGasBill(String groupId, int amount) async {
  final response = await http.post(Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/createBillsForGas'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'value': amount,
      'groupId': groupId,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print(jsonDecode(response.body)['result']);
    return BillResult.fomJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to added bill.');
  }
}

//add new electricity bill for the group from the admin user
Future<BillResult> addElecBill(String groupId, int amount) async {
  final response = await http.post(Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/createBillsForElectricity'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'value': amount,
      'groupId': groupId,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print(jsonDecode(response.body)['result']);
    return BillResult.fomJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to added bill.');
  }
}

//add new Internet bill for the group from the admin user
Future<BillResult> addNetBill(String groupId, int amount) async {
  final response = await http.post(Uri.parse('https://us-central1-ezbill-vision-c.cloudfunctions.net/createBillsForInternet'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'value': amount,
      'groupId': groupId,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print(jsonDecode(response.body)['result']);
    return BillResult.fomJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to added bill.');
  }
}

