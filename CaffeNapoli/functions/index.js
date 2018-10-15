const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
//
// logging = require('@google-cloud/logging')();

admin.initializeApp(functions.config().firebase);

//
// var stripe = require("stripe")(
//   "sk_test_cIWwl0OhiU8S4oQu3IpLUm1N"
// );
//
// Stripe.setPublishableKey('sk_test_cIWwl0OhiU8S4oQu3IpLUm1N');



// const stripe = require('stripe')(functions.config().stripe.token),
//       currency = functions.config().stripe.currency || 'USD';
//
// [START chargecustomer]
// Charge the Stripe customer whenever an amount is written to the Realtime database
// exports.createStripeCharge = functions.database.ref('/stripe_customers/{userId}/charges/{id}').onWrite(event => {
//   const val = event.data.val();
//   // This onWrite will trigger whenever anything is written to the path, so
//   // noop if the charge was deleted, errored out, or the Stripe API returned a result (id exists)
//   if (val === null || val.id || val.error) return null;
//   // Look up the Stripe customer id written in createStripeCustomer
//   return admin.database().ref(`/stripe_customers/${event.params.userId}/customer_id`).once('value').then(snapshot => {
//     return snapshot.val();
//   }).then(customer => {
//     // Create a charge using the pushId as the idempotency key, protecting against double charges
//     const amount = val.amount;
//     const idempotency_key = event.params.id;
//     let charge = {amount, currency, customer};
//     if (val.source !== null) charge.source = val.source;
//     return stripe.charges.create(charge, {idempotency_key});
//   }).then(response => {
//       // If the result is successful, write it back to the database
//       return event.data.adminRef.set(response);
//     }, error => {
//       // We want to capture errors and render them in a user-friendly way, while
//       // still logging an exception with Stackdriver
//       return event.data.adminRef.child('error').set(userFacingMessage(error)).then(() => {
//         return reportError(error, {user: event.params.userId});
//       });
//     }
//   );
// });
// [END chargecustomer]]
// When a user is created, register them with Stripe
// exports.createStripeCustomer = functions.auth.user().onCreate(event => {
//   const data = event.data;
//   return stripe.customers.create({
//     email: data.email
//   }).then(customer => {
//     return admin.database().ref(`/stripe_customers/${data.uid}/customer_id`).set(customer.id);
//   });
// });
//
// Add a payment source (card) for a user by writing a stripe payment source token to Realtime database
// exports.addPaymentSource = functions.database.ref('/stripe_customers/{userId}/sources/{pushId}/token').onWrite(event => {
//   const source = event.data.val();
//   if (source === null) return null;
//   return admin.database().ref(`/stripe_customers/${event.params.userId}/customer_id`).once('value').then(snapshot => {
//     return snapshot.val();
//   }).then(customer => {
//     return stripe.customers.createSource(customer, {source});
//   }).then(response => {
//       return event.data.adminRef.parent.set(response);
//     }, error => {
//       return event.data.adminRef.parent.child('error').set(userFacingMessage(error)).then(() => {
//         return reportError(error, {user: event.params.userId});
//       });
//   });
// });
//
// When a user deletes their account, clean up after them
// exports.cleanupUser = functions.auth.user().onDelete(event => {
//   return admin.database().ref(`/stripe_customers/${event.data.uid}`).once('value').then(snapshot => {
//     return snapshot.val();
//   }).then(customer => {
//     return stripe.customers.del(customer.customer_id);
//   }).then(() => {
//     return admin.database().ref(`/stripe_customers/${event.data.uid}`).remove();
//   });
// });

//
// To keep on top of errors, we should raise a verbose error report with Stackdriver rather
// than simply relying on console.error. This will calculate users affected + send you email
// alerts, if you've opted into receiving them.
// [START reporterror]

// firebase deploy --only functions



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

  var uid = 'I9iTrgGY5igIYE4L22wzLNbHlOl1';

  return admin.database().ref('/users/' + uid).once('value', snapshot => {
    var user = snapshot.val();
    console.log("User username: " + user.username + " fcmToken: " + user.fcmToken);

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
  //
  stripe.fcmToken = "pk_test_10iie7Xp98twCbxCC0njHt8L"
  Stripe.setPublishableKey('sk_test_cIWwl0OhiU8S4oQu3IpLUm1N');

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
