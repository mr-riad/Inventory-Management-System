import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // For web platform only
import 'package:intl/intl.dart'; // For date formatting

import '../../../models/sale_model.dart'; // Adjust the path to your Sale model

class SaleReportPage extends StatelessWidget {
  final Sale sale;
  final double totalBorrowAmount;
  final double previousDue;

  const SaleReportPage({
    Key? key,
    required this.sale,
    required this.totalBorrowAmount,
    required this.previousDue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate invoice number and date
    final String invoiceNumber = _generateInvoiceNumber();
    final String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompanyInfo(),
            const SizedBox(height: 20),
            _buildInvoiceDetails(invoiceNumber, currentDate), // Add invoice details
            const SizedBox(height: 20),
            _buildCustomerInfo(),
            const SizedBox(height: 20),
            _buildSoldProducts(),
            const SizedBox(height: 20),
            _buildPaymentInfo(),
            const SizedBox(height: 30),
            _buildPrintButton(context, invoiceNumber, currentDate), // Pass invoice details
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Center(
      child: Column(
        children: [
          Text("M/S ADIB PHARMACY", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("Proprietor: Al-Amin"),
          Text("Matipara Bazar, Rajbari sadar, Rajbari"),
          Text("Cell: 01714904466, 01910014101"),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetails(String invoiceNumber, String currentDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invoice Number: $invoiceNumber', style: TextStyle(fontSize: 16)),
        Text('Date: $currentDate', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Name: ${sale.customerName}', style: TextStyle(fontSize: 16)),
        Text('Customer Email: ${sale.customerEmail}', style: TextStyle(fontSize: 16)),
        Text('Customer Phone: ${sale.customerPhone}', style: TextStyle(fontSize: 16)),
        Text('Customer Address: ${sale.customerAddress ?? 'N/A'}', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildSoldProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sold Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...sale.soldProducts.asMap().entries.map((entry) {
          final index = entry.key + 1; // Serial number
          final product = entry.value;
          return ListTile(
            leading: Text('$index.', style: TextStyle(fontSize: 16)),
            title: Text(product.productName, style: TextStyle(fontSize: 16)),
            subtitle: Text('Quantity: ${product.quantity}, Price: \৳${product.sellPrice}', style: TextStyle(fontSize: 14)),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Price: \৳${sale.totalPrice}', style: TextStyle(fontSize: 16)),
        Text('Previous Due: \৳$previousDue', style: TextStyle(fontSize: 16, color: Colors.orange)),
        Text('Pay Amount: \৳${sale.payAmount}', style: TextStyle(fontSize: 16)),
        Text('Borrow Amount: \৳${sale.borrowAmount}', style: TextStyle(fontSize: 16)),
        Text('Total Borrow Amount: \৳$totalBorrowAmount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPrintButton(BuildContext context, String invoiceNumber, String currentDate) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          print('Print button clicked');
          final pdf = pw.Document();

          // Generate QR code data
          final qrData = _generateQRData(sale);
          print('QR data generated: $qrData');

          // Generate QR code image
          final qrImage = await _generateQRImage(qrData);
          print('QR image generated');

          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Company Info
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text("M/S ADIB PHARMACY", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          pw.Text("Proprietor: Al-Amin"),
                          pw.Text("Matipara Bazar, Rajbari sadar, Rajbari"),
                          pw.Text("Cell:  01714904466, 01910014101"),
                          pw.SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // Invoice Details
                    pw.Text('Invoice Number: $invoiceNumber'),
                    pw.Text('Date: $currentDate'),
                    pw.SizedBox(height: 20),

                    // Customer Info
                    pw.Text('Customer Name: ${sale.customerName}'),
                    pw.Text('Customer Email: ${sale.customerEmail}'),
                    pw.Text('Customer Phone: ${sale.customerPhone}'),
                    pw.Text('Customer Address: ${sale.customerAddress ?? 'N/A'}'),
                    pw.SizedBox(height: 20),

                    // Sold Products
                    pw.Text('Sold Products:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ...sale.soldProducts.asMap().entries.map((entry) {
                      final index = entry.key + 1; // Serial number
                      final product = entry.value;
                      return pw.Text('$index. ${product.productName} - Quantity: ${product.quantity}, Price: ${product.sellPrice} Taka');
                    }).toList(),
                    pw.SizedBox(height: 20),

                    // Payment Info
                    pw.Text('Total Price: ${sale.totalPrice} Taka'),
                    pw.Text('Previous Due: $previousDue Taka', style: pw.TextStyle(fontSize: 16, color: PdfColors.orange)),
                    pw.Text('Pay Amount: ${sale.payAmount} Taka'),
                    pw.Text('Borrow Amount: ${sale.borrowAmount} Taka'),
                    pw.Text('Total Borrow Amount: $totalBorrowAmount Taka', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 20),

                    // QR Code
                    pw.Center(
                      child: pw.Image(
                        pw.MemoryImage(qrImage),
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ],
                );
              },
            ),
          );

          print('PDF generated');
          final pdfData = await pdf.save(); // Save the PDF

          // Platform-specific printing/downloading
          if (kIsWeb) {
            _printPdf(pdfData); // For web, download the PDF
          } else {
            await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => pdfData,
            ); // For mobile and desktop, print the PDF
          }

          print('Printing completed');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Printing successful')),
          );
        },
        child: const Text('Print Report'),
      ),
    );
  }

  // Generate invoice number
  String _generateInvoiceNumber() {
    final now = DateTime.now();
    final invoiceNumber = 'INV-${now.millisecondsSinceEpoch}'; // Unique invoice number
    return invoiceNumber;
  }

  // Generate QR code data
  String _generateQRData(Sale sale) {
    final invoiceDetails = {
      'customerName': sale.customerName,
      'customerEmail': sale.customerEmail,
      'customerPhone': sale.customerPhone,
      'totalPrice': sale.totalPrice,
      'payAmount': sale.payAmount,
      'borrowAmount': sale.borrowAmount,
      'previousDue': previousDue,
      'soldProducts': sale.soldProducts.map((product) => {
        'productName': product.productName,
        'quantity': product.quantity,
        'sellPrice': product.sellPrice,
      }).toList(),
    };
    return invoiceDetails.toString();
  }

  // Generate QR code image
  Future<Uint8List> _generateQRImage(String data) async {
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
      color: ui.Color(0xFF000000), // Use `ui.Color` for black
      emptyColor: ui.Color(0xFFFFFFFF), // Use `ui.Color` for white
    );

    final ui.Image qrImage = await qrPainter.toImage(200);
    final ByteData? byteData = await qrImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // For web platform: Download PDF
  void _printPdf(Uint8List pdfData) {
    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'sale_report.pdf';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}