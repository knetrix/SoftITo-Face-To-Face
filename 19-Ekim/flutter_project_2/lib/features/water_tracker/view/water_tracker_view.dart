import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../../../core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.
import '../controller/water_tracker_controller.dart'; // Su Takibi Controller'ını import Eder.
import '../models/water_log.dart'; // WaterLog Model'ini import Eder.

class WaterTrackerView extends StatelessWidget { // Su Takibi Sayfasıdır, State Tutmayan Bir StatelessWidget'tır.
  const WaterTrackerView({required this.controller, super.key}); // controller'ı required Alıp key'i Superclass'a İleten const Constructor'dır.

  final WaterTrackerController controller; // Sayfanın Kullandığı Su Takibi Controller'ıdır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Su Takibi Sayfasının Widget Tree'sini Oluşturur.
    return ListenableBuilder( // Controller Değiştikçe Arayüzü Yeniden Çizen Builder'dır.
      listenable: controller, // Dinlenecek Listenable Olarak controller'ı Verir.
      builder: (context, _) { // Her Değişiklikte Çağrılan builder Callback'idir.
        return SingleChildScrollView( // İçeriği Kaydırılabilir Hale Getirir.
          padding: const EdgeInsets.all(16), // Her Yönden 16 Birim Boşluk Verir.
          child: Column( // Child Widget'larını Dikey Olarak Dizer.
            crossAxisAlignment: CrossAxisAlignment.stretch, // Child Widget'ları Yatayda Tam Genişliğe Yayar.
            children: [ // Column'un Child Widget Listesini Başlatır.
              _WaterProgressCard(controller: controller), // Su İlerleme Kartını Gösterir.
              const SizedBox(height: 16), // Dikey 16 Birim Boşluk Bırakır.
              _WaterActionButtons(onAdd: controller.addWater), // Su Ekleme Butonlarını addWater Callback'iyle Gösterir.
              const SizedBox(height: 20), // Dikey 20 Birim Boşluk Bırakır.
              _WaterHistorySection(logs: controller.logs), // Su Kayıt Geçmişini Gösterir.
            ],
          ),
        );
      },
    );
  }
}

class _WaterProgressCard extends StatelessWidget { // Günlük Su İlerlemesini Gösteren Private StatelessWidget'tır.
  const _WaterProgressCard({required this.controller}); // controller'ı required Alan const Constructor'dır.

  final WaterTrackerController controller; // İlerleme Verisinin Alındığı Controller'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // İlerleme Kartının Widget Tree'sini Oluşturur.
    final progress = controller.progressRatio; // Hedefe Ulaşma Oranını Alır.
    final percent = (progress * 100).toInt(); // Oranı Tam Sayı Yüzdeye Çevirir.

