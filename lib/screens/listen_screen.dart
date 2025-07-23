import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class ListenScreen extends StatefulWidget {
  const ListenScreen({Key? key}) : super(key: key);

  @override
  State<ListenScreen> createState() => _ListenScreenState();
}

class _ListenScreenState extends State<ListenScreen>
    with SingleTickerProviderStateMixin {
  bool isListening = false;
  late AnimationController _micController;
  late Animation<double> _micAnimation;

  @override
  void initState() {
    super.initState();
    _micController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _micAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _micController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _micController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      isListening = true;
    });
    _micController.repeat(reverse: true);
  }

  void _endListening() {
    setState(() {
      isListening = false;
    });
    _micController.stop();
    _micController.value = 1.0;
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        Navigator.of(context).pushNamed('/post_recording');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Listen',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: isListening
                    ? FadeTransition(
                        opacity: _micAnimation,
                        child: ScaleTransition(
                          scale: _micAnimation,
                          child: Container(
                            key: const ValueKey('mic-anim'),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.05),
                            ),
                            padding: const EdgeInsets.all(32),
                            child: const Icon(Icons.mic,
                                size: 80, color: Colors.black),
                          ),
                        ),
                      )
                    : Container(
                        key: const ValueKey('mic-static'),
                        padding: const EdgeInsets.all(32),
                        child: const Icon(Icons.mic_none,
                            size: 80, color: Colors.black54),
                      ),
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: isListening
                    ? Column(
                        key: const ValueKey('listening-text'),
                        children: [
                          const Text(
                            'Listening... ',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aidy is capturing your lesson in real time.',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: 320,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Sample captured speech:\n"Photosynthesis is the process by which green plants..."',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        key: const ValueKey('not-listening-text'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: const Text(
                              'Tap Start Listening to capture your lesson or lecture.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 40),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isListening
                    ? SizedBox(
                        key: const ValueKey('end-btn'),
                        width: 220,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _endListening,
                          child: const Text('End',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      )
                    : SizedBox(
                        key: const ValueKey('start-btn'),
                        width: 220,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _startListening,
                          child: const Text('Start Listening',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
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
