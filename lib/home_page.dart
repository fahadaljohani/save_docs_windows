import 'package:fluent_ui/fluent_ui.dart';
import 'package:save_docs/Repository/sql_helper.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:save_docs/pages/documents.dart';
import 'package:save_docs/pages/search.dart';
import 'package:save_docs/widgets/add_doc.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  List<DocumentModel>? listOfAllDocuments;
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    // getAllDocs();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  getAllDocs() async {
    listOfAllDocuments = await SqlHelper.getAllDocumnets();
    setState(() {});
  }

  int curIndex = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: Text(
          'متابعة المعاملات الواردة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
          displayMode: PaneDisplayMode.compact,
          selected: curIndex,
          size: const NavigationPaneSize(
            openMaxWidth: 200,
            openMinWidth: 80,
          ),
          onChanged: (value) {
            setState(() {
              curIndex = value;
            });
          },
          items: <NavigationPaneItem>[
            PaneItem(
              icon: const Icon(FluentIcons.new_folder),
              title: const Text('جديد'),
              body: Center(
                  child: GestureDetector(
                onTap: () async {
                  final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return const AddDocument();
                      });
                  if (result == true) {
                    curIndex = 1;
                    setState(() {});
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/add_doc.png'),
                    const Text('صادر جديد'),
                  ],
                ),
              )),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.document_management),
              title: const Text('المعاملات الصادرة'),
              body: const ShowDocuments(),
            ),
            PaneItem(icon: const Icon(FluentIcons.search), title: const Text('البحث'), body: const Search()),
            PaneItem(
                icon: const Icon(FluentIcons.info),
                title: const Text('تنفيذ'),
                body: const Center(child: Text('فكرة الرئيس بندر الحافضي وتنفيذ الرائد فهد الجهني'))),
          ]),
    );
  }
}
