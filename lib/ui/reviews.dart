import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService{
  getLatestReview(String gender){
    return Firestore.instance
        .collection('mahasiswa')
        .where('gender', isEqualTo: gender)
        .getDocuments();
        
  }
}