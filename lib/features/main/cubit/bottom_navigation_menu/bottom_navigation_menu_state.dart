part of 'bottom_navigation_menu_cubit.dart';

enum BottomNavigationMenuType {
  cardDeck,
  match,
  message,
  profile;

  int get menuIndex {
    switch (this) {
      case BottomNavigationMenuType.cardDeck:
        return 0;
      case BottomNavigationMenuType.match:
        return 1;
      case BottomNavigationMenuType.message:
        return 2;
      case BottomNavigationMenuType.profile:
        return 3;
      default:
        return 0;
    }
  }

  IconData get icon {
    switch (this) {
      case BottomNavigationMenuType.cardDeck:
        return CupertinoIcons.heart;
      case BottomNavigationMenuType.match:
        return CupertinoIcons.sparkles;
      case BottomNavigationMenuType.message:
        return CupertinoIcons.chat_bubble_2;
      case BottomNavigationMenuType.profile:
        return CupertinoIcons.profile_circled;
      default:
        return CupertinoIcons.heart;
    }
  }
}

@immutable
class BottomNavigationMenuState extends Equatable {
  final BottomNavigationMenuType menuType;

  const BottomNavigationMenuState({
    this.menuType = BottomNavigationMenuType.cardDeck,
  });

  @override
  List<Object> get props => [menuType];

  BottomNavigationMenuState copyWith({
    BottomNavigationMenuType? menuType,
  }) {
    return BottomNavigationMenuState(
      menuType: menuType ?? this.menuType,
    );
  }

  @override
  bool get stringify => true;
}

final class BottomNavigationMenuInitial extends BottomNavigationMenuState {
  const BottomNavigationMenuInitial();
}
