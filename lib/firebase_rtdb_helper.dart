import 'package:firebase_database/firebase_database.dart';

class FirebaseRtdbHelper {
  static FirebaseDatabase? _database;

  static FirebaseDatabase get database {
    // if (_database == null) {
    //   _database = FirebaseDatabase.instanceFor(
    //     app: FirebaseDatabase.instance.app,
    //     databaseURL:
    //         'https://dental-clinic-b0628-default-rtdb.asia-southeast1.firebasedatabase.app',
    //   );
    //   // NOTE: setPersistenceEnabled(true) is removed here because it causes Unhandled PlatformException
    //   // on Flutter Hot Restart due to the native Android SDK retaining its state while the Dart isolate restarts.
    //   // If offline persistence is critically needed, it should be set natively or errors ignored during development.

    //   //old code that cause error
    //   // try {
    //   //   // يتم تفعيل الوضع الافتراضي (Offline) مرة واحدة فقط على مستوى التطبيق.
    //   //   _database!.setPersistenceEnabled(true);
    //   // } catch (e) {
    //   //   debugPrint('Firebase Database persistence already enabled: $e');
    //   // }
    // }
    return _database ??= FirebaseDatabase.instanceFor(
      app: FirebaseDatabase.instance.app,
      databaseURL:
          'https://captain-masr-4acb2-default-rtdb.asia-southeast1.firebasedatabase.app',
    );
  }

  static Future<void> incrementInvoiceCounter(int id) async {
    final ref = database.ref().child('invoices/$id');
    try {
      await ref.runTransaction((Object? post) {
        if (post == null) {
          return Transaction.success({'invoice_num': 1});
        }
        Map<String, dynamic> data = Map<String, dynamic>.from(post as Map);
        int invoiceNum =
            int.tryParse(data['invoice_num']?.toString() ?? '0') ?? 0;
        data['invoice_num'] = invoiceNum + 1;
        return Transaction.success(data);
      });
    } catch (e) {
      // Logic for handling errors can be added here
    }
  }

  static Future<void> resetInvoiceCounter(int id) async {
    await database.ref().child('invoices/$id').update({'invoice_num': 0});
  }
}
