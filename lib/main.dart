import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'model/recurring_transaction.dart';
import 'providers/theme_provider.dart';
import 'routes.dart';
import 'utils/app_theme.dart';
import 'utils/notifications_service.dart';

late bool _isFirstLogin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().requestNotificationPermissions();
  NotificationService().initializeNotifications();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.local);

  SharedPreferences preferences = await SharedPreferences.getInstance();

  // Even though the saved key refers to a 'user first login',
  // the behavior mimics a 'has user completed onboarding process' check.
  // The key has not been renamed to maintain support for the app's previous versions.
  _isFirstLogin = preferences.getBool('is_first_login') ?? true;

  // perform recurring transactions checks
  DateTime? lastCheckGetPref = preferences.getString('last_recurring_transactions_check') != null ? DateTime.parse(preferences.getString('last_recurring_transactions_check')!) : null;
  DateTime? lastRecurringTransactionsCheck = lastCheckGetPref;

  if(lastRecurringTransactionsCheck == null || DateTime.now().difference(lastRecurringTransactionsCheck).inDays >= 1){
    RecurringTransactionMethods().checkRecurringTransactions();
    // update last recurring transactions runtime
    await preferences.setString('last_recurring_transactions_check', DateTime.now().toIso8601String());
  }

  initializeDateFormatting('it_IT', null).then((_) => runApp(Phoenix(child: const ProviderScope(child: Launcher()))));
}

class Launcher extends ConsumerWidget {
  const Launcher({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    return MaterialApp(
      title: 'Sossoldi',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appThemeState.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: makeRoute,
      initialRoute: _isFirstLogin ? '/onboarding' : '/',
    );
  }
}
