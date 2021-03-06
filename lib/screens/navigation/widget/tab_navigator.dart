import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/config/custom_router.dart';
import 'package:codespot/enums/enums.dart';
import 'package:codespot/repositories/chat/chat_repository.dart';
import 'package:codespot/screens/chat/cubit/message_cubit.dart';
import 'package:codespot/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = "/";
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilder = _routeBuilder();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilder[initialRoute]!(context),
          ),
        ];
      },
    );
  }

  Map<String, WidgetBuilder> _routeBuilder() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.home:
        return const HomePage();
      case BottomNavItem.chat:
        return const ChatScreen();
      case BottomNavItem.profile:
        return const ProfileScreren();
      default:
        return const Scaffold();
    }
  }
}
