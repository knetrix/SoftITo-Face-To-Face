import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Renk Sabitlerini İçeren AppColors'u import Eder.

class WaterQuickAddWidget extends StatelessWidget { // Hızlı Su Ekleme Butonlarını Gösteren StatelessWidget'tır.
  final ValueChanged<int> onAddWater; // Su Eklendiğinde Miktarla Çağrılan Callback'tir.
  final VoidCallback onReset; // Sıfırlama Butonuna Basılınca Çağrılan Callback'tir.

  const WaterQuickAddWidget({ // Widget'ın const Constructor'ıdır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.onAddWater, // onAddWater Field'ını required Yapar.
    required this.onReset, // onReset Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Hızlı Ekleme Bölümünün Widget Tree'sini Oluşturur.
    return Column( // Başlık ve Buton Satırlarını Dikey Olarak Sıralar.
      crossAxisAlignment: CrossAxisAlignment.start, // Çocukları Sola Hizalar.
      children: [ // Column'un Alt Widget Listesidir.
        const Text( // Bölüm Başlığını Gösterir.
          'Hızlı Su Ekle', // Başlık Metnidir.
          style: TextStyle( // Başlığın Yazı Stilini Tanımlar.
            fontSize: 16, // Yazı Boyutunu 16 Yapar.
            fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
            color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
          ),
        ),
        const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
        Row( // Hızlı Ekleme Butonlarını Yatay Olarak Sıralar.
          children: [ // Row'un Alt Widget Listesidir.
            Expanded( // Butonun Kalan Alanı Eşit Paylaşmasını Sağlar.
              child: _QuickAddButton( // Bardak İçin Hızlı Ekleme Butonu Oluşturur.
                amount: 200, // Eklenecek Miktarı 200 ml Yapar.
                label: 'Bardak', // Butonun label'ını Belirler.
                icon: Icons.local_cafe, // Butonun Icon'unu Belirler.
                onTap: () => onAddWater(200), // Tıklanınca 200 ml Su Ekler.
              ),
            ),
            const SizedBox(width: 8), // Yatayda 8 Birim Boşluk Bırakır.
            Expanded( // Butonun Kalan Alanı Eşit Paylaşmasını Sağlar.
              child: _QuickAddButton( // Kutu İçin Hızlı Ekleme Butonu Oluşturur.
                amount: 330, // Eklenecek Miktarı 330 ml Yapar.
                label: 'Kutu', // Butonun label'ını Belirler.
                icon: Icons.sports_bar, // Butonun Icon'unu Belirler.
                onTap: () => onAddWater(330), // Tıklanınca 330 ml Su Ekler.
              ),
            ),
            const SizedBox(width: 8), // Yatayda 8 Birim Boşluk Bırakır.
            Expanded( // Butonun Kalan Alanı Eşit Paylaşmasını Sağlar.
              child: _QuickAddButton( // Şişe İçin Hızlı Ekleme Butonu Oluşturur.
                amount: 500, // Eklenecek Miktarı 500 ml Yapar.
                label: 'Şişe', // Butonun label'ını Belirler.
                icon: Icons.local_drink, // Butonun Icon'unu Belirler.
                onTap: () => onAddWater(500), // Tıklanınca 500 ml Su Ekler.
              ),
            ),
          ],
        ),
        const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
        Row( // Ekle ve Sıfırla Butonlarını Yatay Olarak Sıralar.
          children: [ // Row'un Alt Widget Listesidir.
            Expanded( // Ekle Butonunun Kalan Alanı Doldurmasını Sağlar.
              child: ElevatedButton.icon( // Icon'lu ElevatedButton Oluşturur.
                onPressed: () => onAddWater(250), // Basılınca 250 ml Su Ekler.
                icon: const Icon(Icons.add, size: 20), // Butonda Artı Icon'unu Gösterir.
                label: const Text('+250 ml Ekle'), // Butonun label Metnini Gösterir.
              ),
            ),
            const SizedBox(width: 12), // Yatayda 12 Birim Boşluk Bırakır.
            OutlinedButton.icon( // Icon'lu OutlinedButton Oluşturur.
              onPressed: onReset, // Basılınca Sıfırlama Callback'ini Çağırır.
              icon: const Icon(Icons.restart_alt, size: 20), // Butonda Yeniden Başlat Icon'unu Gösterir.
              label: const Text('Sıfırla'), // Butonun label Metnini Gösterir.
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget { // Tek Bir Hızlı Ekleme Butonunu Temsil Eden Private StatelessWidget'tır.
  final int amount; // Butonun Ekleyeceği Su Miktarıdır.
  final String label; // Butonun Altında Gösterilen Metindir.
  final IconData icon; // Butonda Gösterilen Icon'dur.
  final VoidCallback onTap; // Butona Tıklanınca Çağrılan Callback'tir.

  const _QuickAddButton({ // Butonun const Constructor'ıdır.
    required this.amount, // amount Field'ını required Yapar.
    required this.label, // label Field'ını required Yapar.
    required this.icon, // icon Field'ını required Yapar.
    required this.onTap, // onTap Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Butonun Widget Tree'sini Oluşturur.
    return InkWell( // Tıklanabilir ve Dalga Efektli Alan Oluşturur.
      onTap: onTap, // Tıklanınca onTap Callback'ini Çağırır.
      borderRadius: BorderRadius.circular(12), // Dalga Efektinin Köşe Yarıçapını 12 Yapar.
      child: Container( // Butonun Kutusunu Oluşturur.
        padding: const EdgeInsets.symmetric(vertical: 14), // Dikeyde 14 Birim İç Boşluk Bırakır.
        decoration: BoxDecoration( // Kutunun Görünümünü Tanımlar.
          color: AppColors.surface, // Kutunun Arka Plan Rengini Belirler.
          borderRadius: BorderRadius.circular(12), // Köşe Yarıçapını 12 Yapar.
          border: Border.all(color: AppColors.border), // Kutuya Kenarlık Ekler.
        ),
        child: Column( // Icon ve Metinleri Dikey Olarak Sıralar.
          children: [ // Column'un Alt Widget Listesidir.
            Icon(icon, color: AppColors.neonCyan, size: 22), // Butonun Icon'unu Neon Cyan Renkte Gösterir.
            const SizedBox(height: 4), // Dikeyde 4 Birim Boşluk Bırakır.
            Text( // Eklenecek Miktarı Gösterir.
              '+$amount ml', // Miktarı İçeren Metindir.
              style: const TextStyle( // Miktarın Yazı Stilini Tanımlar.
                color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
                fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                fontSize: 13, // Yazı Boyutunu 13 Yapar.
              ),
            ),
            Text( // Butonun label'ını Gösterir.
              label, // Gösterilecek label Metnidir.
              style: const TextStyle( // label'ın Yazı Stilini Tanımlar.
                color: AppColors.textSecondary, // Yazı Rengini İkincil Metin Rengi Yapar.
                fontSize: 11, // Yazı Boyutunu 11 Yapar.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
