import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/models/my_data.dart';
import 'package:shopping_list/providers/my_data_provider.dart';

class EditDataScreen extends StatefulWidget {
  final MyData data;

  const EditDataScreen({super.key, required this.data});

  @override
  State<EditDataScreen> createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  // Глобальный ключ и контроллеры для работы с полями формы
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _imageController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Очищаем контроллеры когда они не нужны, чтобы не занимать лищнюю память
  @override
  void dispose() {
    _textController.dispose();
    _imageController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2035),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'title': _textController.text.trim(),
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'imageUrl': _imageController.text.trim(),
        'state': 0
      };
      Provider.of<MyDataProvider>(context, listen: false).editData(
        Provider.of<MyDataProvider>(context, listen: false).getEditingData.id!,
        data
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedDate = Provider.of<MyDataProvider>(context, listen: false).getEditingData.date;
    _textController.text = Provider.of<MyDataProvider>(context, listen: false).getEditingData.title;
    _imageController.text = Provider.of<MyDataProvider>(context, listen: false).getEditingData.imageUrl;
    _dateController.text = DateFormat('yyyy-MM-dd').format(Provider.of<MyDataProvider>(context, listen: false).getEditingData.date);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменить данные'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Напишите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL Изображения',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Вставьте URL изображения';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Дата',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Выберете дату';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}