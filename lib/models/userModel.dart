import 'package:cloud_firestore/cloud_firestore.dart';

class userModel {
  final String? userName;
  final String? bio;
  final String? userID;
  final String? email;
  final String? photoUrl;

  userModel({
    this.userName,
    this.bio,
    this.userID,
    this.email,
    this.photoUrl,
  });

  factory userModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return userModel(
      userName: data?['userName'],
      bio: data?['bio'],
      userID: data?['userID'],
      email: data?['email'],
      photoUrl: data?['photoUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userName != null) "userName": userName,
      if (bio != null) "bio": bio,
      if (userID != null) "userID": userID,
      if (email != null) "email": email,
      if (photoUrl != null) "photoUrl": photoUrl,
    };
  }
}
