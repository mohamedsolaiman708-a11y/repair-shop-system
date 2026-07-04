import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/supabase_constants.dart';

void main() async {
  // 1. ضمان تهيئة محرك فلاتر
  WidgetsFlutterBinding.ensureInitialized();
  
  String? initError;
  
  try {
    // 2. تنظيف الروابط
    final url = SupabaseConstants.url.replaceAll('"', '').replaceAll("'", "").trim();
    final key = SupabaseConstants.anonKey.replaceAll('"', '').replaceAll("'", "").trim();

    if (url.isEmpty || !url.startsWith('http')) {
      throw 'رابط Supabase غير صحيح. تأكد من إعدادات البيئة (Environment Variables).';
    }

    // 3. التهيئة قبل تشغيل الواجهة لضمان عدم حدوث Null Check Error
    await Supabase.initialize(
      url: url,
      anonKey: key,
      debug: true,
    );
  } catch (e) {
    initError = e.toString();
  }

  runApp(
    ProviderScope(
      child: MaintenanceCenterApp(error: initError),
    ),
  );
}

class MaintenanceCenterApp extends StatelessWidget {
  final String? error;
  const MaintenanceCenterApp({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    // عرض شاشة خطأ واضحة إذا فشلت التهيئة
    if (error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 70),
                  const SizedBox(height: 20),
                  const Text('خطأ في تهيئة النظام', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const RepairSystemMain();
  }
}

class RepairSystemMain extends ConsumerWidget {
  const RepairSystemMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // الـ Router لن يعمل إلا بعد أن تكون سوبابيس جاهزة تماماً
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'مركز الصيانة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
