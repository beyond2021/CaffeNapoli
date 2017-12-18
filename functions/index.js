const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
 exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!LBTA");
 });
 // listen for following events and the trigger a push notifications
 exports.observerFollowing = functions.database.ref('/following/{uid}/{followingId}')
  .onCreate(event => {
    //lets log out some messages
    var uid = event.params.uid;
    var followingId = event.params.followingId;
    console.log('User: ' + uid + 'is following:' + followingId);
    // trying to figure out fcmToken to send a push messages
    return admin.database().ref('/users/' + followingId).once('value', snapshot => {
      var userWeAreFollowing = snapshot.val();

      return admin.database().ref('/users/' + uid).once('value', snapshot => {

        var userDoingTheFollowing = snapshot.val();

        var payload = {
              notification : {
                title: "You now have a new follower",
              body: userDoingTheFollowing.username + ' is now following you'
            },
            data: {
              followerId: uid
            }
        }

        admin.messaging().sendToDevice(userWeAreFollowing.fcmToken, payload)
          .then(response => {
            // See the MessagingDevicesResponse reference documentation for
            // the contents of response.
            console.log("Successfully sent message:", response);
          }).catch(function(error) {
            console.log("Error sending message:", error);
          });
      })

    })

    })


//  })

exports.sendPushNotifications = functions.https.onRequest((request, response) => {

  response.send("Attempting to send push notifications...");

  console.log("Logger --- Trying to send push message...");

  // Admin.message().sendToDevice(token, payload)

  var uid = '5WuxELWlevPKQCdOzwHEurhZWPi2';

  return admin.database().ref('/users/' + uid).once('value', snapshot => {
    var user = snapshot.val();
    console.log("User username:  " + user.username + "fcmToken: " + user.fcmToken)

    var payload = {
          notification : {
            title: "Lunch Rush",
          body: "$32 Lobster Ravioli with red wine today"
        }
    }

    admin.messaging().sendToDevice(user.fcmToken, payload)
      .then(function(response) {
        // See the MessagingDevicesResponse reference documentation for
        // the contents of response.
        console.log("Successfully sent message:", response);
      })
      .catch(function(error) {
        console.log("Error sending message:", error);
      });


  })

  // This registration token comes from the client FCM SDKs.
  // var fcmToken = "c5amfozN0tk:APA91bGk5QVzqtfGy-rJsotuL94nzR6YQmdCb5NFZIt4QFjW8hJhMFkiskzYkfHWriBnHYNdT5v2qzPTJicJFsHDOszc8a2vIxQZIRm1Dt4TjAzJ1IgugBKY3fo0edu2b8-cc8BiVq3T";

  // See the "Defining the message payload" section below for details
  // on how to define a message payload.
  // var payload = {
  //   notification: {
  //     title: "Push notification title HERE",
  //     body: "Body over here is our message body..."
  //   },
  //   data: {
  //     score: "850",
  //     time: "2:45"
  //   }
  // };
  //
  // // Send a message to the device corresponding to the provided
  // // registration token.
  // admin.messaging().sendToDevice(fcmToken, payload)
  //   .then(function(response) {
  //     // See the MessagingDevicesResponse reference documentation for
  //     // the contents of response.
  //     console.log("Successfully sent message:", response);
  //   })
  //   .catch(function(error) {
  //     console.log("Error sending message:", error);
  //   });

});
