import 'package:cni/pages/panel/clients/manage_doc/payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../../../Services/auth_services.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;

  final TextEditingController _officeController = TextEditingController(); // Office input controller

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );
    _controller!.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _officeController.dispose(); // Dispose of the controller
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
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

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // Correct format
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(formattedTime); // Correct format
  }

  Future<void> _submitBooking() async {
    final authService = Provider.of<Authservices>(context, listen: false);
    final userId = 1; // Replace with actual user ID

    try {
      await authService.bookAppointment(
        date: _selectedDate,
        time: _formatTime(_selectedTime),
        userId: userId,
        office: _officeController.text, // Pass the office value
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Appointment booked for ${_formatDate(_selectedDate)} at ${_formatTime(_selectedTime)}."),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MakePaymentPage()),
        );
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation!,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select a Date for National ID Booking",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _selectedDate,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () => _selectTime(context),
                child: Text("Select Time: ${_formatTime(_selectedTime)}"),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _officeController,
                decoration: const InputDecoration(labelText: 'Office'), // Office input field
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  child: Text(
                    "Book for ${_formatDate(_selectedDate)}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Please ensure that you select a valid date, time, and office for booking your national ID card.",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
