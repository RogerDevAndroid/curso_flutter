import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/models/movie.dart';

import '../db/DatabaseService.dart';

class MoviesController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedMovies = <Movie>[].obs;
  var watchListMovies = <Movie>[].obs;

  final DatabaseService _databaseService = DatabaseService();

  @override
  void onInit() async {
    super.onInit();
    await fetchMoviesFromDatabase();
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      await fetchTopRatedMovies();
    } else {
      Fluttertoast.showToast(
          msg: "No hay internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
  }

  Future<void> fetchTopRatedMovies() async {
    isLoading.value = true;
    mainTopRatedMovies.value = (await ApiService.getTopRatedMovies())!;
    isLoading.value = false;
  }

  Future<void> fetchMoviesFromDatabase() async {
    watchListMovies.value = await _databaseService.getWatchListMovies();
  }

  bool isInWatchList(Movie movie) {
    return watchListMovies.any((m) => m.id == movie.id);
  }

  Future<void> addToWatchList(Movie movie) async {
    if (isInWatchList(movie)) {
      await _databaseService.removeMovieFromWatchList(movie.id);
      Get.snackbar('Success', 'Removed from watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    } else {
      await _databaseService.addMovieToWatchList(movie);
      Get.snackbar('Success', 'Added to watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
    await fetchMoviesFromDatabase();
  }
}