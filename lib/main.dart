import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/camera_service.dart';
import 'services/gallery_service.dart';
import 'services/editor_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CamarooApp());
}

class CamarooApp extends StatelessWidget {
  const CamarooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraService()),
        ChangeNotifierProvider(create: (_) => GalleryService()),
        ChangeNotifierProvider(create: (_) => EditorService()),
      ],
      child: MaterialApp(
        title: 'Camaroo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
