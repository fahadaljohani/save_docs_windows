import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:save_docs/Repository/sql_helper.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:save_docs/widgets/showDialogDoc.dart';
import 'package:window_manager/window_manager.dart';

class MonitorDocs extends StatefulWidget {
  const MonitorDocs({super.key});

  @override
  State<MonitorDocs> createState() => _MonitorDocsState();
}

class _MonitorDocsState extends State<MonitorDocs> with WindowListener {
  int x = 1;
  List<DocumentModel>? tempList = [];
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  final style = TextStyle(fontSize: 12, color: Colors.grey[100], overflow: TextOverflow.ellipsis);
  final styleHeader = const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis);

  @override
  Widget build(BuildContext context) {
    print('----Monitor Documents rebuilds');

    return
        // FutureBuilder(
        //   future: SqlHelper.getNotRepliedDocs(),
        //   builder: (BuildContext context, AsyncSnapshot<List<DocumentModel>?> snapshot) {
        //     if (snapshot.data != null && snapshot.hasData) {
        //       return Padding(
        //         padding: const EdgeInsets.all(15.0),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             Align(alignment: Alignment.bottomRight, child: Text('معاملات تم الرد عليها')),
        //             Table(
        //               columnWidths: const {
        //                 0: FractionColumnWidth(0.03),
        //                 1: FractionColumnWidth(0.45),
        //                 3: FractionColumnWidth(0.07),
        //               },
        //               border: TableBorder.symmetric(
        //                 outside: BorderSide.none,
        //               ),
        //               defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        //               children: [
        //                 TableRow(
        //                     decoration: BoxDecoration(
        //                       color: Colors.grey[80],
        //                     ),
        //                     children: [
        //                       const TableCell(
        //                           child: Align(
        //                         alignment: Alignment.bottomRight,
        //                         child: Icon(
        //                           FluentIcons.numbered_list,
        //                           size: 10,
        //                         ),
        //                       )),
        //                       TableCell(
        //                           verticalAlignment: TableCellVerticalAlignment.middle,
        //                           child: Text(
        //                             'الموضوع',
        //                             style: styleHeader,
        //                           )),
        //                       TableCell(
        //                           verticalAlignment: TableCellVerticalAlignment.middle,
        //                           child: Text(
        //                             'صادر للجهة ',
        //                             style: styleHeader,
        //                           )),
        //                       TableCell(
        //                           verticalAlignment: TableCellVerticalAlignment.middle,
        //                           child: Text(
        //                             'تسديد قيد ',
        //                             style: styleHeader,
        //                           )),
        //                       TableCell(
        //                           verticalAlignment: TableCellVerticalAlignment.middle,
        //                           child: Text(
        //                             'مكان الحفظ ',
        //                             style: styleHeader,
        //                           )),
        //                       TableCell(
        //                           verticalAlignment: TableCellVerticalAlignment.middle,
        //                           child: Text(
        //                             'بتاريخ',
        //                             style: styleHeader,
        //                           )),
        //                     ]),
        //                 if (snapshot.data!.isNotEmpty)
        //                   ...List.generate(snapshot.data!.length, (index) {
        //                     DocumentModel documentModel = snapshot.data![index];
        //                     return TableRow(
        //                         decoration: BoxDecoration(color: index.isEven ? Colors.grey[20] : Colors.white),
        //                         children: [
        //                           TableCell(
        //                               child: Text(
        //                             documentModel.id.toString(),
        //                             style: const TextStyle(fontSize: 10),
        //                           )),
        //                           TableCell(
        //                               child: Text(
        //                             documentModel.description,
        //                             style: const TextStyle(fontSize: 14),
        //                           )),
        //                           /* TableCell(
        //                       child: Text(
        //                         documentModel.from,
        //                         style: style,
        //                       )),*/
        //                           TableCell(child: Text(documentModel.to, style: style)),
        //                           TableCell(
        //                               child: Text(
        //                                   documentModel.replyFor != null ? documentModel.replyFor.toString() : '',
        //                                   style: style)),
        //                           TableCell(child: Text(documentModel.saveTo ?? '', style: style)),
        //                           TableCell(
        //                               child: Text(DateFormat('yyyy/MM/dd', 'ar').format(documentModel.createdAt),
        //                                   style: style)),
        //                         ]);
        //                   }),
        //               ],
        //             ),
        //           ],
        //         ),
        //       );
        //     } else if (snapshot.hasError) {
        //       return Center(
        //         child: Text(snapshot.error.toString()),
        //       );
        //     } else if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: ProgressBar(),
        //       );
        //     } else if (snapshot.data == null) {
        //       return Center(
        //         child: Text('لا يوجد بيانات'),
        //       );
        //     } else {
        //       return Center(
        //         child: Text('خطاء غير معروف'),
        //       );
        //     }
        //   },
        // ),
        // const SizedBox(height: 30),
        FutureBuilder(
      future: SqlHelper.getDocumentsWaitingToReply(),
      builder: (BuildContext context, AsyncSnapshot<List<DocumentModel>?> snapshot) {
        if (snapshot.data != null && snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(alignment: Alignment.bottomRight, child: Text('معاملات لم يتم الرد عليها')),
                Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.03),
                    1: FractionColumnWidth(0.45),
                    3: FractionColumnWidth(0.07),
                  },
                  border: TableBorder.symmetric(
                    outside: BorderSide.none,
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey[80],
                        ),
                        children: [
                          const TableCell(
                              child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              FluentIcons.numbered_list,
                              size: 10,
                            ),
                          )),
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(
                                'الموضوع',
                                style: styleHeader,
                              )),
                          /*
                        TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Text(
                              'الجهة المعدة',
                              style: styleHeader,
                            )), */
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(
                                'صادر للجهة ',
                                style: styleHeader,
                              )),
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(
                                'تسديد قيد ',
                                style: styleHeader,
                              )),
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(
                                'مكان الحفظ ',
                                style: styleHeader,
                              )),
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(
                                'بتاريخ',
                                style: styleHeader,
                              )),
                        ]),
                    ...List.generate(snapshot.data!.length, (index) {
                      DocumentModel doc = snapshot.data![index];
                      return TableRow(
                          decoration: BoxDecoration(color: index.isEven ? Colors.grey[20] : Colors.white),
                          children: [
                            TableCell(
                                child: Text(
                              doc.id.toString(),
                              style: const TextStyle(fontSize: 10),
                            )),
                            TableCell(
                                child: GestureDetector(
                              onDoubleTap: () => showDialog(
                                  context: context, builder: (context) => ShowDialogDocument(documentModel: doc)),
                              child: Text(
                                doc.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                            )),
                            /* TableCell(
                              child: Text(
                                doc.from,
                                style: style,
                              )),*/
                            TableCell(child: Text(doc.to, style: style)),
                            TableCell(child: Text(doc.replyFor != null ? doc.replyFor.toString() : '', style: style)),
                            TableCell(child: Text(doc.saveTo ?? '', style: style)),
                            TableCell(child: Text(DateFormat('yyyy/MM/dd', 'ar').format(doc.createdAt), style: style)),
                          ]);
                    }),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: ProgressBar(),
          );
        } else if (snapshot.data == null) {
          return Center(
            child: Text('لا يوجد بيانات'),
          );
        } else {
          return Center(
            child: Text('خطاء غير معروف'),
          );
        }
      },
    );
  }
}
