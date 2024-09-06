import 'package:flutter/material.dart';
import 'package:ticketglob/screens/Admin/account_section.dart';
import 'package:ticketglob/screens/Admin/ticket_section.dart';
import 'package:ticketglob/utils.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int? selectedIndex = 0;
  String searchQuery = ''; // Variable pour stocker la recherche

List<Widget> get pages => [
    AccountSection(searchQuery: searchQuery, onSearch: (query) {
      setState(() {
        searchQuery = query;
      });
    }),
    TicketSection(searchQuery: searchQuery, onSearch: (query) {
      setState(() {
        searchQuery = query;
      });
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
            indicatorShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: AppColors.primarySwatch,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            leading: avatar("assets/images/profil.jpeg"),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(
                  AppIcons.group,
                  color: Colors.white,
                ),
                label: const Text(
                  "Comptes",
                  style: TextStyle(color: Colors.white),
                ),
                selectedIcon: Container(
                  color: AppColors.primarySwatch.withOpacity(0.7),
                  child: const Icon(
                    AppIcons.group,
                    color: Colors.white,
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: const Icon(
                  AppIcons.receipt,
                  color: Colors.white,
                ),
                label: const Text(
                  "Tickets",
                  style: TextStyle(color: Colors.white),
                ),
                selectedIcon: Container(
                  color: AppColors.primarySwatch.withOpacity(0.7),
                  child: const Icon(
                    AppIcons.receipt,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            selectedIndex: selectedIndex),
        Expanded(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Search Section
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 10,
                              color: Color(0xFF979797))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            style: AppTextStyles.bodyText1,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: AppColors.primarySwatch
                                            .withOpacity(0.2))),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: AppColors.primarySwatch
                                            .withOpacity(0.2))),
                                hintText: "Recherche",
                                hintStyle: AppTextStyles.bodyText1
                                    .copyWith(color: const Color(0xFF979797)),
                                prefixIcon: Icon(
                                  AppIcons.search,
                                  color:
                                      AppColors.primarySwatch.withOpacity(0.4),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(
                                AppIcons.notif,
                                color: Colors.black,
                              ),
                              Positioned(
                                top: 0,
                                right: -8,
                                child: Badge("3"),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      color: const Color(0xFFE5E5E5),
                      child: pages[selectedIndex!])
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container avatar(String image) {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage(
                image,
              ),
              fit: BoxFit.cover)),
    );
  }

  Widget Badge(String number) => Container(
        width: 21,
        height: 15,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 175, 28, 18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 0.5,
              color: Colors.white,
            )),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      );
}
