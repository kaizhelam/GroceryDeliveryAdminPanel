import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/driver_list.dart';
import 'package:provider/provider.dart';

import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/header.dart';
import '../widgets/order_list.dart';
import '../widgets/side_menu.dart';
import 'package:grocery_admin_panel/controllers/MenuController.dart'
as AdminMenuController;

class AllDriver extends StatefulWidget {
  const AllDriver({super.key});

  @override
  State<AllDriver> createState() => _AllDriverState();
}

class _AllDriverState extends State<AllDriver> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context
          .read<AdminMenuController.MenuController>()
          .getDriverScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Header(showTexField: false,
                      fct: () {
                        context
                            .read<AdminMenuController.MenuController>()
                            .controlAllDriver();
                      },
                      title: 'All Driver',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DriverList(
                        isInDashboard: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
