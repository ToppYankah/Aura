import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/screens/home_screen/widgets/bottom_navigation/home_bottom_navigation.dart';
import 'package:flutter/material.dart';

class HomeRouter {
  final List<HomeScreenPage> _stack = [];

  HomeRouter();

  HomeScreenPage get current => _stack.last;

  bool get hasRoute => _stack.isNotEmpty;

  HomeScreenPage pop() => _stack.removeLast();

  set current(HomeScreenPage page) {
    if (_stack.contains(page)) _stack.remove(page);
    _stack.add(page);
  }
}

class HomeScreen extends StatefulWidget {
  final HomeScreenPage? page;
  const HomeScreen({Key? key, this.page}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeRouter _router = HomeRouter();
  late final PageController _pageController;
  final ValueNotifier<HomeScreenPage> _currentPage =
      ValueNotifier<HomeScreenPage>(HomeScreenPage.home);
  final Map<HomeScreenPage, HomePageItem> _pages = HomeScreenConfig.pages;

  @override
  void initState() {
    super.initState();

    int initialPage = 0;

    _router.current = _currentPage.value;

    if (widget.page != null) {
      _currentPage.value = widget.page!;
      initialPage = widget.page!.index;
    }

    _pageController = PageController(initialPage: initialPage);

    CommonUtils.initializeAutoReloadLatestMeasurements(context);
  }

  Future<bool> _handleWillPop() async {
    bool output = true;

    _router.pop();
    if (_router.hasRoute) {
      output = false;
      _currentPage.value = _router.current;
      _handleNavigationChange(_router.current);
    }

    return output;
  }

  void _addPageToRouteStack(HomeScreenPage page) {
    _router.current = page;
    _currentPage.value = page;
  }

  void _handleNavigationChange(HomeScreenPage page) {
    if (page == HomeScreenPage.profile && !AuthService.hasUser) {
      Navigation.openSignInScreen(context);
    } else {
      _addPageToRouteStack(page);
      _pageController.animateToPage(
        page.index,
        curve: Curves.easeOutExpo,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onWillPop: _handleWillPop,
      bodyBuilder: (_, __) {
        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: _pages.length,
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, currentIndex) =>
                    _pages[HomeScreenPage.values[currentIndex]],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _currentPage,
              builder: (context, current, _) {
                return HomeBottomNavigation(
                  currentPage: current,
                  onNavigationChange: _handleNavigationChange,
                  navigationOptions: HomeScreenConfig.bottomNavigationOptions,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
