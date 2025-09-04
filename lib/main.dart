import 'package:flutter/material.dart';
import 'dart:math';

// Main function to run the app
void main() {
  runApp(const VeloraApp());
}

// The root widget of the application
class VeloraApp extends StatelessWidget {
  const VeloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), // A light grey background
        fontFamily: 'Inter',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF), // A vibrant blue
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
        ),
      ),
      home: const OnboardingScreenController(),
    );
  }
}

// --- ONBOARDING FLOW ---

// This widget controls the PageView for the entire onboarding flow
class OnboardingScreenController extends StatefulWidget {
  const OnboardingScreenController({super.key});

  @override
  State<OnboardingScreenController> createState() => _OnboardingScreenControllerState();
}

class _OnboardingScreenControllerState extends State<OnboardingScreenController> {
  final PageController _pageController = PageController();

  void _navigateToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding(String userName) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainScreen(userName: userName)), // Navigate to the new MainScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
        children: [
          SplashScreen(onNext: _navigateToNextPage),
          InfoScreen(onNext: _navigateToNextPage),
          AgeSelectionScreen(onNext: _navigateToNextPage),
          SleepDurationScreen(onNext: _navigateToNextPage),
          SignInScreen(onNext: _completeOnboarding),
        ],
      ),
    );
  }
}


// Screen 1: The Splash / Welcome Screen
class SplashScreen extends StatelessWidget {
  final VoidCallback onNext;
  const SplashScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0056B3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          ..._buildFloatingIcons(context),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    const Text(
                      'Velora',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(flex: 3),
                    ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF007AFF),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Let\'s Get Started',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingIcons(BuildContext context) {
    const icons = [
      Icons.self_improvement, Icons.fitness_center, Icons.book, Icons.pie_chart,
      Icons.water_drop, Icons.bedtime, Icons.lightbulb, Icons.directions_run
    ];
    final random = Random();
    final size = MediaQuery.of(context).size;
    return List.generate(10, (index) {
      final top = random.nextDouble() * size.height;
      final left = random.nextDouble() * size.width;
      final iconSize = 24.0 + random.nextDouble() * 24.0;
      final angle = random.nextDouble() * pi * 2;
      return Positioned(
        top: top, left: left,
        child: Transform.rotate(
          angle: angle,
          child: Icon(icons[index % icons.length], color: Colors.white.withOpacity(0.2), size: iconSize),
        ),
      );
    });
  }
}

// Screen 2: The Info Screen with Illustration
class InfoScreen extends StatelessWidget {
  final VoidCallback onNext;
  const InfoScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.network('https://i.imgur.com/caEX3t2.png', height: 250,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      height: 250, width: 250,
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                      child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey[400]),
                    ),
              ),
              const SizedBox(height: 48),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.3, fontFamily: 'Inter'),
                  children: [
                    const TextSpan(text: 'Dream big, start small\n'),
                    TextSpan(text: 'act now!', style: TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Set goals, track progress, and stay motivated with daily reminders and insightful progress reports.',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                child: const Text('Continue'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text('Have an account? Sign In', style: TextStyle(color: Colors.black54, fontSize: 16)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen 3: Age Selection Screen
class AgeSelectionScreen extends StatefulWidget {
  final VoidCallback onNext;
  const AgeSelectionScreen({super.key, required this.onNext});

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  String? _selectedAgeRange;
  final List<String> _ageRanges = ['Under 18', '18-24', '25-34', '35-44', '45 and above', 'Prefer not to answer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text('Tell us about you!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 24),
              const Text('😊', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _ageRanges.length,
                  itemBuilder: (context, index) {
                    final range = _ageRanges[index];
                    bool isSelected = _selectedAgeRange == range;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAgeRange = range),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        margin: const EdgeInsets.only(bottom: 12.0),
                        decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF007AFF).withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? const Color(0xFF007AFF) : Colors.grey.shade300, width: 1.5)
                        ),
                        child: Text(
                          range,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFF007AFF) : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _selectedAgeRange != null ? widget.onNext : null,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                child: const Text('Next'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen 4: Sleep Duration Screen
class SleepDurationScreen extends StatefulWidget {
  final VoidCallback onNext;
  const SleepDurationScreen({super.key, required this.onNext});

  @override
  State<SleepDurationScreen> createState() => _SleepDurationScreenState();
}

class _SleepDurationScreenState extends State<SleepDurationScreen> {
  String? _selectedDuration;
  final List<String> _durations = ['less than 6 hours', '6-8 hours', '8-10 hours', 'more than 10 hours'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text('How long do you usually sleep at night', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 24),
              const Text('😴', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _durations.length,
                  itemBuilder: (context, index) {
                    final duration = _durations[index];
                    bool isSelected = _selectedDuration == duration;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDuration = duration),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        margin: const EdgeInsets.only(bottom: 12.0),
                        decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF007AFF).withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? const Color(0xFF007AFF) : Colors.grey.shade300, width: 1.5)
                        ),
                        child: Text(
                          duration,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFF007AFF) : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _selectedDuration != null ? widget.onNext : null,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                child: const Text('Next'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen 5: Sign In Screen
class SignInScreen extends StatefulWidget {
  final void Function(String) onNext;
  const SignInScreen({super.key, required this.onNext});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const Text('Thank you\nfor your answers ✨', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Transform your app experience with our comprehensive personalization features.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 32),
              Text('Let\'s get started!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              const SizedBox(height: 32),
              _buildTextField("Email", "es_jake.carker@gmail.com", controller: _emailController),
              const SizedBox(height: 16),
              _buildTextField("Password", "********", obscureText: true),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  String email = _emailController.text;
                  String name = 'rajat'; // Default name

                  if (email.isNotEmpty) {
                    name = email.split('@').first;
                    name = name.replaceAll(RegExp(r'[._]'), ' ');
                    name = name.split(' ').map((word) {
                      if (word.isEmpty) return '';
                      return word[0].toUpperCase() + word.substring(1);
                    }).join(' ');
                  }
                  widget.onNext(name);
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                child: const Text('SIGN IN'),
              ),
              const SizedBox(height: 24),
              const Text('or sign in with', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.g_mobiledata),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.facebook),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.add), // Placeholder for Twitter/X
                ],
              ),
              const Spacer(flex: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(onPressed: (){}, child: Text('SIGN UP', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)))
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool obscureText = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
        filled: true, fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return CircleAvatar(radius: 24, backgroundColor: Colors.grey[200], child: Icon(icon, color: Colors.black));
  }
}

