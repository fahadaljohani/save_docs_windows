import 'package:fluent_ui/fluent_ui.dart';
import 'package:save_docs/models/doc_model.dart';

class ShowDialogDocument extends StatelessWidget {
  final DocumentModel documentModel;
  const ShowDialogDocument({super.key, required this.documentModel});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ContentDialog(
        title: Text('التفاصيل'),
        content: ListView(shrinkWrap: true, children: [
          // Row(
          //     children: List.generate(
          //   2,
          //   (index) {
          //     return Container(
          //       margin: const EdgeInsets.only(right: 10),
          //       child: RadioButton(
          //           checked: isSelected == index,
          //           content: Text(index == 0 ? 'صادر' : 'وارد'),
          //           onChanged: (checked) {
          //             if (checked) {
          //               setState(() {
          //                 isSelected = indexSelection = index;
          //               });
          //             }
          //           }),
          //     );
          //   },
          // )),
          // const SizedBox(height: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(alignment: Alignment.bottomRight, child: Text('رقم الخطاب')),
              TextBox(
                readOnly: true,
                foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                placeholder: documentModel.documentID,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Text('الجهة المعدة'),
              ),
              TextBox(
                readOnly: true,
                foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                placeholder: documentModel.from,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Text('الجهة الصادرة'),
              ),
              TextBox(
                readOnly: true,
                foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                placeholder: documentModel.to,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Text('وصف المعاملة'),
              ),
              TextBox(
                readOnly: true,
                foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                placeholder: documentModel.description,
                minLines: 8,
                maxLines: 10,
              ),
            ],
          ),

          const SizedBox(height: 15),
          Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Text('تسديد قيد'),
              ),
              TextBox(
                readOnly: true,
                foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                placeholder: documentModel.replyFor != null ? 'نعم' : 'لا',
              ),
            ],
          ),

          const SizedBox(height: 15),
          Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Text('المرفقات'),
              ),
              TextBox(
                readOnly: true,
                foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                placeholder: documentModel.attachNumber.toString(),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Text('ملف الحفظ'),
              ),
              TextBox(
                readOnly: true,
                foregroundDecoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                placeholder: documentModel.saveTo,
              ),
            ],
          ),
        ]),
        actions: [
          FilledButton(
            child: const Text('رجوع'),
            onPressed: () => Navigator.pop(context, 0),
          ),
        ],
      ),
    );
  }
}
