import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_menu_state.dart';

class BottomNavigationMenuCubit extends Cubit<BottomNavigationMenuState> {
  BottomNavigationMenuCubit() : super(const BottomNavigationMenuInitial());

  late PageController pageController;

  void setPageController() {
    pageController = PageController(keepPage: true);
  }

  void changeMenu(BottomNavigationMenuType value) {
    pageController.jumpToPage(value.menuIndex);
    emit(state.copyWith(menuType: value));
  }

  void dispose() {
    pageController.dispose();
  }
}
