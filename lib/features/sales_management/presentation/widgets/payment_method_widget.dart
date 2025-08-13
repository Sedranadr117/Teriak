// import 'package:flutter/material.dart';

// class PaymentMethodWidget extends StatefulWidget {
//   const PaymentMethodWidget({super.key});

//   @override
//   State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
// }

// class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedType = method['name'];
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: (method['color'] as Color).withOpacity(0.5),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? method['color'] as Color : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             if (isSelected)
//               BoxShadow(
//                 color: (method['color'] as Color).withOpacity(0.2),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // الاسم
//             Text(
//               method['name'],
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: isSelected ? method['color'] as Color : Colors.grey[800],
//               ),
//             ),
//             // الوصف
//             Text(
//               method['description'],
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//     ;
//   }
// }
