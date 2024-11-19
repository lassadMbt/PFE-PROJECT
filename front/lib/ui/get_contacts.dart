// lib/ui/get_contacts.dart
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tataguid/userPages/favoritPage.dart';
import 'package:tataguid/userPages/homePage.dart';
import 'package:tataguid/userPages/profilePage.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/userPages/searchPage.dart';

class UserPage extends StatefulWidget {
  final GoogleSignInAccount? user;

  const UserPage({Key? key, this.user}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;
  Set<String> favoriteIds = {};
  List<PlaceModel> favoritePlaces = [];

  void _toggleFavorite(PlaceModel place) {
    setState(() {
      if (favoriteIds.contains(place.id)) {
        favoriteIds.remove(place.id);
        favoritePlaces.removeWhere((element) => element.id == place.id);
      } else {
        favoriteIds.add(place.id);
        favoritePlaces.add(place);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double responsivePadding = constraints.maxWidth < 600 ? 15.0 : 30.0;

        return Scaffold(
          bottomNavigationBar: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsivePadding,
                vertical: 20.0,
              ),
              child: GNav(
                rippleColor: Colors.grey,
                hoverColor: Colors.grey,
                haptic: true,
                curve: Curves.linear,
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade800,
                gap: 8,
                onTabChange: (index) {
                  setState(() => _selectedIndex = index);
                },
                padding: const EdgeInsets.all(16),
                tabs: const [
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.map,
                    text: 'Cart',
                  ),
                  GButton(
                    icon: Icons.favorite_border,
                    text: 'Favorites',
                  ),
                  GButton(
                    icon: Icons.account_circle_outlined,
                    text: 'Profile',
                  ),
                ],
              ),
            ),
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              UserHome(favorites: favoriteIds, onFavoriteToggle: _toggleFavorite),
              MapPage(),
              //Center(child: Text('Search Content')),
              FavoritesPage(userId: widget.user?.id ?? ''),
              ProfilePage(),
            ],
          ),
        );
      },
    );
  }
}