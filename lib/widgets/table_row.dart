// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:intl/intl.dart';
// import 'package:save_docs/models/doc_model.dart';

// class TableRow extends StatelessWidget {
//   final int index;
//   final DocumentModel documentModel;

//   final style = TextStyle(fontSize: 12, color: Colors.grey[100], overflow: TextOverflow.ellipsis);
//   TableRow({super.key, required this.documentModel, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return TableRow(
//       children: [
//         TableCell(
//             child: Text(
//           documentModel.id.toString(),
//           style: const TextStyle(fontSize: 10),
//         )),
//         TableCell(
//             child: Text(
//           documentModel.description,
//           style: const TextStyle(fontSize: 14),
//         )),
//         /* TableCell(
//                       child: Text(
//                         documentModel.from,
//                         style: style,
//                       )),*/
//         TableCell(child: Text(documentModel.to, style: style)),
//         TableCell(child: Text(documentModel.replyFor != null ? documentModel.replyFor.toString() : '', style: style)),
//         TableCell(child: Text(documentModel.saveTo ?? '', style: style)),
//         TableCell(child: Text(DateFormat('yyyy/MM/dd', 'ar').format(documentModel.createdAt), style: style)),
//       ],
//       decoration: BoxDecoration(color: index.isEven ? Colors.grey[20] : Colors.white),
//     );
//   }
// }
