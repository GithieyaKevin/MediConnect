import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({super.key});

  @override
  _MedicationReminderScreenState createState() =>
      _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final List<Medication> _medications = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<bool> _selectedDays = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(Medication medication) async {
    for (int i = 0; i < 7; i++) {
      if (_selectedDays[i]) {
        final now = DateTime.now();
        var scheduledDate = tz.TZDateTime.from(
          DateTime(
            now.year,
            now.month,
            now.day + (i - now.weekday + 7) % 7,
            _selectedTime.hour,
            _selectedTime.minute,
          ),
          tz.local,
        );

        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 7));
        }

        await flutterLocalNotificationsPlugin.zonedSchedule(
          medication.hashCode + i,
          'Medication Reminder',
          'Time to take ${medication.name} (${medication.dosage})',
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'medication_channel',
              'Medication Reminders',
              channelDescription: 'Reminders for taking medications',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addMedication() {
    if (_formKey.currentState!.validate() && _selectedDays.contains(true)) {
      final newMedication = Medication(
        name: _nameController.text,
        dosage: _dosageController.text,
        time: _selectedTime,
        days: _selectedDays,
      );

      setState(() {
        _medications.add(newMedication);
      });

      _scheduleNotification(newMedication);

      _nameController.clear();
      _dosageController.clear();
      setState(() {
        _selectedDays = List.filled(7, false);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication reminder set!')),
      );
    } else if (!_selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
    }
  }

  Future<void> _cancelNotification(Medication medication) async {
    for (int i = 0; i < 7; i++) {
      await flutterLocalNotificationsPlugin.cancel(medication.hashCode + i);
    }
  }

  void _deleteMedication(int index) {
    _cancelNotification(_medications[index]);
    setState(() {
      _medications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Reminder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add New Reminder',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Medication Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter medication name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _dosageController,
                        decoration: const InputDecoration(labelText: 'Dosage (e.g., 1 tablet)'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter dosage';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => _selectTime(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Time'),
                          child: Text(_selectedTime.format(context)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Repeat on:'),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          for (int i = 0; i < 7; i++)
                            FilterChip(
                              label: Text(_getDayName(i)),
                              selected: _selectedDays[i],
                              onSelected: (selected) {
                                setState(() {
                                  _selectedDays[i] = selected;
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addMedication,
                        child: const Text('Add Reminder'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_medications.isNotEmpty)
              const Text(
                'Your Medication Reminders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ..._medications.asMap().entries.map((entry) {
              final index = entry.key;
              final medication = entry.value;
              return Dismissible(
                key: Key(medication.name + index.toString()),
                background: Container(color: Colors.red),
                onDismissed: (direction) => _deleteMedication(index),
                child: MedicationCard(
                  medication: medication,
                  onDelete: () => _deleteMedication(index),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getDayName(int index) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }
}

class Medication {
  final String name;
  final String dosage;
  final TimeOfDay time;
  final List<bool> days;

  Medication({
    required this.name,
    required this.dosage,
    required this.time,
    required this.days,
  });
}

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onDelete;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  medication.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Dosage: ${medication.dosage}'),
            const SizedBox(height: 8),
            Text('Time: ${medication.time.format(context)}'),
            const SizedBox(height: 8),
            Text(
              'Days: ${_getSelectedDays()}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _getSelectedDays() {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDays = <String>[];
    for (int i = 0; i < 7; i++) {
      if (medication.days[i]) {
        selectedDays.add(dayNames[i]);
      }
    }
    return selectedDays.isEmpty ? 'None' : selectedDays.join(', ');
  }
}
