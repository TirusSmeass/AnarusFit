import 'package:flutter/material.dart';
import 'data_storage.dart';
import 'calculator.dart';

class FoodDiaryScreen extends StatefulWidget {
  final double targetKalori;
  final double targetProtein;

  const FoodDiaryScreen({
    super.key,
    required this.targetKalori,
    required this.targetProtein,
  });

  @override
  State<FoodDiaryScreen> createState() => _FoodDiaryScreenState();
}

class _FoodDiaryScreenState extends State<FoodDiaryScreen> {
  List<Map<String, dynamic>> todayFoods = [];
  Map<String, double> total = {'kalori': 0, 'protein': 0};
  bool isLoading = true;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController kaloriController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  String selectedWaktu = 'Pagi';

  final List<String> waktuMakan = ['Pagi', 'Siang', 'Malam', 'Camilan'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    todayFoods = await DataStorage.loadTodayFoods();
    total = await DataStorage.getTodayTotal();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _addFoodManually() async {
    if (namaController.text.isNotEmpty &&
        kaloriController.text.isNotEmpty &&
        proteinController.text.isNotEmpty) {
      
      await DataStorage.addTodayFood(
        nama: namaController.text,
        kalori: double.parse(kaloriController.text),
        protein: double.parse(proteinController.text),
        waktu: selectedWaktu,
      );

      namaController.clear();
      kaloriController.clear();
      proteinController.clear();
      
      await _loadData();
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil ditambahkan')),
      );
    }
  }

  Future<void> _addFoodFromDatabase(Map<String, dynamic> food) async {
    await DataStorage.addTodayFood(
      nama: food['nama'],
      kalori: food['kalori'],
      protein: food['protein'],
      waktu: selectedWaktu,
    );
    
    await _loadData();
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${food['nama']} ditambahkan')),
    );
  }

  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Makanan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedWaktu,
                items: waktuMakan.map((waktu) {
                  return DropdownMenuItem(
                    value: waktu,
                    child: Text(waktu),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedWaktu = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Waktu Makan',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showFoodDatabaseDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Pilih dari Database'),
              ),
              const Divider(height: 30),
              const Text(
                'Atau input manual:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: kaloriController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kalori (kkal)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Protein (gram)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _addFoodManually,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showFoodDatabaseDialog() {
    List<String> categories = Calculator.getCategories();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Makanan'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String category = categories[index];
              List<Map<String, dynamic>> foods = Calculator.getFoodsByCategory(category);
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...foods.map((food) {
                    return ListTile(
                      title: Text(food['nama']),
                      subtitle: Text('${food['kalori']} kkal | ${food['protein']}g protein'),
                      onTap: () => _addFoodFromDatabase(food),
                    );
                  }),
                  const Divider(),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index, Map<String, dynamic> food) {
    namaController.text = food['nama'];
    kaloriController.text = food['kalori'].toString();
    proteinController.text = food['protein'].toString();
    selectedWaktu = food['waktu'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Makanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedWaktu,
              items: waktuMakan.map((waktu) {
                return DropdownMenuItem(
                  value: waktu,
                  child: Text(waktu),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedWaktu = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Waktu Makan',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Makanan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: kaloriController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kalori (kkal)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: proteinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Protein (gram)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await DataStorage.updateTodayFood(
                index: index,
                nama: namaController.text,
                kalori: double.parse(kaloriController.text),
                protein: double.parse(proteinController.text),
                waktu: selectedWaktu,
              );
              await _loadData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Makanan diupdate')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Color _getWarnaWaktu(String waktu) {
    switch (waktu) {
      case 'Pagi':
        return Colors.orange;
      case 'Siang':
        return Colors.blue;
      case 'Malam':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    double kaloriPersen = (total['kalori']! / widget.targetKalori) * 100;
    double proteinPersen = (total['protein']! / widget.targetProtein) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Diary'),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Diary'),
                  content: const Text('Hapus semua makanan hari ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await DataStorage.clearTodayFoods();
                        await _loadData();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Diary direset')),
                        );
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF2E7D32),
                  child: Column(
                    children: [
                      const Text(
                        'Progress Hari Ini',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Kalori',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${total['kalori']!.toInt()} / ${widget.targetKalori.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                LinearProgressIndicator(
                                  value: kaloriPersen / 100,
                                  backgroundColor: Colors.white24,
                                  color: Colors.amber,
                                ),
                                Text(
                                  '${kaloriPersen.toStringAsFixed(1)}%',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Protein',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${total['protein']!.toInt()} / ${widget.targetProtein.toInt()}g',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                LinearProgressIndicator(
                                  value: proteinPersen / 100,
                                  backgroundColor: Colors.white24,
                                  color: Colors.lightBlue,
                                ),
                                Text(
                                  '${proteinPersen.toStringAsFixed(1)}%',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: todayFoods.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Belum ada makanan hari ini',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: todayFoods.length,
                          itemBuilder: (context, index) {
                            var food = todayFoods[index];
                            return Dismissible(
                              key: Key('$index${food['nama']}'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) async {
                                await DataStorage.removeTodayFood(index);
                                await _loadData();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Makanan dihapus')),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _getWarnaWaktu(food['waktu']),
                                    child: Text(
                                      food['waktu'][0],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(food['nama']),
                                  subtitle: Text(
                                    '${food['kalori']} kkal | ${food['protein']}g protein',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(food['waktu']),
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showEditDialog(index, food),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFoodDialog,
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add),
      ),
    );
  }
}