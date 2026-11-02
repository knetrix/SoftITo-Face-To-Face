import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.

class WorkoutAddDialogWidget extends StatelessWidget { // Yeni Egzersiz Ekleme Dialog'unu Gösteren StatelessWidget'tır.
  final void Function(String title, String category, int duration, int calories) onAdd; // Egzersiz Eklendiğinde Çağrılacak Callback'tir.

  const WorkoutAddDialogWidget({ // key ve onAdd Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.onAdd, // onAdd Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Dialog'un Widget Tree'sini Oluşturur.
    final titleController = TextEditingController(); // Egzersiz Adı Girişini Yöneten TextEditingController'dır.
    final durationController = TextEditingController(text: '20'); // Varsayılan Değeri 20 Olan Süre Girişi Controller'ıdır.
    final calController = TextEditingController(text: '150'); // Varsayılan Değeri 150 Olan Kalori Girişi Controller'ıdır.
    String selectedCategory = 'Kardiyo'; // Seçili Kategoriyi Varsayılan Olarak 'Kardiyo' Tutar.

    return AlertDialog( // Material Tasarımlı Bir AlertDialog Döndürür.
      backgroundColor: AppColors.surface, // Dialog Arka Plan Rengini Yüzey Rengi Yapar.
      title: const Text('Yeni Egzersiz Ekle'), // Dialog Başlığını Gösterir.
      content: SingleChildScrollView( // Dialog İçeriğini Kaydırılabilir Yapar.
        child: Column( // Giriş Alanlarını Dikey Olarak Sıralar.
          mainAxisSize: MainAxisSize.min, // Column'un Yüksekliğini İçeriğe Göre Minimumda Tutar.
          children: [ // Column'un Alt Widget'larını Tanımlar.
            TextField( // Egzersiz Adı Giriş Alanını Oluşturur.
              controller: titleController, // Alanı titleController İle Bağlar.
              decoration: const InputDecoration( // Giriş Alanının Görünümünü Belirler.
                labelText: 'Egzersiz Adı', // Alanın label Metnini Belirler.
                hintText: 'Örn: İp Atlama', // Alan Boşken Gösterilecek İpucu Metnidir.
              ),
            ),
            const SizedBox(height: 12), // 12 Piksel Dikey Boşluk Bırakır.
            TextField( // Süre Giriş Alanını Oluşturur.
              controller: durationController, // Alanı durationController İle Bağlar.
              keyboardType: TextInputType.number, // Sayısal Klavye Açılmasını Sağlar.
              decoration: const InputDecoration( // Giriş Alanının Görünümünü Belirler.
                labelText: 'Süre (dakika)', // Alanın label Metnini Belirler.
              ),
            ),
            const SizedBox(height: 12), // 12 Piksel Dikey Boşluk Bırakır.
            TextField( // Kalori Giriş Alanını Oluşturur.
              controller: calController, // Alanı calController İle Bağlar.
              keyboardType: TextInputType.number, // Sayısal Klavye Açılmasını Sağlar.
              decoration: const InputDecoration( // Giriş Alanının Görünümünü Belirler.
                labelText: 'Tahmini Kalori (kcal)', // Alanın label Metnini Belirler.
              ),
            ),
          ],
        ),
      ),
      actions: [ // Dialog'un Alt Kısmındaki Butonları Tanımlar.
        TextButton( // İptal Butonunu Oluşturur.
          onPressed: () => Navigator.of(context).pop(), // Butona Basılınca Dialog'u Kapatır.
          child: const Text('İptal'), // Butonun Metnini Gösterir.
        ),
        ElevatedButton( // Ekle Butonunu Oluşturur.
          onPressed: () { // Butona Basılınca Çalışacak Callback'tir.
            final title = titleController.text.trim(); // Girilen Başlığı Boşluklardan Temizleyerek Alır.
            final duration = int.tryParse(durationController.text) ?? 20; // Süreyi Sayıya Çevirir, Başarısızsa 20 Kullanır.
            final cal = int.tryParse(calController.text) ?? 150; // Kaloriyi Sayıya Çevirir, Başarısızsa 150 Kullanır.
            if (title.isNotEmpty) { // Başlık Boş Değilse Ekleme İşlemine Devam Eder.
              onAdd(title, selectedCategory, duration, cal); // Girilen Değerlerle onAdd Callback'ini Çağırır.
              Navigator.of(context).pop(); // Ekleme Sonrası Dialog'u Kapatır.
            }
          },
          child: const Text('Ekle'), // Butonun Metnini Gösterir.
        ),
      ],
    );
  }
}
