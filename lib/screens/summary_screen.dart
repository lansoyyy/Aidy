import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final TextEditingController _controller = TextEditingController(
    text:
        'Summary\nThis is a generated summary of the recorded lesson. It provides a concise overview of the main points discussed.\nKey concept 1: Photosynthesis process\nKey concept 2: Importance of sunlight\nKey concept 3: Plant cell structure',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shareNote() {
    Share.share(_controller.text, subject: 'Aidy Note');
  }

  Future<void> _saveAsPdf() async {
    final title = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Save as PDF',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Enter note title',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  autofocus: true,
                  cursorColor: Colors.black,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () =>
                          Navigator.of(context).pop(controller.text),
                      child: const Text('Save',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (title == null || title.trim().isEmpty) return;

    final pdf = pw.Document();
    final lines = _controller.text.split('\n');
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            color: PdfColors.white,
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(title,
                    style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black)),
                pw.SizedBox(height: 24),
                ...lines.map((line) => pw.Text(line,
                    style: pw.TextStyle(fontSize: 16, color: PdfColors.black))),
              ],
            ),
          );
        },
      ),
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$title.pdf');
    await file.writeAsBytes(await pdf.save());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('PDF saved!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fromHome = ModalRoute.of(context)?.settings.arguments is Map &&
        (ModalRoute.of(context)?.settings.arguments as Map)['fromHome'] == true;
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
          'Summary',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -1,
          ),
        ),
        actions: [
          if (fromHome)
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.black),
              tooltip: 'Share PDF',
              onPressed: () async {
                // Use the first line as the title
                final lines = _controller.text.split('\n');
                final title =
                    (lines.isNotEmpty && lines.first.trim().isNotEmpty)
                        ? lines.first.trim()
                        : 'Aidy Note';
                final pdf = pw.Document();
                pdf.addPage(
                  pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Container(
                        color: PdfColors.white,
                        padding: const pw.EdgeInsets.all(32),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(title,
                                style: pw.TextStyle(
                                    fontSize: 28,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.black)),
                            pw.SizedBox(height: 24),
                            ...lines.map((line) => pw.Text(line,
                                style: pw.TextStyle(
                                    fontSize: 16, color: PdfColors.black))),
                          ],
                        ),
                      );
                    },
                  ),
                );
                final dir = await getTemporaryDirectory();
                final file = File('${dir.path}/$title.pdf');
                await file.writeAsBytes(await pdf.save());
                await Share.shareXFiles([XFile(file.path)], text: title);
              },
            ),
          IconButton(
              onPressed: _saveAsPdf,
              icon: const Icon(Icons.save_alt, color: Colors.black)),
          IconButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Delete Note',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black)),
                          const SizedBox(height: 16),
                          const Text(
                              'Are you sure you want to delete this note?',
                              style: TextStyle(color: Colors.black)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.black)),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                if (confirm == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Note deleted.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  );
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                }
              },
              icon: const Icon(Icons.delete_outline, color: Colors.black)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Editable note field
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  autofocus: true,
                  cursorColor: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 32, thickness: 1, color: Colors.black12),
              const SizedBox(height: 8),
              const Text(
                'Ask Aidy about this summary',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              _AidyQASection(summaryGetter: () => _controller.text),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AidyQASection extends StatefulWidget {
  final String Function() summaryGetter;
  const _AidyQASection({required this.summaryGetter});

  @override
  State<_AidyQASection> createState() => _AidyQASectionState();
}

class _AidyQASectionState extends State<_AidyQASection> {
  final TextEditingController _questionController = TextEditingController();
  String? _answer;
  bool _loading = false;

  void _askAidy() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) return;
    setState(() {
      _loading = true;
      _answer = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _answer =
          'This is a sample answer based on your summary: "${widget.summaryGetter().split('\n').first}".\n\n(Replace this with real AI integration.)';
      _loading = false;

      _questionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _questionController,
                style: const TextStyle(fontSize: 15, color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Ask a question about this summary...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                cursorColor: Colors.black,
                minLines: 1,
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.black),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _loading ? null : _askAidy,
              child: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Ask',
                      style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        if (_answer != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12),
            ),
            child: Text(
              _answer!,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ],
    );
  }
}
