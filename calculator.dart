class Calculator {
  static double hitungBMR(double berat, double tinggi, int umur) {
    return (10 * berat) + (6.25 * tinggi) - (5 * umur) + 5;
  }

  static Map<String, double> hitungKebutuhan({
    required double berat,
    required double tinggi,
    required int umur,
    required String target,
  }) {
    double bmr = hitungBMR(berat, tinggi, umur);
    double tdee = bmr * 1.55;
    
    double totalKalori;
    if (target == 'Diet') {
      totalKalori = tdee - 500;
    } else {
      totalKalori = tdee + 500;
    }

    double protein = berat * 2;

    return {
      'kalori': totalKalori.roundToDouble(),
      'protein': protein,
    };
  }

  static List<String> getSaranMakanan(String target) {
    if (target == 'Diet') {
      return [
        'Dada ayam tanpa kulit',
        'Telur rebus',
        'Ikan tuna',
        'Brokoli kukus',
        'Tahu putih',
        'Tempe kukus',
      ];
    } else {
      return [
        'Nasi merah',
        'Daging sapi',
        'Kentang rebus',
        'Susu',
        'Kacang tanah',
        'Pisang',
      ];
    }
  }

  // ===== DATABASE MAKANAN =====
  static List<Map<String, dynamic>> getFoodDatabase() {
    return [
      // Makanan Pokok
      {'nama': 'Nasi Putih (1 porsi)', 'kalori': 200, 'protein': 4, 'kategori': 'Pokok'},
      {'nama': 'Nasi Merah (1 porsi)', 'kalori': 180, 'protein': 5, 'kategori': 'Pokok'},
      {'nama': 'Kentang Rebus (1 buah)', 'kalori': 150, 'protein': 3, 'kategori': 'Pokok'},
      {'nama': 'Roti Gandum (2 lembar)', 'kalori': 160, 'protein': 6, 'kategori': 'Pokok'},
      
      // Lauk Protein
      {'nama': 'Dada Ayam (100g)', 'kalori': 165, 'protein': 31, 'kategori': 'Lauk'},
      {'nama': 'Telur Rebus (1 butir)', 'kalori': 70, 'protein': 6, 'kategori': 'Lauk'},
      {'nama': 'Ikan Tuna (100g)', 'kalori': 130, 'protein': 28, 'kategori': 'Lauk'},
      {'nama': 'Tahu (100g)', 'kalori': 80, 'protein': 8, 'kategori': 'Lauk'},
      {'nama': 'Tempe (100g)', 'kalori': 150, 'protein': 14, 'kategori': 'Lauk'},
      {'nama': 'Daging Sapi (100g)', 'kalori': 250, 'protein': 26, 'kategori': 'Lauk'},
      
      // Sayuran
      {'nama': 'Brokoli (100g)', 'kalori': 55, 'protein': 4, 'kategori': 'Sayur'},
      {'nama': 'Bayam (100g)', 'kalori': 23, 'protein': 3, 'kategori': 'Sayur'},
      {'nama': 'Wortel (100g)', 'kalori': 41, 'protein': 1, 'kategori': 'Sayur'},
      {'nama': 'Tomat (1 buah)', 'kalori': 20, 'protein': 1, 'kategori': 'Sayur'},
      
      // Buah
      {'nama': 'Pisang (1 buah)', 'kalori': 105, 'protein': 1, 'kategori': 'Buah'},
      {'nama': 'Apel (1 buah)', 'kalori': 95, 'protein': 0.5, 'kategori': 'Buah'},
      {'nama': 'Alpukat (1/2 buah)', 'kalori': 160, 'protein': 2, 'kategori': 'Buah'},
      
      // Minuman
      {'nama': 'Susu (200ml)', 'kalori': 120, 'protein': 8, 'kategori': 'Minuman'},
      {'nama': 'Yogurt (150ml)', 'kalori': 100, 'protein': 6, 'kategori': 'Minuman'},
      
      // Camilan
      {'nama': 'Kacang Almond (30g)', 'kalori': 170, 'protein': 6, 'kategori': 'Camilan'},
      {'nama': 'Protein Bar (1 buah)', 'kalori': 200, 'protein': 15, 'kategori': 'Camilan'},
    ];
  }

  static List<Map<String, dynamic>> getFoodsByCategory(String kategori) {
    return getFoodDatabase().where((food) => food['kategori'] == kategori).toList();
  }

  static List<String> getCategories() {
    Set<String> categories = {};
    for (var food in getFoodDatabase()) {
      categories.add(food['kategori']);
    }
    return categories.toList();
  }
}