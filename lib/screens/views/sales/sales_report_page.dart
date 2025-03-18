import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../../../models/sale_model.dart';

class SaleReportPage extends StatelessWidget {
  final Sale sale;
  final double totalBorrowAmount;

  const SaleReportPage({Key? key, required this.sale, required this.totalBorrowAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerInfo(),
            const SizedBox(height: 20),
            _buildSoldProducts(),
            const SizedBox(height: 20),
            _buildPaymentInfo(),
            const SizedBox(height: 30),
            _buildPrintButton(context),
          ],
        ),
      ),
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
        ...sale.soldProducts.map((product) {
          return ListTile(
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
        Text('Pay Amount: \৳${sale.payAmount}', style: TextStyle(fontSize: 16)),
        Text('Borrow Amount: \৳${sale.borrowAmount}', style: TextStyle(fontSize: 16)),
        Text('Total Borrow Amount: \৳$totalBorrowAmount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPrintButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final pdf = pw.Document();

          // Generate QR code data
          final qrData = _generateQRData(sale);

          // Generate QR code image
          final qrImage = await _generateQRImage(qrData);

          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Customer Name: ${sale.customerName}'),
                    pw.Text('Customer Email: ${sale.customerEmail}'),
                    pw.Text('Customer Phone: ${sale.customerPhone}'),
                    pw.Text('Customer Address: ${sale.customerAddress ?? 'N/A'}'),
                    pw.SizedBox(height: 20),
                    pw.Text('Sold Products:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ...sale.soldProducts.map((product) {
                      return pw.Text('${product.productName} - Quantity: ${product.quantity}, Price: \৳${product.sellPrice}');
                    }).toList(),
                    pw.SizedBox(height: 20),
                    pw.Text('Total Price: \৳${sale.totalPrice}'),
                    pw.Text('Pay Amount: \৳${sale.payAmount}'),
                    pw.Text('Borrow Amount: \৳${sale.borrowAmount}'),
                    pw.Text('Total Borrow Amount: \৳$totalBorrowAmount', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 20),
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

          await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdf.save(),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Printing successful')),
          );
        },
        child: const Text('Print Report'),
      ),
    );
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
}