import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobs_global/Screens/AdminScreen/comapny_dashboard_page.dart';
import 'package:jobs_global/Screens/AdminScreen/company_profile_page.dart';
import 'package:jobs_global/Screens/home_page.dart';
import 'package:jobs_global/Screens/logout_page.dart';
import 'package:jobs_global/Utils/global.dart';

import '../../DataBaseManagements/riverPodStateManagemnts.dart';
import 'view_company_profile_page.dart';

class CompanyBottomNavigatorScreen extends ConsumerStatefulWidget {
  const CompanyBottomNavigatorScreen({super.key});

  @override
  ConsumerState<CompanyBottomNavigatorScreen> createState() =>
      _CompanyBottomNavigatorScreenState();
}

class _CompanyBottomNavigatorScreenState
    extends ConsumerState<CompanyBottomNavigatorScreen> {
  // static int pageIndex = 0;

  final pages = [
    const ComapnyDashboardPage(),
    const CompanyViewProfilePage(),
    const LogoutPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var pageIndex = ref.watch(bottomAppBarStateNotifer);
        return Scaffold(
          backgroundColor: Colors.white,
          body: pages[pageIndex],
          bottomNavigationBar: buildMyNavBar(context),
        );
      },
    );
  }

  buildMyNavBar(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      var pageIndex = ref.watch(bottomAppBarStateNotifer);
      return Container(
        height: 47,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.goldenColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 10,
              enableFeedback: false,
              onPressed: () {
                ref.read(bottomAppBarStateNotifer.notifier).state = 0;
                // setState(() {
                //   pageIndex = 0;
                // });
              },
              icon: pageIndex == 0
                  ? const Column(
                      children: [
                        Icon(
                          Icons.home_filled,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    )
                  : const Column(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              enableFeedback: false,
              onPressed: () {
                ref.read(bottomAppBarStateNotifer.notifier).state = 1;
                // setState(() {
                //   pageIndex = 1;
                // });
              },
              icon: pageIndex == 1
                  ? const Column(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    )
                  : const Column(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              enableFeedback: false,
              onPressed: () {
                ref.read(bottomAppBarStateNotifer.notifier).state = 2;
                // setState(() {
                //   pageIndex = 2;
                // });
              },
              icon: pageIndex == 2
                  ? const Column(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          "Setting",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    )
                  : const Column(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          "Setting",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    ),
            ),
          ],
        ),
      );
    }));
  }
}
