import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _background = Color(0xFF101311);
const _surface = Color(0xFF171B18);
const _surfaceRaised = Color(0xFF1D231F);
const _accent = Color(0xFFC5F36A);
const _muted = Color(0xFF9BA49D);
const _line = Color(0xFF2C342E);

void main() {
  runApp(const JefinPortfolio());
}

class JefinPortfolio extends StatelessWidget {
  const JefinPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jefin Jacob — Mechanical Engineer & Researcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _background,
        colorScheme: const ColorScheme.dark(
          primary: _accent,
          surface: _surface,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: _accent,
          selectionColor: Color(0x66C5F36A),
          selectionHandleColor: _accent,
        ),
        useMaterial3: true,
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _sectionKeys = <String, GlobalKey>{
    'Home': GlobalKey(),
    'About': GlobalKey(),
    'Projects': GlobalKey(),
    'Notes': GlobalKey(),
    'Contact': GlobalKey(),
  };
  String _activeSection = 'Home';

  Future<void> _scrollTo(String section) async {
    final sectionContext = _sectionKeys[section]?.currentContext;
    if (sectionContext == null) return;
    await Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
      alignment: section == 'Home' ? 0 : 0.04,
    );
    if (mounted) setState(() => _activeSection = section);
  }

  Future<void> _openLink(String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: '_blank',
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildNavigation(),
              _buildHero(),
              _buildExpertise(),
              _buildProjects(),
              _buildAbout(),
              _buildNotes(),
              _buildContact(),
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
        constraints: const BoxConstraints(maxWidth: 1120),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: child,
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      key: _sectionKeys['Home'],
      child: _content(
        child: Padding(
          padding: const EdgeInsets.only(top: 26, bottom: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 620;
              return Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 18,
                children: [
                  GestureDetector(
                    onTap: () => _scrollTo('Home'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Monogram(),
                        SizedBox(width: 11),
                        Text(
                          'JEFIN JACOB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: compact ? 15 : 25,
                    runSpacing: 4,
                    children: ['Home', 'About', 'Projects', 'Notes', 'Contact']
                        .map(
                          (label) => _NavLink(
                            label: label,
                            selected: _activeSection == label,
                            onTap: () => _scrollTo(label),
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return _content(
      child: Padding(
        padding: const EdgeInsets.only(top: 74, bottom: 104),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 760;
            final intro = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Eyebrow(label: 'MECHANICAL ENGINEER · RESEARCHER'),
                const SizedBox(height: 27),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Building at the\n'),
                      TextSpan(
                        text: 'intersection ',
                        style: TextStyle(color: _accent),
                      ),
                      TextSpan(text: 'of\nmachines & ideas.'),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 56,
                    height: 1.12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -2.3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'I work across control systems, robotics, and embedded '
                  'technology — turning complex engineering into things '
                  'that move, measure, and make sense.',
                  style: TextStyle(
                    color: _muted,
                    height: 1.8,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 31),
                Wrap(
                  spacing: 13,
                  runSpacing: 12,
                  children: [
                    _ActionButton(
                      label: 'Explore my work',
                      icon: Icons.arrow_downward_rounded,
                      onTap: () => _scrollTo('Projects'),
                    ),
                    _ActionButton(
                      label: 'GitHub',
                      icon: Icons.open_in_new_rounded,
                      outlined: true,
                      onTap: () => _openLink('https://github.com/Jefin-J'),
                    ),
                  ],
                ),
              ],
            );
            const visual = _HeroVisual();
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, const SizedBox(height: 50), visual],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: intro),
                const SizedBox(width: 56),
                const Expanded(flex: 5, child: visual),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpertise() {
    const areas = [
      _ExpertiseData(
        number: '01',
        icon: Icons.settings_suggest_outlined,
        title: 'Mechanical design',
        description: 'System dynamics, prototyping & compliant mechanisms',
      ),
      _ExpertiseData(
        number: '02',
        icon: Icons.multiline_chart_rounded,
        title: 'Control systems',
        description: 'PID, MPC, nonlinear dynamics & system modelling',
      ),
      _ExpertiseData(
        number: '03',
        icon: Icons.precision_manufacturing_outlined,
        title: 'Robotics & ROS',
        description: 'ROS 2, Jetson, Raspberry Pi & machine vision',
      ),
      _ExpertiseData(
        number: '04',
        icon: Icons.memory_rounded,
        title: 'Embedded systems',
        description: 'Arduino, ESP32, sensors, encoders & motor drivers',
      ),
    ];
    return _content(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 108),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Eyebrow(label: 'WHAT I DO'),
            const SizedBox(height: 15),
            const Text(
              'Engineering, end to end.',
              style: _sectionHeading,
            ),
            const SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth > 800
                    ? 4
                    : constraints.maxWidth > 520
                        ? 2
                        : 1;
                final gap = 14.0;
                final cardWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: areas
                      .map(
                        (area) => SizedBox(
                          width: cardWidth,
                          child: _ExpertiseCard(data: area),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjects() {
    const projects = [
      _ProjectData(
        number: '01',
        title: 'Genetic algorithm routing',
        category: 'OPTIMIZATION',
        description:
            'Exploring genetic algorithms for practical routing and '
            'scheduling problems.',
        icon: Icons.hub_outlined,
        tags: ['Genetic algorithms', 'Scheduling'],
      ),
      _ProjectData(
        number: '02',
        title: 'Nonlinear beam dynamics',
        category: 'RESEARCH',
        description:
            'Modelling cantilever beam vibration with large deflections '
            'and smart-material actuation.',
        icon: Icons.waves_rounded,
        tags: ['Dynamics', 'MFC unimorphs'],
      ),
      _ProjectData(
        number: '03',
        title: 'ROS 2 thermal vision',
        category: 'ROBOTICS',
        description:
            'Camera driver experiments and Jetson integration for FLIR '
            'thermal imaging.',
        icon: Icons.thermostat_auto_rounded,
        tags: ['ROS 2', 'Jetson', 'FLIR'],
      ),
      _ProjectData(
        number: '04',
        title: 'Compliant mechanisms',
        category: 'PROTOTYPING',
        description:
            'Designing and 3D-printing compliant mechanisms for actuation '
            'and motion studies.',
        icon: Icons.view_in_ar_outlined,
        tags: ['3D printing', 'Mechanisms'],
      ),
      _ProjectData(
        number: '05',
        title: 'Encoder motor control',
        category: 'EMBEDDED',
        description:
            'Building an RPM feedback loop with encoder sensing and '
            'Arduino-based PID control.',
        icon: Icons.speed_rounded,
        tags: ['PID', 'Arduino', 'Encoders'],
      ),
      _ProjectData(
        number: '06',
        title: 'MPC vs PID tuning',
        category: 'CONTROL',
        description:
            'Comparing control strategies and using clustering methods '
            'to explore parameter tuning.',
        icon: Icons.tune_rounded,
        tags: ['MPC', 'PID', 'Simulation'],
      ),
    ];
    return Container(
      key: _sectionKeys['Projects'],
      child: _content(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 108),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow(label: 'SELECTED WORK'),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Text('Projects & experiments', style: _sectionHeading),
                  ),
                  if (MediaQuery.sizeOf(context).width > 550)
                    const Text(
                      'A sample of what I like to build.',
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 800 ? 2 : 1;
                  const gap = 15.0;
                  final cardWidth =
                      (constraints.maxWidth - gap * (columns - 1)) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: projects
                        .map(
                          (project) => SizedBox(
                            width: cardWidth,
                            child: _ProjectCard(data: project),
                          ),
                        )
                        .toList(),
                  );
                },
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
          padding: const EdgeInsets.only(bottom: 108),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _line),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 700;
                final story = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Eyebrow(label: 'A LITTLE ABOUT ME'),
                    SizedBox(height: 16),
                    Text('Curious by design.', style: _sectionHeading),
                    SizedBox(height: 19),
                    Text(
                      "I'm Jefin, a mechanical engineer interested in the "
                      'places where physical systems meet computation. '
                      'My work ranges from motor control and ROS 2 on Jetson '
                      'to nonlinear system modelling.',
                      style: TextStyle(color: _muted, height: 1.8),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'My current research explores beam dynamics, compliant '
                      'mechanisms, and smart materials such as MFC unimorphs. '
                      'Away from the lab, I enjoy 3D printing and writing '
                      'practical engineering notes.',
                      style: TextStyle(color: _muted, height: 1.8),
                    ),
                  ],
                );
                final tools = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Eyebrow(label: 'TOOLS OF THE TRADE'),
                    SizedBox(height: 19),
                    _ToolLine(name: 'Modelling', value: 'MATLAB · Simulink'),
                    _ToolLine(name: 'Simulation', value: 'APDL · Abaqus'),
                    _ToolLine(name: 'Robotics', value: 'ROS 2 · Jetson'),
                    _ToolLine(name: 'Prototyping', value: 'Arduino · ESP32'),
                  ],
                );
                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [story, const SizedBox(height: 38), tools],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: story),
                    const SizedBox(width: 44),
                    Expanded(flex: 4, child: tools),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotes() {
    const notes = [
      _NoteData(
        title: 'Getting started with ROS 2 on Jetson',
        description:
            'Setup notes for ROS 2 Humble on Jetson Orin Nano and AGX.',
        label: 'ROBOTICS',
        icon: Icons.developer_board_outlined,
      ),
      _NoteData(
        title: 'Zero-crossing frequency detection',
        description:
            'Building a real-time frequency detector with Simulink blocks.',
        label: 'SIMULATION',
        icon: Icons.graphic_eq_rounded,
      ),
      _NoteData(
        title: 'Encoder-based motor control',
        description:
            'PID tuning notes for DC motors with Arduino and encoder feedback.',
        label: 'EMBEDDED',
        icon: Icons.rotate_right_rounded,
      ),
    ];
    return Container(
      key: _sectionKeys['Notes'],
      child: _content(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 108),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow(label: 'FIELD NOTES'),
              const SizedBox(height: 15),
              const Text('Things I’ve been figuring out.', style: _sectionHeading),
              const SizedBox(height: 30),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 800
                      ? 3
                      : constraints.maxWidth > 540
                          ? 2
                          : 1;
                  const gap = 14.0;
                  final cardWidth =
                      (constraints.maxWidth - gap * (columns - 1)) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: notes
                        .map(
                          (note) => SizedBox(
                            width: cardWidth,
                            child: _NoteCard(data: note),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContact() {
    return Container(
      key: _sectionKeys['Contact'],
      child: _content(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 38),
          margin: const EdgeInsets.only(bottom: 70),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 640;
              final message = const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HAVE A GOOD PROBLEM?',
                    style: TextStyle(
                      color: Color(0xFF3B4B28),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Let’s make something work.',
                    style: TextStyle(
                      color: _background,
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                    ),
                  ),
                ],
              );
              final button = _ActionButton(
                label: 'Find me on GitHub',
                icon: Icons.arrow_outward_rounded,
                dark: true,
                onTap: () => _openLink('https://github.com/Jefin-J'),
              );
              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [message, const SizedBox(height: 24), button],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [message, button],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return _content(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '© 2026 Jefin Jacob',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
            GestureDetector(
              onTap: () => _openLink('https://github.com/Jefin-J'),
              child: const Text(
                'BUILT WITH FLUTTER WEB  ↗',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _sectionHeading = TextStyle(
  color: Colors.white,
  fontSize: 29,
  height: 1.2,
  fontWeight: FontWeight.w700,
  letterSpacing: -0.9,
);

class _Monogram extends StatelessWidget {
  const _Monogram();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'J',
        style: TextStyle(
          color: _background,
          fontWeight: FontWeight.w900,
          fontSize: 19,
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: selected ? _accent : _muted,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(color: _accent, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: _accent,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.outlined = false,
    this.dark = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? _background : Colors.white;
    return Material(
      color: outlined ? Colors.transparent : (dark ? _background : _accent),
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: outlined ? Border.all(color: _line) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: outlined ? _muted : (dark ? _accent : _background),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 9),
              Icon(icon, size: 15, color: outlined ? _muted : foreground),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _WindowDot(color: Color(0xFFFF766F)),
              SizedBox(width: 6),
              _WindowDot(color: Color(0xFFFFC45B)),
              SizedBox(width: 6),
              _WindowDot(color: _accent),
              Spacer(),
              Text(
                'SYSTEMS_OVERVIEW',
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: _background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _line),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _GridPainter()),
                  ),
                  Container(
                    width: 158,
                    height: 158,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x443F5141)),
                    ),
                  ),
                  Container(
                    width: 116,
                    height: 116,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x66576A55)),
                    ),
                  ),
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: const Color(0x223B4B28),
                      shape: BoxShape.circle,
                      border: Border.all(color: _accent, width: 1.4),
                    ),
                    child: const Icon(
                      Icons.precision_manufacturing_outlined,
                      size: 31,
                      color: _accent,
                    ),
                  ),
                  const Positioned(
                    left: 18,
                    top: 20,
                    child: _DiagramLabel(label: 'INPUT', value: 'SENSOR DATA'),
                  ),
                  const Positioned(
                    right: 18,
                    top: 20,
                    child: _DiagramLabel(label: 'PROCESS', value: 'CONTROL'),
                  ),
                  const Positioned(
                    left: 18,
                    bottom: 20,
                    child: _DiagramLabel(label: 'MODEL', value: 'DYNAMICS'),
                  ),
                  const Positioned(
                    right: 18,
                    bottom: 20,
                    child: _DiagramLabel(label: 'OUTPUT', value: 'MOTION'),
                  ),
                  const Positioned(
                    top: 78,
                    left: 0,
                    right: 0,
                    child: _SignalLine(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DESIGN  →  MODEL  →  BUILD',
                style: TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              Icon(Icons.north_east_rounded, color: _accent, size: 15),
            ],
          ),
        ],
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF202722)
      ..strokeWidth = 0.6;
    const gap = 24.0;
    for (var x = 0.0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DiagramLabel extends StatelessWidget {
  const _DiagramLabel({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 8,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _SignalLine extends StatelessWidget {
  const _SignalLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0x55495B47), height: 1)),
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(color: _accent, shape: BoxShape.circle),
        ),
        const Expanded(child: Divider(color: Color(0x55495B47), height: 1)),
      ],
    );
  }
}

