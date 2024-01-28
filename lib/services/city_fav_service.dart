class FavoritesManager {
  List<String> favoriteCities = ["mumbai"];

  void addFavoriteCity(String cityName) {
    if (!favoriteCities.contains(cityName)) {
      favoriteCities.add(cityName);
    }
  }

  void removeFavoriteCity(String cityName) {
    favoriteCities.remove(cityName);
  }
}
