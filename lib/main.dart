import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Edit these values to update the content shown on the page.
const name = 'Jefin Jacob';
const headline = 'Mechanical Engineer | Control Systems | Robotics';
const introduction =
    'I work across control systems, robotics, and embedded technology, '
    'turning engineering ideas into practical projects.';
const about =
    'I’m a mechanical engineer interested in control systems, robotics, and '
    'embedded prototyping. My work includes motor control, ROS 2 development '
    'on Jetson platforms, and nonlinear system modelling. My current research '
    'focuses on beam dynamics, compliant mechanisms, and smart materials.';

const skills = [
  'Mechanical design and prototyping',
  'PID, MPC, and nonlinear control',
  'Robotics and ROS 2',
  'Arduino, ESP32, and embedded systems',
  'MATLAB, Simulink, APDL, and Abaqus',
];

const projects = [
  PortfolioItem(
    'Genetic algorithm routing',
    'Genetic algorithm experiments for routing and scheduling problems.',
  ),
  PortfolioItem(
    'Nonlinear beam dynamics',
    'Modelling cantilever beam vibration and large deflections.',
  ),
  PortfolioItem(
    'ROS 2 camera drivers',
    'Camera driver experiments with NVIDIA Jetson and FLIR thermal cameras.',
  ),
  PortfolioItem(
    'Encoder-based motor control',
    'RPM feedback and PID control using an encoder and Arduino.',
  ),
  PortfolioItem(
    'Compliant mechanisms',
    '3D-printed mechanisms for actuation and motion studies.',
  ),
];

const notes = [
  PortfolioItem(
    'Getting started with ROS 2 on Jetson',
    'Notes on setting up ROS 2 Humble on Jetson Orin Nano and AGX.',
  ),
  PortfolioItem(
    'Frequency detection in Simulink',
    'Building a real-time frequency detector with zero-crossing blocks.',
  ),
  PortfolioItem(
    'Encoder-based motor control',
    'PID tuning notes for DC motors with Arduino and encoder feedback.',
  ),
];

const backgroundColor = Color(0xFF101311);
const cardColor = Color(0xFF1A201B);
const accentColor = Color(0xFFC5F36A);
const secondaryTextColor = Color(0xFFB4BDB5);

void main() {
  runApp(const PortfolioApp());
}

class PortfolioItem {
  const PortfolioItem(this.title, this.description);

  final String title;
  final String description;
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$name | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: const ColorScheme.dark(
          primary: accentColor,
          surface: cardColor,
        ),
        useMaterial3: true,
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _sectionKeys = {
    'Home': GlobalKey(),
    'About': GlobalKey(),
    'Projects': GlobalKey(),
    'Notes': GlobalKey(),
  };

  Future<void> _scrollTo(String section) async {
    final target = _sectionKeys[section]?.currentContext;
    if (target == null) return;

    await Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _openGithub() async {
    final opened = await launchUrl(Uri.parse('https://github.com/Jefin-J'));
    if (!opened && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open GitHub.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildHero(),
              _buildSkills(),
              _buildItemsSection('Projects', projects),
              _buildAbout(),
              _buildItemsSection('Notes', notes),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content({required Widget child}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      key: _sectionKeys['Home'],
      child: _content(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 12,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 8,
                children: ['Home', 'About', 'Projects', 'Notes']
                    .map(
                      (section) => TextButton(
                        onPressed: () => _scrollTo(section),
                        child: Text(section),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return _content(
      child: Padding(
        padding: const EdgeInsets.only(top: 56, bottom: 76),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MECHANICAL ENGINEER · RESEARCHER',
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Hi, I’m $name.',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                height: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              headline,
              style: const TextStyle(color: accentColor, fontSize: 19),
            ),
            const SizedBox(height: 18),
            Text(
              introduction,
              style: const TextStyle(
                color: secondaryTextColor,
                fontSize: 16,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _openGithub,
              icon: const Icon(Icons.open_in_new),
              label: const Text('GitHub'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkills() {
    return _content(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('What I do'),
            ...skills.map(
              (skill) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  ', style: TextStyle(color: accentColor)),
                    Expanded(
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(String title, List<PortfolioItem> items) {
    return Container(
      key: _sectionKeys[title],
      child: _content(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(title),
              ...items.map(
                (item) => Card(
                  color: cardColor,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        item.description,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbout() {
    return Container(
      key: _sectionKeys['About'],
      child: _content(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('About me'),
              Text(
                about,
                style: const TextStyle(color: secondaryTextColor, height: 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return _content(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: const Text(
          '© 2026 Jefin Jacob',
          style: TextStyle(color: secondaryTextColor, fontSize: 12),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
