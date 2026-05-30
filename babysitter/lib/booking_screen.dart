import 'package:flutter/material.dart';
import 'data_manager.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();

  // State
  int _currentStep = 0;
  String _selectedService = 'Nanny';
  double _urgency = 2; // 1 to 5
  DateTime _selectedDate = DateTime.now();
  final List<String> _selectedChildOptions = [];

  final List<String> _childOptions = ['Infant', 'Toddler', 'Special Needs', 'School Age', 'Twins'];

  // Colors
  final Color _primary = const Color(0xFF2E3192);
  final Color _accent = const Color(0xFFFBBF24);
  final Color _bg = const Color(0xFFF5F7FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text("Book a Service", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: _primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildAnimatedStepper(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: offsetAnimation, child: child),
                );
              },
              child: _buildCurrentStepContent(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // --- ANIMATED STEPPER ---
  Widget _buildAnimatedStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStepNode(0, Icons.person_outline, "Details"),
          _buildStepLine(0),
          _buildStepNode(1, Icons.calendar_today_outlined, "Schedule"),
          _buildStepLine(1),
          _buildStepNode(2, Icons.check_circle_outline, "Confirm"),
        ],
      ),
    );
  }

  Widget _buildStepNode(int index, IconData icon, String label) {
    bool isActive = _currentStep >= index;
    bool isCurrent = _currentStep == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? _primary : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isActive ? _primary.withOpacity(0.4) : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: Border.all(color: isActive ? _primary : Colors.grey.shade300, width: 2),
            ),
            child: Icon(icon, color: isActive ? _accent : Colors.grey, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              color: isActive ? _primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int index) {
    return Expanded(
      child: Container(
        height: 4,
        margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Stack(
            children: [
              Container(color: Colors.grey.shade200),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 500),
                widthFactor: _currentStep > index ? 1.0 : 0.0,
                child: Container(color: _primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- STEP CONTENT MANAGER ---
  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return SingleChildScrollView(key: const ValueKey(0), padding: const EdgeInsets.all(20), child: Form(key: _formKey, child: _buildDetailsStep()));
      case 1:
        return SingleChildScrollView(key: const ValueKey(1), padding: const EdgeInsets.all(20), child: _buildScheduleStep());
      case 2:
        return SingleChildScrollView(key: const ValueKey(2), padding: const EdgeInsets.all(20), child: _buildConfirmStep());
      default:
        return const SizedBox.shrink();
    }
  }

  // --- STEP 1: DETAILS ---
  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Who are we booking for?"),
        const SizedBox(height: 15),
        _buildModernField("Your Full Name", Icons.person_rounded, _nameController),
        _buildModernField("Email Address", Icons.alternate_email_rounded, _emailController),
        _buildModernField("WhatsApp Number", Icons.phone_android_rounded, _whatsappController, isPhone: true),
        _buildModernField("Home Address", Icons.location_city, _addressController, maxLines: 2),

        const SizedBox(height: 25),
        _sectionHeader("Child Information"),
        const Text("Select all that apply:", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _childOptions.map((option) {
            bool isSelected = _selectedChildOptions.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  isSelected ? _selectedChildOptions.remove(option) : _selectedChildOptions.add(option);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? _primary : Colors.grey.shade300),
                  boxShadow: isSelected
                      ? [BoxShadow(color: _primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                      : [],
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 25),
        _sectionHeader("Service Type"),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedService,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: _primary),
              items: ['Nanny', 'Nurse', 'Doctor Consultation', 'Elderly Care']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedService = v!),
            ),
          ),
        ),
      ],
    );
  }

  // --- STEP 2: SCHEDULE ---
  Widget _buildScheduleStep() {
    Color sliderColor = Color.lerp(Colors.green, Colors.red, (_urgency - 1) / 4)!;
    String urgencyLabel = _urgency == 1 ? "Flexible" : (_urgency == 5 ? "EMERGENCY" : "Standard");

    return Column(
      children: [
        _sectionHeader("Select Date"),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: _primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 5))],
          ),
          child: CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateChanged: (date) => setState(() => _selectedDate = date),
          ),
        ),
        const SizedBox(height: 30),
        _sectionHeader("Urgency Level"),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Level:", style: TextStyle(fontWeight: FontWeight.bold)),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sliderColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      urgencyLabel,
                      style: TextStyle(color: sliderColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _urgency,
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: sliderColor,
                inactiveColor: Colors.grey.shade200,
                onChanged: (v) => setState(() => _urgency = v),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Low", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text("High", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- STEP 3: CONFIRM ---
  Widget _buildConfirmStep() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: _primary.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long_rounded, size: 50, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text("Review Request", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("Please verify details before submitting", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),
              const Divider(),
              _reviewRow("Full Name", _nameController.text),
              _reviewRow("Service", _selectedService),
              _reviewRow("Urgency", _urgency == 5 ? "Emergency" : "Standard"),
              _reviewRow("Date", "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
              _reviewRow("Contact", _whatsappController.text),
              const Divider(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                  const SizedBox(width: 5),
                  Text("Status: PENDING APPROVAL",
                      style: TextStyle(fontSize: 14, color: Colors.orange[800], fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- HELPERS ---
  Widget _sectionHeader(String title) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primary));
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildModernField(String label, IconData icon, TextEditingController controller,
      {bool isPhone = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          style: const TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: _primary.withOpacity(0.7)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          validator: (v) => v!.isEmpty ? "Required" : null,
        ),
      ),
    );
  }

  // --- BUTTONS ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: TextButton(
                onPressed: () => setState(() => _currentStep--),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  foregroundColor: Colors.grey,
                ),
                child: const Text("Back"),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep == 0) {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _currentStep++);
                  }
                } else if (_currentStep == 1) {
                  setState(() => _currentStep++);
                } else {
                  // Calls the function properly now
                  _submitBooking();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 5,
                shadowColor: _primary.withOpacity(0.4),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_currentStep == 2 ? "Confirm Booking" : "Next Step",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Icon(_currentStep == 2 ? Icons.check_circle : Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- THE FIX: BEAUTIFUL DIALOG + NO CRASH ---
  void _submitBooking() {
    // 1. Save data
    DataManager.addBooking({
      "service": _selectedService,
      "date": "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
      "price": "PKR 2500",
      "status": "Pending",
    });

    // 2. Show Beautiful Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent, // Transparent to show custom shape
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Main Card
            Container(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Success!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E3192))),
                  const SizedBox(height: 10),
                  Text(
                    "Your request for $_selectedService has been placed successfully.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FF),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.message, color: Colors.green),
                        SizedBox(width: 10),
                        Expanded(child: Text("We will contact you on WhatsApp shortly.", style: TextStyle(fontSize: 13))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. Close Dialog
                        Navigator.pop(context); 
                        
                        // 2. DO NOT close app, instead Reset Form
                        setState(() {
                          _currentStep = 0;
                          _nameController.clear();
                          _emailController.clear();
                          _whatsappController.clear();
                          _addressController.clear();
                          _selectedChildOptions.clear();
                          _urgency = 2; 
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3192),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Done", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            
            // Floating Top Icon
            Positioned(
              top: -40,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E3192), Color(0xFF4A4EBA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF2E3192).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 10))
                  ]
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}