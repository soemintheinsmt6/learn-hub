import 'package:flutter/material.dart';
import 'package:learn_hub/core/di/injection.dart';
import 'package:learn_hub/core/utils/app_color.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';
import 'package:learn_hub/features/company/presentation/screens/company_list.dart';
import 'package:learn_hub/features/home/presentation/screens/home_screen.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';
import 'package:learn_hub/features/user/presentation/screens/user_list.dart';

class BottomNavigationScreen extends StatefulWidget {
  static const String route = 'bottomNavigation';

  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final List<Widget?> _screens = List<Widget?>.filled(3, null);
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late final UserRepository _userRepository;
  late final CompanyRepository _companyRepository;

  int _selectedIndex = 0;

  final List<IconData> _iconPaths = [
    Icons.home,
    Icons.person,
    Icons.collections_bookmark,
  ];

  Widget _buildScreens(int index) {
    switch (index) {
      case 0:
        return HomeScreen(repository: _userRepository);
      case 1:
        return UserList(repository: _userRepository);
      case 2:
        return CompanyList(repository: _companyRepository);
      default:
        return Container();
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    }

    setState(() {
      if (_screens[index] == null) {
        _screens[index] = _buildScreens(index);
      }
      _selectedIndex = index;
    });
  }

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => _buildScreens(index));
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _userRepository = getIt<UserRepository>();
    _companyRepository = getIt<CompanyRepository>();

    _screens[0] = _buildTabNavigator(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens.map((screen) => screen ?? const SizedBox()).toList(),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          color: AppColors.primary,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
            items: List.generate(_iconPaths.length, (index) {
              return BottomNavigationBarItem(
                icon: Icon(
                  _iconPaths[index],
                  color: _selectedIndex == index ? Colors.black : Colors.white,
                ),
                label: '',
              );
            }),
          ),
        ),
      ),
    );
  }
}
