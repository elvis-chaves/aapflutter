import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendamento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Map<String, dynamic>> _appointments = [];
  List<TimeOfDay> _availableTimes = [];
  bool _isLoading = false;

  static String basepath = 'http://192.168.15.10:3000/';

  static const List<String> _services = ['Cabelo', 'Barba', 'Sobrancelha', 'Completo'];

  @override
  void initState() {
    super.initState();
    _fetchAvailableTimes();
  }

  Future<void> _fetchAvailableTimes() async {
    final String apiUrl = '${basepath}available-times';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );
      print('GET $apiUrl - Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> times = jsonDecode(response.body);

        setState(() {
          _availableTimes = times.map((time) => _timeOfDayFromString(time)).toList();
        });
      } else {
        throw Exception('Falha ao carregar horários disponíveis');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAppointmentsForDate(DateTime date) async {
    final String apiUrl = '${basepath}appointments?date=${DateFormat('yyyy-MM-dd').format(date)}';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(data);
      return data.map((appointment) => {
        'id': appointment['id'],
        'nome': appointment['nome'],
        'modalidade': appointment['modalidade'],
        'data': DateTime.parse(appointment['data']),
        'horario': _timeOfDayFromString(appointment['horario']),
      }).toList();
    } else {
      throw Exception('Falha ao carregar agendamentos');
    }
  }
  String removeLettersAndSpaces(String input) {
    // Usando expressão regular para substituir todas as letras e espaços por uma string vazia
    return input.replaceAll(RegExp(r'[A-Za-z\s]'), '');

  }
  Future<void> _syncAppointments() async {
    if (_selectedDate != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        var abc = await _fetchAppointmentsForDate(_selectedDate!);

        List<Map<String, dynamic>> fetchedAppointments = await _fetchAppointmentsForDate(_selectedDate!);
        setState(() {
          _appointments = fetchedAppointments;
        });
      } catch (e) {
        print(e.toString());
        _showSnackBar('Falha ao sincronizar agendamentos');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String apiUrl = '${basepath}appointments';
      final payload = jsonEncode({
        'nome': _nameController.text,
        'modalidade': _selectedService,
        'data': _selectedDate?.toIso8601String(),
        'horario': _selectedTime?.format(context),
      });
      print('POST $apiUrl - Payload: $payload');

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: payload,
        );
        print('POST $apiUrl - Status: ${response.statusCode}');
        print('Response: ${response.body}');

        if (response.statusCode == 200) {
          _showSnackBar('Agendamento realizado com sucesso');
          _resetForm();
          _syncAppointments();

          await Future.delayed(const Duration(seconds: 5));

          Navigator.pop(context);
        } else {
          _showSnackBar('Falha ao realizar agendamento');
        }
      } catch (e) {
        print('Erro: $e');
        _showSnackBar('Falha ao realizar agendamento');
      }
    }
  }
  Future<void> _cancelAppointment(int index) async {
    final appointmentId = _appointments[index]['id'];
    final String apiUrl = '${basepath}appointments/$appointmentId';

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _showSnackBar('Agendamento cancelado com sucesso');
      _syncAppointments();
    } else {
      _showSnackBar('Falha ao cancelar agendamento');
    }
  }

  void _resetForm() {
    _nameController.clear();
    setState(() {
      _selectedService = null;
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  TimeOfDay _timeOfDayFromString(String time) {

    final parts = removeLettersAndSpaces(time).split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  List<TimeOfDay> _filterAvailableTimes() {
    if (_selectedDate == null) return _availableTimes;
    final bookedTimes = _appointments.map((appt) => appt['horario']).toSet();
    return _availableTimes.where((time) => !bookedTimes.contains(time)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento',style: TextStyle(fontSize: 20),),
      ),
      body: Container(
        height:800.0,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.only(topLeft:Radius.circular(16) ,topRight:Radius.circular(16)  ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(fontSize: 20,color: Colors.white),
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome',labelStyle: TextStyle(fontSize: 20,color: Colors.white)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.black87,


                  style: TextStyle(fontSize: 20,color: Colors.white),
                  value: _selectedService,
                  decoration: InputDecoration(labelText: 'Modalidade',labelStyle: TextStyle(fontSize: 20,color: Colors.white)),
                  items: _services.map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedService = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma modalidade';
                    }
                    return null;
                  },
                ),
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'Selecione uma data'
                        : 'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',style: TextStyle(fontSize: 20,color: Colors.white),
                  ),
                  trailing: Icon(Icons.calendar_today,color: Colors.white,),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _selectedTime = null; // Reset the selected time when the date changes
                      });
                      _syncAppointments();
                    }
                  },
                ),
                DropdownButtonFormField<TimeOfDay>(
                  dropdownColor: Colors.black87,
                  style:TextStyle(fontSize: 20,color: Colors.white) ,
                  value: _selectedTime,
                  decoration: InputDecoration(labelText: 'Horário',labelStyle: TextStyle(fontSize: 20,color: Colors.white)),
                  items: _filterAvailableTimes().map((time) {
                    return DropdownMenuItem<TimeOfDay>(
                      value: time,
                      child: Text(time.format(context)),
                    );
                  }).toList(),
                  onChanged: (time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  validator: (time) {
                    if (time == null) {
                      return 'Por favor, selecione um horário';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading ? CircularProgressIndicator() : Text('Agendar'),
                ),
                SizedBox(height: 20),
                /*if (_appointments.isNotEmpty) ...[
                  Text('Agendamentos para o dia:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = _appointments[index];
                      return ListTile(
                        title: Text('${appointment['nome']} - ${appointment['modalidade']}'),
                        subtitle: Text(
                          'Horário: ${appointment['horario'].format(context)}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () => _cancelAppointment(index),
                        ),
                      );
                    },
                  ),
                ]*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
