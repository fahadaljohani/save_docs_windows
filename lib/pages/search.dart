import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:save_docs/Repository/sql_helper.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:save_docs/widgets/add_doc.dart';
import 'package:window_manager/window_manager.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with WindowListener {
  List<DocumentModel>? tempList = [];

  late TextEditingController searchController;

  void filteredSearchQuery(String searchText) async {
    List<DocumentModel>? filteredList = await SqlHelper.getAllDocumnets();
    if (filteredList == null) return;
    tempList = filteredList.where((element) => element.description.contains(searchText)).toList();
    filteredList = [];
    setState(() {});
  }

  @override
  void initState() {
    windowManager.addListener(this);
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    super.dispose();
  }

  final style = TextStyle(fontSize: 12, color: Colors.grey[100]);
  final styleHeader = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .50,
                margin: const EdgeInsets.only(right: 5),
                child: TextBox(
                  controller: searchController,
                  placeholder: 'بحث في معاملات الصادرة',
                  foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                  decoration: BoxDecoration(color: Colors.grey[30]),
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FluentIcons.search,
                      color: Colors.grey[130],
                    ),
                  ),
                  onChanged: (value) {
                    filteredSearchQuery(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Table(
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
              if (tempList != null && tempList!.isNotEmpty && searchController.text != '')
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
                        TableCell(child: Text(doc.replyFor != null ? doc.replyFor.toString() : '', style: style)),
                        TableCell(child: Text(doc.saveTo ?? '', style: style)),
                        TableCell(child: Text(DateFormat('yyyy/MM/dd', 'ar').format(doc.createdAt), style: style)),
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
                })
            ],
          ),
        ]),
      ),
    );
  }
}
