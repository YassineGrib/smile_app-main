import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smile_app/services/demo_data_service.dart';
import 'package:smile_app/widgets/event_card.dart';
import '../models/event_model.dart';
import '../utils/app_theme.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Event> events = DemoDataService.getEvents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(event: events[index]);
        },
      ),
    );
  }
} 