import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TabNavigator extends ChangeNotifier{

  TabNavigator(this._initialPage){
    _navigationStack.add(_initialPage);
  }

  final TabItem _initialPage;

  final List<TabItem> _navigationStack = [];

  TabItem get currentPage => _navigationStack.last;

  List<TabItem> get allPages => _navigationStack;

  int get totalPages => _navigationStack.length;

  void push(TabItem page){
    _navigationStack.add(page);
    notifyListeners();
  }

  void pop(){
    if(_navigationStack.length > 1) _navigationStack.removeLast();
    notifyListeners();
  }

  void popToRoot(){
    _navigationStack
    ..clear()
    ..add(_initialPage);
    notifyListeners();
  }

  void popTo(TabItem page){
    _navigationStack.remove(page);
    notifyListeners();
  }

  void popUntil(TabItem? page){
    if(page == null) return popToRoot();
    if(_navigationStack.length > 1){
      _navigationStack.removeRange(1, _navigationStack.indexOf(page) + 1);
      notifyListeners();
    }
  }

  void pushAndPopUntil(TabItem page){
    _navigationStack
    ..add(page)
    ..removeRange(1, _navigationStack.indexOf(page));
    notifyListeners();
  }

}

class TabItem extends Equatable{

  TabItem({required this.child}) : id = const Uuid().v1();

  final Widget child;
  final String id;

  @override
  List<Object?> get props => [id];

  @override 
  String toString() {
    return 'id: $id, child: $child';
  }
  
}
