import 'package:flutter/foundation.dart';
import 'package:flutter_assignment/model/task_model.dart';
import 'package:flutter_assignment/services/firebase_service.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseServices _firebaseService = FirebaseServices();
  List<TaskModel> data = [];

  Future<List<TaskModel>> fetchData() async {
    final List<Map<String, dynamic>> rawData = await _firebaseService.getData();
    data = rawData.map((map) => TaskModel.fromJson(map)).toList();
    notifyListeners();
    return data;
  }

  Future<void> addData(Map<String, dynamic> newData) async {
    await _firebaseService.addData(newData);
    await fetchData();
  }
}
