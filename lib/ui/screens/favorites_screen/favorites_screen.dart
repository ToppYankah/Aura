// ignore_for_file: use_build_context_synchronously

import 'package:aura/resources/app_images.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/services/firebase/database/database_service.dart';
import 'package:aura/services/firebase/database/models/favorite_location.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/empty_list.dart';
import 'package:aura/ui/screens/favorites_screen/widgets/favorite_location_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteLocationScreen extends StatefulWidget {
  const FavoriteLocationScreen({super.key});

  @override
  State<FavoriteLocationScreen> createState() => _FavoriteLocationScreenState();
}

class _FavoriteLocationScreenState extends State<FavoriteLocationScreen> {
  final String _userEmail = AuthService.user?.email ?? "";

  List<FavoriteLocation> _getData(QuerySnapshot<Map<String, dynamic>> data) {
    List<FavoriteLocation> output = [];

    for (var doc in data.docs) {
      output.add(FavoriteLocation.fromJson(doc.data()));
    }

    return output;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return Column(
          children: [
            const SafeArea(
              bottom: false,
              child: AppHeader(title: "Favorite Locations"),
            ),
            Expanded(
              child: StreamBuilder(
                stream: DatabaseService.favoritesStream(_userEmail),
                builder: (context, snapshot) {
                  final bool isLoading =
                      snapshot.connectionState == ConnectionState.waiting;

                  final List<FavoriteLocation> data =
                      snapshot.hasData ? _getData(snapshot.data!) : [];

                  return isLoading
                      ? const Center(child: AppLoader())
                      : data.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 100.0),
                              child: AppEmptyPlaceholder(
                                customImage: AppImages.emptyBox,
                                message:
                                    "Your favorite locations\nwill appear here",
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  for (FavoriteLocation item in data)
                                    FavoriteLocationTile(data: item)
                                ],
                              ),
                            );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
