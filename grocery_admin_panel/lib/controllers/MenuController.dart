import 'package:flutter/material.dart';

class MenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // All products
  final GlobalKey<ScaffoldState> _gridScaffoldKey = GlobalKey<ScaffoldState>();
  // Add Products page
  final GlobalKey<ScaffoldState> _addProductScaffoldKey =
  GlobalKey<ScaffoldState>();
  // Edit product screen
  final GlobalKey<ScaffoldState> _editProductScaffoldKey =
  GlobalKey<ScaffoldState>();
  // Orders screen
  final GlobalKey<ScaffoldState> _ordersScaffoldKey =
  GlobalKey<ScaffoldState>();
  // Getters
  final GlobalKey<ScaffoldState> _driverScaffoldKey =
  GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get getScaffoldKey => _scaffoldKey;
  GlobalKey<ScaffoldState> get getgridscaffoldKey => _gridScaffoldKey;
  GlobalKey<ScaffoldState> get getAddProductscaffoldKey =>
      _addProductScaffoldKey;
  GlobalKey<ScaffoldState> get getEditProductscaffoldKey =>
      _editProductScaffoldKey;
  GlobalKey<ScaffoldState> get getOrdersScaffoldKey => _ordersScaffoldKey;
  GlobalKey<ScaffoldState> get getDriverScaffoldKey => _driverScaffoldKey;
  // Callbacks
  void controlDashboarkMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void controlProductsMenu() {
    if (!_gridScaffoldKey.currentState!.isDrawerOpen) {
      _gridScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAddProductsMenu() {
    if (!_addProductScaffoldKey.currentState!.isDrawerOpen) {
      _addProductScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlEditProductsMenu() {
    if (!_editProductScaffoldKey.currentState!.isDrawerOpen) {
      _editProductScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAllOrder() {
    if (!_ordersScaffoldKey.currentState!.isDrawerOpen) {
      _ordersScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAllDriver(){
    if (!_driverScaffoldKey.currentState!.isDrawerOpen) {
      _driverScaffoldKey.currentState!.openDrawer();
    }
  }

}
