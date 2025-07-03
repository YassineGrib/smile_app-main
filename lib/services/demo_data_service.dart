import 'dart:math';
import '../models/event_model.dart';

class DemoDataService {
  static final Random _random = Random();

  // Algerian names
  static const List<String> _algerianFirstNames = [
    'Ahmed', 'Mohamed', 'Ali', 'Omar', 'Youssef', 'Karim', 'Amine', 'Bilal',
    'Fatima', 'Aicha', 'Khadija', 'Amina', 'Yasmine', 'Salma', 'Nour', 'Lina',
    'Rania', 'Sara', 'Meriem', 'Asma', 'Houda', 'Nesrine', 'Imane', 'Widad'
  ];

  static const List<String> _algerianLastNames = [
    'Benali', 'Benaissa', 'Boumediene', 'Cherif', 'Djelloul', 'Ferhat',
    'Ghali', 'Hamidi', 'Kaci', 'Larbi', 'Mansouri', 'Naceri', 'Ouali',
    'Rahmani', 'Saidi', 'Tebboune', 'Yahiaoui', 'Zeroual', 'Belkacem',
    'Mokrani', 'Slimani', 'Brahimi', 'Meziane', 'Boudjelal'
  ];

  // Algerian cities and addresses
  static const List<String> _algerianCities = [
    'Algiers', 'Oran', 'Constantine', 'Annaba', 'Blida', 'Batna', 'Djelfa',
    'Sétif', 'Sidi Bel Abbès', 'Biskra', 'Tébessa', 'El Oued', 'Skikda',
    'Tiaret', 'Béjaïa', 'Tlemcen', 'Ouargla', 'Mostaganem', 'Bordj Bou Arréridj',
    'Chlef', 'Médéa', 'Tizi Ouzou', 'Béchar', 'Boumerdès'
  ];

  static const List<String> _algerianStreets = [
    'Rue Didouche Mourad', 'Avenue de l\'Indépendance', 'Rue Larbi Ben M\'hidi',
    'Boulevard Mohamed V', 'Rue Hassiba Ben Bouali', 'Avenue Souidani Boudjemaa',
    'Rue Colonel Amirouche', 'Boulevard Frantz Fanon', 'Rue Abane Ramdane',
    'Avenue Ahmed Ghermoul', 'Rue Krim Belkacem', 'Boulevard Zighout Youcef',
    'Rue Mohamed Belouizdad', 'Avenue Pasteur', 'Rue Ben Badis'
  ];

  // Child names (more child-friendly)
  static const List<String> _childNames = [
    'Yacine', 'Rayan', 'Adam', 'Ayoub', 'Samy', 'Ilyes', 'Wassim', 'Rayane',
    'Lina', 'Malak', 'Nour', 'Aya', 'Inès', 'Yasmine', 'Amira', 'Selma',
    'Rima', 'Dina', 'Jana', 'Nada', 'Leen', 'Maya', 'Tala', 'Sama'
  ];

  // Health conditions in Arabic/French context
  static const List<String> _healthConditions = [
    'No health issues',
    'Food allergies (nuts, dairy)',
    'Seasonal allergies',
    'Mild asthma',
    'Lactose intolerance',
    'Other: Sensitive skin'
  ];

  // Email domains commonly used in Algeria
  static const List<String> _emailDomains = [
    'gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'live.com'
  ];

  static final List<Event> _events = [
    Event(
      id: 'event-1',
      title: 'Summer Fun Fair',
      description: 'Join us for a day of fun, games, and food! A great opportunity for kids and parents to socialize and enjoy the summer weather.',
      date: DateTime.now().add(const Duration(days: 10)),
      location: 'Nursery Playground',
      imagePath: 'assets/images/1.jpg',
    ),
    Event(
      id: 'event-2',
      title: 'Parents Workshop',
      description: 'A workshop for parents on early childhood development. Learn about key milestones and how to support your child\'s growth.',
      date: DateTime.now().add(const Duration(days: 25)),
      location: 'Main Hall',
      imagePath: 'assets/images/2.jpg',
    ),
    Event(
      id: 'event-3',
      title: 'Art & Craft Day',
      description: 'Let your child\'s creativity shine! A full day dedicated to painting, drawing, and crafting masterpieces.',
      date: DateTime.now().add(const Duration(days: 40)),
      location: 'Activity Room',
      imagePath: 'assets/images/3.jpg',
    ),
  ];

  /// Generate demo data for child information
  static Map<String, dynamic> generateChildInfo() {
    final childName = _childNames[_random.nextInt(_childNames.length)];
    final lastName = _algerianLastNames[_random.nextInt(_algerianLastNames.length)];
    final fullName = '$childName $lastName';
    
    // Generate birth date (6 months to 5 years old)
    final now = DateTime.now();
    final minAge = 6; // months
    final maxAge = 60; // months (5 years)
    final ageInMonths = minAge + _random.nextInt(maxAge - minAge);
    final birthDate = DateTime(
      now.year,
      now.month - ageInMonths,
      1 + _random.nextInt(28),
    );

    final gender = _random.nextBool() ? 'male' : 'female';
    final city = _algerianCities[_random.nextInt(_algerianCities.length)];
    final street = _algerianStreets[_random.nextInt(_algerianStreets.length)];
    final streetNumber = 1 + _random.nextInt(200);
    final address = '$streetNumber $street, $city, Algeria';

    // Randomly select health conditions (80% chance of no issues)
    List<String> healthConditions = [];
    if (_random.nextDouble() < 0.8) {
      healthConditions = ['No health issues'];
    } else {
      // 20% chance of having some health condition
      final condition = _healthConditions[1 + _random.nextInt(_healthConditions.length - 1)];
      healthConditions = [condition];
    }

    final notes = _random.nextBool() 
        ? '' 
        : 'Very active child, loves playing with other children. Prefers outdoor activities.';

    return {
      'fullName': fullName,
      'birthDate': birthDate,
      'gender': gender,
      'address': address,
      'healthConditions': healthConditions,
      'notes': notes,
    };
  }

