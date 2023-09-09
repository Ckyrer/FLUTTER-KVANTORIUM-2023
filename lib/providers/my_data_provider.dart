import 'package:flutter/material.dart';
import 'package:shopping_list/models/my_data.dart';
import 'package:shopping_list/utils/database_helper.dart';

class MyDataProvider extends ChangeNotifier {
    List _dataList = [];
  
    List get dataList => _dataList;
  
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
  }