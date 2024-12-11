// import 'package:flutter/material.dart';
// import 'CustomizationPage.dart'; // Import the CustomizationPage

// class DesignPage extends StatelessWidget {
//   final ImageProvider image;
//   const DesignPage({super.key, required this.image});

//   void _showCustomizationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Customize Design'),
//           content: const Text('Do you want to customize this?'),
//           actions: [
//             TextButton( 
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('No'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 // Navigate to the CustomizationPage
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CustomizationPage(image: image)),
//                 );
//               },
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFecd8c6), // Background color
//       body: Center(
//         // Center the contents of the page
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome to the Design Page!',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.pinkAccent,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _showCustomizationDialog(context); // Show the dialog
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.pinkAccent,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 40.0, vertical: 15.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//               ),
//               child: const Text(
//                 'Customize',
//                 style: TextStyle(color: Colors.white, fontSize: 18.0),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