  /// Generate demo data for parent information
  static Map<String, dynamic> generateParentData() {
    final firstName = _algerianFirstNames[_random.nextInt(_algerianFirstNames.length)];
    final lastName = _algerianLastNames[_random.nextInt(_algerianLastNames.length)];
    final fullName = '$firstName $lastName';

    // Generate Algerian phone number (starts with 05, 06, or 07)
    final phonePrefix = ['05', '06', '07'][_random.nextInt(3)];
    final phoneNumber = '$phonePrefix${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}';

    // Generate email
    final emailName = firstName.toLowerCase();
    final emailDomain = _emailDomains[_random.nextInt(_emailDomains.length)];
    final email = '$emailName.${lastName.toLowerCase()}@$emailDomain';

    // Generate address
    final city = _algerianCities[_random.nextInt(_algerianCities.length)];
    final street = _algerianStreets[_random.nextInt(_algerianStreets.length)];
    final streetNumber = 1 + _random.nextInt(200);
    final address = '$streetNumber $street, $city, Algeria';

    // Random time period
    final timePeriods = ['morning', 'evening', 'full_day'];
    final timePeriod = timePeriods[_random.nextInt(timePeriods.length)];

    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'timePeriod': timePeriod,
    };
  }

  /// Generate demo data for plan selection
  static Map<String, dynamic> generatePlanData() {
    // 70% chance of selecting premium plan (more realistic for demo)
    final selectedPlan = _random.nextDouble() < 0.7 ? 'premium' : 'basic';
    
    return {
      'selectedPlan': selectedPlan,
    };
  }

  /// Generate demo data for payment information
  static Map<String, dynamic> generatePaymentData() {
    // Use only the methods available in the UI
    final paymentMethods = ['ccp', 'baridimob'];
    final paymentMethod = paymentMethods[_random.nextInt(paymentMethods.length)];
    final accountNumber = paymentMethod == 'ccp' ? '0012345678' : '0551234567';
    final accountHolder = 'Demo User';
    return {
      'paymentMethod': paymentMethod,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
    };
  }

  /// Generate complete demo registration data
  static Map<String, dynamic> generateCompleteRegistrationData() {
    return {
      'child': generateChildInfo(),
      'parent': generateParentData(),
      'plan': generatePlanData(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Get a list of predefined demo scenarios
  static List<Map<String, dynamic>> getPredefinedScenarios() {
    return [
      {
        'name': 'Family Benali - Premium Plan',
        'child': {
          'fullName': 'Yacine Benali',
          'birthDate': DateTime(2021, 3, 15),
          'gender': 'male',
          'address': '25 Rue Didouche Mourad, Algiers, Algeria',
          'healthConditions': ['No health issues'],
          'notes': 'Very energetic child, loves drawing and playing with blocks.',
        },
        'parent': {
          'fullName': 'Ahmed Benali',
          'phoneNumber': '0661234567',
          'email': 'ahmed.benali@gmail.com',
          'address': '25 Rue Didouche Mourad, Algiers, Algeria',
          'timePeriod': 'full_day',
        },
        'plan': {
          'selectedPlan': 'premium',
        },
      },
      {
        'name': 'Family Mansouri - Basic Plan',
        'child': {
          'fullName': 'Lina Mansouri',
          'birthDate': DateTime(2020, 8, 22),
          'gender': 'female',
          'address': '12 Avenue de l\'Indépendance, Oran, Algeria',
          'healthConditions': ['Food allergies (nuts, dairy)'],
          'notes': 'Allergic to nuts and dairy products. Very social and loves singing.',
        },
        'parent': {
          'fullName': 'Fatima Mansouri',
          'phoneNumber': '0551987654',
          'email': 'fatima.mansouri@yahoo.com',
          'address': '12 Avenue de l\'Indépendance, Oran, Algeria',
          'timePeriod': 'morning',
        },
        'plan': {
          'selectedPlan': 'basic',
        },
      },
      {
        'name': 'Family Cherif - Premium Plan',
        'child': {
          'fullName': 'Rayan Cherif',
          'birthDate': DateTime(2022, 1, 10),
          'gender': 'male',
          'address': '8 Boulevard Mohamed V, Constantine, Algeria',
          'healthConditions': ['Mild asthma'],
          'notes': 'Has mild asthma, inhaler available if needed. Loves books and puzzles.',
        },
        'parent': {
          'fullName': 'Omar Cherif',
          'phoneNumber': '0771234567',
          'email': 'omar.cherif@hotmail.com',
          'address': '8 Boulevard Mohamed V, Constantine, Algeria',
          'timePeriod': 'evening',
        },
        'plan': {
          'selectedPlan': 'premium',
        },
      },
    ];
  }

  /// Get random demo scenario from predefined list
  static Map<String, dynamic> getRandomPredefinedScenario() {
    final scenarios = getPredefinedScenarios();
    return scenarios[_random.nextInt(scenarios.length)];
  }

  static List<Event> getEvents() {
    return _events;
  }

  static String get agetitle => 'age';

  static String get childNametitle => 'child-name';
}
