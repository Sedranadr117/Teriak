import 'package:flutter/material.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/customer_profile_card.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/debt_breakdown_section.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/new_payment_bottom_sheet.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/notes_section.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/payment_history_section.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/payment_plan_section.dart';

class IndebtedCustomerDetails extends StatefulWidget {
  const IndebtedCustomerDetails({Key? key}) : super(key: key);

  @override
  State<IndebtedCustomerDetails> createState() =>
      _IndebtedCustomerDetailsState();
}

class _IndebtedCustomerDetailsState extends State<IndebtedCustomerDetails> {
  String customerName = '';
  Map<String, dynamic> customerData = {};
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCustomerData();
  }

  void _loadCustomerData() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    setState(() {
      customerName = args['customerName'] ?? 'John Doe';
      customerData = {
        'id': args['customerId'] ?? '1',
        'name': customerName,
        'phone': args['phone'] ?? '+1 (555) 123-4567',
        'email': args['email'] ?? 'john.doe@email.com',
        'address': args['address'] ?? '123 Main St, City, State 12345',
        'profileImage': args['profileImage'] ??
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'totalDebt': args['totalDebt'] ?? 1250.75,
        'totalPayments': args['totalPayments'] ?? 750.00,
        'remainingBalance': args['remainingBalance'] ?? 500.75,
        'joinDate': args['joinDate'] ?? '2024-01-15',
        'lastPayment': args['lastPayment'] ?? '2024-07-28',
        'paymentHistory':
            args['paymentHistory'] ?? _generateMockPaymentHistory(),
        'debtBreakdown': args['debtBreakdown'] ?? _generateMockDebtBreakdown(),
        'paymentPlan': args['paymentPlan'] ?? _generateMockPaymentPlan(),
        'notes': args['notes'] ?? _generateMockNotes(),
      };
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> _generateMockPaymentHistory() {
    return [
      {
        'id': '1',
        'date': '2024-07-28',
        'amount': 150.00,
        'method': 'Credit Card',
        'status': 'Completed',
        'reference': 'PAY-001',
        'receipt': true,
      },
      {
        'id': '2',
        'date': '2024-07-15',
        'amount': 200.00,
        'method': 'Cash',
        'status': 'Completed',
        'reference': 'PAY-002',
        'receipt': true,
      },
      {
        'id': '3',
        'date': '2024-06-30',
        'amount': 100.00,
        'method': 'Bank Transfer',
        'status': 'Completed',
        'reference': 'PAY-003',
        'receipt': false,
      },
      {
        'id': '4',
        'date': '2024-06-15',
        'amount': 300.00,
        'method': 'Credit Card',
        'status': 'Completed',
        'reference': 'PAY-004',
        'receipt': true,
      },
    ];
  }

  Map<String, dynamic> _generateMockDebtBreakdown() {
    return {
      'originalAmount': 1000.00,
      'interestCharges': 150.75,
      'lateFees': 75.00,
      'adjustments': 25.00,
      'details': [
        {
          'type': 'Purchase',
          'date': '2024-01-15',
          'amount': 500.00,
          'description': 'Prescription medications'
        },
        {
          'type': 'Purchase',
          'date': '2024-02-20',
          'amount': 300.00,
          'description': 'Medical supplies'
        },
        {
          'type': 'Purchase',
          'date': '2024-03-10',
          'amount': 200.00,
          'description': 'Vitamins and supplements'
        },
        {
          'type': 'Interest',
          'date': '2024-04-01',
          'amount': 50.25,
          'description': 'Monthly interest charge'
        },
        {
          'type': 'Interest',
          'date': '2024-05-01',
          'amount': 50.25,
          'description': 'Monthly interest charge'
        },
        {
          'type': 'Interest',
          'date': '2024-06-01',
          'amount': 50.25,
          'description': 'Monthly interest charge'
        },
        {
          'type': 'Late Fee',
          'date': '2024-05-15',
          'amount': 25.00,
          'description': 'Late payment fee'
        },
        {
          'type': 'Late Fee',
          'date': '2024-06-15',
          'amount': 25.00,
          'description': 'Late payment fee'
        },
        {
          'type': 'Late Fee',
          'date': '2024-07-15',
          'amount': 25.00,
          'description': 'Late payment fee'
        },
        {
          'type': 'Adjustment',
          'date': '2024-07-20',
          'amount': 25.00,
          'description': 'Goodwill adjustment'
        },
      ],
    };
  }

  List<Map<String, dynamic>> _generateMockPaymentPlan() {
    return [
      {
        'id': '1',
        'dueDate': '2024-08-15',
        'amount': 125.00,
        'status': 'upcoming',
        'description': 'Monthly installment 1/4',
      },
      {
        'id': '2',
        'dueDate': '2024-09-15',
        'amount': 125.00,
        'status': 'scheduled',
        'description': 'Monthly installment 2/4',
      },
      {
        'id': '3',
        'dueDate': '2024-10-15',
        'amount': 125.00,
        'status': 'scheduled',
        'description': 'Monthly installment 3/4',
      },
      {
        'id': '4',
        'dueDate': '2024-11-15',
        'amount': 125.75,
        'status': 'scheduled',
        'description': 'Final installment 4/4',
      },
    ];
  }

  List<Map<String, dynamic>> _generateMockNotes() {
    return [
      {
        'id': '1',
        'date': '2024-07-28',
        'user': 'Sarah Johnson',
        'note':
            'Customer made partial payment of \$150. Agreed to payment plan for remaining balance.',
        'timestamp': '2024-07-28 14:30:00',
      },
      {
        'id': '2',
        'date': '2024-07-15',
        'user': 'Michael Chen',
        'note':
            'Called customer regarding overdue payment. Customer requested payment plan options.',
        'timestamp': '2024-07-15 10:15:00',
      },
      {
        'id': '3',
        'date': '2024-06-30',
        'user': 'Emily Davis',
        'note':
            'Customer experiencing financial difficulties. Offered extended payment terms.',
        'timestamp': '2024-06-30 16:45:00',
      },
    ];
  }

  void _showNewPaymentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewPaymentBottomSheet(
        customerData: customerData,
        onPaymentAdded: (paymentData) {
          setState(() {
            customerData['paymentHistory'].insert(0, paymentData);
            customerData['totalPayments'] += paymentData['amount'];
            customerData['remainingBalance'] -= paymentData['amount'];
          });
        },
      ),
    );
  }

  void _showDebtAdjustmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Debt Adjustment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Adjustment Amount',
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Reason for Adjustment',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Debt adjustment recorded')),
              );
            },
            child: Text('Apply Adjustment'),
          ),
        ],
      ),
    );
  }

  void _sendPaymentReminder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Payment Reminder'),
        content: Text('Send payment reminder to $customerName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment reminder sent')),
              );
            },
            child: Text('Send Reminder'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: customerName,
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $customerName...')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening email to $customerName...')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  Navigator.pushNamed(
                    context,
                    AppPages.addNewIndebtedCustomer,
                    arguments: customerData,
                  );
                  break;
                case 'statement':
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Generating customer statement...')),
                  );
                  break;
                case 'delete':
                  _showDeleteConfirmation();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text('Edit Customer')),
              PopupMenuItem(
                  value: 'statement', child: Text('Generate Statement')),
              PopupMenuItem(value: 'delete', child: Text('Delete Customer')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomerProfileCard(customerData: customerData),
            SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showNewPaymentBottomSheet,
                    icon: Icon(Icons.payment),
                    label: Text('Record Payment'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showDebtAdjustmentDialog,
                    icon: Icon(Icons.tune),
                    label: Text('Adjust Debt'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sendPaymentReminder,
                    icon: Icon(Icons.notifications),
                    label: Text('Send Reminder'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),
            PaymentHistorySection(
                paymentHistory: customerData['paymentHistory']),
            SizedBox(height: 24),
            DebtBreakdownSection(debtBreakdown: customerData['debtBreakdown']),
            SizedBox(height: 24),
            PaymentPlanSection(
              paymentPlan: customerData['paymentPlan'],
              enablePaymentPlan: true,
              installments: 11,
              installmentAmount: 00,
              totalDebt: 100,
              onEnablePaymentPlanChanged: (bool) {},
              onInstallmentsChanged: (int) {},
            ),
            SizedBox(height: 24),
            NotesSection(notes: customerData['notes']),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Customer'),
        content: Text(
            'Are you sure you want to delete $customerName? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Customer deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
