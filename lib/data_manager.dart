import 'package:flutter/material.dart';
import 'dart:math';

// --- ENHANCED MODELS ---

class RequestModel {
  final String id;
  final String title;
  final String date;
  final DateTime rawDate; // For sorting
  final String status; // Pending, Approved, Completed, Cancelled
  final String providerName;
  final String providerImage;
  final String requirements;
  final double price;

  RequestModel({
    required this.id,
    required this.title,
    required this.date,
    required this.rawDate,
    required this.status,
    required this.providerName,
    required this.providerImage,
    required this.requirements,
    this.price = 0.0,
  });

  // Helper to get color based on status for the UI
  Color get statusColor {
    switch (status) {
      case 'Approved': return Colors.green;
      case 'Pending': return Colors.orange;
      case 'Completed': return const Color(0xFF2E3192);
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}

class ProfessionalModel {
  final String name;
  final String role;
  final String rating;
  final String experience;
  final String imageUrl;
  final String bio;
  final double hourlyRate;
  final bool isVerified;

  ProfessionalModel({
    required this.name,
    required this.role,
    required this.rating,
    required this.experience,
    required this.imageUrl,
    required this.bio,
    required this.hourlyRate,
    this.isVerified = true,
  });
}

// --- GLOBAL DATA MANAGER ---

class DataManager {
  // Store user bookings here
  static List<Map<String, String>> userBookings = [];
  static final Random _random = Random();

  static void addBooking(Map<String, String> booking) {
    userBookings.add(booking);
  }

  // --- REALISTIC DATA GENERATORS ---

  // Curated Names for a "Real" feel
  static final List<String> _names = [
    "Dr. Sarah Ahmed", "Nurse Fatima", "Ayesha Khan", "Dr. Bilal Hussein", 
    "Maria Garcia", "Sadia Malik", "Dr. John Smith", "Zainab Bibi", 
    "Hira Mani", "Dr. Ali Raza", "Sana Mir", "Yasir Shah"
  ];

  static final List<String> _titles = [
    "Babysitting Service", "Elderly Care Visit", "Physiotherapy Session", 
    "General Checkup", "Post-Op Nursing", "Infant Care (Night)", 
    "Emergency Consultation"
  ];

  static final List<String> _bios = [
    "Certified specialist with a focus on pediatric care and early childhood development. Compassionate and patient.",
    "Over 10 years of experience in ICU and emergency care. Highly skilled in managing critical patients at home.",
    "Friendly and energetic nanny who loves engaging kids in educational activities and arts & crafts.",
    "Specialized in geriatric care, ensuring your elderly loved ones receive the dignity and medical attention they deserve.",
    "Gold medalist pediatrician with a gentle approach to treating children of all ages."
  ];

  static List<RequestModel> getRequests(int count) {
    List<String> statuses = ['Pending', 'Approved', 'Completed', 'Cancelled'];
    
    return List.generate(count, (index) {
      DateTime date = DateTime.now().add(Duration(days: index * 2, hours: _random.nextInt(12)));
      String status = statuses[index % statuses.length];
      
      return RequestModel(
        id: "#REQ-${1000 + index}",
        title: _titles[index % _titles.length],
        rawDate: date,
        date: "${_getMonth(date.month)} ${date.day}, ${date.year} • ${date.hour > 12 ? date.hour - 12 : date.hour}:00 ${date.hour >= 12 ? 'PM' : 'AM'}",
        status: status,
        providerName: _names[index % _names.length],
        providerImage: 'https://i.pravatar.cc/300?img=${index + 10}',
        price: (1500 + _random.nextInt(3000)).toDouble(),
        requirements: "Requires assistance with strictly timed medication and monitoring vitals. "
            "Please ensure arrival 15 minutes prior to the slot. Location: DHA Phase ${index % 8 + 1}.",
      );
    });
  }

  static List<ProfessionalModel> getProfessionals() {
    return List.generate(20, (index) {
      String role = index % 3 == 0 ? "Doctor" : (index % 3 == 1 ? "Nurse" : "Nanny");
      String name = _names[index % _names.length];
      
      // Ensure unique-ish images
      String imgUrl = 'https://i.pravatar.cc/300?img=${index + 30}'; 

      return ProfessionalModel(
        name: name,
        role: role,
        rating: (4.2 + (_random.nextDouble() * 0.8)).toStringAsFixed(1), // Rating between 4.2 and 5.0
        experience: "${_random.nextInt(15) + 2} Years Exp.",
        imageUrl: imgUrl,
        hourlyRate: role == "Doctor" ? 3500 : (role == "Nurse" ? 2000 : 1200),
        bio: _bios[index % _bios.length],
        isVerified: index % 5 != 0, // Most are verified
      );
    });
  }

  // Helper for Date Formatting
  static String _getMonth(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }
}