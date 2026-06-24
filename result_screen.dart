import 'package:flutter/material.dart';
import 'calculator.dart';
import 'food_diary_screen.dart';

class ResultScreen extends StatelessWidget {
  final double kalori;
  final double protein;
  final String target;
  final double berat;
  final double tinggi;
  final int umur;

  const ResultScreen({
    super.key,
    required this.kalori,
    required this.protein,
    required this.target,
    required this.berat,
    required this.tinggi,
    required this.umur,
  });

  @override
  Widget build(BuildContext context) {
    List<String> saranMakanan = Calculator.getSaranMakanan(target);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Perhitungan'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Target: $target',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF2E7D32),
              child: Column(
                children: [
                  const Text(
                    'Total Kalori Harian',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${kalori.toInt()} kkal',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kebutuhan Protein',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${protein.toInt()} gram',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.blue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Anda:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Berat: $berat kg'),
                  Text('Tinggi: $tinggi cm'),
                  Text('Umur: $umur tahun'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saran Makanan:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: saranMakanan.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        const Icon(
                          Icons.fastfood,
                          size: 20,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 10),
                        Text(saranMakanan[index]),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDiaryScreen(
                      targetKalori: kalori,
                      targetProtein: protein,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Buka Food Diary'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Hitung Ulang'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}