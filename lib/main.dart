import 'package:fluent_ui/fluent_ui.dart';
import 'package:save_docs/home_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
      title: 'متابعة المعاملات',
      size: Size(1400, 800),
      maximumSize: Size(2000, 1200),
      minimumSize: Size(1400, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: true,
      titleBarStyle: TitleBarStyle.hidden);
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  // Initialize FFI
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;
  // await Window.initialize();
  // await Window.setEffect(
  //   effect: WindowEffect.acrylic,
  //   color: const Color(0xCC222222),
  // );
  // await Window.setEffect(
  //   effect: WindowEffect.mica,
  //   dark: true,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'save documents',
      home: Directionality(textDirection: TextDirection.rtl, child: HomePage()),
    );
  }
}
