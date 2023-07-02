import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/screens/home_screen/widgets/bottom_navigation/home_bottom_navigation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenPage? page;
  const HomeScreen({Key? key, this.page}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<HomeScreenPage, HomePageItem> _pages = {};
  HomeScreenPage _currentPage = HomeScreenPage.home;
  final PageController _pageController = PageController();
  final List<HomeScreenPage> _navRouteStack = [HomeScreenPage.home];

  @override
  void initState() {
    super.initState();

    CommonUtils.performPostBuild(context, () {
      setState(() {
        _navRouteStack.add(_currentPage);
        if (widget.page != null) {
          _handleNavigationChange(widget.page!);
        }
        _pages = HomeScreenConfig.pages(_handleWillPop);
      });
    });

    CommonUtils.initializeAutoReloadLatestMeasurements(context);
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
            HomeBottomNavigation(
              currentPage: _currentPage,
              onNavigationChange: _handleNavigationChange,
              navigationOptions: HomeScreenConfig.bottomNavigationOptions,
            ),
          ],
        );
      },
    );
  }

  Future<bool> _handleWillPop() async {
    bool output = true;

    _navRouteStack.removeLast();
    if (_navRouteStack.isNotEmpty) {
      output = false;
      _handleNavigationChange(_navRouteStack.last);
      setState(() => _currentPage = _navRouteStack.last);
    }

    return output;
  }

  void _addPageToRouteStack(HomeScreenPage page) {
    if (_navRouteStack.contains(page)) {
      _navRouteStack.remove(page);
    }
    _navRouteStack.add(page);
    setState(() => _currentPage = page);
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
    super.dispose();
  }
}
