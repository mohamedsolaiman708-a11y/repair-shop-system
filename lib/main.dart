import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/supabase_constants.dart';

void main() {
  // 1. تشغيل المحرك فوراً لضمان سيطرة فلاتر على الشاشة وإخفاء لوادر الـ HTML
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: MaintenanceCenterApp(),
    ),
  );
}

class MaintenanceCenterApp extends StatefulWidget {
  const MaintenanceCenterApp({super.key});

  @override
  State<MaintenanceCenterApp> createState() => _MaintenanceCenterAppState();
}

class _MaintenanceCenterAppState extends State<MaintenanceCenterApp> {
  bool _isInitialized = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initSystem();
  }

  Future<void> _initSystem() async {
    try {
      setState(() {
        _initError = null;
        _isInitialized = false;
      });

      // تنظيف المتغيرات من أي علامات تنصيص زائدة
      final url = SupabaseConstants.url.replaceAll('"', '').replaceAll("'", "").trim();
      final key = SupabaseConstants.anonKey.replaceAll('"', '').replaceAll("'", "").trim();

      if (url.isEmpty || key.isEmpty) {
        throw 'مفاتيح الربط (API Keys) مفقودة. يرجى التأكد من إضافتها في Vercel.';
      }

      // تهيئة سوبابيس داخل واجهة فلاتر باستخدام المسمى الجديد
      await Supabase.initialize(
        url: url, 
        anonKey: key, // استخدام anonKey تماشياً مع التحديثات الأخيرة
      );

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _initError = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // شاشة عرض الأخطاء بأسلوب مركز الصيانة
    if (_initError != null) {
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
                  const Icon(Icons.cloud_off, color: Colors.red, size: 70),
                  const SizedBox(height: 20),
                  const Text('تعذر الاتصال بمركز البيانات', 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(_initError!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _initSystem,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // شاشة انتظار داخل فلاتر (تضمن اختفاء شاشة الـ HTML فوراً)
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 25),
                Text('جاري تهيئة مركز الصيانة...', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      );
    }

    // تشغيل السيستم الحقيقي
    return const RepairSystemMain();
  }
}

class RepairSystemMain extends ConsumerWidget {
  const RepairSystemMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'مركز الصيانة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
