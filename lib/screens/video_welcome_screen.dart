import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../services/demo_data_service.dart';

class VideoWelcomeScreen extends StatefulWidget {
  const VideoWelcomeScreen({super.key});

  @override
  State<VideoWelcomeScreen> createState() => _VideoWelcomeScreenState();
}

class _VideoWelcomeScreenState extends State<VideoWelcomeScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isVideoInitialized = false;
  final bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeAnimations();
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/videos/welcom.mp4');

      await _videoController.initialize();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });

        // Configure video settings
        _videoController.setLooping(true);
        _videoController.setVolume(0.5); // Set volume to 50%

        // Start playing
        await _videoController.play();

        print('Video initialized and playing successfully');
      }
    } catch (error) {
      print('Error initializing video: $error');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
        });
      }
    }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _toggleVideoPlayback() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      if (_videoController.value.volume > 0) {
        _videoController.setVolume(0.0);
      } else {
        _videoController.setVolume(0.3);
      }
    });
  }

  void _showDemoScenarios() {
    final scenarios = DemoDataService.getPredefinedScenarios();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppBorderRadius.xl),
            topRight: Radius.circular(AppBorderRadius.xl),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTheme.textLightColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_fix_high,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Demo Registration Scenarios',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Scenarios List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: scenarios.length,
                itemBuilder: (context, index) {
                  final scenario = scenarios[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        scenario['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Child: ${scenario['child']['fullName']}'),
                          Text('Parent: ${scenario['parent']['fullName']}'),
                          Text('Plan: ${scenario['plan']['selectedPlan'] == 'premium' ? 'Premium' : 'Basic'}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to registration with this scenario
                        // For now, just go to child info
                        context.go('/registration/child-info');
                      },
                    ),
                  );
                },
              ),
            ),

            // Random Demo Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/registration/child-info');
                  },
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Start with Random Demo Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Loading indicator while video is initializing
          if (!_isVideoInitialized)
            Container(
              color: AppTheme.primaryColor,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading video...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Video Background
          if (_isVideoInitialized && _videoController.value.isInitialized)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Transform.scale(
                  scale: 1.0,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

          // Fallback gradient background if video fails to load
          if (!_isVideoInitialized || !_videoController.value.isInitialized)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryLightColor,
                    AppTheme.primaryColor,
                    AppTheme.primaryDarkColor,
                  ],
                ),
              ),
            ),

          // Dark overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),

          // Magic Button (top left)
          Positioned(
            top: 50,
            left: 20,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(AppBorderRadius.round),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.secondaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _showDemoScenarios,
                  icon: const Icon(
                    Icons.auto_fix_high,
                    color: Colors.white,
                    size: 24,
                  ),
                  tooltip: 'Demo Scenarios',
                ),
              ),
            ),
          ),

          // Admin Access (top right)
          if (_isVideoInitialized)
            Positioned(
              top: 50,
              right: 20,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppBorderRadius.round),
                  ),
                  child: IconButton(
                    onPressed: () => context.go('/admin/login'),
                    icon: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 20,
                    ),
                    tooltip: 'Admin Access',
                  ),
                ),
              ),
            ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hidden Logo and Title Section (commented out)
                        // FadeTransition(
                        //   opacity: _fadeAnimation,
                        //   child: SlideTransition(
                        //     position: _slideAnimation,
                        //     child: Column(
                        //       children: [
                        //         // Logo Container with enhanced styling
                        //         Container(
                        //           width: 140,
                        //           height: 140,
                        //           decoration: BoxDecoration(
                        //             color: Colors.white.withOpacity(0.95),
                        //             borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: Colors.black.withOpacity(0.3),
                        //                 blurRadius: 25,
                        //                 offset: const Offset(0, 15),
                        //               ),
                        //             ],
                        //           ),
                        //           child: const Icon(
                        //             Icons.child_care,
                        //             size: 70,
                        //             color: AppTheme.primaryColor,
                        //           ),
                        //         ),
                        //         const SizedBox(height: AppSpacing.xl),
                        //
                        //         // App Name with shadow
                        //         Text(
                        //           AppConstants.nurseryName,
                        //           style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             shadows: [
                        //               Shadow(
                        //                 color: Colors.black.withOpacity(0.7),
                        //                 offset: const Offset(2, 2),
                        //                 blurRadius: 8,
                        //               ),
                        //             ],
                        //           ),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //         const SizedBox(height: AppSpacing.sm),
                        //
                        //         // Subtitle with shadow
                        //         Text(
                        //           'Nursery Care & Education',
                        //           style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        //             color: Colors.white.withOpacity(0.9),
                        //             shadows: [
                        //               Shadow(
                        //                 color: Colors.black.withOpacity(0.5),
                        //                 offset: const Offset(1, 1),
                        //                 blurRadius: 4,
                        //               ),
                        //             ],
                        //           ),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //
                        // const SizedBox(height: AppSpacing.xxl),
                        //
                        // // Hidden Motivational Text with enhanced styling
                        // FadeTransition(
                        //   opacity: _fadeAnimation,
                        //   child: SlideTransition(
                        //     position: _slideAnimation,
                        //     child: Container(
                        //       padding: const EdgeInsets.all(AppSpacing.xl),
                        //       decoration: BoxDecoration(
                        //         color: Colors.white.withOpacity(0.95),
                        //         borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.black.withOpacity(0.2),
                        //             blurRadius: 20,
                        //             offset: const Offset(0, 10),
                        //           ),
                        //         ],
                        //       ),
                        //       child: Column(
                        //         children: [
                        //           Icon(
                        //             Icons.favorite,
                        //             color: AppTheme.secondaryColor,
                        //             size: 40,
                        //           ),
                        //           const SizedBox(height: AppSpacing.md),
                        //           Text(
                        //             AppConstants.appDescription,
                        //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        //               color: AppTheme.textPrimaryColor,
                        //               height: 1.6,
                        //               fontWeight: FontWeight.w500,
                        //             ),
                        //             textAlign: TextAlign.center,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  
                  // Action Buttons
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Main CTA Button
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/registration/child-info');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.app_registration, size: 28),
                                  const SizedBox(width: AppSpacing.md),
                                  Text(
                                    'Start Registration',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Secondary Actions
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      context.go('/chat');
                                    },
                                    icon: const Icon(Icons.chat_bubble_outline, size: 22),
                                    label: const Text('Chat'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppTheme.primaryColor,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: AppTheme.textLightColor.withOpacity(0.5),
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      context.go('/events');
                                    },
                                    icon: const Icon(Icons.event, size: 22),
                                    label: const Text('Events'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppTheme.primaryColor,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: AppTheme.textLightColor.withOpacity(0.5),
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      context.go('/book-visit');
                                    },
                                    icon: const Icon(Icons.calendar_today, size: 22),
                                    label: const Text('Book Visit'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppTheme.primaryColor,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
