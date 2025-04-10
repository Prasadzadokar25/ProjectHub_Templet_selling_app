import 'package:flutter/material.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/controller/reels_controller.dart';
import 'package:projecthub/model/reel_model.dart';
import 'package:provider/provider.dart';

class ReelsProvider extends ChangeNotifier {
  bool isLoading = false;
  List<ReelModel>? reels;
  String? errorMassage;
  final ReelsController _reelsController = ReelsController();
  int offset = 0;
  int limit = 5;

  setLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  fetchReels(int userId, [bool isFirstCall = false]) async {
    setLoading(true);
    errorMassage = null;

    if (isFirstCall) {
      reset();
    }

    try {
      final newData = await _reelsController.fetchReels(userId, limit, offset);
      if (isFirstCall || reels == null) {
        reels = newData;
      } else {
        reels!.addAll(newData);
      }

      offset += newData.length;
    } catch (e) {
      errorMassage = e.toString();
    }
    setLoading(false);
  }

  // toggleLike(index) {
  //   reels![index].isLikedByUser = !reels![index].isLikedByUser;
  //   if (reels![index].isLikedByUser) {
  //     reels![index].likeCount++;
  //   } else {
  //     reels![index].likeCount--;
  //   }
  //   notifyListeners();
  // }
  void toggleLike(ReelModel reel, int userId, [bool confirmLike = false]) {
    if (confirmLike) {
      if (!reel.isLikedByUser) {
        reel.likeCount++;
      }
      reel.isLikedByUser = true;
      notifyListeners();
      _reelsController.addLike(reel.creationId, userId);
      return;
    }
    reel.isLikedByUser = !reel.isLikedByUser;
    if (reel.isLikedByUser) {
      reel.likeCount++;
      _reelsController.addLike(reel.creationId, userId);
    } else {
      reel.likeCount--;
      _reelsController.removeLike(reel.creationId, userId);
    }
    notifyListeners();
  }

  reset() {
    offset = 1;
    reels = [];
    notifyListeners();
  }
}
