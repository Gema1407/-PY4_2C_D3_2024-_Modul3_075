import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logbook_app_075/features/logbook/log_controller.dart'; 

void main() {
  group('Module 3 - LogController (Save Data to Disk)', () {
    late LogController controller;
    const username = "admin";

    setUp(() async {
      // (1) setup (arrange, build)
      SharedPreferences.setMockInitialValues({}); 
      
      controller = LogController(username);
      await Future.delayed(Duration.zero); 
    });

    test('TC01: addLog should add a valid log to the list (Positif)', () {
      // (1) setup
      final initialLength = controller.logsNotifier.value.length;
      const testTitle = "Tugas Praktikum";
      const testDesc = "Membuat unit test modul 3";

      // (2) exercise (act, operate)
      controller.addLog(testTitle, testDesc);

      // (3) verify (assert, check)
      final currentLogs = controller.logsNotifier.value;
      expect(currentLogs.length, initialLength + 1, reason: 'Panjang list harusnya bertambah 1');
      expect(currentLogs.last.title, testTitle, reason: 'Judul log terakhir harus sesuai dengan yang diinput');
    });

    test('TC02: addLog should reject log with empty title and description (Negatif)', () {
      // (1) setup
      final initialLength = controller.logsNotifier.value.length;

      // (2) exercise (act, operate)
      controller.addLog("", "");

      // (3) verify (assert, check)
      expect(
        controller.logsNotifier.value.length, 
        initialLength, 
        reason: 'Sistem harus menolak log kosong, panjang list tidak boleh bertambah'
      );
    });

    test('TC03: addLog should persist data to SharedPreferences (Positif)', () async {
      // (1) setup
      const testTitle = "Persistent Data";
      const testDesc = "Harus tersimpan di disk";
      controller.addLog(testTitle, testDesc);
      
      await Future.delayed(Duration.zero); 

      // (2) exercise (act, operate)
      final newController = LogController(username);
      await newController.loadFromDisk();

      // (3) verify (assert, check)
      final loadedLogs = newController.logsNotifier.value;
      expect(loadedLogs.isNotEmpty, true, reason: 'Data dari disk tidak boleh kosong');
      expect(loadedLogs.last.title, testTitle, reason: 'Data yang dimuat dari disk harus sama dengan yang disimpan');
    });
  });
}