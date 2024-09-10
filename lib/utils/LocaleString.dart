import "package:get/get.dart";

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "en_US": {
      "Home": "Home",
      "Search": "Search",
      "Favorite": "Favorite",
      "Map": "Map",
    },
    "es_MX": {
      "Home": "Inicio",
      "Search": "Buscar",
      "Map": "Mapa",
    },
  };
}