class _ExpertiseData {
  const _ExpertiseData({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  final String number;
  final IconData icon;
  final String title;
  final String description;
}

class _ExpertiseCard extends StatelessWidget {
  const _ExpertiseCard({required this.data});

  final _ExpertiseData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 178),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(data.icon, color: _accent, size: 22),
              Text(
                data.number,
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: const TextStyle(color: _muted, fontSize: 12, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _ProjectData {
  const _ProjectData({
    required this.number,
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.tags,
  });

  final String number;
  final String title;
  final String category;
  final String description;
  final IconData icon;
  final List<String> tags;
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.data});

  final _ProjectData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 214),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, color: _accent, size: 19),
              const SizedBox(width: 9),
              Text(
                data.category,
                style: const TextStyle(
                  color: _accent,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
              const Spacer(),
              Text(
                data.number,
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 19),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            data.description,
            style: const TextStyle(color: _muted, height: 1.65, fontSize: 12),
          ),
          const SizedBox(height: 17),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: data.tags
                .map(
                  (tag) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: _surfaceRaised,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(color: _muted, fontSize: 10),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ToolLine extends StatelessWidget {
  const _ToolLine({required this.name, required this.value});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteData {
  const _NoteData({
    required this.title,
    required this.description,
    required this.label,
    required this.icon,
  });

  final String title;
  final String description;
  final String label;
  final IconData icon;
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.data});

  final _NoteData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 190),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(data.icon, color: _accent, size: 20),
              Text(
                data.label,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            data.description,
            style: const TextStyle(color: _muted, fontSize: 12, height: 1.6),
          ),
        ],
      ),
    );
  }
}
