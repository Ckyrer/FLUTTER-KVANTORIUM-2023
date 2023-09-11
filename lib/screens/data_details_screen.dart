import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/models/my_data.dart';
import 'package:shopping_list/providers/my_data_provider.dart';
import 'package:shopping_list/screens/edit_data_screen.dart';

class DataDetailsScreen extends StatelessWidget {
    final MyData data;
  
    const DataDetailsScreen({Key? key, required this.data}) : super(key: key);

    // ! (PRACTIC) Изменить данные
    void _changeData(BuildContext context, MyData data) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditDataScreen(data: data,))
      );
    }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Подробно о товаре'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(data.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    data.date.toString(),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  // ! (PRACTIC) Кнопка для изменения данных
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<MyDataProvider>(context, listen: false).setEditingData(data);
                      _changeData(context, data);
                    },
                    child: const Text("Изменить")
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }