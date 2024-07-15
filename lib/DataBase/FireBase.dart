// // ignore_for_file: file_names

// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../Model/names_model.dart';

// class FireBase {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//   Future<List<NameModel>> getData() async {
//     List<NameModel> list = [];
//     try {
//       QuerySnapshot snapshot =
//           await _firebaseFirestore.collection('Names').get();
//       list = snapshot.docs.map((obj) {
//         return NameModel.fromMap(obj.data());
//       }).toList();
//     } catch (e) {
//       print(e.toString());
//     }
//     return list;
//   }
// }
