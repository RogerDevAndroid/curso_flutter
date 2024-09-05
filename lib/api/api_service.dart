import 'dart:convert';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/models/backdrop.dart';
import 'package:movies_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/review.dart';

import '../models/negocio.dart';

class ApiService {
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(
          Uri.parse(
              '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=es-MX&page=1'),
          headers: Api.headers);
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http
          .get(Uri.parse('${Api.baseUrl}movie/$url'), headers: Api.headers);
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(
      String query, String anio) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(
          Uri.parse(
              'https://api.themoviedb.org/3/search/movie?api_key=YourApiKey&language=es-MX&query=$query&page=1&include_adult=false&year=$anio'),
          headers: Api.headers);
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {

      http.Response response = await http.get(
          Uri.parse(
              'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=es-MX&page=1'),
          headers: Api.headers);
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Backdrop>?> getMovieImages(int movieId) async {
    List<Backdrop> backdrop = [];
    try {
      http.Response response = await http.get(
          Uri.parse('https://api.themoviedb.org/3/movie/$movieId/images'),
          headers: Api.headers);
      var res = jsonDecode(response.body);
      res['backdrops'].forEach(
        (r) {
          backdrop.add(
            Backdrop(
                aspectRatio: r['aspect_ratio'],
                height: r['height'],
                iso6391: r['iso_639_1'],
                filePath: r['file_path'],
                voteAverage: r['vote_average'],
                voteCount: r['vote_count'],
                width: r['width']),
          );
        },
      );
      return backdrop;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Negocio>?> getSearchStore(String querryBusqueda,double lat,double lon,int radio) async {
    List<Negocio> negocio = [];
    try {
      http.Response response = await http.get(
          Uri.parse('${Api.baseUrlMap}$querryBusqueda/$lat,$lon/$radio/${Api.apiKeyMap}'),
          headers: Api.headers);
      var res = jsonDecode(response.body);
      res.forEach(
            (r) {
              negocio.add(
                Negocio(
                  clee: r['CLEE'],
                  id: r['Id'],
                  nombre: r['Nombre'],
                  razonSocial: r['Razon_social'],
                  claseActividad: r['Clase_actividad'],
                  estrato: r['Estrato'],
                  tipoVialidad: r['Tipo_vialidad'],
                  calle: r['Calle'],
                  numExterior: r['Num_Exterior'],
                  numInterior: r['Num_Interior'],
                  colonia: r['Colonia'],
                  cp: r['CP'],
                  ubicacion: r['Ubicacion'],
                  telefono: r['Telefono'],
                  correoE: r['Correo_e'],
                  sitioInternet: r['Sitio_internet'],
                  tipo: r['Tipo'],
                  longitud: r['Longitud'],
                  latitud: r['Latitud'],
                  centroComercial: r['CentroComercial'],
                  tipoCentroComercial: r['TipoCentroComercial'],
                  numLocal: r['NumLocal'],
                ),
          );
        },
      );
      return negocio;
    } catch (e) {
      return null;
    }
  }


}
