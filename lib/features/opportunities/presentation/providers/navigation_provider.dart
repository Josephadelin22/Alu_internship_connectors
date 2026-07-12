import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationIndex extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

// Gère l'index de la page active (0 = Home, 1 = Explore, 2 = Applications, 3 = Profile)
final navigationIndexProvider = NotifierProvider<NavigationIndex, int>(() => NavigationIndex());
