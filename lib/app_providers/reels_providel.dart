import 'package:flutter/material.dart';
import 'package:projecthub/controller/reels_controller.dart';
import 'package:projecthub/model/reel_model.dart';

class ReelsProvider extends ChangeNotifier {
  bool isLoading = false;
  List<ReelModel>? reels;
  String? errorMassage;
  final ReelsController _reelsController = ReelsController();
  int offset = 1;
  int limit = 5;

  setLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  fetchReels(int userId) async {
    setLoading(true);
    errorMassage = null;
    try {
      final newData = await _reelsController.fetchReels(userId, limit, offset);
      reels ??= newData;
      reels!.addAll(newData);
      offset += limit;
    } catch (e) {
      errorMassage = e.toString();
    }
    setLoading(false);
  }

  toggleLike(index) {
    reels![index].isLikedByUser = !reels![index].isLikedByUser;
    if (reels![index].isLikedByUser) {
      reels![index].likeCount++;
    } else {
      reels![index].likeCount--;
    }
    notifyListeners();
  }

  reset() {
    offset = 1;
    notifyListeners();
  }
}
