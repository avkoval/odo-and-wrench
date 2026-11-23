// Entry point. The app is ClojureDart (src/, compiled to lib/cljd-out/); this file only adds what has to be written
// in Dart: the background entry point of the reminder job (D9), which needs @pragma('vm:entry-point').
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'cljd-out/auto-maintenance/main.dart' as app;
import 'cljd-out/auto-maintenance/reminders.dart' as reminders;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, input) async {
    await reminders.run_task();
    return true;
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);
  await app.main();
}
