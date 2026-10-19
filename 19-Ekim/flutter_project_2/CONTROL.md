# Kurallar

1. Projenin Kimliği & Vizyonu: Uygulama Nedir? Kime Hitap Eder? Hedef Platform?

2. Mimari Desen & Dizin Haritası: Dosyalar Nereye Kurulur (lib/core, lib/features, vb).

3. İzin Verilen ve Yasaklı Paketler: Hangi Kütüphaneler Serbest ve Hangileri Yasak veya Kesimlinlikle Yasak?

4. Kırmızı Çizgiler (Kesinlikle Uyulması Gerekenler)
- Asla setState ile Büyük Ağaç Tetikleme.
- const Zorunluluğu.
- buildContext async ile Kullanmak
- ...

5. Terminal ve Çalıştırma Komutları: Test Koşma, Lint Kontrolleri, Build Alma, vb. Komutlar

6. Ajan Davranışı ve Çıktı Standartları: Kodları Nasıl Sunmalı, Tam Dosya Mı, Yoksa Diff Mi, Türkçe Mi, Farklı Bir Dilde Açıklama Yapmak Mı vb.