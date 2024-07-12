/* eslint-disable camelcase */
/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
/* eslint-disable require-jsdoc */
/* eslint-disable prefer-const */
/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
// const moment = require("moment");
// const express = require("express");
// const {database} = require("firebase-admin");
// const FieldValue = require("firebase-admin").firestore.FieldValue;
const stripe = require("stripe")("_inputkey");
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
// kill -9 $(lsof -t -i:8080) to kill the ports
admin.initializeApp();


// -----------------------------------------------------//
// What this function for: for retriving the group members of a group
// when to call this function : call this function where you want to display the members of the group
// what this function is returning: // {result:{"0":"Anoop"}}
exports.retriveGroupMembers = functions.https.onRequest(async (data, res) =>{
  let leaderUid;
  let getGroupId;
  let membersArray = [];
  let userId = data.body.userId;
  let detailsinOne;
  // retriving the list of members via their userID
  const userRef = await admin.firestore().collection("users/")
      .doc(userId)
      .get();
  getGroupId = await userRef.data().groupId;
  console.log(getGroupId);
  // retriving the list of members via their userID
  const groupMembers = await admin.firestore().collection("groups/")
      .doc(getGroupId)
      .get();
  const value = await groupMembers.data().members;
  leaderUid = await groupMembers.data().leader;
  console.log(value);

  // retriving the users details such as first and Last Name
  for (let i =0; i< value.length; i++) {
    const userDetails = await admin.firestore().collection("users/")
        .doc(value[i])
        .get();

    let fullName = await userDetails.data().firstName + " " + await userDetails.data().LastName;
    let photoLinks = await userDetails.data().photoLink;
    let email = await userDetails.data().email;
    if (value[i] == leaderUid) {
      detailsinOne= {
        "full Name": fullName,
        "email": email,
        "photoLinks": photoLinks,
        "leader": true,
      };
    } else {
      detailsinOne= {
        "full Name": fullName,
        "email": email,
        "photoLinks": photoLinks,
        "leader": false,
      };
    }


    membersArray.push(detailsinOne);
  }
  // just printing members of the group
  console.log(membersArray);
  const result = {
    "memberList": membersArray,
  };

  return res.end(JSON.stringify(result)); // {"0":{"full Name":"Anoop kumar","email":"jksajdks@gmail.com"},"1":{"full Name":"sun Yu","email":"sun@gmail.com"}}
});

// ----------------------------------------------------------------------
// function for the camera accessing the camera mac address @SL  step : 3
// this function will be responding to camera request
exports.getBarCodeCameraAndBluetooth = functions.https.onRequest(async (data, res) => {
  const valueCameraId = data.body.camId;
  console.log(valueCameraId);
  let result = 1;
  // Create a reference to the cities collection
  // const membersOftheGroup = [];
  const valueUsersMacMap = new Map();
  let groupId;
  const usersList = [];
  // reading from the camera Id from the camera collection to fetch the group id
  const findCamera = await admin.firestore().collection("cameras")
      .doc(data.body.camId)
      .get();
  if (!findCamera.exists) {
    result = 0;
    return res.send(JSON.stringify(result));
  } else {
    groupId = await findCamera.data().groupId;
  }

  // geting the memebers users UID
  const getMembersUserUid = await admin.firestore().collection("groups/")
      .doc(groupId)
      .get();
  // getting members list
  const value = await getMembersUserUid.data().members;

  // get camera location:
  const getCamera = await admin.firestore().collection("groups/" + groupId + "/cameras")
      .doc(valueCameraId)
      .get();
  // getting members list
  const location = await getCamera.data().location;


  for (let i =0; i<value.length; i++) {
    valueUsersMacMap.set(await value[i]); // storing members uid as a key inside the MAP
  }
  // fetching all the details of that users
  for (let index = 0; index < value.length; index++) {
    if (valueUsersMacMap.has(value[index])) {
    // console.log(value[index]);
      const retrivingSpecificUsersMacAddress = await admin.firestore()
          .collection("users")
          .doc(value[index])
          .get();
      const storeUserDetails = {
        userCount: index,
        userId: value[index],
        firstName: await retrivingSpecificUsersMacAddress.data().firstName,
        lastName: await retrivingSpecificUsersMacAddress.data().LastName,
        photoLink: await retrivingSpecificUsersMacAddress.data().photoLink,
        bluetoothMacAddress: await retrivingSpecificUsersMacAddress.data().macAddress,
      };
      usersList.push(storeUserDetails);
      console.log(usersList);
    }
  }
  // sending all the results back
  const response = {
    result,
    location,
    groupId,
    usersList,
  };
  return res.end(JSON.stringify(response));
});


// -----------------------------------------------------//
// What this function for: for uplaoding the electricity bills, only group leader must be allowed to call this function
// when to call this function : call this function when group leader want to add the electricity bill
// what this function is returning: it is returning the json file
exports.createBillsLeader = functions.https.onRequest(async (data, res) => {
  const groupId = data.body.groupId;
  const billsType = data.body.billType;
  // then updating it
  admin.firestore()
      .collection("groups/" + groupId + "/bills")
      .doc(`${billsType}`)
      .update({
        // eslint-disable-next-line quotes
        "amount": admin.firestore.FieldValue.increment(data.body.amount),
        "fromDate": data.body.fromDate,
        "toDate": data.body.fromDate,
      });

  // to do check this function
  // retuning const which is going to be converted into JSON response
  const result = {
    "result": "bills got updated",
  };
  return res.end(JSON.stringify(result));
});


// -----------------------------------------------------//
// What this function for: for uplaoding the electricity bills, only group leader must be allowed to call this function
// when to call this function : call this function when group leader want to add the electricity bill
// what this function is returning: it is returning the json file
exports.createBillsLeader = functions.https.onRequest(async (data, res) => {
  const groupId = data.body.groupId;
  const billsType = data.body.billType;
  // then updating it
  admin.firestore()
      .collection("groups/" + groupId + "/bills")
      .doc(`${billsType}`)
      .update({
        // eslint-disable-next-line quotes
        "amount": admin.firestore.FieldValue.increment(data.body.amount),
        "fromDate": data.body.fromDate,
        "toDate": data.body.fromDate,
      });

  // to do check this function
  // retuning const which is going to be converted into JSON response
  const result = {
    "result": "bills got updated",
  };
  return res.end(JSON.stringify(result));
});


// /payment testing function step 2 Huixin sun when the function payment completes
exports.paymentSecond = functions.https.onRequest(async (data, res) => {
//   const groupId = data.body.groupId;
  const userId = data.body.userId;
  const billType = data.body.billType;
  await admin.firestore()
      .collection("users")
      .doc(userId)
      .collection("bills")
      .doc(`${billType}`)
      .update({
        amount: 0,
      });
  const result ={
    result: "amount got update",
  };

  res.end(JSON.stringify(result));
});


exports.inputCameraIdFromClientSide = functions.https.onRequest(async (data, res) => {
  const groupId = data.body.groupId;
  const camId = data.body.camId;
  console.log(data.body.groupId);
  const value = {
    groupId: data.body.groupId,
    camId: camId,
  };
  const forGroup = {
    location: data.body.location,
  };
    // running the quieres on the whole collection opencameras
  const findCamera = await admin.firestore().collection("cameras").doc(camId).get();
  if (!findCamera.exists) {
    let error = "error: please type the correct macAddress of the camera";
    return res.send(JSON.stringify(error));
  } else {
    await admin.firestore().collection("cameras").doc(data.body.camId).set(value);
    await admin.firestore().collection("groups/" + groupId + "/cameras").doc(`${camId}`).set(forGroup);
  }
  const result ={
    result: "camera got registered from the client side successfully",
  };
  return res.end(JSON.stringify(result));
});

