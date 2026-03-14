import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'presentation/screens/property_list_screen.dart';
import 'presentation/viewmodels/property_list_viewmodel.dart';
import 'presentation/viewmodels/property_details_viewmodel.dart';
import 'core/di/accessibility/accessibility_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await AppTheme.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<ThemeService>()),
        ChangeNotifierProvider(create: (_) => di.sl<PropertyDetailsViewModel>()),
        BlocProvider(create: (_) => di.sl<PropertyListViewModel>()),
        Provider(create: (_) => di.sl<AccessibilityService>()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'EstateView',
            theme: AppTheme.getTheme(themeService.isDarkMode),
            home: const PropertyListScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
