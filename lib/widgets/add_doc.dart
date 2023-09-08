import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_docs/Repository/sql_helper.dart';
import 'package:save_docs/constants.dart';
import 'package:save_docs/models/doc_model.dart';
import 'package:window_manager/window_manager.dart';

class AddDocument extends StatefulWidget {
  final DocumentModel? documentModel;

  const AddDocument({super.key, this.documentModel});

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> with WindowListener {
  int? isSelected;
  int indexSelection = 0;
  late TextEditingController attachNumberController;
  late TextEditingController descriptionController;
  late TextEditingController replyToController;
  late TextEditingController saveToController;
  late TextEditingController documentIDController;

  String? toSectionSelected;
  String? fromSectionSelected;
  File? _selectedImage;

  void pickedImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print(pickedImage.path);
      print(pickedImage.name);
      print(pickedImage);
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    attachNumberController = TextEditingController(text: widget.documentModel?.attachNumber.toString());
    descriptionController = TextEditingController(text: widget.documentModel?.description);
    documentIDController = TextEditingController(text: widget.documentModel?.documentID);
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
    final size = MediaQuery.of(context).size;
    print('rebuild');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: material.Dialog(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: size.width * 0.70, maxHeight: size.height * 0.98, minHeight: size.height * 0.97),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.documentModel == null
                        ? indexSelection == 1
                            ? 'وارد جديد'
                            : 'صادر جديد'
                        : 'تعديل الصادر',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: size.height * 0.90,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('نوع المعاملة'),
                                    const SizedBox(height: 5),
                                    Row(
                                        children: List.generate(
                                      2,
                                      (index) {
                                        return Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: RadioButton(
                                              checked: isSelected == index, // you have to chagne it to indexSelection.
                                              content: Text(index == 0 ? 'صادر' : 'وارد'),
                                              onChanged: (checked) {
                                                if (checked) {
                                                  setState(() {
                                                    isSelected = indexSelection = index;
                                                  });
                                                }
                                              }),
                                        );
                                      },
                                    )),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('رقم الخطاب'),
                                    const SizedBox(height: 5),
                                    TextBox(
                                      autocorrect: false,
                                      // autofillHints: true,
                                      autofocus: true,
                                      controller: documentIDController,
                                      foregroundDecoration:
                                          const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                                      placeholder: 'رقم الخطاب',
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('الجهة المعدة'),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ComboBox<String>(
                                        value: fromSectionSelected,
                                        items: kConstant.sections.map<ComboBoxItem<String>>((e) {
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
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('صادر للجهة'),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ComboBox<String>(
                                        value: toSectionSelected,
                                        items: kConstant.sections.map<ComboBoxItem<String>>((e) {
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
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('الموضوع'),
                                    const SizedBox(height: 5),
                                    TextBox(
                                      autocorrect: false,
                                      // autofillHints: true,
                                      autofocus: true,
                                      controller: descriptionController,
                                      foregroundDecoration:
                                          const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                                      placeholder: 'الموضوع',
                                      minLines: 8,
                                      maxLines: 10,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ],
                                ),
                                if (indexSelection == 0) ...[
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('تسديد قيد'),
                                      const SizedBox(height: 5),
                                      TextBox(
                                        autocorrect: false,
                                        // autofillHints: true,
                                        autofocus: false,
                                        controller: replyToController,
                                        foregroundDecoration:
                                            const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                                        placeholder: 'تسديد قيد',
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      ),
                                    ],
                                  )
                                ],
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('عدد المرفقات'),
                                    const SizedBox(height: 5),
                                    TextBox(
                                      autocorrect: false,
                                      // autofillHints: true,
                                      autofocus: false,
                                      controller: attachNumberController,
                                      foregroundDecoration:
                                          const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                                      placeholder: 'عدد المرفقات',
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('مكان الحفظ'),
                                    const SizedBox(height: 5),
                                    TextBox(
                                      autocorrect: false,
                                      // autofillHints: true,
                                      autofocus: false,
                                      controller: saveToController,
                                      foregroundDecoration:
                                          const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                                      placeholder: 'مكان الحفظ',
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: pickedImage,
                          child: SizedBox(
                            height: size.height * 0.90,
                            child: Container(
                              margin: const EdgeInsets.only(left: 7.0),
                              child: DottedBorder(
                                dashPattern: const [10, 4],
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                radius: const Radius.circular(10),
                                color: Colors.black,
                                child: Center(
                                  child: _selectedImage != null
                                      ? Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.fill,
                                        )
                                      : Icon(
                                          FluentIcons.camera,
                                          size: 40,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0).copyWith(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Button(
                            style:
                                ButtonStyle(padding: ButtonState.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10))),
                            child: const Text(
                              'الغاء',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            onPressed: () => Navigator.pop(context, 0),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: FilledButton(
                              style:
                                  ButtonStyle(padding: ButtonState.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10))),
                              child: Text(
                                widget.documentModel == null ? 'حفظ' : 'تحديث',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              onPressed: () async {
                                if (toSectionSelected == null ||
                                    descriptionController.text.isEmpty ||
                                    fromSectionSelected == null ||
                                    documentIDController.text.isEmpty) {
                                  return;
                                } else {
                                  final documentModel = DocumentModel(
                                    id: widget.documentModel?.id,
                                    to: toSectionSelected!,
                                    from: fromSectionSelected!,
                                    description: descriptionController.text,
                                    attachNumber: attachNumberController.text.isNotEmpty
                                        ? int.parse(attachNumberController.text)
                                        : 0,
                                    createdAt: widget.documentModel?.createdAt ?? DateTime.now(),
                                    replyFor: replyToController.text != '' ? int.parse(replyToController.text) : null,
                                    saveTo: saveToController.text,
                                    documentID: documentIDController.text,
                                    imageUrl: _selectedImage != null ? _selectedImage!.path : null,
                                  );
                                  if (widget.documentModel != null) {
                                    indexSelection == 0
                                        ? await SqlHelper.updateDocument(documentModel)
                                        : await SqlHelper.updateToInDocument(documentModel);
                                  } else {
                                    indexSelection == 0
                                        ? await SqlHelper.addDocument(documentModel)
                                        : await SqlHelper.addToInDocument(documentModel);
                                  }
                                  if (!mounted) return;
                                  Navigator.pop(context, indexSelection == 0 ? 1 : 2);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



 // // actions: [
          // //   Button(
          // //     child: const Text('الغاء'),
          // //     onPressed: () => Navigator.pop(context, 0),
          // //   ),
          // //   FilledButton(
          // //       child: Text(widget.documentModel == null ? 'حفظ' : 'تحديث'),
          // //       onPressed: () async {
          // //         if (toSectionSelected == null ||
          // //             descriptionController.text.isEmpty ||
          // //             fromSectionSelected == null ||
          // //             documentIDController.text.isEmpty) {
          // //           return;
          // //         } else {
          // //           final documentModel = DocumentModel(
          // //             id: widget.documentModel?.id,
          // //             to: toSectionSelected!,
          // //             from: fromSectionSelected!,
          // //             description: descriptionController.text,
          // //             attachNumber: attachNumberController.text.isNotEmpty ? int.parse(attachNumberController.text) : 0,
          // //             createdAt: widget.documentModel?.createdAt ?? DateTime.now(),
          // //             replyFor: replyToController.text != '' ? int.parse(replyToController.text) : null,
          // //             saveTo: saveToController.text,
          // //             documentID: documentIDController.text,
          // //           );
          // //           if (widget.documentModel != null) {
          // //             indexSelection == 0
          // //                 ? await SqlHelper.updateDocument(documentModel)
          // //                 : await SqlHelper.updateToInDocument(documentModel);
          // //           } else {
          // //             indexSelection == 0
          // //                 ? await SqlHelper.addDocument(documentModel)
          // //                 : await SqlHelper.addToInDocument(documentModel);
          // //           }
          // //           if (!mounted) return;
          // //           Navigator.pop(context, indexSelection == 0 ? 1 : 2);
          // //         }
          // //       }),
          // ],

