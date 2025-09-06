import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';

class PurchaseInvoicePrinter {
  final PurchaseInvoiceModel invoice;

  PurchaseInvoicePrinter({required this.invoice});

  Future<void> printInvoice() async {
    final pdf = pw.Document();

    // تحميل الخط العربي
    final arabicFont = await _loadArabicFont();

    final double subtotal = invoice.items.fold(0.0, (sum, item) {
      final price = item.actualPrice;
      final qty = item.receivedQty + item.bonusQty;
      return sum + price * qty;
    });

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(arabicFont),
                pw.SizedBox(height: 20),
                _buildItemsTable(arabicFont),
                pw.SizedBox(height: 20),
                _buildTotals(arabicFont, subtotal),
                pw.SizedBox(height: 20),
                _buildFooter(arabicFont),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget _buildHeader(pw.Font arabicFont) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${'Purchase Invoice'.tr} #${invoice.invoiceNumber ?? "N/A"}',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: arabicFont),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "Supplier: ${invoice.supplierName}",
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: arabicFont),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            "Date: ${invoice.formattedCreationDateTime}",
            style: pw.TextStyle(fontSize: 14, font: arabicFont, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable(pw.Font arabicFont) {
    final items = invoice.items;

    return pw.Column(
      children: [
        // Table Header
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            "Items (${items.length})",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: arabicFont),
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
          columnWidths: {
            0: pw.FlexColumnWidth(0.4),
            1: pw.FlexColumnWidth(0.2),
            2: pw.FlexColumnWidth(0.2),
            3: pw.FlexColumnWidth(0.2),
          },
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey200),
              children: ['Product', 'Quantity','Bonus Quantity', 'Unit Price', 'Total']
                  .map((e) => pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(
                          e,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: arabicFont),
                          textAlign: pw.TextAlign.center,
                        ),
                      ))
                  .toList(),
            ),
            ...items.map<pw.TableRow>((item) {
              final quantity = item.receivedQty;
               final bonus = item.bonusQty;
              final unitPrice = item.actualPrice;
              final total = quantity * unitPrice;

              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.productName, style: pw.TextStyle(font: arabicFont, fontSize: 12)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(quantity.toString(),
                        style: pw.TextStyle(font: arabicFont, fontSize: 12), textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(bonus.toString(),
                        style: pw.TextStyle(font: arabicFont, fontSize: 12), textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(unitPrice.toStringAsFixed(2),
                        style: pw.TextStyle(font: arabicFont, fontSize: 12), textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(total.toStringAsFixed(2),
                        style: pw.TextStyle(font: arabicFont, fontSize: 12), textAlign: pw.TextAlign.center),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTotals(pw.Font arabicFont, double subtotal) {
    final totalAmount = invoice.total;

    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          _buildTotalRow("Subtotal:", subtotal, arabicFont),
          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.grey400, height: 20),
          _buildTotalRow("TOTAL:", totalAmount, arabicFont, isBold: true),
        ],
      ),
    );
  }

  pw.Widget _buildTotalRow(String title, double value, pw.Font font, {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 16, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, font: font)),
        pw.Text(value.toStringAsFixed(2),
            style: pw.TextStyle(fontSize: 16, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, font: font)),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Font arabicFont) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(15),
      child: pw.Text(
        'Thank you for your business!',
        style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic, font: arabicFont, color: PdfColors.grey600),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  Future<pw.Font> _loadArabicFont() async {
          final fontData =
          await rootBundle.load('assets/fonts/Tajawal-Regular.ttf');
    return pw.Font.ttf(fontData);
  }
}
