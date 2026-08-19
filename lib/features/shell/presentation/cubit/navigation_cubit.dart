import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTab { overview, explore, insights, protocols }

class NavigationCubit extends Cubit<AppTab> {
  NavigationCubit() : super(AppTab.overview);

  void selectTab(AppTab tab) => emit(tab);
  void selectIndex(int index) {
    if (index >= 0 && index < AppTab.values.length) {
      emit(AppTab.values[index]);
    }
  }
}
