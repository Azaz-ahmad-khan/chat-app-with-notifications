const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendMessageNotification = functions.firestore
    .document("chats/{chatRoomId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
        const messageData = snapshot.data();

        if (!messageData) {
            console.log("No message data found");
            return null;
        }

        const senderId = messageData.userId;
        const messageText = messageData.message;
        const chatRoomId = context.params.chatRoomId;

        console.log("New message from:", senderId);
        console.log("Message:", messageText);

        const userIds = chatRoomId.split("-");
        const receiverId = userIds.find((id) => id !== senderId);

        if (!receiverId) {
            console.log("Could not determine receiver");
            return null;
        }

        const senderDoc = await admin
            .firestore()
            .collection("Users")
            .doc(senderId)
            .get();

        if (!senderDoc.exists) {
            console.log("Sender document not found");
            return null;
        }

        const senderName = senderDoc.data().name;

        const receiverDoc = await admin
            .firestore()
            .collection("Users")
            .doc(receiverId)
            .get();

        if (!receiverDoc.exists) {
            console.log("Receiver document not found");
            return null;
        }

        const receiverToken = receiverDoc.data().fcmToken;

        if (!receiverToken || receiverToken === "") {
            console.log("Receiver has no FCM token");
            return null;
        }

        const payload = {
            notification: {
                title: senderName,
                body: messageText,
            },
            data: {
                senderId: senderId,
                senderName: senderName,
                receiverId: receiverId,
                screen: "chat",
            },
            token: receiverToken,
        };

        try {
            const response = await admin.messaging().send(payload);
            console.log("Notification sent successfully:", response);
            return response;
        } catch (error) {
            console.log("Error sending notification:", error);
            return null;
        }
    });