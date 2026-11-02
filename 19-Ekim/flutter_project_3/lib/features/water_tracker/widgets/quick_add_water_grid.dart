import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

class QuickAddWaterGrid extends StatelessWidget { // Hızlı Su Ekleme Butonlarını Gösteren StatelessWidget'tır.
  final ValueChanged<int> onAddWater; // Su Eklenince Çağrılan Callback'tir.

  const QuickAddWaterGrid({super.key, required this.onAddWater}); // key'i Superclass'a İleten ve onAddWater'ı required Alan const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Buton Satırının Widget Tree'sini Oluşturur.
    return Row( // Butonları Yatay Olarak Sıralar.
      children: [ // Row'un Alt Widget'larını Tanımlar.
        Expanded( // İlk Butonun Eşit Genişlik Almasını Sağlar.
          child: _QuickAddButton( // 200 ml'lik Hızlı Ekleme Butonunu Oluşturur.
            amountMl: 200, // Eklenecek Miktarı 200 ml Yapar.
            label: 'Bardak (200ml)', // Buton Etiketini Belirler.
            icon: Icons.local_drink, // Bardak Icon'unu Kullanır.
            onTap: () => onAddWater(200), // Tıklanınca 200 ml Su Ekler.
          ),
        ),
        const SizedBox(width: 12), // Butonlar Arasında 12 Piksel Boşluk Bırakır.
        Expanded( // İkinci Butonun Eşit Genişlik Almasını Sağlar.
          child: _QuickAddButton( // 500 ml'lik Hızlı Ekleme Butonunu Oluşturur.
            amountMl: 500, // Eklenecek Miktarı 500 ml Yapar.
            label: 'Şişe (500ml)', // Buton Etiketini Belirler.
            icon: Icons.water_drop, // Su Damlası Icon'unu Kullanır.
            onTap: () => onAddWater(500), // Tıklanınca 500 ml Su Ekler.
          ),
        ),
        const SizedBox(width: 12), // Butonlar Arasında 12 Piksel Boşluk Bırakır.
        Expanded( // Üçüncü Butonun Eşit Genişlik Almasını Sağlar.
          child: _QuickAddButton( // 750 ml'lik Hızlı Ekleme Butonunu Oluşturur.
            amountMl: 750, // Eklenecek Miktarı 750 ml Yapar.
            label: 'Matara (750ml)', // Buton Etiketini Belirler.
            icon: Icons.fitness_center, // Fitness Icon'unu Kullanır.
            onTap: () => onAddWater(750), // Tıklanınca 750 ml Su Ekler.
          ),
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget { // Tek Bir Hızlı Su Ekleme Butonunu Temsil Eden Private StatelessWidget'tır.
  final int amountMl; // Butonun Ekleyeceği Su Miktarını Tutar.
  final String label; // Buton Alt Etiketini Tutar.
  final IconData icon; // Butonda Gösterilecek Icon'u Tutar.
  final VoidCallback onTap; // Butona Tıklanınca Çağrılan Callback'tir.

  const _QuickAddButton({ // Tüm Field'ları Alan const Constructor'dır.
    required this.amountMl, // amountMl Field'ını required Yapar.
    required this.label, // label Field'ını required Yapar.
    required this.icon, // icon Field'ını required Yapar.
    required this.onTap, // onTap Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Butonun Widget Tree'sini Oluşturur.
    final theme = Theme.of(context); // Aktif ThemeData'yı Alır.
    final isDark = theme.brightness == Brightness.dark; // Dark Mode Aktif mi Diye Hesaplar.
    final primaryColor = theme.colorScheme.primary; // Theme'in primary Rengini Alır.

    final bgColor = isDark ? const Color(0xFF161B22) : Colors.white; // Moda Göre Arka Plan Rengini Seçer.
    final borderColor = isDark // Moda Göre Border Rengini Seçer.
        ? const Color(0xFF30363D) // Dark Mode İçin Border Rengidir.
        : const Color(0xFFD0D7DE); // Light Mode İçin Border Rengidir.
    final titleColor = isDark // Moda Göre Başlık Rengini Seçer.
        ? const Color(0xFFF0F6FC) // Dark Mode İçin Başlık Rengidir.
        : const Color(0xFF1F2328); // Light Mode İçin Başlık Rengidir.
    final subtitleColor = isDark // Moda Göre Alt Başlık Rengini Seçer.
        ? const Color(0xFF8B949E) // Dark Mode İçin Alt Başlık Rengidir.
        : const Color(0xFF656D76); // Light Mode İçin Alt Başlık Rengidir.

    return InkWell( // Tıklanabilir ve Ripple Efektli Alan Oluşturur.
      onTap: onTap, // Tıklanınca onTap Callback'ini Çağırır.
      borderRadius: BorderRadius.circular(14), // Ripple Efektinin Köşelerini Yuvarlar.
      child: Container( // Butonun Görsel Kutusunu Oluşturur.
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8), // Kutunun İç Boşluğunu Belirler.
        decoration: BoxDecoration( // Kutunun Dekorasyonunu Tanımlar.
          color: bgColor, // Arka Plan Rengini Uygular.
          borderRadius: BorderRadius.circular(14), // Kutu Köşelerini Yuvarlar.
          border: Border.all(color: borderColor), // Kutuya Border Ekler.
        ),
        child: Column( // İçeriği Dikey Olarak Sıralar.
          mainAxisSize: MainAxisSize.min, // Column'u İçeriği Kadar Yükseklikte Tutar.
          children: [ // Column'un Alt Widget'larını Tanımlar.
            Icon(icon, color: primaryColor, size: 26), // Buton Icon'unu primary Renkte Gösterir.
            const SizedBox(height: 8), // 8 Piksel Dikey Boşluk Bırakır.
            Text( // Eklenecek Miktarı Gösteren Text'tir.
              '+$amountMl ml', // Miktarı +X ml Formatında Yazar.
              style: TextStyle( // Miktar Yazısının Stilini Tanımlar.
                fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                fontSize: 14, // Font Boyutunu 14 Yapar.
                color: titleColor, // Başlık Rengini Uygular.
              ),
            ),
            const SizedBox(height: 2), // 2 Piksel Dikey Boşluk Bırakır.
            Text( // Buton Etiketini Gösteren Text'tir.
              label, // label Değerini Yazar.
              maxLines: 1, // Yazıyı Tek Satırla Sınırlar.
              overflow: TextOverflow.ellipsis, // Taşan Yazıyı Üç Noktayla Keser.
              style: TextStyle(fontSize: 10, color: subtitleColor), // Küçük Font ve Alt Başlık Rengi Uygular.
            ),
          ],
        ),
      ),
    );
  }
}