// --- MAIN APP SCREENS WRAPPER ---
class MainScreen extends StatefulWidget {
  final String userName;
  const MainScreen({super.key, this.userName = 'rajat'});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userName: widget.userName),
      const ProgressScreen(),
      const BadgesScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HabitIdeasScreen()));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        shape: const CircleBorder(),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavItem(icon: Icons.home, index: 0, label: 'Home'),
            _buildBottomNavItem(icon: Icons.bar_chart, index: 1, label: 'Progress'),
            const SizedBox(width: 48), // The central gap for the FAB
            _buildBottomNavItem(icon: Icons.emoji_events, index: 2, label: 'Badges'),
            _buildBottomNavItem(icon: Icons.settings, index: 3, label: 'Settings'),
          ],
        ),
      ),
    );
  }
  Widget _buildBottomNavItem({required IconData icon, required int index, required String label}) {
    return IconButton(
      icon: Icon(icon, color: _currentIndex == index ? Theme.of(context).primaryColor : Colors.grey),
      onPressed: () => setState(() => _currentIndex = index),
      tooltip: label,
    );
  }
}


// Home Screen (Dashboard)
class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Monday is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildWeekCalendar(),
            _buildTodaysHabits(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF3A3A3A),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome back', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text(widget.userName, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Keep pushing yourself!', style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          const LinearProgressIndicator(
            value: 0.25,
            backgroundColor: Colors.white30,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 5),
          const Text('1/4 tasks complete', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dates = ['26', '27', '28', '29', '30', '31', '1'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          bool isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
              ),
              child: Column(
                children: [
                  Text(days[index], style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(dates[index], style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTodaysHabits() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Today\'s habits', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildHabitCard('Learn a new language', '3/5 Sessions', Icons.language, Colors.orange, 0.6),
          _buildHabitCard('Read books', 'Start Now', Icons.book, Colors.blue, 0),
          _buildHabitCard('Meditation', 'Start Now', Icons.self_improvement, Colors.purple, 0),
          _buildHabitCard('Exercise', 'Completed', Icons.fitness_center, Colors.green, 1.0),
        ],
      ),
    );
  }

  Widget _buildHabitCard(String title, String subtitle, IconData icon, Color color, double progress) {
    return GestureDetector(
      onTap: (){
        if(progress < 1.0) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => HabitTimerScreen(habitTitle: title)));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  if (progress > 0 && progress < 1) ...[
                    const SizedBox(height: 5),
                    LinearProgressIndicator(value: progress, color: color, backgroundColor: color.withOpacity(0.2)),
                  ]
                ],
              ),
            ),
            if (progress == 1.0)
              const Icon(Icons.check_circle, color: Colors.green)
            else
              const Icon(Icons.more_vert, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}

// Habit Ideas Screen
class HabitIdeasScreen extends StatelessWidget {
  const HabitIdeasScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Ideas for you'),
        backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildHabitIdea(context, 'Read books', Icons.book),
                  _buildHabitIdea(context, 'Meditation', Icons.self_improvement),
                  _buildHabitIdea(context, 'Exercise', Icons.fitness_center),
                  _buildHabitIdea(context, 'Take a walk', Icons.directions_walk),
                  _buildHabitIdea(context, 'Drink water', Icons.water_drop),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateHabitScreen())),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('+ Create custom habit'),
            ),
            const SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }

  Widget _buildHabitIdea(BuildContext context, String title, IconData icon){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200)
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}


