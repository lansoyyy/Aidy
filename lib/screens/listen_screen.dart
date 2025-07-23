import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class ListenScreen extends StatefulWidget {
  const ListenScreen({Key? key}) : super(key: key);

  @override
  State<ListenScreen> createState() => _ListenScreenState();
}

class _ListenScreenState extends State<ListenScreen> {
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: TextWidget(
          text: 'Listen',
          fontSize: 20,
          isBold: true,
          color: primary,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic_none,
              size: 80,
              color: isListening ? primary : accent,
            ),
            const SizedBox(height: 32),
            TextWidget(
              text: isListening
                  ? 'Listening...'
                  : 'Tap Start Listening to capture your lesson or lecture.',
              fontSize: 16,
              color: textGrey,
            ),
            const SizedBox(height: 40),
            if (!isListening)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: buttonText,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Listening'),
                onPressed: () {
                  setState(() {
                    isListening = true;
                  });
                },
              ),
            if (isListening)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: buttonText,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.stop),
                label: const Text('End'),
                onPressed: () {
                  setState(() {
                    isListening = false;
                  });
                  Navigator.of(context).pushNamed('/post_recording');
                },
              ),
          ],
        ),
      ),
    );
  }
}
