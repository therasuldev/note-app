import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/app_scaffold.dart';
import 'package:note_app/core/models/note/note.dart';
import 'package:note_app/core/provider/note_bloc/note_bloc.dart';
import 'package:note_app/core/provider/search_note_bloc/search_bloc.dart';
import 'package:note_app/core/provider/theme/theme_cubit.dart';
import 'package:note_app/core/provider/theme/theme_state.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await path.getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  //await Hive.deleteBoxFromDisk('notes');

  if (!(Hive.isAdapterRegistered(0))) {
    Hive.registerAdapter(NoteAdapter());
  }

  await Hive.openBox<Note>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NoteBloc()),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => ThemeCubit()..getTheme),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Note app',
            debugShowCheckedModeBanner: false,
            theme: state.theme,
            home: const AppScaffold(),
          );
        },
      ),
    );
  }
}
