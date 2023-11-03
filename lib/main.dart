import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_project/config/app_theme.dart';
import 'package:new_project/config/routes.dart';
import 'package:new_project/config/shared_pref.dart';
import 'package:new_project/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: 'Main Navigator');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await SharedPref.init();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en', 'US'), Locale('my', 'MM')],
    path: 'languages',
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Happy Cooky',
      navigatorKey: navigatorKey,
      onGenerateRoute: Routes.routeGenerator,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ExpansionTile(
              collapsedBackgroundColor: AppTheme.grey.withOpacity(.2),
              iconColor: AppTheme.deactivatedText,
              textColor: AppTheme.deactivatedText,
              collapsedTextColor: AppTheme.deactivatedText,
              collapsedIconColor: AppTheme.deactivatedText,
              title: Text(tr('Cluster')),
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 300,
                  child: NotificationListener<OverscrollNotification>(
                    onNotification: (OverscrollNotification value) {
                      if (value.overscroll < 0 &&
                          scrollController.offset + value.overscroll <= 0) {
                        if (scrollController.offset != 0) {
                          scrollController.jumpTo(0);
                        }
                        return true;
                      }
                      if (scrollController.offset + value.overscroll >=
                          scrollController.position.maxScrollExtent) {
                        if (scrollController.offset !=
                            scrollController.position.maxScrollExtent) {
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent);
                        }
                        return true;
                      }
                      scrollController
                          .jumpTo(scrollController.offset + value.overscroll);
                      return true;
                    },
                    child: SingleChildScrollView(
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(3, (index) => Container()),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
