import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hd_wallet_flutter/ui/component/tabbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hd_wallet_flutter/ui/nft_list.dart';
import 'package:hd_wallet_flutter/ui/wallet.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:uuid/uuid.dart';

class RootPage extends HookWidget {
  static Widget init() {
    return RootPage(
      key: Key(const Uuid().v4()),
    );
  }

  RootPage({Key? key}) : super(key: key);

  late final PersistentTabController _tabController;
  final List<GlobalKey<NavigatorState>> globalKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    final tabIndex = useState(0);

    useEffect(() {
      _tabController = PersistentTabController(initialIndex: 0);
      return () {};
    }, const []);

    _tabController.index = tabIndex.value;

    return PersistentTabView.custom(
      context,
      controller: _tabController,
      screens: [
        WalletPage(key: globalKeys[0]),
        NftListPage(key: globalKeys[1]),
      ],
      onWillPop: (context) async {
        final isFirstRouteInCurrentTab =
            !await globalKeys[_tabController.index].currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          return isFirstRouteInCurrentTab;
        }

        return false;
      },
      itemCount: globalKeys.length,
      customWidget: CustomTabBar(
        items: [
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.account_balance_wallet),
            title: "ウォレット",
            activeColorPrimary: ThemeData().primaryColor,
            inactiveColorPrimary: CupertinoColors.systemGrey,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.folder),
            title: "NFT",
            activeColorPrimary: ThemeData().primaryColor,
            inactiveColorPrimary: CupertinoColors.systemGrey,
          ),
        ],
        selectedIndex: _tabController.index,
        onItemSelected: (index) {
          if (_tabController.index == index) {
            Navigator.popUntil(globalKeys[index].currentContext!,
                (Route<dynamic> route) => route.isFirst);
            return;
          }

          tabIndex.value = index;
        },
      ),
      confineInSafeArea: true,
      backgroundColor: ThemeData.dark().colorScheme.background,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      screenTransitionAnimation:
          const ScreenTransitionAnimation(animateTabTransition: false),
    );
  }
}
