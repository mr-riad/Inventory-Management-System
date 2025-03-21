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
  final double previousDue;
  final double totalBorrowAmount;

  const SaleReportPage({
    Key? key,
    required this.sale,
    required this.previousDue,
    required this.totalBorrowAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging: Print values to verify
    print('Previous Due: $previousDue');
    print('Total Borrow Amount: $totalBorrowAmount');

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
            _buildInvoiceDetails(invoiceNumber, currentDate),
            const SizedBox(height: 20),
            _buildCustomerInfo(),
            const SizedBox(height: 20),
            _buildSoldProducts(),
            const SizedBox(height: 20),
            _buildPaymentInfo(),
            const SizedBox(height: 30),
            _buildPrintButton(context, invoiceNumber, currentDate),
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

                    // Sold Products Table
                    pw.Text('Sold Products:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        // Table Header
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('SL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('Product Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                          ],
                        ),
                        // Table Rows
                        ...sale.soldProducts.asMap().entries.map((entry) {
                          final index = entry.key + 1; // Serial number
                          final product = entry.value;
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text('$index'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(product.productName),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text('${product.quantity}'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text('${product.sellPrice} Taka'),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                    pw.SizedBox(height: 20),

                    // Payment Info Table
                    pw.Text('Payment Information:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('Total Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('${sale.totalPrice} Taka'),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('Previous Due', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('$previousDue Taka', style: pw.TextStyle(color: PdfColors.orange)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('Pay Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('${sale.payAmount} Taka'),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('Borrow Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('${sale.borrowAmount} Taka'),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('Total Borrow Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text('$totalBorrowAmount Taka', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
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