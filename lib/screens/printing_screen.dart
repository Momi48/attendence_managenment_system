import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintingScreen extends StatefulWidget {
  final String? name;
  final int? present;
  final int? absent;
  final int? leaves;
  final String? time;
  final Timestamp? createdAt;
  const PrintingScreen(
      {super.key,
      required this.name,
      required this.present,
      required this.absent,
      required this.leaves,
      required this.time,
      required this.createdAt});

  @override
  State<PrintingScreen> createState() => _PrintingScreenState();
}

class _PrintingScreenState extends State<PrintingScreen> {
  final text = const pw.TextStyle(
    fontSize: 30,
  );
  final reference =
      FirebaseFirestore.instance.collection('User_Details').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Column(
        children: [
          Text('Name: ${widget.name}'),
          Text('Absent: ${widget.absent}'),
          Text('Present: ${widget.present}'),
          Text('Leaves: ${widget.leaves}'),
          Text('Day: ${widget.time}'),
          Text(
              'Created: ${DateFormat('dd MMM yyyy').format(widget.createdAt!.toDate())}'),
          const SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () async {
              // Generating the PDF document
              await Printing.layoutPdf(onLayout: (PdfPageFormat format) {
                // create a pdf
                final pdf = pw.Document();
                pdf.addPage(pw.Page(build: (context) {
                  return pw.Center(
                      child: pw.Column(children: [
                    pw.Text('Name: ${widget.name}',
                        style: const pw.TextStyle(fontSize: 20)),
                    pw.Text('Absent: ${widget.absent}',
                        style: const pw.TextStyle(fontSize: 20)),
                    pw.Text('Present: ${widget.present}',
                        style: const pw.TextStyle(fontSize: 20)),
                    pw.Text('Leaves: ${widget.leaves}',
                        style: const pw.TextStyle(fontSize: 20)),
                    pw.Text('Day: ${widget.time}',
                        style: const pw.TextStyle(fontSize: 20)),
                    pw.Text(
                        'Created: ${DateFormat('dd MMM yyyy').format(widget.createdAt!.toDate())}',
                        style: const pw.TextStyle(fontSize: 20)),
                  ]));
                }));
                return pdf.save();
              });
            },
            child: Center(
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                  child: Text(
                    'Print',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
