
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'resume_service.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final ResumeService _service = ResumeService();

  bool _busy = false;
  String? _error;

  Future<void> _upload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );

      if (result == null || !mounted) return;

      setState(() {
        _busy = true;
        _error = null;
      });

      await _service.uploadResume(result.files.single);

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Resume uploaded. Automated analysis is not enabled yet.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Resume Analyzer',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload a PDF or DOC/DOCX file. This version stores the file '
          'and records the upload. Resume text extraction and scoring '
          'require a backend function.',
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _busy ? null : _upload,
          icon: const Icon(Icons.upload_file),
          label: Text(_busy ? 'Uploading...' : 'Choose and upload resume'),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
        const SizedBox(height: 24),
        Text(
          'Your uploads',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _service.getReports(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Unable to load reports: ${snapshot.error}',
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final reports = snapshot.data ?? [];

            if (reports.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No resumes uploaded yet.'),
                ),
              );
            }

            return Column(
              children: reports.map((report) {
                final fileName = report['file_name'] ?? 'Resume';
                final status = report['status'] ?? 'uploaded';
                final score = report['score'];
                final createdAt = report['created_at'] ?? '';

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(fileName.toString()),
                    subtitle: Text(
                      'Status: $status • $createdAt',
                    ),
                    trailing: Text(
                      score == null ? 'Pending' : '$score%',
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
