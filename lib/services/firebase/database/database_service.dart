import 'package:aura/helpers/utils/app_logger.dart';
import 'package:aura/services/firebase/database/collections.dart';
import 'package:aura/services/firebase/database/models/favorite_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> favoritesStream(
      String userEmail) {
    return _firestore
        .collection(DatabaseCollections.favorites)
        .where("userEmail", isEqualTo: userEmail)
        .snapshots();
  }

  static Future<void> addFavoriteLocation(FavoriteLocation location) async {
    try {
      await _firestore
          .collection(DatabaseCollections.favorites)
          .doc()
          .set(location.toJson());
    } catch (e) {
      AppLogger.logOne(
        LogItem(title: "Firestore Failure", data: {"error": e}),
        type: LogType.error,
      );
    }
  }

  static Future<List<FavoriteLocation>> getFavoritesByUser(
      String userEmail) async {
    final List<FavoriteLocation> output = [];
    try {
      print('Get favorites by $userEmail');
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(DatabaseCollections.favorites)
          .where("userEmail", isEqualTo: userEmail)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> item in snapshot.docs) {
        output.add(FavoriteLocation.fromJson(item.data()));
      }
    } catch (e) {
      AppLogger.logOne(
        LogItem(title: "Firestore Failure", data: {"error": e}),
        type: LogType.error,
      );
    }
    return output;
  }

  static Future<void> removeFromFavorites(FavoriteLocation location) async {
    try {
      print('Removing favorites by ${location.userEmail}');
      final document = await findFavoriteLocationById(
          userEmail: location.userEmail, locationId: location.locationId);

      if (document != null) {
        await _firestore
            .collection(DatabaseCollections.favorites)
            .doc(document.id)
            .delete();
      }
    } catch (e) {
      AppLogger.logOne(
        LogItem(title: "Firestore Failure", data: {"error": e}),
        type: LogType.error,
      );
    }
  }

  static Future<QueryDocumentSnapshot<Map<String, dynamic>>?>
      findFavoriteLocationById(
          {required String userEmail, required int locationId}) async {
    try {
      final snapshot = await _firestore
          .collection(DatabaseCollections.favorites)
          .where("userEmail", isEqualTo: userEmail)
          .where("locationId", isEqualTo: locationId)
          .get();

      if (snapshot.docs.isNotEmpty) return snapshot.docs.first;

      return null;
    } catch (e) {
      AppLogger.logOne(
        LogItem(title: "Firestore Failure", data: {"error": e}),
        type: LogType.error,
      );

      rethrow;
    }
  }
}