// Create Custom Habit Screen
class CreateHabitScreen extends StatelessWidget {
  const CreateHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your custom habit'),
        backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'e.g. Learn a new language', labelText: 'Write the name of your habit',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildOptionRow(Icons.add_reaction_outlined, 'Add Icon', '🎨'),
                  _buildOptionRow(Icons.palette_outlined, 'Add Color', '🟢'),
                  _buildOptionRow(Icons.date_range_outlined, 'Start date', '26 March 2024 >'),
                  _buildOptionRow(Icons.date_range_outlined, 'End date', '06 April 2024 >'),
                  _buildOptionRow(Icons.timer_outlined, 'Duration', '30 minutes >'),
                  _buildOptionRow(Icons.repeat, 'Count', '1 per day >'),
                  _buildOptionRow(Icons.notifications_outlined, 'Reminders', '7:00 am >'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Add'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]), const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16)), const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

// --- NEW SCREENS ---

// Habit Timer Screen
class HabitTimerScreen extends StatelessWidget {
  final String habitTitle;
  const HabitTimerScreen({super.key, required this.habitTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habitTitle),
        backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            // Placeholder for hourglass image
            Image.network('https://i.imgur.com/8Q5R42G.png', height: 150),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]
              ),
              child: const Column(
                children: [
                  Text('Minutes', style: TextStyle(color: Colors.grey)),
                  Text('15:35/30', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  Text('14:25 Minutes Left', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
                "Success Is the Sum of Small Efforts Repeated Daily. Keep Pushing Forward!",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.delete_outline), onPressed: (){}, iconSize: 30, color: Colors.grey),
                const SizedBox(width: 20),
                IconButton(icon: const Icon(Icons.pause_circle_outline), onPressed: (){}, iconSize: 40, color: Colors.grey),
                const SizedBox(width: 20),
                IconButton(icon: const Icon(Icons.refresh), onPressed: (){}, iconSize: 30, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CompletionScreen()));
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Completion Screen
class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF007AFF),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, const Color(0xFF0056B3)],
              begin: Alignment.topCenter, end: Alignment.bottomCenter
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Text('Well done!', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 30),
                Image.network('https://i.imgur.com/xpFFDAn.png', height: 200),
                const SizedBox(height: 30),
                const Text('You have completed your first goal!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, color: Colors.white)),
                const SizedBox(height: 10),
                const Text('You are making great progress in building new habits. You\'re on the right track.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white70)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(), // Go back to the previous screen (home)
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Theme.of(context).primaryColor),
                  child: const Text('Continue'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Progress Screen
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Progress', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,
          bottom: const TabBar(
            tabs: [Tab(text: 'Weekly'), Tab(text: 'Monthly'), Tab(text: 'Yearly')],
            labelColor: Colors.black, unselectedLabelColor: Colors.grey,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: 200, // Placeholder for chart
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Text('Chart Placeholder')),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('4', 'On Progress'),
                  _buildStatCard('1', 'Completed'),
                  _buildStatCard('6', 'All Habits'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// Badges Screen
class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  void _showCongratsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Congrats!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield, color: Colors.orange, size: 50),
              SizedBox(height: 10),
              Text('You have completed your first goal!'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            bool earned = index == 0;
            String label = '${pow(5, index)} Goal${index > 0 ? 's' : ''}';
            if (index == 0) label = '1 Goal';
            if (index == 1) label = '5 Goals';
            if (index > 1) label = '${10 * (index-1)} Goals';


            return GestureDetector(
                onTap: () {
                  if(earned) _showCongratsDialog(context);
                },
                child: _Badge(earned: earned, label: label)
            );
          },
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final bool earned;
  final String label;
  const _Badge({required this.earned, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.shield, size: 60, color: earned ? Colors.orange : Colors.grey[300]),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: earned ? Colors.black : Colors.grey)),
      ],
    );
  }
}


// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _buildSettingsTile(Icons.person_outline, 'Personal Info', (){}),
          _buildSettingsTile(Icons.notifications_none, 'Notifications', (){}),
          _buildSettingsTile(Icons.lock_outline, 'Privacy & Security', (){}),
          const SizedBox(height: 30),
          const Text('Support & About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _buildSettingsTile(Icons.help_outline, 'Help & Support', (){}),
          _buildSettingsTile(Icons.feedback_outlined, 'Give us Feedback', (){}),
          _buildSettingsTile(Icons.info_outline, 'About', (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
          }),
          const SizedBox(height: 30),
          const Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _buildSettingsTile(Icons.logout, 'Log out', (){}, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[700]),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}


// About Screen
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Velora'),
        backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(size: 80),
              SizedBox(height: 20),
              Text('Velora', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 40),
              Text('Built by raj577', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

