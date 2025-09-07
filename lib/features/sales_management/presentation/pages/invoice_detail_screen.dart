import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/customer_managment/presentation/controllers/customer_controller.dart';
import 'package:teriak/features/sales_management/presentation/controllers/sale_controller.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/main.dart';

import '../widgets/invoice_header_card.dart';
import '../widgets/invoice_totals_card.dart';
import '../widgets/product_item_card.dart';
import '../widgets/sticky_return_button.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({super.key});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late ScrollController _scrollController;
  late SaleController saleController;
  late CustomerController customerController;
  late Map<String, dynamic> _invoiceData;
  final Map<int, int> _selectedItems = {};
  @override
  void initState() {
    super.initState();
    customerController = Get.put(CustomerController());
    saleController = Get.put(SaleController(customerTag: ''));
    _invoiceData = Get.arguments as Map<String, dynamic>;

    customerController.fetchCustomers();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.fetchAllInvoices();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Obx(
        () => saleController.isLoading.value
            ? _buildLoadingState()
            : _buildContent(),
      ),
      bottomNavigationBar: _buildStickyReturnButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        '${'Invoice'.tr} #${_invoiceData["customerName"]}',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
      ),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 2,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: colorScheme.onPrimary,
          size: 6.w,
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
      ),
      actions: [
        PopupMenuButton<String>(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: colorScheme.onPrimary,
            size: 6.w,
          ),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'print',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'print',
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF212121)
                        : const Color(0xFFFFFFFF),
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text('Print'.tr),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      children: [
        // Header skeleton
        Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Container(
            height: 22.h,
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Container(
                  height: 3.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF424242),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  height: 12.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF424242),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product skeletons
        ...List.generate(
            3,
            (index) => Card(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Container(
                    height: 12.h,
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.light
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF424242),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 2.h,
                                width: 70.w,
                                decoration: BoxDecoration(
                                  color: theme.brightness == Brightness.light
                                      ? const Color(0xFFE0E0E0)
                                      : const Color(0xFF424242),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                height: 1.5.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: theme.brightness == Brightness.light
                                      ? const Color(0xFFE0E0E0)
                                      : const Color(0xFF424242),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(
              top: 1.h,
              bottom: 20.h,
            ),
            children: [
              // Invoice header
              InvoiceHeaderCard(invoiceData: _invoiceData),

              // Products section header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Text(
                      '${'Items'.tr}(${_invoiceData['items'].length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    if (role != "PHARMACY_TRAINEE") ...[
                      if (_selectedItems.isNotEmpty)
                        TextButton(
                          onPressed: _clearSelection,
                          child: Text(
                            'Clear Selection'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              if (role != "PHARMACY_TRAINEE") ...[
                ..._invoiceData['items'].map((product) => ProductItemCard(
                      product: product,
                      isSelected: _selectedItems.containsKey(product["id"]),
                      selectedQuantity: _selectedItems[product["id"]] ?? 0,
                      onTap: () => _toggleProductSelection(product),
                      onQuantityChanged: (quantity) =>
                          _updateSelectedQuantity(product["id"], quantity),
                    )),
              ] else ...[
                ..._invoiceData['items'].map((product) => ProductItemCard(
                      product: product,
                    )),
              ],
              // Product list

              // Invoice totals
              InvoiceTotalsCard(invoiceData: _invoiceData),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStickyReturnButton() {
    final selectedItemsCount = _selectedItems.values.fold<int>(
      0,
      (sum, quantity) => sum + (quantity > 0 ? 1 : 0),
    );

    return StickyReturnButton(
      selectedItemsCount: selectedItemsCount,
      isEnabled: selectedItemsCount > 0,
      onPressed: _processReturn,
    );
  }

  void _toggleProductSelection(Map<String, dynamic> product) {
    final int productId = product["id"];
    final int returnableQty = product["availableForRefund"] as int? ?? 0;

    if (returnableQty == 0) {
      _showSnackBar(
          'This item cannot be returned because it has already been returned.'
              .tr);
      return;
    }

    setState(() {
      if (_selectedItems.containsKey(productId)) {
        _selectedItems.remove(productId);
      } else {
        _selectedItems[productId] = 1;
      }
    });

    HapticFeedback.selectionClick();
  }

  void _updateSelectedQuantity(int productId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _selectedItems.remove(productId);
      } else {
        _selectedItems[productId] = quantity;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
    });
    HapticFeedback.lightImpact();
    _showSnackBar('Selection cleared'.tr);
  }

  Future<void> printInvoice() async {
    final pdf = pw.Document();

    // Load Arabic font
    final arabicFont = await loadArabicFont();
    final double subtotal =
        (_invoiceData["items"] as List<dynamic>? ?? []).fold(0.0, (sum, item) {
      final price =
          double.tryParse(item["unitPrice"]?.toString() ?? '0') ?? 0.0;
      final qty = double.tryParse(item["quantity"]?.toString() ?? '0') ?? 0.0;
      return sum + price * qty;
    });
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header Section
                  pw.Container(
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
                          '${'Invoice'.tr} #${_invoiceData["customerName"] ?? "N/A"}',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                            font: arabicFont,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          "${"Customer:".tr} ${_invoiceData["customerName"] ?? "N/A"}",
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                            font: arabicFont,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "${"Date:".tr} ${_invoiceData["createdAt"] ?? DateTime.now().toString().split(' ')[0]}",
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey700,
                            font: arabicFont,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Items Section Header
                  pw.Container(
                    width: double.infinity,
                    padding:
                        pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Text(
                          "${'Items'.tr}  (${_invoiceData['items']?.length ?? 0})",
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                            font: arabicFont,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 15),

                  // Items Table
                  pw.Table(
                    border:
                        pw.TableBorder.all(color: PdfColors.grey400, width: 1),
                    columnWidths: {
                      0: pw.FlexColumnWidth(0.4), // Product name
                      1: pw.FlexColumnWidth(0.2), // Quantity
                      2: pw.FlexColumnWidth(0.2), // Unit price
                      3: pw.FlexColumnWidth(0.2), // Total
                    },
                    children: [
                      // Table header
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Product'.tr,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Qty'.tr,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Unit Price'.tr,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Total'.tr,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      // Table rows
                      ...(_invoiceData['items'] as List<dynamic>? ?? [])
                          .map<pw.TableRow>((product) {
                        final quantity = product["quantity"] as int? ?? 0;
                        final unitPrice =
                            (product["unitPrice"] as num?)?.toDouble() ?? 0.0;
                        final total = quantity * unitPrice;

                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                product["productName"]?.toString() ?? "N/A",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.black,
                                  font: arabicFont,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                quantity.toString(),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.black,
                                  font: arabicFont,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "Sp ${unitPrice.toStringAsFixed(2)}",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.black,
                                  font: arabicFont,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "Sp ${total.toStringAsFixed(2)}",
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.black,
                                  font: arabicFont,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),

                  pw.SizedBox(height: 20),

                  // Totals Section
                  pw.Container(
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
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Subtotal:'.tr,
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                            ),
                            pw.Text(
                              'Sp $subtotal',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Discount:'.tr,
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                            ),
                            pw.Text(
                              'Sp ${_invoiceData["discount"]?.toStringAsFixed(2) ?? "0.00"}',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.Divider(color: PdfColors.grey400, height: 20),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'TOTAL:'.tr,
                              style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                            ),
                            pw.Text(
                              'Sp ${_invoiceData["totalAmount"]?.toStringAsFixed(2) ?? "0.00"}',
                              style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                                font: arabicFont,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Footer
                  pw.Container(
                    width: double.infinity,
                    padding: pw.EdgeInsets.all(15),
                    child: pw.Text(
                      'Thank you for your business!',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey600,
                        fontStyle: pw.FontStyle.italic,
                        font: arabicFont,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ));
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'print':
        printInvoice();
        break;
    }
  }

  void _processReturn() {
    if (_selectedItems.isEmpty) return;

    // Calculate return details
    final selectedProducts = _invoiceData['items']
        .where((product) => _selectedItems.containsKey(product["id"]))
        .toList();

    double totalReturnAmount = 0.0;
    for (final product in selectedProducts) {
      final quantity = _selectedItems[product["id"]] ?? 0;
      final unitPrice = product["unitPrice"] as double? ?? 0.0;
      totalReturnAmount += quantity * unitPrice;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        const reasons = <String>[
          'Damaged',
          'Expired',
          'Wrong item',
          'Customer changed mind',
          'Other',
        ];

        String selectedReason = 'Customer changed mind'.tr;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Confirm Return'.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${'Return'.tr} ${_selectedItems.length} ${_selectedItems.length == 1 ? 'item'.tr : 'items'.tr}${'?'.tr}'),
                SizedBox(height: 1.h),
                Text(
                  '${'Estimated refund'.tr}: Sp ${totalReturnAmount.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Refund reason'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: reasons
                      .map((r) => DropdownMenuItem<String>(
                            value: r.tr,
                            child: Text(r.tr),
                          ))
                      .toList(),
                  value: selectedReason,
                  onChanged: (v) => setState(() => selectedReason = v!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final int saleInvoiceId = _invoiceData['id'] as int;
                  final List<Map<String, dynamic>> products =
                      List<Map<String, dynamic>>.from(selectedProducts);
                  final List<RefundItemParams> items = products.map((p) {
                    final int id = p['id'] as int;
                    final int qty = _selectedItems[id] ?? 0;
                    return RefundItemParams(
                      itemId: id,
                      quantity: qty,
                      itemRefundReason: selectedReason,
                    );
                  }).toList();
                  await saleController.createRefund(
                    saleInvoiceId: saleInvoiceId,
                    items: items,
                    refundReason: selectedReason,
                  );
                },
                child: Text('Continue'.tr),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Loads Arabic font for PDF generation
  Future<pw.Font?> loadArabicFont() async {
    try {
      // Try to load a custom Arabic font if available
      final fontData =
          await rootBundle.load('assets/fonts/Tajawal-Regular.ttf');
      return pw.Font.ttf(fontData);
    } catch (e) {
      // Use a built-in font that supports Arabic characters
      // Times New Roman has better Arabic support than Helvetica
      return pw.Font.times();
    }
  }
}
