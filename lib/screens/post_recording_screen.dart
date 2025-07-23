import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class PostRecordingScreen extends StatelessWidget {
  const PostRecordingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            color: surface,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, color: accent, size: 48),
                  const SizedBox(height: 18),
                  TextWidget(
                    text: 'Session Complete',
                    fontSize: 20,
                    isBold: true,
                    color: primary,
                  ),
                  const SizedBox(height: 10),
                  TextWidget(
                    text: 'What would you like to do with this recording?',
                    fontSize: 15,
                    color: textGrey,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: buttonText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.summarize,
                        color: Colors.white,
                      ),
                      label: const Text('Summarize with AI'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/summary');
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Return Home',
                      style: TextStyle(
                        color: accent,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
