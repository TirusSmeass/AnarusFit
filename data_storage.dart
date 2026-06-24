import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  // Menyimpan data user
  static Future<void> saveUserData({
    required double berat,
    required double tinggi,
    required int umur,
    required String target,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('berat', berat);
    await prefs.setDouble('tinggi', tinggi);
    await prefs.setInt('umur', umur);
    await prefs.setString('target', target);
    await prefs.setBool('hasData', true);
  }

  // Memuat data user
  static Future<Map<String, dynamic>> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    bool hasData = prefs.getBool('hasData') ?? false;
    
    if (hasData) {
      return {
        'berat': prefs.getDouble('berat') ?? 0,
        'tinggi': prefs.getDouble('tinggi') ?? 0,
        'umur': prefs.getInt('umur') ?? 0,
        'target': prefs.getString('target') ?? 'Diet',
        'hasData': true,
      };
    }
    
    return {'hasData': false};
  }

  // Menyimpan history perhitungan
  static Future<void> saveHistory({
    required double kalori,
    required double protein,
    required String target,
    required DateTime tanggal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    List<String> historyList = prefs.getStringList('history') ?? [];
    
    String newHistory = '${tanggal.toIso8601String()}|$kalori|$protein|$target';
    
    historyList.add(newHistory);
    
    await prefs.setStringList('history', historyList);
  }

  // Memuat semua history
  static Future<List<Map<String, dynamic>>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyList = prefs.getStringList('history') ?? [];
    
    List<Map<String, dynamic>> result = [];
    
    for (String item in historyList) {
      List<String> parts = item.split('|');
      if (parts.length == 4) {
        result.add({
          'tanggal': DateTime.parse(parts[0]),
          'kalori': double.parse(parts[1]),
          'protein': double.parse(parts[2]),
          'target': parts[3],
        });
      }
    }
    
    result.sort((a, b) => b['tanggal'].compareTo(a['tanggal']));
    
    return result;
  }

  // Menghapus semua data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Menghapus history tertentu
  static Future<void> deleteHistoryAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyList = prefs.getStringList('history') ?? [];
    
    if (index >= 0 && index < historyList.length) {
      historyList.removeAt(index);
      await prefs.setStringList('history', historyList);
    }
  }

  // ===== FITUR FOOD DIARY =====
  static Future<void> saveTodayFoods(List<Map<String, dynamic>> foods) async {
    final prefs = await SharedPreferences.getInstance();
    
    List<String> foodStrings = foods.map((food) {
      return '${food['nama']}|${food['kalori']}|${food['protein']}|${food['waktu']}';
    }).toList();
    
    await prefs.setStringList('today_foods', foodStrings);
    await prefs.setString('last_update', DateTime.now().toIso8601String());
  }

  static Future<List<Map<String, dynamic>>> loadTodayFoods() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> foodStrings = prefs.getStringList('today_foods') ?? [];
    
    String? lastUpdate = prefs.getString('last_update');
    if (lastUpdate != null) {
      DateTime lastDate = DateTime.parse(lastUpdate);
      DateTime now = DateTime.now();
      
      if (lastDate.day != now.day || 
          lastDate.month != now.month || 
          lastDate.year != now.year) {
        await clearTodayFoods();
        return [];
      }
    }
    
    List<Map<String, dynamic>> foods = [];
    for (String foodString in foodStrings) {
      List<String> parts = foodString.split('|');
      if (parts.length == 4) {
        foods.add({
          'nama': parts[0],
          'kalori': double.parse(parts[1]),
          'protein': double.parse(parts[2]),
          'waktu': parts[3],
        });
      }
    }
    
    foods.sort((a, b) => a['waktu'].compareTo(b['waktu']));
    
    return foods;
  }

  static Future<void> addTodayFood({
    required String nama,
    required double kalori,
    required double protein,
    required String waktu,
  }) async {
    List<Map<String, dynamic>> foods = await loadTodayFoods();
    
    foods.add({
      'nama': nama,
      'kalori': kalori,
      'protein': protein,
      'waktu': waktu,
    });
    
    await saveTodayFoods(foods);
  }

  static Future<void> removeTodayFood(int index) async {
    List<Map<String, dynamic>> foods = await loadTodayFoods();
    
    if (index >= 0 && index < foods.length) {
      foods.removeAt(index);
      await saveTodayFoods(foods);
    }
  }

  static Future<void> updateTodayFood({
    required int index,
    required String nama,
    required double kalori,
    required double protein,
    required String waktu,
  }) async {
    List<Map<String, dynamic>> foods = await loadTodayFoods();
    
    if (index >= 0 && index < foods.length) {
      foods[index] = {
        'nama': nama,
        'kalori': kalori,
        'protein': protein,
        'waktu': waktu,
      };
      await saveTodayFoods(foods);
    }
  }

  static Future<void> clearTodayFoods() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('today_foods');
    await prefs.remove('last_update');
  }

  static Future<Map<String, double>> getTodayTotal() async {
    List<Map<String, dynamic>> foods = await loadTodayFoods();
    
    double totalKalori = 0;
    double totalProtein = 0;
    
    for (var food in foods) {
      totalKalori += food['kalori'];
      totalProtein += food['protein'];
    }
    
    return {
      'kalori': totalKalori,
      'protein': totalProtein,
    };
  }
}