// billing calculation
// on update function when water bill gets updated
exports.billCalculationForWater = functions.firestore
    .document("groups/{groupsId}/bills/water")
    .onUpdate(async (change, context) => {
      const FieldValue = require("firebase-admin").firestore.FieldValue;
      const newValue = change.after.data();
      let getWaterRef = await admin.firestore().collection("groups/" + context.params.groupsId + "/bills")
          .doc("water")
          .get();
      let fromDate = await getWaterRef.data().fromDate;
      let splitingFromDate = fromDate.split("/");
      // console.log("splitingFromDate -->" + splitingFromDate);
      let toDate = await getWaterRef.data().toDate;
      let splitingToDate = toDate.split("/");
      // console.log("splitingToDate -->" + splitingToDate);
      let orignalBillAmount = await getWaterRef.data().amount;
      console.log(newValue);
      console.log( fromDate + " -> " +toDate);
      const locationsUsagesMap = new Map([
        ["usagesKitchen", "usagesKitchen"],
        ["usagesUnkown", "usagesUnkown"],
        ["usagesLivingRoom", "usagesLivingRoom"],
      ]);
      class NewFieldLocations {
        NewFieldLocations(userIds, mapLocations) {
          this.userIds = userIds;
          this.mapLocations = mapLocations;
        }
      }
      let mapUsersCollectionStoringUsersUsages = new Map();

      let totalTime = 0;

      // predefining the usages percentages for unkown
      const usagesUnkownPercentage = {
        water: 20,
        gas: 30,
        electricity: 20,
        internet: 40,
      };
      // predefining the usages percentages for kitchen
      const usagesKitchenPercentage = {
        water: 60,
        gas: 50,
        electricity: 40,
        internet: 10,
      };
      // predefining the usages percentages for LivingRoom
      const usagesLivingRoomPercentage = {
        water: 20,
        gas: 20,
        electricity: 40,
        internet: 50,
      };

      // retriving the list of members via their userID
      const groupMembers = await admin.firestore().collection("groups")
          .doc(context.params.groupsId)
          .get();
      const membersArray = await groupMembers.data().members;

      let newMapForCalculatedResult = new Map();


      // fetching all the usages from all the database
      // step1: get the members first
      for (let i =0; i< membersArray.length; i++ ) {
        let mapForCollectionOfUsagesForEachUsages = new Map(); // {usagesKitchen = 1000, usagesKitchen =100...}
        // getting userId
        // mapUsersCollectionStoringUsersUsages.set(membersArray[i]); // setting keys first
        // step: 2 get members usages location collection
        // for (let index = 0; index < locationsUsages.length; index++) {
        // step 2.a getting first users listcollection
        let userDetailsUsagesTemp = admin.firestore().collection("users")
            .doc(membersArray[i]);
        let userDataBaseSnaphot = await userDetailsUsagesTemp.listCollections();
        for (let j = 0; j < userDataBaseSnaphot.length; j++) {
          const element = userDataBaseSnaphot[j].id;
          if (locationsUsagesMap.has(userDataBaseSnaphot[j].id)) {
            // console.log(userDataBaseSnaphot[j].id);
            let getTempDocRef = admin.firestore().collection("users/" + membersArray[i] + "/" + userDataBaseSnaphot[j].id);
            let snapshotDoc = await getTempDocRef.get();

            snapshotDoc.forEach( (doc) => {
              let tempDate = new Date(doc.id*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
              let getCurrrentDateMonth = tempDate.split("/"); // [ '10', '10', '2022, 11:59:00 pm' ]
              // step 2.a.b check if it matches with the dates from the bills date else ignore
              // case 1: if the date, month are equal or greater than the
              if (getCurrrentDateMonth[0] >= splitingFromDate[0] && getCurrrentDateMonth[1] >= splitingFromDate[1] &&
                  getCurrrentDateMonth[0] <= splitingToDate[0] && getCurrrentDateMonth[1] <= splitingToDate[1] ) {
                //   arrayforUsages.push(arrayforDocIds[index].data().inMinutes);
                // console.log("true inside the loop");
                totalTime = doc.data().inMinutes + totalTime;
                // console.log(totalTime);
              }
            });
            mapForCollectionOfUsagesForEachUsages.set(userDataBaseSnaphot[j].id, totalTime);
          }
          totalTime =0;
        }
        console.log("running from outside of the functions");
        mapUsersCollectionStoringUsersUsages.set(membersArray[i], mapForCollectionOfUsagesForEachUsages); // finally setting the values

        // console.log(mapUsersCollectionStoringUsersUsages);
      }


      let text = "--->";
      let totalMinutes =0;
      mapUsersCollectionStoringUsersUsages.forEach(function(value, key) {
        let tempRef = mapUsersCollectionStoringUsersUsages.get(key);
        let getKey = key;
        let kitchen=0;
        let LivingRoom=0;
        let unkown=0;

        // console.log(key, "==>key");
        tempRef.forEach((value, key) => {
          if (key == "usagesKitchen") {
            console.log((value * (usagesKitchenPercentage.water/100)));
            kitchen = Math.floor(value * (usagesKitchenPercentage.water/100));
            // tempNewMap.kitchen = kitchen;
          } else if (key == "usagesLivingRoom") {
            // LivingRoom = (value * (usagesLivingRoomPercentage.water/100));
            console.log(value * (usagesLivingRoomPercentage.water/100));
            LivingRoom = Math.floor(value * (usagesLivingRoomPercentage.water/100));
          } else { // for the usagesUnkown
            // unkown = (value * (usagesUnkownPercentage.water/100));
            unkown = Math.floor(value * (usagesUnkownPercentage.water/100));
            console.log(value * (usagesUnkownPercentage.water/100));
          }
        });
        totalMinutes =+ totalMinutes + kitchen + LivingRoom + unkown;
        newMapForCalculatedResult.set(getKey, kitchen + LivingRoom + unkown );
      });

      // newMapForCalculatedResult.forEach(function(value, key) {
      //   console.log(key, value);
      // });

      console.log(totalMinutes + " total minutes");
      let tempBillPercentage =0;
      let postBill =0;
      // last step calculating the bill against
      newMapForCalculatedResult.forEach(function(value, key) {
        // console.log(key + "value ", value);
        tempBillPercentage = Math.round((value/totalMinutes)*100);
        if (isNaN(tempBillPercentage)) {
          tempBillPercentage = 0;
        }
        console.log(tempBillPercentage);
        postBill = Math.floor((orignalBillAmount/100)*tempBillPercentage);
        if (isNaN(postBill)) {
          postBill = 0;
        }
        console.log(postBill);
      });

      // saving the result percentage and the amount inside the users database

      let groupRef = await admin.firestore().collection("groups")
          .doc(context.params.groupsId )
          .get();
      let letsGetAllTheMembers = groupRef.data().members;
      for (let k = 0; k < letsGetAllTheMembers.length; k++) {
        let userInfo = await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/bills")
            .doc("water")
            .get();
        let getUserPasValue = await userInfo.data().amount + postBill;

        let userRef = await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/bills")
            .doc("water")
            .update({
              "amount": getUserPasValue,
              "fromDate": fromDate,
              "toDate": toDate,
            });
        await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/shares")
            .doc("water")
            .set({
              "percentage": tempBillPercentage,
              "fromDate": fromDate,
              "toDate": toDate,
            });
        // updating the notification page
        const newMessages = [];
        const messagesRef = await admin.firestore()
            .collection("users")
            .doc(letsGetAllTheMembers[k])
            .collection("notificationMessages")
            .doc("allMessages")
            .get();

        const oldMessages = messagesRef.data().messages;
        oldMessages.forEach((element) => {
          newMessages.push(element);
        });
        newMessages.push("Your water new bill got updated to " + postBill);
        console.log(newMessages);

        // adding or adding new messaging inside the notification page
        await admin.firestore()
            .collection("users")
            .doc(letsGetAllTheMembers[k])
            .collection("notificationMessages")
            .doc("allMessages")
            .set({
              "messages": newMessages,
            });
      }
    });


// billing calculation
// on update function when Internet bill gets updated
exports.billCalculationForInternet = functions.firestore
    .document("groups/{groupsId}/bills/internet")
    .onUpdate(async (change, context) => {
      const FieldValue = require("firebase-admin").firestore.FieldValue;
      const newValue = change.after.data();
      let getWaterRef = await admin.firestore().collection("groups/" + context.params.groupsId + "/bills")
          .doc("internet")
          .get();
      let fromDate = await getWaterRef.data().fromDate;
      let splitingFromDate = fromDate.split("/");
      // console.log("splitingFromDate -->" + splitingFromDate);
      let toDate = await getWaterRef.data().toDate;
      let splitingToDate = toDate.split("/");
      // console.log("splitingToDate -->" + splitingToDate);
      let orignalBillAmount = await getWaterRef.data().amount;
      console.log(newValue);
      console.log( fromDate + " ->" +toDate);
      const locationsUsagesMap = new Map([
        ["usagesKitchen", "usagesKitchen"],
        ["usagesUnkown", "usagesUnkown"],
        ["usagesLivingRoom", "usagesLivingRoom"],
      ]);
      let mapUsersCollectionStoringUsersUsages = new Map();

      let totalTime = 0;

      // predefining the usages percentages for unkown
      const usagesUnkownPercentage = {
        water: 20,
        gas: 30,
        electricity: 20,
        internet: 40,
      };
      // predefining the usages percentages for kitchen
      const usagesKitchenPercentage = {
        water: 60,
        gas: 50,
        electricity: 40,
        internet: 10,
      };
      // predefining the usages percentages for LivingRoom
      const usagesLivingRoomPercentage = {
        water: 20,
        gas: 20,
        electricity: 40,
        internet: 50,
      };

      // retriving the list of members via their userID
      const groupMembers = await admin.firestore().collection("groups")
          .doc(context.params.groupsId)
          .get();
      const membersArray = await groupMembers.data().members;

      let newMapForCalculatedResult = new Map();


      // fetching all the usages from all the database
      // step1: get the members first
      for (let i =0; i< membersArray.length; i++ ) {
        let mapForCollectionOfUsagesForEachUsages = new Map(); // {usagesKitchen = 1000, usagesKitchen =100...}
        // getting userId
        // mapUsersCollectionStoringUsersUsages.set(membersArray[i]); // setting keys first
        // step: 2 get members usages location collection
        // for (let index = 0; index < locationsUsages.length; index++) {
        // step 2.a getting first users listcollection
        let userDetailsUsagesTemp = admin.firestore().collection("users")
            .doc(membersArray[i]);
        let userDataBaseSnaphot = await userDetailsUsagesTemp.listCollections();
        for (let j = 0; j < userDataBaseSnaphot.length; j++) {
          const element = userDataBaseSnaphot[j].id;
          if (locationsUsagesMap.has(userDataBaseSnaphot[j].id)) {
            // console.log(userDataBaseSnaphot[j].id);
            let getTempDocRef = admin.firestore().collection("users/" + membersArray[i] + "/" + userDataBaseSnaphot[j].id);
            let snapshotDoc = await getTempDocRef.get();

            snapshotDoc.forEach( (doc) => {
              tempDate = new Date(doc.id*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
              let getCurrrentDateMonth = tempDate.split("/"); // [ '10', '10', '2022, 11:59:00 pm' ]
              // step 2.a.b check if it matches with the dates from the bills date else ignore
              // case 1: if the date, month are equal or greater than the
              if (getCurrrentDateMonth[0] >= splitingFromDate[0] && getCurrrentDateMonth[1] >= splitingFromDate[1] &&
              getCurrrentDateMonth[0] <= splitingToDate[0] && getCurrrentDateMonth[1] <= splitingToDate[1] ) {
                //   arrayforUsages.push(arrayforDocIds[index].data().inMinutes);
                // console.log("true inside the loop");
                totalTime = doc.data().inMinutes + totalTime;
                // console.log(totalTime);
              }
            });
            mapForCollectionOfUsagesForEachUsages.set(userDataBaseSnaphot[j].id, totalTime);
          }
          totalTime =0;
        }

        console.log("running from outside of the functions");
        mapUsersCollectionStoringUsersUsages.set(membersArray[i], mapForCollectionOfUsagesForEachUsages); // finally setting the values

        // console.log(mapUsersCollectionStoringUsersUsages);
      }


      let text = "--->";
      let totalMinutes =0;
      mapUsersCollectionStoringUsersUsages.forEach(function(value, key) {
        let tempRef = mapUsersCollectionStoringUsersUsages.get(key);
        let getKey = key;
        let kitchen=0;
        let LivingRoom=0;
        let unkown=0;

        // console.log(key, "==>key");
        tempRef.forEach((value, key) => {
          if (key == "usagesKitchen") {
            console.log((value * (usagesKitchenPercentage.water/100)));
            kitchen = Math.floor(value * (usagesKitchenPercentage.water/100));
            // tempNewMap.kitchen = kitchen;
          } else if (key == "usagesLivingRoom") {
            // LivingRoom = (value * (usagesLivingRoomPercentage.water/100));
            console.log(value * (usagesLivingRoomPercentage.water/100));
            LivingRoom = Math.floor(value * (usagesLivingRoomPercentage.water/100));
          } else if (key == "usagesUnkown") { // for the usagesUnkown
            // unkown = (value * (usagesUnkownPercentage.water/100));
            unkown = Math.floor(value * (usagesUnkownPercentage.water/100));
            console.log(value * (usagesUnkownPercentage.water/100));
          }
        });
        totalMinutes =+ totalMinutes + kitchen + LivingRoom + unkown;
        newMapForCalculatedResult.set(getKey, kitchen + LivingRoom + unkown );
      });

      // newMapForCalculatedResult.forEach(function(value, key) {
      //   console.log(key, value);
      // });

      console.log(totalMinutes + " total minutes");
      let tempBillPercentage =0;
      let postBill =0;
      // last step calculating the bill against
      newMapForCalculatedResult.forEach(function(value, key) {
        console.log(key + "newMapForCalculatedResult ", value);
        tempBillPercentage = Math.round((value/totalMinutes)*100);
        console.log(tempBillPercentage);
        if (isNaN(tempBillPercentage)) {
          tempBillPercentage = 0;
        }
        console.log(tempBillPercentage);
        postBill = Math.floor((orignalBillAmount/100)*tempBillPercentage);
        if (isNaN(postBill)) {
          postBill = 0;
        }
        console.log(postBill);
      });

      // saving the result percentage and the amount inside the users database

      let groupRef = await admin.firestore().collection("groups")
          .doc(context.params.groupsId )
          .get();
      let letsGetAllTheMembers = groupRef.data().members;
      for (let k = 0; k < letsGetAllTheMembers.length; k++) {
        let userInfo = await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/bills")
            .doc("internet")
            .get();
        let getUserPasValue = await userInfo.data().amount + postBill;

        let userRef = await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/bills")
            .doc("internet")
            .update({
              "amount": getUserPasValue,
              "fromDate": fromDate,
              "toDate": toDate,
            });
        await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/shares")
            .doc("internet")
            .set({
              "percentage": tempBillPercentage,
              "fromDate": fromDate,
              "toDate": toDate,
            });
        // updating the notification page
        const newMessages = [];
        const messagesRef = await admin.firestore()
            .collection("users")
            .doc(letsGetAllTheMembers[k])
            .collection("notificationMessages")
            .doc("allMessages")
            .get();

        const oldMessages = messagesRef.data().messages;
        oldMessages.forEach((element) => {
          newMessages.push(element);
        });
        newMessages.push("Your internet new bill got updated to " + postBill);
        console.log(newMessages);

        // adding or adding new messaging inside the notification page
        await admin.firestore()
            .collection("users")
            .doc(letsGetAllTheMembers[k])
            .collection("notificationMessages")
            .doc("allMessages")
            .set({
              "messages": newMessages,
            });
      }
    });


// billing calculation
// on update function when Electricity bill gets updated
exports.billCalculationForElectricity = functions.firestore
    .document("groups/{groupsId}/bills/electricity")
    .onUpdate(async (change, context) => {
      const FieldValue = require("firebase-admin").firestore.FieldValue;
      const newValue = change.after.data();
      let getWaterRef = await admin.firestore().collection("groups/" + context.params.groupsId + "/bills")
          .doc("electricity")
          .get();
      let fromDate = await getWaterRef.data().fromDate;
      let splitingFromDate = fromDate.split("/");
      // console.log("splitingFromDate -->" + splitingFromDate);
      let toDate = await getWaterRef.data().toDate;
      let splitingToDate = toDate.split("/");
      // console.log("splitingToDate -->" + splitingToDate);
      let orignalBillAmount = await getWaterRef.data().amount;
      console.log(newValue);
      console.log( fromDate + " ->" +toDate);
      const locationsUsagesMap = new Map([
        ["usagesKitchen", "usagesKitchen"],
        ["usagesUnkown", "usagesUnkown"],
        ["usagesLivingRoom", "usagesLivingRoom"],
      ]);
      class NewFieldLocations {
        NewFieldLocations(userIds, mapLocations) {
          this.userIds = userIds;
          this.mapLocations = mapLocations;
        }
      }
      let mapUsersCollectionStoringUsersUsages = new Map();

      let totalTime = 0;

      // predefining the usages percentages for unkown
      const usagesUnkownPercentage = {
        water: 20,
        gas: 30,
        electricity: 20,
        internet: 40,
      };
      // predefining the usages percentages for kitchen
      const usagesKitchenPercentage = {
        water: 60,
        gas: 50,
        electricity: 40,
        internet: 10,
      };
      // predefining the usages percentages for LivingRoom
      const usagesLivingRoomPercentage = {
        water: 20,
        gas: 20,
        electricity: 40,
        internet: 50,
      };

      // retriving the list of members via their userID
      const groupMembers = await admin.firestore().collection("groups")
          .doc(context.params.groupsId)
          .get();
      const membersArray = await groupMembers.data().members;

      let newMapForCalculatedResult = new Map();


      // fetching all the usages from all the database
      // step1: get the members first
      for (let i =0; i< membersArray.length; i++ ) {
        let mapForCollectionOfUsagesForEachUsages = new Map(); // {usagesKitchen = 1000, usagesKitchen =100...}
        // getting userId
        // mapUsersCollectionStoringUsersUsages.set(membersArray[i]); // setting keys first
        // step: 2 get members usages location collection
        // for (let index = 0; index < locationsUsages.length; index++) {
        // step 2.a getting first users listcollection
        let userDetailsUsagesTemp = admin.firestore().collection("users")
            .doc(membersArray[i]);
        let userDataBaseSnaphot = await userDetailsUsagesTemp.listCollections();
        for (let j = 0; j < userDataBaseSnaphot.length; j++) {
          const element = userDataBaseSnaphot[j].id;
          if (locationsUsagesMap.has(userDataBaseSnaphot[j].id)) {
            // console.log(userDataBaseSnaphot[j].id);
            let getTempDocRef = admin.firestore().collection("users/" + membersArray[i] + "/" + userDataBaseSnaphot[j].id);
            let snapshotDoc = await getTempDocRef.get();

            snapshotDoc.forEach( (doc) => {
              tempDate = new Date(doc.id*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
              let getCurrrentDateMonth = tempDate.split("/"); // [ '10', '10', '2022, 11:59:00 pm' ]
              // step 2.a.b check if it matches with the dates from the bills date else ignore
              // case 1: if the date, month are equal or greater than the
              if (getCurrrentDateMonth[0] >= splitingFromDate[0] && getCurrrentDateMonth[1] >= splitingFromDate[1] &&
              getCurrrentDateMonth[0] <= splitingToDate[0] && getCurrrentDateMonth[1] <= splitingToDate[1] ) {
                //   arrayforUsages.push(arrayforDocIds[index].data().inMinutes);
                // console.log("true inside the loop");
                totalTime = doc.data().inMinutes + totalTime;
                // console.log(totalTime);
              }
            });
            mapForCollectionOfUsagesForEachUsages.set(userDataBaseSnaphot[j].id, totalTime);
          }
          totalTime =0;
        }

        console.log("running from outside of the functions");
        mapUsersCollectionStoringUsersUsages.set(membersArray[i], mapForCollectionOfUsagesForEachUsages); // finally setting the values

        // console.log(mapUsersCollectionStoringUsersUsages);
      }


      let text = "--->";
      let totalMinutes =0;
      mapUsersCollectionStoringUsersUsages.forEach(function(value, key) {
        let tempRef = mapUsersCollectionStoringUsersUsages.get(key);
        let getKey = key;
        let kitchen=0;
        let LivingRoom=0;
        let unkown=0;

        // console.log(key, "==>key");
        tempRef.forEach((value, key) => {
          if (key == "usagesKitchen") {
            console.log((value * (usagesKitchenPercentage.water/100)));
            kitchen = Math.floor(value * (usagesKitchenPercentage.water/100));
            // tempNewMap.kitchen = kitchen;
          } else if (key == "usagesLivingRoom") {
            // LivingRoom = (value * (usagesLivingRoomPercentage.water/100));
            console.log(value * (usagesLivingRoomPercentage.water/100));
            LivingRoom = Math.floor(value * (usagesLivingRoomPercentage.water/100));
          } else { // for the usagesUnkown
            // unkown = (value * (usagesUnkownPercentage.water/100));
            unkown = Math.floor(value * (usagesUnkownPercentage.water/100));
            console.log(value * (usagesUnkownPercentage.water/100));
          }
        });
        totalMinutes =+ totalMinutes + kitchen + LivingRoom + unkown;
        newMapForCalculatedResult.set(getKey, kitchen + LivingRoom + unkown );
      });

      // newMapForCalculatedResult.forEach(function(value, key) {
      //   console.log(key, value);
      // });

      console.log(totalMinutes + " total minutes");
      let tempBillPercentage =0;
      let postBill =0;
      // last step calculating the bill against
      newMapForCalculatedResult.forEach(function(value, key) {
        // console.log(key + "value ", value);
        tempBillPercentage = Math.round((value/totalMinutes)*100);
        if (isNaN(tempBillPercentage)) {
          tempBillPercentage = 0;
        }
        console.log(tempBillPercentage);
        postBill = Math.floor((orignalBillAmount/100)*tempBillPercentage);
        if (isNaN(postBill)) {
          postBill = 0;
        }
        console.log(postBill);
      });

      // saving the result percentage and the amount inside the users database

      let groupRef = await admin.firestore().collection("groups")
          .doc(context.params.groupsId )
          .get();
      let letsGetAllTheMembers = groupRef.data().members;
      for (let k = 0; k < letsGetAllTheMembers.length; k++) {
        let userInfo = await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/bills")
            .doc("electricity")
            .get();
        let getUserPasValue = await userInfo.data().amount + postBill;

        let userRef = await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/bills")
            .doc("electricity")
            .update({
              "amount": getUserPasValue,
              "fromDate": fromDate,
              "toDate": toDate,
            });
        await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/shares")
            .doc("electricity")
            .set({
              "percentage": tempBillPercentage,
              "fromDate": fromDate,
              "toDate": toDate,
            });
        // updating the notification page
        const newMessages = [];
        const messagesRef = await admin.firestore()
            .collection("users")
            .doc(letsGetAllTheMembers[k])
            .collection("notificationMessages")
            .doc("allMessages")
            .get();

        const oldMessages = messagesRef.data().messages;
        oldMessages.forEach((element) => {
          newMessages.push(element);
        });
        newMessages.push("Your electricity new bill got updated to " + postBill);
        console.log(newMessages);

        // adding or adding new messaging inside the notification page
        await admin.firestore()
            .collection("users")
            .doc(letsGetAllTheMembers[k])
            .collection("notificationMessages")
            .doc("allMessages")
            .set({
              "messages": newMessages,
            });
      }
    });


// billing calculation
// on update function when gas bill gets updated
exports.billCalculationForGas = functions.firestore
    .document("groups/{groupsId}/bills/gas")
    .onUpdate(async (change, context) => {
      const FieldValue = require("firebase-admin").firestore.FieldValue;
      const newValue = change.after.data();
      let getWaterRef = await admin.firestore().collection("groups/" + context.params.groupsId + "/bills")
          .doc("gas")
          .get();
      let fromDate = await getWaterRef.data().fromDate;
      let splitingFromDate = fromDate.split("/");
      console.log("splitingFromDate -->" + splitingFromDate);
      let toDate = await getWaterRef.data().toDate;
      let splitingToDate = toDate.split("/");
      console.log("splitingToDate -->" + splitingToDate);
      let orignalBillAmount = await getWaterRef.data().amount;
      console.log(newValue);
      console.log( fromDate + " ->" +toDate);
      const locationsUsagesMap = new Map([
        ["usagesKitchen", "usagesKitchen"],
        ["usagesUnkown", "usagesUnkown"],
        ["usagesLivingRoom", "usagesLivingRoom"],
      ]);
      class NewFieldLocations {
        NewFieldLocations(userIds, mapLocations) {
          this.userIds = userIds;
          this.mapLocations = mapLocations;
        }
      }
      let mapUsersCollectionStoringUsersUsages = new Map();

      let totalTime = 0;

      // predefining the usages percentages for unkown
      const usagesUnkownPercentage = {
        water: 20,
        gas: 30,
        electricity: 20,
        internet: 40,
      };
      // predefining the usages percentages for kitchen
      const usagesKitchenPercentage = {
        water: 60,
        gas: 50,
        electricity: 40,
        internet: 10,
      };
      // predefining the usages percentages for LivingRoom
      const usagesLivingRoomPercentage = {
        water: 20,
        gas: 20,
        electricity: 40,
        internet: 50,
      };

      // retriving the list of members via their userID
      const groupMembers = await admin.firestore().collection("groups")
          .doc(context.params.groupsId)
          .get();
      const membersArray = await groupMembers.data().members;

      let newMapForCalculatedResult = new Map();


      // fetching all the usages from all the database
      // step1: get the members first
      for (let i =0; i< membersArray.length; i++ ) {
        let mapForCollectionOfUsagesForEachUsages = new Map(); // {usagesKitchen = 1000, usagesKitchen =100...}
        // getting userId
        // mapUsersCollectionStoringUsersUsages.set(membersArray[i]); // setting keys first
        // step: 2 get members usages location collection
        // for (let index = 0; index < locationsUsages.length; index++) {
        // step 2.a getting first users listcollection
        let userDetailsUsagesTemp = admin.firestore().collection("users")
            .doc(membersArray[i]);
        let userDataBaseSnaphot = await userDetailsUsagesTemp.listCollections();
        for (let j = 0; j < userDataBaseSnaphot.length; j++) {
          const element = userDataBaseSnaphot[j].id;
          if (locationsUsagesMap.has(userDataBaseSnaphot[j].id)) {
            // console.log(userDataBaseSnaphot[j].id);
            let getTempDocRef = admin.firestore().collection("users/" + membersArray[i] + "/" + userDataBaseSnaphot[j].id);
            let snapshotDoc = await getTempDocRef.get();

            snapshotDoc.forEach( (doc) => {
              tempDate = new Date(doc.id*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
              let getCurrrentDateMonth = tempDate.split("/"); // [ '10', '10', '2022, 11:59:00 pm' ]
              // step 2.a.b check if it matches with the dates from the bills date else ignore
              // case 1: if the date, month are equal or greater than the
              if (getCurrrentDateMonth[0] >= splitingFromDate[0] && getCurrrentDateMonth[1] >= splitingFromDate[1] &&
              getCurrrentDateMonth[0] <= splitingToDate[0] && getCurrrentDateMonth[1] <= splitingToDate[1] ) {
                //   arrayforUsages.push(arrayforDocIds[index].data().inMinutes);
                // console.log("true inside the loop");
                totalTime = doc.data().inMinutes + totalTime;
                console.log("total time from inside =>"+ totalTime);
              }
            });
            mapForCollectionOfUsagesForEachUsages.set(userDataBaseSnaphot[j].id, totalTime);
          }
          totalTime =0;
        }

        console.log("running from outside of the functions");
        mapUsersCollectionStoringUsersUsages.set(membersArray[i], mapForCollectionOfUsagesForEachUsages); // finally setting the values

        // console.log(mapUsersCollectionStoringUsersUsages);
      }


      let text = "--->";
      let totalMinutes =0;
      mapUsersCollectionStoringUsersUsages.forEach(function(value, key) {
        let tempRef = mapUsersCollectionStoringUsersUsages.get(key);
        let getKey = key;
        let kitchen=0;
        let LivingRoom=0;
        let unkown=0;

        // console.log(key, "==>key");
        tempRef.forEach((value, key) => {
          if (key == "usagesKitchen") {
            console.log((value * (usagesKitchenPercentage.water/100)));
            kitchen = Math.round(value * (usagesKitchenPercentage.water/100));
            // tempNewMap.kitchen = kitchen;
          } else if (key == "usagesLivingRoom") {
            // LivingRoom = (value * (usagesLivingRoomPercentage.water/100));
            console.log(value * (usagesLivingRoomPercentage.water/100));
            LivingRoom = Math.round(value * (usagesLivingRoomPercentage.water/100));
          } else { // for the usagesUnkown
            // unkown = (value * (usagesUnkownPercentage.water/100));
            unkown = Math.round(value * (usagesUnkownPercentage.water/100));
            console.log(value * (usagesUnkownPercentage.water/100));
          }
        });
        totalMinutes =+ totalMinutes + kitchen + LivingRoom + unkown;
        newMapForCalculatedResult.set(getKey, kitchen + LivingRoom + unkown );
      });

      // newMapForCalculatedResult.forEach(function(value, key) {
      //   console.log(key, value);
      // });

      console.log(totalMinutes + " total minutes");
      let tempBillPercentage =0;
      let postBill =0;
      // last step calculating the bill against
      newMapForCalculatedResult.forEach(function(value, key) {
        // console.log(key + "value ", value);
        tempBillPercentage = Math.round((value/totalMinutes)*100);
        if (isNaN(tempBillPercentage)) {
          tempBillPercentage = 0;
        }
        console.log(tempBillPercentage);
        postBill = Math.floor((orignalBillAmount/100)*tempBillPercentage);
        if (isNaN(postBill)) {
          postBill = 0;
        }
        console.log(postBill);
      });

      // saving the result percentage and the amount inside the users database

      let groupRef = await admin.firestore().collection("groups")
          .doc(context.params.groupsId )
          .get();
      let letsGetAllTheMembers = groupRef.data().members;
      for (let k = 0; k < letsGetAllTheMembers.length; k++) {
        let userInfo = await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/bills")
            .doc("gas")
            .get();
        let getUserPasValue = await userInfo.data().amount + postBill;

        let userRef = await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/bills")
            .doc("gas")
            .update({
              "amount": getUserPasValue,
              "fromDate": fromDate,
              "toDate": toDate,
            });
        await admin.firestore().collection("users/" + letsGetAllTheMembers[k] + "/shares")
            .doc("gas")
            .set({
              "percentage": tempBillPercentage,
              "fromDate": fromDate,
              "toDate": toDate,
            });
        // updating the notification page
        const newMessages = [];
        const messagesRef = await admin.firestore()
            .collection("users")
            .doc(letsGetAllTheMembers[k])
            .collection("notificationMessages")
            .doc("allMessages")
            .get();

        const oldMessages = messagesRef.data().messages;
        oldMessages.forEach((element) => {
          newMessages.push(element);
        });
        newMessages.push("Your gas new bill got updated to " + postBill);
        console.log(newMessages);

        // adding or adding new messaging inside the notification page
        await admin.firestore()
            .collection("users")
            .doc(letsGetAllTheMembers[k])
            .collection("notificationMessages")
            .doc("allMessages")
            .set({
              "messages": newMessages,
            });
      }
    });

// // -------------------------------------------------------------------------------------//
// // What this function for: collection for Bills
// // when to call this function : call this function during the startup
// // what this function is returning: it will return json file containing the FromDate and toDate and amount for each of the bills
exports.accessTheBills = functions.https.onRequest(async (data, res) => {
  const userId = data.body.userId;
  let isLeader = false;
  let totalAmount = 0;
  const accessAllinformations = await admin.firestore()
      .collection("users/")
      .doc(userId)
      .get();
  const getgroupId = accessAllinformations.data().groupId;
  const getGroup = await admin.firestore()
      .collection("groups/")
      .doc(getgroupId)
      .get();

  const getLeaderUid = getGroup.data().leader;
  if (userId == getLeaderUid) {
    // eslint-disable-next-line no-const-assign
    isLeader =true;
  }
  // adding the collection inside the users database first
  // const bills = [];
  const billRef = admin.firestore()
      .collection("users/" + userId + "/bills");
  const valuesElec = await billRef.doc("electricity").get();
  const electricityBill = valuesElec.data();
  totalAmount += valuesElec.data().amount;

  const valuesGas = await billRef.doc("gas").get();
  const gasBill = valuesGas.data();
  totalAmount += valuesGas.data().amount;

  const valuesWater = await billRef.doc("water").get();
  const waterBill = valuesWater.data();
  totalAmount += valuesWater.data().amount;

  const valuesInternet = await billRef.doc("internet").get();
  const internetBill = valuesInternet.data();
  totalAmount += valuesInternet.data().amount;

  const result ={
    electricityBill,
    gasBill,
    waterBill,
    internetBill,
    isLeader: isLeader,
    totalAmount: totalAmount,
  };
  return res.send(JSON.stringify(result));
});


// -------------------------------------------------------------------------------------//
// What this function for: collection for to show what type of the access he got
// when to call this function : call this function when group member is joining the group or creating the group
// purpose? : 1. creating collection of bills inside users database
//            2. creating collection for accessforServices inside the group and user databases
//            3. adding the mac address of the user inside the users collection

// what this function is returning: just json file telling that result has been updated successfully
exports.creatingCollectionForAllTheDetails = functions.https.onRequest(async (data, res) => {
  const groupId = data.body.groupId;
  const userId = data.body.userId;
  const messages = [];
  let photoLink = "https://firebasestorage.googleapis.com/v0/b/ezbill-vision-c.appspot.com/o/3vo65oTY8CYTckGXlif6ULQxxm52%2Fimages%2Fpost_null?alt=media&token=2bc53775-fdd6-404f-acbf-7a416eecb552";
  let photoLinkDefault = [];
  photoLinkDefault.push(photoLink);
  const currentDate = Math.floor(Date.now() / 1000);
  console.log(currentDate);
  messages.push("welcome to ez bill");
  // creating collection for notificationMessages
  await admin.firestore()
      .collection("users/" + userId +"/"+ "notificationMessages")
      .doc("allMessages")
      .set({messages});
  // creating collection for usages
  await admin.firestore()
      .collection("users/" + userId + "/" + "usages");

  // adding the collection inside the users database first
  await admin.firestore()
      .collection("users/" + userId +"/"+ "accessForServices")
      .doc("details")
      .set({
        "accessForGas": true,
        "accessForWater": true,
        "accessForElectricity": true,
        "accessForInternet": true,
      });

  // adding the mac address of the users database
  await admin.firestore()
      .collection("users/")
      .doc(userId)
      .update({
        "macAddress": data.body.macAddress,
        "photoLink": photoLinkDefault,
      });

  // adding the current default date and in Minutes to zero // usages
  admin.firestore()
      .collection("users/")
      .doc(userId)
      .collection("usagesUnkown")
      .doc(`${currentDate}`)
      .set({
        "endTime": currentDate,
        "inMinutes": 0,
      });
  // adding the current default date and in Minutes to zero // usagesKitchen
  await admin.firestore()
      .collection("users/")
      .doc(userId)
      .collection("usagesKitchen")
      .doc(`${currentDate}`)
      .set({
        "endTime": currentDate,
        "inMinutes": 0,
      });
  // adding the current default date and in Minutes to zero // usagesLivingRoom
  await admin.firestore()
      .collection("users/")
      .doc(userId)
      .collection("usagesLivingRoom")
      .doc(`${currentDate}`)
      .set({
        "endTime": currentDate,
        "inMinutes": 0,
      });
  // creating the bill collection for the users
  // bill collection/doc for the electricity
  await admin.firestore().collection("users/" + userId + "/bills")
      .doc("electricity")
      .set({
        "type": 1,
        "amount": 0,
        "toDate": "",
        "fromDate": "",
      });
  // bill collection/doc for the gas
  await admin.firestore().collection("users/" + userId + "/bills")
      .doc("gas")
      .set({
        "type": 3,
        "amount": 0,
        "toDate": "",
        "fromDate": "",
      });
  // bill collection/doc for the water
  await admin.firestore().collection("users/" + userId + "/bills")
      .doc("water")
      .set({
        "type": 2,
        "amount": 0,
        "toDate": "",
        "fromDate": "",
      });
  // bill collection/doc for the internet
  await admin.firestore().collection("users/" + userId + "/bills")
      .doc("internet")
      .set({
        "type": 4,
        "amount": 0,
        "toDate": "",
        "fromDate": "",
      });

  // adding the collection inside the groups database at last
  await admin.firestore()
      .collection("groups/" + groupId +"/"+ userId)
      .doc("details")
      .set({
        "accessForGas": true,
        "accessForWater": true,
        "accessForElectricity": true,
        "accessForInternet": true,
      });

  await admin.firestore().collection("users/" + data.body.userId + "/shares")
      .doc("gas")
      .set({
        fromDate: "",
        toDate: "",
        percentage: 0,
      });

  await admin.firestore().collection("users/" + data.body.userId + "/shares")
      .doc("electricity")
      .set({
        fromDate: "",
        toDate: "",
        percentage: 0,
      });
  await admin.firestore().collection("users/" + data.body.userId + "/shares")
      .doc("water")
      .set({
        fromDate: "",
        toDate: "",
        percentage: 0,
      });
  await admin.firestore().collection("users/" + data.body.userId + "/shares")
      .doc("internet")
      .set({
        fromDate: "",
        toDate: "",
        percentage: 0,
      });
  const result ={
    result: "new collection inside the group database and user database got created",
  };
  return res.end(JSON.stringify(result));
});


// step 1 for bill
exports.addingNewCollectionForBillsForNewGroup = functions
    .https
    .onRequest(async (data, res) => {
      const groupId = data.body.groupId;

      if (groupId == "") {
        return res.end("please provide the group id");
      }
      try {
        await admin.firestore()
            .collection("groups/" + groupId +"/bills")
            .doc("electricity")
            .set({
              amount: 0,
              toDate: "",
              fromDate: "",
            });
        await admin.firestore()
            .collection("groups/" + groupId +"/bills")
            .doc("water")
            .set({
              amount: 0,
              toDate: "",
              fromDate: "",
            });
        await admin.firestore()
            .collection("groups/" + groupId +"/bills")
            .doc("gas")
            .set({
              amount: 0,
              toDate: "",
              fromDate: "",
            });
        await admin.firestore()
            .collection("groups/" + groupId +"/bills")
            .doc("internet")
            .set({
              amount: 0,
              toDate: "",
              fromDate: "",
            });
        await admin.firestore()
            .collection("groups/" + groupId +"/cameras")
            .doc("cam001")
            .set({
              location: "not installed",
            });
        await admin.firestore()
            .collection("groups/" + groupId +"/cameras")
            .doc("cam002")
            .set({
              location: "not installed",
            });
        await admin.firestore()
            .collection("groups/" + groupId +"/cameras")
            .doc("cam003")
            .set({
              location: "not installed",
            });
      } catch (e) {
        return res.end(e);
      }
      const result = {
        result: "successfull new collection got created",
      };
      const res1 = JSON.stringify(result);
      return res.end(res1);
    });


// -------------------------------------------------------------------------
// function for reading and storing the users usages {updating the users usages} @SL
exports.updateUsersUsages = functions.https.onRequest(async (data, res) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  let startTime= data.body.startTime;
  let endTime= data.body.endTime;
  let location = data.body.location;
  console.log(data.body.isRecognized + " coming from the camera part");
  location = "usages"+`${location}`;


  // handling startTime coming from the start time
  let auStartTime = new Date(startTime*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
  let getStartTimeArray = auStartTime.split("/"); // [ '27', '10', '2020' ] example
  let auStartTimeJsonArray = auStartTime.split(",");


  // handling endTime coming from the start time
  let auEndTime = new Date(endTime*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
  // console.log(auEndTime);
  let getEndTimeArray = auEndTime.split("/"); // [ '27', '10', '2020' ] example
  let auEndTimeJsonArray = auEndTime.split(",");
  let getEndHoursArray = auEndTime.split(":");


  let futureDate;
  let tempNewDate = startTime;
  let storeAllMinute = 0;
  let getTempMinutes =0;
  let futureDateArray = [];
  let futureDateHoursArray = [];
  let count = 1;
  let prevDate =0;
  let prevDatefuture;
  let getDifferenceInMinutes = Math.floor((endTime - startTime)/60);


  console.log(getDifferenceInMinutes);
  // case 1: checking if the startTimeJSON and storedLAstTime is same
  if (data.body.isRecognized == 0) {
    const getGroup = await admin.firestore()
        .collection("groups/")
        .doc(data.body.groupId)
        .get();

    const getLeaderUid = getGroup.data().leader;

    const newMessages = [];
    const messagesRef = await admin.firestore()
        .collection("users")
        .doc(getLeaderUid)
        .collection("notificationMessages")
        .doc("allMessages")
        .get();

    const oldMessages = messagesRef.data().messages;
    oldMessages.forEach((element) => {
      newMessages.push(element);
    });
    newMessages.push(auStartTime + ": Unauthorized user detected at location - " + data.body.location + "- stayed for " + getDifferenceInMinutes + " minutes" );
    console.log(newMessages);

    // adding or adding new messaging inside the notification page
    await admin.firestore()
        .collection("users")
        .doc(getLeaderUid)
        .collection("notificationMessages")
        .doc("allMessages")
        .set({
          "messages": newMessages,
        });

    await admin.firestore()
        .collection("groups/" + data.body.groupId + "/unautorizedUsages")
        .doc(`${endTime}`)
        .set({
          inMinutes: getDifferenceInMinutes,
          startTime: data.body.startTime,
          endTime: data.body.endTime,
          location: data.body.location,
        });
  } else {
    // fetching the last document for authorized users ----
    const getLastDocRef = admin.firestore()
        .collection("users/")
        .doc(data.body.userId);
    let isExist;
    let snapshot = await getLastDocRef.listCollections(location);
    snapshot.forEach((snapshot) => {
      console.log("Found subcollection with id:", snapshot.id);
      if (snapshot.id == "location") {
        isExist = snapshot.id;
        console.log(isExist);
      }
    });
    let gettingLastStoredDocId;
    let gettingLastStoredInMinutesValue;
    if (isExist == "location") {
      console.log("document exist");
      const getLastDocRef = admin.firestore()
          .collection("users/" + data.body.userId +"/"+ location);
      let snapshotInside = await getLastDocRef.get();
      snapshotInside.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        gettingLastStoredDocId = doc.id;
        console.log(doc.id);
        gettingLastStoredInMinutesValue = doc.data().inMinutes;
      });
      // converting the gettingLastStoredDocId into date
      const intogettingLastStoredDocIdDate = new Date(gettingLastStoredDocId*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
      let intogettingLastStoredDocIdDateArray = intogettingLastStoredDocIdDate.split(",");

      console.log(getDifferenceInMinutes);
      console.log(intogettingLastStoredDocIdDateArray[0]);
      console.log(auEndTimeJsonArray[0]);
      // case 1: checking if the startTimeJSON and storedLAstTime is same
      if (auEndTimeJsonArray[0] == intogettingLastStoredDocIdDateArray[0]) {
        console.log("run first loop");
        await admin.firestore()
            .collection("users/" + data.body.userId + "/"+ location)
            .doc(`${gettingLastStoredDocId}`)
            .update({
              "inMinutes": admin.firestore.FieldValue.increment(getDifferenceInMinutes),
            });
      } else {
        // case1  if the start date same as the end date
        if (getStartTimeArray[0] == getEndTimeArray[0]) {
          console.log("runned from new collection side for the start date same as end date");
          await admin.firestore()
              .collection("users/" + data.body.userId + "/"+ location)
              .doc(`${data.body.endTime}`)
              .set({
                inMinutes: getDifferenceInMinutes,
                endTime: data.body.endTime,
              });
        } else {
          for (let index = 1; index <= getDifferenceInMinutes; index++) {
            // step 1: start increasing the time in minute
          // step 1: start increasing the time in minute
            let temp = 1*60;
            storeAllMinute = temp + storeAllMinute;
            getTempMinutes = Math.floor(temp/60) + getTempMinutes; // get the minutes for while loop
            prevDate = tempNewDate;
            tempNewDate = startTime + storeAllMinute; // getting the newDate
            futureDate = new Date(tempNewDate*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
            prevDatefuture = new Date(prevDate*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
            let prevDateArray = prevDatefuture.split("/");

            // console.log("current"+ futureDate + "prev" + prevDatefuture);
            futureDateArray = futureDate.split("/");
            futureDateHoursArray = futureDate.split(":");
            // console.log(prevDateArray[0]);
            // console.log(futureDateArray[0]);
            if (prevDateArray[0] != futureDateArray[0]) {
              console.log("sasaa from already collection side");
            }
            // now we are also check if the day has start changed
            // checking date, hours and minute from future date and enddate JSON
            if (futureDateArray[0] == getEndTimeArray[0] && futureDateHoursArray[1] == getEndHoursArray[1] &&
                futureDateHoursArray[2] == getEndHoursArray[2] ) {
              console.log("runned from new collection side");
              await admin.firestore()
                  .collection("users/" + data.body.userId + "/"+ location)
                  .doc(`${data.body.endTime}`)
                  .set({
                    inMinutes: getTempMinutes,
                    endTime: prevDate,
                  });
            }
            if (prevDateArray[0] != futureDateArray[0]) { // now checking if the date has changed its not equal to endDate time
              // then create a new collection
              console.log("2n loop runned from already collection side");
              await admin.firestore()
                  .collection("users/" + data.body.userId + "/"+ location)
                  .doc(`${prevDate}`)
                  .set({
                    "inMinutes": getTempMinutes,
                    "endTime": prevDate,
                  });
              getTempMinutes = 0;
            }
            count ++;
          }
        }
      }
    } else {
      console.log("no document found!");
      console.log("creating new collection");
      // case1  if the start date same as the end date
      if (getStartTimeArray[0] == getEndTimeArray[0]) {
        console.log("runned from new collection side for the start date same as end date");
        await admin.firestore()
            .collection("users/" + data.body.userId + "/"+ location)
            .doc(`${data.body.endTime}`)
            .set({
              inMinutes: getDifferenceInMinutes,
              endTime: data.body.endTime,
            });
      } else { // else
        for (let index = 1; index <= getDifferenceInMinutes; index++) {
          // else
          // step 1: start increasing the time in minute
          let temp = 1*60;
          storeAllMinute = temp + storeAllMinute;
          getTempMinutes = Math.floor(temp/60) + getTempMinutes; // get the minutes for while loop
          prevDate = tempNewDate;
          tempNewDate = startTime + storeAllMinute; // getting the newDate
          futureDate = new Date(tempNewDate*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
          prevDatefuture = new Date(prevDate*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
          let prevDateArray = prevDatefuture.split("/");

          // console.log("current"+ futureDate + "prev" + prevDatefuture);
          futureDateArray = futureDate.split("/");
          futureDateHoursArray = futureDate.split(":");
          // console.log(prevDateArray[0]);
          // console.log(futureDateArray[0]);
          //   if (prevDateArray[0] != futureDateArray[0]) {
          //     console.log("sasaa from new collection side");
          //   }

          // now we are also check if the day has start changed
          // checking date, hours and minute from future date and enddate JSON
          if (futureDateArray[0] == getEndTimeArray[0] && futureDateHoursArray[1] == getEndHoursArray[1] &&
       futureDateHoursArray[2] == getEndHoursArray[2] ) {
            console.log("runned from new collection side");
            await admin.firestore()
                .collection("users/" + data.body.userId + "/"+ location)
                .doc(`${data.body.endTime}`)
                .set({
                  inMinutes: getTempMinutes,
                  endTime: prevDate,
                });
          }
          if (prevDateArray[0] != futureDateArray[0]) { // now checking if the date has changed its not equal to endDate time
          // then create a new collection
            console.log("2n loop runned from new collection side");
            await admin.firestore()
                .collection("users/" + data.body.userId + "/"+ location)
                .doc(`${prevDate}`)
                .set({
                  "inMinutes": getTempMinutes,
                  "endTime": prevDate,
                });
            getTempMinutes = 0;
          }
          count ++;
        }
      }
    }
  }

  const resulting = {
    result: "usage time got updated",
  };


  return res.end(JSON.stringify(resulting));
});


// / payment testing function step 1 Huixin sun
exports.payments = functions.https.onRequest(async (data, res) => {
  const secret_key = "sk_test_51LvzdiI0dSBEtrTkeaxy661nLcrPfMHaXD8r5ENI66eCPX4JsPPZGUsJ0YGTfYfpQFZxP2zQ3NolWGKADX5Jmmcp00Ghjubx7Z";
  const pulishable_key = "sk_test_51LvzdiI0dSBEtrTkeaxy661nLcrPfMHaXD8r5ENI66eCPX4JsPPZGUsJ0YGTfYfpQFZxP2zQ3NolWGKADX5Jmmcp00Ghjubx7Z";
  // get the payment type
  const userId = data.body.userId;
  const billType = data.body.billType;
  // documentation https://stripe.com/docs/payments/accept-a-payment
  // fetching the price from the database
  const userRef = await admin.firestore()
      .collection("users")
      .doc(userId)
      .collection("bills")
      .doc(`${billType}`)
      .get();
  let get_amount = userRef.data().amount;
  get_amount += get_amount * 100; // converting into the cents
  const product_id = await stripe.products.create({
    name: billType,
  });

  console.log(product_id.id);
  const price = await stripe.prices.create({
    currency: "usd",
    unit_amount: get_amount,
    product: product_id.id,
  });

  const paymentLink = await stripe.paymentLinks.create({
    line_items: [{price: price.id,
      quantity: 1}],
    after_completion: {type: "hosted_confirmation", hosted_confirmation: {custom_message: "Thank you for the payment, please go back to the application to see an update"},
    },

  });

  const paymentLinkJson = {
    paymentLink,
  };
  res.end(JSON.stringify(paymentLinkJson));
});


// // -------------------------------------------------------------------------------------//
// // What this function for: collection for Bills
// // when to call this function : call this function during the startup
// // what this function is returning: it will return json file containing the FromDate and toDate and amount for each of the bills
exports.accessTheBills = functions.https.onRequest(async (data, res) => {
  const userId = data.body.userId;
  let isLeader = false;
  let totalAmount = 0;
  const accessAllinformations = await admin.firestore()
      .collection("users/")
      .doc(userId)
      .get();
  const information = accessAllinformations.data();
  const getgroupId = accessAllinformations.data().groupId;
  const getGroup = await admin.firestore()
      .collection("groups/")
      .doc(getgroupId)
      .get();

  const getLeaderUid = getGroup.data().leader;
  if (userId == getLeaderUid) {
    // eslint-disable-next-line no-const-assign
    isLeader =true;
  }
  // adding the collection inside the users database first
  // const bills = [];
  const billRef = admin.firestore()
      .collection("users/" + userId + "/bills");
  const valuesElec = await billRef.doc("electricity").get();
  const electricityBill = valuesElec.data();
  totalAmount += valuesElec.data().amount;

  const valuesGas = await billRef.doc("gas").get();
  const gasBill = valuesGas.data();
  totalAmount += valuesGas.data().amount;

  const valuesWater = await billRef.doc("water").get();
  const waterBill = valuesWater.data();
  totalAmount += valuesWater.data().amount;

  const valuesInternet = await billRef.doc("internet").get();
  const internetBill = valuesInternet.data();
  totalAmount += valuesInternet.data().amount;

  const result ={
    electricityBill,
    gasBill,
    waterBill,
    internetBill,
    isLeader: isLeader,
    totalAmount: totalAmount,
  };
  console.log(result);
  return res.send(JSON.stringify(result));
});


// -----------------------------------------------------// step 2 for the bill
// What this function for: for uplaoding the electricity bills, only group leader must be allowed to call this function
// when to call this function : call this function when group leader want to add the electricity bill
// what this function is returning: it is returning the json file
exports.createBillsLeader = functions.https.onRequest(async (data, res) => {
  const userId = data.body.userId;
  const billsType = data.body.billType;
  const accessAllinformations = await admin.firestore()
      .collection("users/")
      .doc(userId)
      .get();
  const information = accessAllinformations.data();
  const getgroupId = accessAllinformations.data().groupId;
  const getGroup = await admin.firestore()
      .collection("groups/")
      .doc(getgroupId)
      .get();

  const getLeaderUid = getGroup.data().leader;

  // then updating it
  admin.firestore()
      .collection("groups/" + getgroupId + "/bills")
      .doc(`${billsType}`)
      .update({
        // eslint-disable-next-line quotes
        "amount": admin.firestore.FieldValue.increment(data.body.amount),
        "fromDate": data.body.fromDate,
        "toDate": data.body.toDate,
      });

  const forLogs = {
    "amount": data.body.amount,
    "fromDate": data.body.fromDate,
    "toDate": data.body.toDate,
  };
  console.log(forLogs);

  // to do check this function
  // retuning const which is going to be converted into JSON response
  const result = {
    "result": "bills got updated",
  };
  return res.end(JSON.stringify(result));
});

// / -------------------------------------------------------------------------------------//
// What this function for: reading the notification messages
// when to call this function : call this function from the notification page
// what this function is returning: it will return json file containing all the messages
exports.accessTheNotifications = functions.https.onRequest(async (data, res) => {
  const userId = data.body.userId;
  const accessAllTheNotifications = await admin.firestore()
      .collection("users/" + userId + "/notificationMessages")
      .doc("allMessages")
      .get();
  const allTheMessages = accessAllTheNotifications.data().messages;
  let messagesArray=[];
  let count =0;
  for (let index = allTheMessages.length-1; index > 0; index--) {
    if (count < 5) {
      messagesArray.push(allTheMessages[index]);
    } else {
      break;
    }
    count++;
  }
  console.log(messagesArray);
  const result = {
    messages: messagesArray,
  };
  return res.end(JSON.stringify(result));
});

// -------------------------------------------------------------------------------------//
// What this function for: fetching all the users details
// when to call this function : call this function after the users logininto the app
// what this function is returning: it will return json file containing firstName, lastName, email address,
//                                  isheLeaderofTheGroup, groupId, all send information if he is the group leader
exports.accessTheFieldInformationOfTheUsers = functions.https.onRequest(async (data, res) => {
  const userId = data.body.userId;
  let isLeader = false;
  let getGroupId;
  let cameras = [];
  // retriving the list of members via their userID
  const userRef = await admin.firestore().collection("users/")
      .doc(userId)
      .get();
  getGroupId = await userRef.data().groupId;
  console.log(getGroupId);
  // retriving the list of members via their userID
  const groupMembers = await admin.firestore().collection("groups/" + getGroupId + "/cameras");
  const getCameraLocation = await groupMembers.get();
  getCameraLocation.forEach((doc) => {
    let tempLocation = {
      camId: doc.id,
      location: doc.data().location,
    };
    cameras.push(tempLocation);
  });
  const accessAllinformations = await admin.firestore()
      .collection("users")
      .doc(userId)
      .get();
  const information = accessAllinformations.data();
  const getgroupId = await accessAllinformations.data().groupId;
  console.log(getgroupId);
  const getGroup = await admin.firestore()
      .collection("groups")
      .doc(getgroupId)
      .get();

  const getLeaderUid = getGroup.data().leader;
  const groupName = getGroup.data().name;
  if (userId == getLeaderUid) {
    // eslint-disable-next-line no-const-assign
    isLeader =true;
  }
  const result = {
    information,
    camera: cameras,
    groupName: groupName,
    leader: isLeader,
  };
  console.log(result);
  return res.send(JSON.stringify(result));
});


// ------------------------------------------------------ CAMERA SIDE FUNCTION---------
// step 1
// pi needs to be turned before start of group registration
// open camera registration @SL from the sl side
// this function should be call when py start
// pi needs to start at the end after registration of the creating group
exports.cameraRegistration = functions.https.onRequest(async (data, res) => {
  const camera = {
  };
  admin.firestore().collection("cameras").doc(data.body.camId).set(camera);
  const result ={
    result: "camera got registered",
  };
  console.log(result);
  return res.end(JSON.stringify(result));
});


// adding the barcode/macaddress of the cameras step = 2 this sun needs to call
// where to call from ---> call it from anywhere you would like the group leaders to add the cameras
// this function must be call by the group leader
// const data1 = {
//   "groupId": data.body.groupId,
//   "cameraBarcode": data.body.cameraId,
// };
exports.inputCameraIdFromClientSide = functions.https.onRequest(async (data, res) => {
  const groupId = data.body.groupId;
  const camId = data.body.camId;
  console.log(data.body.groupId);
  const value = {
    groupId: data.body.groupId,
    camId: camId,
  };
  const forGroup = {
    location: data.body.location,
  };
  // running the quieres on the whole collection opencameras
  const findCamera = await admin.firestore().collection("cameras").doc(camId).get();
  if (!findCamera.exists) {
    let error = "error: please type the correct macAddress of the camera";
    return res.send(JSON.stringify(error));
  } else {
    await admin.firestore().collection("cameras").doc(data.body.camId).set(value);
    await admin.firestore().collection("groups/" + groupId + "/cameras").doc(`${camId}`).set(forGroup);
  }
  const result ={
    result: "camera got registered from the client side successfully",
  };
  console.log("camera got registered from the client side successfully");
  return res.end(JSON.stringify(result));
});

// ----------------------------------------------------------------------
// function for the camera accessing the camera mac address @SL  step : 3
// this function will be responding to camera request
exports.getBarCodeCameraAndBluetooth = functions.https.onRequest(async (data, res) => {
  const valueCameraId = data.body.camId;
  const endTime = data.body.endTime;
  console.log(valueCameraId);
  let result = 1;
  // Create a reference to the cities collection
  // const membersOftheGroup = [];
  const valueUsersMacMap = new Map();
  let groupId;
  const usersList = [];
  // reading from the camera Id from the camera collection to fetch the group id
  const findCamera = await admin.firestore().collection("cameras")
      .doc(data.body.camId)
      .get();
  if (!findCamera.exists) {
    result = 0;
    return res.send(JSON.stringify(result));
  } else {
    groupId = await findCamera.data().groupId;
  }

  // geting the memebers users UID
  const getMembersUserUid = await admin.firestore().collection("groups/")
      .doc(groupId)
      .get();
  // getting members list
  const value = await getMembersUserUid.data().members;

  // get camera location:
  const getCamera = await admin.firestore().collection("groups/" + groupId + "/cameras")
      .doc(valueCameraId)
      .get();
  // getting members list
  const location = await getCamera.data().location;


  for (let i =0; i<value.length; i++) {
    valueUsersMacMap.set(await value[i]); // storing members uid as a key inside the MAP
  }
  // fetching all the details of that users
  for (let index = 0; index < value.length; index++) {
    if (valueUsersMacMap.has(value[index])) {
    // console.log(value[index]);
      const retrivingSpecificUsersMacAddress = await admin.firestore()
          .collection("users")
          .doc(value[index])
          .get();
      const storeUserDetails = {
        userCount: index,
        userId: value[index],
        firstName: await retrivingSpecificUsersMacAddress.data().firstName,
        lastName: await retrivingSpecificUsersMacAddress.data().LastName,
        photoLink: await retrivingSpecificUsersMacAddress.data().photoLink,
        bluetoothMacAddress: await retrivingSpecificUsersMacAddress.data().macAddress,
      };
      usersList.push(storeUserDetails);
      console.log(usersList);
    }
  }
  // sending all the results back
  const response = {
    result,
    location,
    groupId,
    usersList,
  };
  console.log(response);
  return res.end(JSON.stringify(response));
});


// function for retriving from two dates
// function for the users only and group leaders
exports.retriveUsageDatasForUsers = functions.https.onRequest(async (data, res) => {
  const userId = data.body.userId;
  const fromDate = data.body.fromDate;
  let fromDateFromJson = fromDate.split("/"); // >  [ '10', '10', '2022, 11:59:00 pm' ]
  const toDate = data.body.toDate;
  let toDateFromJson = toDate.split("/");
  let getInMinutes;
  let arrayforDocIds = [];
  let arrayforUsages=[];


  const getUsersUsages = admin.firestore()
      .collection("users")
      .doc(userId)
      .collection(`${data.body.location}`);

  const getDoc = await getUsersUsages.get();
  getDoc.forEach((doc) => {
    console.log(doc.id, "=>", doc.data());
    arrayforDocIds.push(doc.id);
  });
  console.log(arrayforDocIds);
  for (let index = 0; index < arrayforDocIds.length; index++) {
    date = new Date(arrayforDocIds[index]*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"});
    let getCurrrentDateMonth = date.split("/"); // [ '10', '10', '2022, 11:59:00 pm' ]

    // case 1: if the date, month are equal or greater than the
    if (getCurrrentDateMonth[0] >= fromDateFromJson[0] && getCurrrentDateMonth[1] >= fromDateFromJson[1] &&
        getCurrrentDateMonth[0] <= toDateFromJson[0] && getCurrrentDateMonth[1] >= toDateFromJson[1] ) {
    //   arrayforUsages.push(arrayforDocIds[index].data().inMinutes);
      let getSpecificUsersUsages = await admin.firestore()
          .collection("users/" + userId + "/" + data.body.location)
          .doc(arrayforDocIds[index])
          .get();

      let getDocSpecific = await getSpecificUsersUsages.data().inMinutes;
      let getTime = await getSpecificUsersUsages.data().endTime;
      const getEverything = {
        "Date": new Date(getTime*1000).toLocaleString("en-AU", {timeZone: "Australia/Adelaide"}),
        "UsagesInMinutes": getDocSpecific,
      };
      arrayforUsages.push(getEverything);
      console.log(arrayforUsages);
    }
  }

  // creating map for each days
  console.log(arrayforUsages);
  res.send(JSON.stringify(arrayforUsages));
});

// access shares of the bill from the for everyone
exports.accessTheSharesBillsPercentages = functions.https.onRequest(async (data, res) => {
  let leaderUid;
  let getGroupId;
  let isLeader = false;
  let membersArray = [];
  let userId = data.body.userId;
  let memberList = [];
  // retriving the list of members via their userID
  const userRef = await admin.firestore().collection("users/")
      .doc(userId)
      .get();
  getGroupId = await userRef.data().groupId;
  console.log(getGroupId);
  // retriving the list of members via their userID
  const groupMembers = await admin.firestore().collection("groups/")
      .doc(getGroupId)
      .get();
  const membersList = await groupMembers.data().members;
  leaderUid = await groupMembers.data().leader;

  if (leaderUid == userId) {
    isLeader = true;
    // getting all the shares of the users
    for (let index = 0; index < membersList.length; index++) {
      let getUsersRef = await admin.firestore().collection("users/" + membersList[index] + "/shares");
      let usersGasData = await getUsersRef.doc("gas").get();
      let usersInternetData = await getUsersRef.doc("internet").get();
      let usersWaterData = await getUsersRef.doc("water").get();
      let usersElectricityData = await getUsersRef.doc("electricity").get();
      let userRefForName = await admin.firestore().collection("users/")
          .doc(membersList[index])
          .get();
      let fullName = await userRefForName.data().firstName + await userRefForName.data().LastName;
      // console.log(usersGasData.data().percentage);
      let users = {
        fullName: fullName,
        gas: usersGasData.data().percentage,
        electricity: usersInternetData.data().percentage,
        water: usersWaterData.data().percentage,
        internet: usersElectricityData.data().percentage,
      };
      memberList.push(users);
    }
  } else {
    console.log("running from members only side");
    let getUsersRef = await admin.firestore().collection("users/" + data.body.userId + "/shares");
    let usersGasData = await getUsersRef.doc("gas").get();
    let usersInternetData = await getUsersRef.doc("internet").get();
    let usersWaterData = await getUsersRef.doc("water").get();
    let usersElectricityData = await getUsersRef.doc("electricity").get();
    let fullName = await userRef.data().firstName + await userRef.data().LastName;
    // console.log(usersGasData.data().percentage);
    let users = {
      fullName: fullName,
      gas: usersGasData.data().percentage,
      electricity: usersInternetData.data().percentage,
      water: usersWaterData.data().percentage,
      internet: usersElectricityData.data().percentage,
    };
    memberList.push(users);
  }
  const details={
    memberList: memberList,
  };
  console.log(details);
  return res.end(JSON.stringify(details));
});


// -------------------------------------------------------------------------------------//
// -------------------------------------------------------------------------------------//
// What this function for:  updating the access for certain services
// when to call this function : call this function from the leader side when he wants to updated the access of the service for the certain member of the group
// what this function is returning: just json file telling that result has been updated successfully
exports.updatingAccessForCertainMembers = functions.https.onRequest(async (data, res) => {
  const groupId = data.body.groupId;
  const userId = data.body.userId;
  const updateAccess = data.body.service;
  console.log(updateAccess.toString());
  const boolValue= data.body.boolValue;
  if (updateAccess.match("accessForElectricity")) {
    admin.firestore()
        .collection("groups/" + groupId +"/"+userId)
        .doc("details")
        .update({
          "accessForElectricity": boolValue,
        });

    await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("notificationMessages")
        .doc("allMessages")
        .update({
          messages: admin.firestore.FieldValue.arrayUnion("Your access for the electricty has been" + boolValue),
        });
  }
  if (updateAccess.match("accessForGas")) {
    admin.firestore()
        .collection("groups/" + groupId +"/"+userId)
        .doc("details")
        .update({
          "accessForGas": boolValue,
        });
    await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("notificationMessages")
        .doc("allMessages")
        .update({
          messages: admin.firestore.FieldValue.arrayUnion("Your access for the gas has been" + boolValue),
        });
  }
  if (updateAccess.match("accessForInternet")) {
    admin.firestore()
        .collection("groups/" + groupId +"/"+userId)
        .doc("details")
        .update({
          "accessForInternet": boolValue,
        });
    await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("notificationMessages")
        .doc("allMessages")
        .update({
          messages: admin.firestore.FieldValue.arrayUnion("Your access for the electricity has been" + boolValue),
        });
  }
  if (updateAccess.match("accessForWater")) {
    admin.firestore()
        .collection("groups/" + groupId +"/"+userId)
        .doc("details")
        .update({
          "accessForWater": boolValue,
        });
    await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("notificationMessages")
        .doc("allMessages")
        .update({
          messages: admin.firestore.FieldValue.arrayUnion("Your access for the water has been" + boolValue),
        });
  }
  // ----------
  // updating the user's database too
  if (updateAccess.match("accessForElectricity")) {
    admin.firestore()
        .collection("users/" + userId +"/accessForServices")
        .doc("details")
        .update({
          "accessForElectricity": boolValue,
        });
  }
  if (updateAccess.match("accessForGas")) {
    admin.firestore()
        .collection("users/" + userId +"/accessForServices")
        .doc("details")
        .update({
          "accessForGas": boolValue,
        });
  }
  if (updateAccess.match("accessForInternet")) {
    admin.firestore()
        .collection("users/" + userId +"/accessForServices")
        .doc("details")
        .update({
          "accessForInternet": boolValue,
        });
  }
  if (updateAccess.match("accessForWater")) {
    admin.firestore()
        .collection("users/" + userId +"/accessForServices")
        .doc("details")
        .update({
          "accessForWater": boolValue,
        });
  }


  // retrieving new data
  const getUpdatedResultRef = admin.firestore()
      .collection("groups/" + groupId +"/"+userId)
      .doc("details")
      .get();
  const getUpdatedResult = (await getUpdatedResultRef).data();

  const result ={
    getUpdatedResult,
  };
  return res.end(JSON.stringify(result));
});

