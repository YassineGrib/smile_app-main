class AppConstants {
  // App Information
  static const String appName = 'SmileAPP';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A nursery designed especially for health heroes. Because your comfort matters to us.';
  
  // Nursery Information
  static const String nurseryName = 'SmileAPP';
  static const String nurseryPhone = '+213 555 123 456';
  static const String nurseryEmail = 'info@smilenursery.dz';
  static const String nurseryAddress = 'Algiers, Algeria';
  static const String nurseryCCP = '1234567890';
  
  // Working Hours
  static const String morningShift = '08:00 - 12:00';
  static const String eveningShift = '13:00 - 17:00';
  static const String fullDay = '08:00 - 17:00';
  
  // Pricing (in DZD)
  static const int basicPlanPrice = 6000;
  static const int premiumPlanPrice = 10000;
  static const String currency = 'DA';
  
  // Plan Features
  static const List<String> basicPlanFeatures = [
    'SmileAPP',
    'Lunch meal',
    'Light activities',
    'Basic supervision',
  ];
  
  static const List<String> premiumPlanFeatures = [
    'SmileAPP',
    '3 daily meals',
    'Educational activities',
    'Daily photos sent to parents',
    'Enhanced supervision',
    'Health monitoring',
  ];
  
  // Time Periods
  static const List<Map<String, dynamic>> timePeriods = [
    {
      'id': 'morning',
      'name': 'Morning Period',
      'time': morningShift,
      'description': 'Perfect for working parents',
    },
    {
      'id': 'evening',
      'name': 'Evening Period', 
      'time': eveningShift,
      'description': 'Afternoon care and activities',
    },
    {
      'id': 'full_day',
      'name': 'Full Day',
      'time': fullDay,
      'description': 'Complete day care (higher price)',
    },
  ];
  
  // Health Conditions
  static const List<String> healthConditions = [
    'No health issues',
    'Allergies',
    'Breathing problems',
    'Special medical condition',
    'Dietary restrictions',
    'Other',
  ];
  
  // Appointment Types
  static const List<Map<String, dynamic>> appointmentTypes = [
    {
      'id': 'visit',
      'name': 'Nursery Visit',
      'description': 'Tour the facilities and meet our staff',
      'duration': 30,
    },
    {
      'id': 'admin',
      'name': 'Administrative Meeting',
      'description': 'Discuss enrollment and policies',
      'duration': 45,
    },
    {
      'id': 'consultation',
      'name': 'Child Consultation',
      'description': 'Discuss your child\'s specific needs',
      'duration': 60,
    },
  ];
  
  // Working Days (Monday to Friday)
  static const List<int> workingDays = [1, 2, 3, 4, 5]; // 1 = Monday, 5 = Friday
  
  // Working Hours for Appointments
  static const int appointmentStartHour = 8;
  static const int appointmentEndHour = 17;
  static const int appointmentSlotDuration = 30; // minutes
  
  // File Upload Limits
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // Validation
  static const int minChildAge = 0; // months
  static const int maxChildAge = 72; // months (6 years)
  static const int phoneNumberLength = 10;
  
  // Chat
  static const String adminChatId = 'admin_001';
  static const String adminName = 'SmileAPP Admin';
  static const String welcomeChatMessage = 'Welcome! You can contact us directly here, and we will respond within minutes.';
  
  // Storage Keys
  static const String keyUserData = 'user_data';
  static const String keyChildData = 'child_data';
  static const String keyRegistrationData = 'registration_data';
  static const String keyChatMessages = 'chat_messages';
  static const String keyAppointments = 'appointments';
  
  // API Endpoints (for future backend integration)
  static const String baseUrl = 'https://api.smilenursery.dz';
  static const String registerEndpoint = '/api/register';
  static const String chatEndpoint = '/api/chat';
  static const String appointmentEndpoint = '/api/appointments';
  
  // Error Messages
  static const String errorGeneral = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorValidation = 'Please check your input and try again.';
  static const String errorFileUpload = 'Failed to upload file. Please try again.';
  
  // Success Messages
  static const String successRegistration = 'Registration submitted successfully! We will confirm within 24 hours via email.';
  static const String successAppointment = 'Appointment booked successfully! We will contact you to confirm attendance.';
  static const String successMessageSent = 'Message sent successfully!';
  
  // Regex Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9]{10}$';
  static const String namePattern = r'^[a-zA-Z\s]+$';
}

// Enums
enum RegistrationStep {
  welcome,
  childInfo,
  parentInfo,
  planSelection,
  payment,
  confirmation,
}

enum TimePeriod {
  morning,
  evening,
  fullDay,
}

enum PlanType {
  basic,
  premium,
}

enum PaymentMethod {
  ccp,
  baridiMob,
}

enum AppointmentStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

enum MessageType {
  text,
  image,
  document,
}

enum UserType {
  parent,
  admin,
}
