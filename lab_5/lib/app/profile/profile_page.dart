import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';
import 'package:mad_flutter_practicum/app/utils/theme/theme_data.dart';
import 'package:mad_flutter_practicum/app/utils/theme_mode_ext.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:provider/provider.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';

part 'theme_mode_selector_bs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ValueNotifier<AppThemeMode> _themeModeNotifier = ValueNotifier(_settingsRepository.themeMode);

  SettingsRepository get _settingsRepository => context.read<SettingsRepository>();

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _themeModeNotifier,
              builder: (BuildContext context, AppThemeMode mode, Widget? child) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 24),
                  leading: Icon(Icons.dark_mode, color: colors.secondary),
                  title: child,
                  subtitle: Text(
                    mode.title,
                    style: fonts.regular12,
                  ),
                  onTap: () async {
                    final AppThemeMode? newMode = await ThemeModeSelectorBottomSheet.show(context, mode);
                    if (newMode == null) return;

                    _themeModeNotifier.value = newMode;
                  },
                );
              },
              child: Text(
                'Тема',
                style: fonts.regular16,
              ),
            ),

            // Grade 3: Clear Cache
            ListTile(
               contentPadding: EdgeInsets.only(left: 24),
               leading: Icon(Icons.delete, color: colors.secondary),
               title: Text('Очистить кэш', style: fonts.regular16),
               onTap: () async {
                   await context.read<CurrencyRepository>().clearCache();
                   await context.read<NewsRepository>().clearCache();
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Кэш очищен')));
               },
            ),

            // Grade 4: Last Updated
            FutureBuilder<DateTime?>(
                future: context.read<CurrencyRepository>().getLastUpdated(),
                builder: (context, snapshot) {
                    final date = snapshot.data;
                    String text = 'Нет данных';
                    if (date != null) {
                        text = DateFormat('dd.MM.yyyy HH:mm').format(date);
                    }
                    return ListTile(
                       contentPadding: EdgeInsets.only(left: 24),
                       leading: Icon(Icons.update, color: colors.secondary),
                       title: Text('Дата последнего обновления', style: fonts.regular16),
                       subtitle: Text(text, style: fonts.regular12),
                    );
                }
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: () => context.read<SettingsRepository>().setToken(null),
              child: Text(
                'Выйти',
                style: fonts.regular14.copyWith(color: context.colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
