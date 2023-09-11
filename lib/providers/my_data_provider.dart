import 'package:flutter/material.dart';
import 'package:shopping_list/models/my_data.dart';
import 'package:shopping_list/utils/database_helper.dart';

class MyDataProvider extends ChangeNotifier {
    List _dataList = [];
  
    List get dataList => _dataList;

    MyData? _editingData;
    MyData get getEditingData => _editingData!;

    bool getDataCheckState(int id) {
      return _dataList.firstWhere((element) => element.id==id).state==0?false:true;
    }

    void setEditingData(MyData data) { _editingData = data; }
  
    // ! Получить товар из базы данных и обновить список на экране
    void getData([DateTime? selectedDate]) async {
      final dataList = await DatabaseHelper.instance.getData(selectedDate);
      _dataList = dataList;
      notifyListeners();
    }
  
    // ! Добавить товар в базу данных и обновить список на экране
    void addData(MyData data) async {
      final id = await DatabaseHelper.instance.insertData(data);
      final newData = data.copyWith(id: id);
      _dataList.add(newData);
      notifyListeners();
    }

    // ! (PRACTIC) Удалить товар из базы данных и обновить список на экране
    void removeData(MyData data) async {
      await DatabaseHelper.instance.removeData(data.id!);
      _dataList.remove(data);
      notifyListeners();
    }

    // ! (PRACTIC) Изменить данные в базе данных и обновить список на экране
    void editData(int id, Map<String, dynamic> newData) async {
      await DatabaseHelper.instance.editData(id, newData);
      MyData replacingData = MyData(
        id: id,
        title: newData['title'],
        date: DateTime.parse(newData['date']),
        imageUrl: newData['imageUrl'],
        state: newData['state']
      );
      MyData oldData = _dataList.firstWhere((element) => element.id==id);
      int indexOfOldData = _dataList.indexOf(oldData);
      _dataList[indexOfOldData] = replacingData;
      notifyListeners();
    }

    // ! (PRACTIC) Изменить состояние в базе данных
    Future<void> changeDataCheckState(MyData data) async {
      final int newState = _dataList[_dataList.indexOf(data)].state==0?1:0;
      await DatabaseHelper.instance.changeDataCheckState(data.id!, newState);
      _dataList[_dataList.indexOf(data)].state = newState;
      notifyListeners();
    }

  }