    return Card( // İlerleme Bilgilerini İçeren Kartı Oluşturur.
      child: Padding( // Kart İçeriğine Boşluk Ekler.
        padding: const EdgeInsets.all(20), // Her Yönden 20 Birim Boşluk Verir.
        child: Column( // Kart İçeriğini Dikey Dizer.
          children: [ // Column'un Child Widget Listesini Başlatır.
            const Text( // Başlık Metnini Oluşturur.
              'GÜNLÜK SU HEDEFİ', // Gösterilecek Başlık Metnidir.
              style: TextStyle( // Başlık Stilini Tanımlar.
                color: AppColors.textSecondary, // Metin Rengini İkincil Renk Yapar.
                fontSize: 12, // Yazı Boyutunu 12 Yapar.
                letterSpacing: 1.2, // Harf Aralığını 1.2 Yapar.
                fontWeight: FontWeight.w600, // Yazı Kalınlığını w600 Yapar.
              ),
            ),
            const SizedBox(height: 12), // Dikey 12 Birim Boşluk Bırakır.
            Text( // Tüketilen ve Hedef Miktarı Gösteren Metni Oluşturur.
              '${controller.totalConsumedMl} / ${controller.dailyGoalMl} ml', // Toplam Tüketimi ve Günlük Hedefi Yazdırır.
              style: const TextStyle( // Miktar Metninin Stilini Tanımlar.
                color: AppColors.neonCyan, // Metin Rengini Neon Cyan Yapar.
                fontSize: 28, // Yazı Boyutunu 28 Yapar.
                fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
              ),
            ),
            const SizedBox(height: 16), // Dikey 16 Birim Boşluk Bırakır.
            LinearProgressIndicator( // Yatay İlerleme Çubuğunu Oluşturur.
              value: progress, // Çubuğun Doluluk Oranını Belirler.
              minHeight: 12, // Çubuğun Minimum Yüksekliğini 12 Yapar.
              borderRadius: BorderRadius.circular(6), // Çubuğun Köşelerini Yuvarlatır.
              backgroundColor: AppColors.surfaceVariant, // Çubuğun Boş Kısmının Rengini Belirler.
              valueColor: const AlwaysStoppedAnimation<Color>( // Dolu Kısmın Rengini Sabit Animation Olarak Verir.
                AppColors.neonCyan, // Dolu Kısmı Neon Cyan Yapar.
              ),
            ),
            const SizedBox(height: 8), // Dikey 8 Birim Boşluk Bırakır.
            Text( // Tamamlanma Yüzdesini Gösteren Metni Oluşturur.
              '%$percent Tamamlandı', // Yüzde Değerini Yazdırır.
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12), // Soluk Renkli Küçük Yazı Stili Uygular.
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterActionButtons extends StatelessWidget { // Su Ekleme Butonlarını Gösteren Private StatelessWidget'tır.
  const _WaterActionButtons({required this.onAdd}); // onAdd Callback'ini required Alan const Constructor'dır.

  final void Function(int amount) onAdd; // Butona Basılınca Miktarla Çağrılan Callback'tir.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Buton Satırının Widget Tree'sini Oluşturur.
    return Row( // Butonları Yatay Olarak Dizer.
      children: [ // Row'un Child Widget Listesini Başlatır.
        _buildButton(250, '250 ml'), // 250 ml Ekleme Butonunu Oluşturur.
        const SizedBox(width: 8), // Yatay 8 Birim Boşluk Bırakır.
        _buildButton(500, '500 ml'), // 500 ml Ekleme Butonunu Oluşturur.
        const SizedBox(width: 8), // Yatay 8 Birim Boşluk Bırakır.
        _buildButton(750, '750 ml'), // 750 ml Ekleme Butonunu Oluşturur.
      ],
    );
  }

  Widget _buildButton(int ml, String label) { // Verilen Miktar ve Etiketle Buton Oluşturan Yardımcı Metottur.
    return Expanded( // Butonun Kalan Alanı Eşit Paylaşmasını Sağlar.
      child: ElevatedButton( // Yükseltilmiş Buton Oluşturur.
        style: ElevatedButton.styleFrom( // Butonun Stilini Tanımlar.
          backgroundColor: AppColors.surfaceVariant, // Buton Arka Plan Rengini Belirler.
          foregroundColor: AppColors.neonCyan, // Buton Yazı ve İkon Rengini Belirler.
          side: const BorderSide(color: AppColors.border), // Buton Kenarlık Rengini Belirler.
          padding: const EdgeInsets.symmetric(vertical: 12), // Dikey 12 Birim İç Boşluk Verir.
          shape: RoundedRectangleBorder( // Butonun Köşe Şeklini Tanımlar.
            borderRadius: BorderRadius.circular(12), // Köşe Yarıçapını 12 Olarak Belirler.
          ),
        ),
        onPressed: () => onAdd(ml), // Basılınca onAdd Callback'ini Miktarla Çağırır.
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)), // Buton Etiketini Kalın Yazıyla Gösterir.
      ),
    );
  }
}

class _WaterHistorySection extends StatelessWidget { // Su Kayıt Geçmişini Gösteren Private StatelessWidget'tır.
  const _WaterHistorySection({required this.logs}); // logs Listesini required Alan const Constructor'dır.

  final List<WaterLog> logs; // Gösterilecek Su Kayıtlarının Listesidir.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Geçmiş Bölümünün Widget Tree'sini Oluşturur.
    if (logs.isEmpty) { // Kayıt Yoksa Boş Durum Mesajı Gösterir.
      return const Center( // Mesajı Ortalar.
        child: Padding( // Mesaja Boşluk Ekler.
          padding: EdgeInsets.symmetric(vertical: 24), // Dikey 24 Birim Boşluk Verir.
          child: Text( // Boş Durum Metnini Oluşturur.
            'Henüz su kaydı girilmedi.', // Gösterilecek Boş Durum Metnidir.
            style: TextStyle(color: AppColors.textMuted), // Soluk Metin Rengi Uygular.
          ),
        ),
      );
    }

    return Column( // Başlık ve Listeyi Dikey Dizer.
      crossAxisAlignment: CrossAxisAlignment.start, // Child Widget'ları Sola Hizalar.
      children: [ // Column'un Child Widget Listesini Başlatır.
        const Text( // Bölüm Başlığını Oluşturur.
          'Günün Kayıtları', // Gösterilecek Başlık Metnidir.
          style: TextStyle( // Başlık Stilini Tanımlar.
            color: AppColors.textPrimary, // Metin Rengini Birincil Renk Yapar.
            fontSize: 16, // Yazı Boyutunu 16 Yapar.
            fontWeight: FontWeight.w600, // Yazı Kalınlığını w600 Yapar.
          ),
        ),
        const SizedBox(height: 8), // Dikey 8 Birim Boşluk Bırakır.
        ListView.separated( // Aralarında Ayırıcı Olan Bir ListView Oluşturur.
          shrinkWrap: true, // ListView'ın Sadece İçeriği Kadar Yer Kaplamasını Sağlar.
          physics: const NeverScrollableScrollPhysics(), // ListView'ın Kendi Kaydırmasını Kapatır.
          itemCount: logs.length > 5 ? 5 : logs.length, // En Fazla 5 Kayıt Gösterir.
          separatorBuilder: (context, index) => const SizedBox(height: 8), // Elemanlar Arasına 8 Birim Boşluk Koyar.
          itemBuilder: (context, index) { // Her Eleman İçin Widget Oluşturan Callback'tir.
            final log = logs[index]; // İlgili Index'teki Kaydı Alır.
            return Container( // Kayıt Satırının Kutusunu Oluşturur.
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Yatay 16, Dikey 12 Birim İç Boşluk Verir.
              decoration: BoxDecoration( // Kutunun Görünümünü Tanımlar.
                color: AppColors.surface, // Kutu Arka Plan Rengini Belirler.
                borderRadius: BorderRadius.circular(10), // Köşe Yarıçapını 10 Olarak Belirler.
                border: Border.all(color: AppColors.border), // Kutuya Kenarlık Ekler.
              ),
              child: Row( // Miktar ve Saati Yatay Dizer.
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Elemanları İki Uca Yaslar.
                children: [ // Row'un Child Widget Listesini Başlatır.
                  Text( // Eklenen Miktarı Gösteren Metni Oluşturur.
                    '+${log.amountMl} ml', // Kaydın Miktarını Yazdırır.
                    style: const TextStyle( // Miktar Metninin Stilini Tanımlar.
                      color: AppColors.neonCyan, // Metin Rengini Neon Cyan Yapar.
                      fontWeight: FontWeight.w600, // Yazı Kalınlığını w600 Yapar.
                    ),
                  ),
                  Text( // Kayıt Saatini Gösteren Metni Oluşturur.
                    '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}', // Saat ve Dakikayı İki Haneli Formatta Yazdırır.
                    style: const TextStyle( // Saat Metninin Stilini Tanımlar.
                      color: AppColors.textMuted, // Metin Rengini Soluk Renk Yapar.
                      fontSize: 12, // Yazı Boyutunu 12 Yapar.
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
