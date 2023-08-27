import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:save_docs/Repository/sql_helper.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:window_manager/window_manager.dart';

class AddDocument extends StatefulWidget {
  final DocumentModel? documentModel;

  const AddDocument({super.key, this.documentModel});

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> with WindowListener {
  late TextEditingController attachNumberController;
  late TextEditingController descriptionController;
  late TextEditingController replyToController;
  late TextEditingController saveToController;
  List<String> allSections = [
    'ادارة العمليات',
    'ادارة السلامة',
    'ادارة الشوون الادارية',
    'شعبة الموارد البشرية',
    'شعبة الشوون الفنية',
    'شعبة التميز الموسسي',
    'شعبة المراجعة الداخلية ',
    'شعبة الإعلام والإتصال الموسسي ',
    'شعبة الإتصالات وتقنية المعلومات',
  ];
  String? toSectionSelected;
  String? fromSectionSelected;

  @override
  void initState() {
    super.initState();
    attachNumberController = TextEditingController(text: widget.documentModel?.attachNumber.toString());
    descriptionController = TextEditingController(text: widget.documentModel?.description);
    toSectionSelected = widget.documentModel?.to;
    fromSectionSelected = widget.documentModel?.from;
    replyToController = TextEditingController(
        text: widget.documentModel?.replyFor != null ? widget.documentModel!.replyFor.toString() : '');
    saveToController = TextEditingController(text: widget.documentModel?.saveTo);
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    attachNumberController.dispose();
    replyToController.dispose();
    saveToController.dispose();
    windowManager.removeListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ContentDialog(
        title: Text(widget.documentModel == null ? 'صادر جديد' : 'تعديل الصادر'),
        content: ListView(shrinkWrap: true, children: [
          ComboBox<String>(
            value: fromSectionSelected,
            items: allSections.map<ComboBoxItem<String>>((e) {
              return ComboBoxItem<String>(
                value: e,
                child: Text(e),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => fromSectionSelected = value!);
            },
            placeholder: const Text('الجهة المعدة'),
            autofocus: false,
          ),
          const SizedBox(height: 20),
          ComboBox<String>(
            value: toSectionSelected,
            items: allSections.map<ComboBoxItem<String>>((e) {
              return ComboBoxItem<String>(
                value: e,
                child: Text(e),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => toSectionSelected = value);
            },
            placeholder: const Text('صادر الى الجهة'),
            autofocus: true,
          ),
          const SizedBox(height: 20),
          TextBox(
            autocorrect: false,
            // autofillHints: true,
            autofocus: true,
            controller: descriptionController,
            foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
            placeholder: 'الموضوع',
            minLines: 8,
            maxLines: 10,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 15),
          TextBox(
            autocorrect: false,
            // autofillHints: true,
            autofocus: false,
            controller: replyToController,
            foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
            placeholder: 'تسديد قيد',
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 15),
          TextBox(
            autocorrect: false,
            // autofillHints: true,
            autofocus: false,
            controller: attachNumberController,
            foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
            placeholder: 'عدد المرفقات',
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 15),
          TextBox(
            autocorrect: false,
            // autofillHints: true,
            autofocus: false,
            controller: saveToController,
            foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
            placeholder: 'مكان الحفظ',
            textInputAction: TextInputAction.done,
          ),
        ]),
        actions: [
          Button(
            child: const Text('الغاء'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FilledButton(
              child: Text(widget.documentModel == null ? 'حفظ' : 'تحديث'),
              onPressed: () async {
                if (toSectionSelected == null || descriptionController.text.isEmpty || fromSectionSelected == null) {
                  return;
                } else {
                  final documentModel = DocumentModel(
                    id: widget.documentModel?.id,
                    to: toSectionSelected!,
                    from: fromSectionSelected!,
                    description: descriptionController.text,
                    attachNumber: attachNumberController.text.isNotEmpty ? int.parse(attachNumberController.text) : 0,
                    createdAt: widget.documentModel?.createdAt ?? DateTime.now(),
                    replyFor: replyToController.text != '' ? int.parse(replyToController.text) : null,
                    saveTo: saveToController.text,
                  );
                  if (widget.documentModel != null) {
                    await SqlHelper.updateDocument(documentModel);
                  } else {
                    await SqlHelper.addDocument(documentModel);
                  }
                  if (!mounted) return;
                  Navigator.pop(context, true);
                }
              }),
        ],
      ),
    );
  }
}
