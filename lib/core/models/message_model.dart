class MessageModel {
  final String message;
  final String userId;
  final DateTime sendingTime;

  MessageModel({
    required this.message,
    required this.userId,
    required this.sendingTime,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'],
      userId: map['userId'],
      sendingTime: map['sendingTime'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'message': message, 'userId': userId, 'sendingTime': sendingTime};
  }
}
