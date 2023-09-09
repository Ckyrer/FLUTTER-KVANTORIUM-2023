import 'package:flutter/material.dart';
import 'package:shopping_list/models/my_data.dart';
import 'package:shopping_list/widgets/edit_data_form.dart';

class DataDetailsScreen extends StatelessWidget {
    final MyData data;
  
    const DataDetailsScreen({Key? key, required this.data}) : super(key: key);

    // ! (PRACTIC) Изменить данные
    void _changeData(BuildContext context, MyData data) {
      showDialog(
        context: context,
        builder: (_) => const SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          title: Text("Изменение данных"),
          contentPadding: EdgeInsets.all(25),
          children: <Widget>[
            // EditDataForm()
          ],
        ),
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
                    onPressed: () => _changeData(context, data),
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