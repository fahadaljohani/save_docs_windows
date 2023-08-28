import 'dart:io';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:save_docs/Repository/sql_helper.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:save_docs/widgets/add_doc.dart';
import 'package:window_manager/window_manager.dart';

class ShowDocuments extends StatefulWidget {
  const ShowDocuments({super.key});

  @override
  State<ShowDocuments> createState() => _ShowDocumentsState();
}

class _ShowDocumentsState extends State<ShowDocuments> with WindowListener {
  List<DocumentModel>? tempList = [];
  @override
  void initState() {
    getDocuments();
    windowManager.addListener(this);
    super.initState();
  }

  exportToExel() {
    print('-----exportToExel----');
    if (tempList == null || tempList!.isEmpty) return;
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet() as String];
    // sheet!.setColWidth(2, 50);
    sheet!.setColAutoFit(1);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = '-';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = 'الموضوع';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value = "الجهة المعدة";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value = "صادر الى";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value = "تسديد قيد";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value = "مكان الحفظ";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0)).value = "التاريخ";
    // sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).cellStyle!.backgroundColor = Color("faf487");

    for (var i = 0; i < tempList!.length; i++) {
      var doc = tempList![i];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i)).value = doc.id;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i)).value = doc.description;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i)).value = doc.from;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i)).value = doc.to;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i)).value = doc.replyFor;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i)).value = doc.saveTo;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i)).value =
          DateFormat('dd/MM/yyyy').format(doc.createdAt);
    }
    final byte = excel.save(fileName: '’متابعة العاملات.xlsx');
    File('معاملاتي.xlsx').writeAsBytes(byte!);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  getDocuments() async {
    tempList = await SqlHelper.getAllDocumnets();
    if (!mounted) return;
    setState(() {});
  }

  final style = TextStyle(fontSize: 12, color: Colors.grey[100], overflow: TextOverflow.ellipsis);
  final styleHeader = const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis);

  @override
  Widget build(BuildContext context) {
    getDocuments();
    return tempList != null && tempList!.isNotEmpty
        ? Column(
            children: [
              Align(alignment: Alignment.topLeft, child: Button(onPressed: () => exportToExel(), child: Text('تصدير'))),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Table(
                      columnWidths: const {
                        0: FractionColumnWidth(0.03),
                        1: FractionColumnWidth(0.45),
                        // 2: FractionColumnWidth(0.11),
                        // 2: FractionColumnWidth(0.11),
                        3: FractionColumnWidth(0.07),
                        6: FractionColumnWidth(0.07)
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
                              const TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle, child: Icon(FluentIcons.more)),
                            ]),
                        ...List.generate(tempList!.length, (index) {
                          final doc = tempList![index];
                          return TableRow(
                              decoration: BoxDecoration(color: index.isEven ? Colors.grey[20] : Colors.white),
                              children: [
                                TableCell(
                                    child: Text(
                                  doc.id.toString(),
                                  style: const TextStyle(fontSize: 10),
                                )),
                                TableCell(
                                    child: Text(
                                  doc.description,
                                  style: const TextStyle(fontSize: 14),
                                )),
                                /* TableCell(
                                    child: Text(
                                      doc.from,
                                      style: style,
                                    )),*/
                                TableCell(child: Text(doc.to, style: style)),
                                TableCell(
                                    child: Text(doc.replyFor != null ? doc.replyFor.toString() : '', style: style)),
                                TableCell(child: Text(doc.saveTo ?? '', style: style)),
                                TableCell(
                                    child: Text(DateFormat('yyyy/MM/dd', 'ar').format(doc.createdAt), style: style)),
                                TableCell(
                                  child: DropDownButton(
                                      title: const Icon(
                                        FluentIcons.more,
                                        size: 10,
                                      ),
                                      items: [
                                        MenuFlyoutItem(
                                            text: const Text('تعديل'),
                                            onPressed: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AddDocument(
                                                    documentModel: doc,
                                                  );
                                                }),
                                            leading: const Icon(
                                              FluentIcons.edit,
                                              size: 10,
                                            )),
                                        MenuFlyoutItem(
                                            text: const Text('حذف'),
                                            onPressed: () async {
                                              final result = await SqlHelper.deleteDocument(doc);
                                              if (result != 0) {
                                                tempList = await SqlHelper.getAllDocumnets();
                                                setState(() {});
                                              }
                                            },
                                            leading: Icon(
                                              FluentIcons.delete,
                                              color: Colors.red,
                                              size: 10,
                                            )),
                                      ]),
                                ),
                              ]);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : const Center(child: Text('لا يوجد بيانات'));
  }
}
