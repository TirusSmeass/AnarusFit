import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'calculator.dart';
import 'data_storage.dart';
import 'food_diary_screen.dart';  // Tambahkan import ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController umurController = TextEditingController();
  
  String selectedTarget = 'Diet';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    Map<String, dynamic> savedData = await DataStorage.loadUserData();
    
    if (savedData['hasData']) {
      setState(() {
        beratController.text = savedData['berat'].toString();
        tinggiController.text = savedData['tinggi'].toString();
        umurController.text = savedData['umur'].toString();
        selectedTarget = savedData['target'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AnarusFit'),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () async {
              if (beratController.text.isNotEmpty && 
                  tinggiController.text.isNotEmpty && 
                  umurController.text.isNotEmpty) {
                
                double berat = double.parse(beratController.text);
                double tinggi = double.parse(tinggiController.text);
                int umur = int.parse(umurController.text);

                Map hasil = Calculator.hitungKebutuhan(
                  berat: berat,
                  tinggi: tinggi,
                  umur: umur,
                  target: selectedTarget,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDiaryScreen(
                      targetKalori: hasil['kalori'],
                      targetProtein: hasil['protein'],
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Isi data diri terlebih dahulu!')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Data'),
                  content: const Text('Hapus semua data yang tersimpan?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await DataStorage.clearAllData();
                        beratController.clear();
                        tinggiController.clear();
                        umurController.clear();
                        setState(() {
                          selectedTarget = 'Diet';
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Semua data telah dihapus')),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.calculate,
              size: 60,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(height: 20),
            const Text(
              'Input Data Diri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: beratController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Berat Badan (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: tinggiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tinggi Badan (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: umurController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Umur (tahun)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Target:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: selectedTarget == 'Diet' 
                          ? const Color(0xFF2E7D32) 
                          : Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedTarget = 'Diet';
                        });
                      },
                      child: Text(
                        'Diet',
                        style: TextStyle(
                          color: selectedTarget == 'Diet' 
                              ? Colors.white 
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: selectedTarget == 'Bulking' 
                          ? const Color(0xFF2E7D32) 
                          : Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedTarget = 'Bulking';
                        });
                      },
                      child: Text(
                        'Bulking',
                        style: TextStyle(
                          color: selectedTarget == 'Bulking' 
                              ? Colors.white 
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (beratController.text.isNotEmpty && 
                    tinggiController.text.isNotEmpty && 
                    umurController.text.isNotEmpty) {
                  
                  double berat = double.parse(beratController.text);
                  double tinggi = double.parse(tinggiController.text);
                  int umur = int.parse(umurController.text);

                  await DataStorage.saveUserData(
                    berat: berat,
                    tinggi: tinggi,
                    umur: umur,
                    target: selectedTarget,
                  );

                  Map hasil = Calculator.hitungKebutuhan(
                    berat: berat,
                    tinggi: tinggi,
                    umur: umur,
                    target: selectedTarget,
                  );

                  await DataStorage.saveHistory(
                    kalori: hasil['kalori'],
                    protein: hasil['protein'],
                    target: selectedTarget,
                    tanggal: DateTime.now(),
                  );

                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          kalori: hasil['kalori'],
                          protein: hasil['protein'],
                          target: selectedTarget,
                          berat: berat,
                          tinggi: tinggi,
                          umur: umur,
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'HITUNG KALORI',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    List<Map<String, dynamic>> loadedHistory = await DataStorage.loadHistory();
    setState(() {
      history = loadedHistory;
      isLoading = false;
    });
  }

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day}/${tanggal.month}/${tanggal.year} ${tanggal.hour}:${tanggal.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Perhitungan'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? const Center(
                  child: Text('Belum ada riwayat perhitungan'),
                )
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    var item = history[index];
                    return Dismissible(
                      key: Key(item['tanggal'].toString()),
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
                        await DataStorage.deleteHistoryAt(index);
                        setState(() {
                          history.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Riwayat dihapus')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(
                            '${item['kalori'].toInt()} kkal',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Protein: ${item['protein'].toInt()} gram'),
                              Text('Target: ${item['target']}'),
                              Text(
                                _formatTanggal(item['tanggal']),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Detail ${item['target']}'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Kalori: ${item['kalori'].toInt()} kkal'),
                                    Text('Protein: ${item['protein'].toInt()} gram'),
                                    Text('Target: ${item['target']}'),
                                    Text('Tanggal: ${_formatTanggal(item['tanggal'])}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}