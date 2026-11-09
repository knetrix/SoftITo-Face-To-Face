import 'dart:io'; // File Class'ını Kullanmak için dart:io Library'sini import Eder.

import 'package:flutter/material.dart'; // Material Widget'larını Kullanmak için flutter/material Library'sini import Eder.

class ImageUploadCard extends StatelessWidget { // Görsel Seçme, Önizleme ve Yükleme Arayüzünü Gösteren StatelessWidget'tır.
  final File? selectedFile; // Kullanıcının Seçtiği Yerel Dosyayı Tutan Nullable Field'dır.
  final String? uploadUrl; // Yüklenen Görselin Download URL'ini Tutan Nullable Field'dır.
  final bool isLoading; // Yükleme İşleminin Sürüp Sürmediğini Tutan Flag'dir.
  final VoidCallback onGallerySelect; // Galeriden Seç Butonuna Basılınca Çağrılan Callback'tir.
  final VoidCallback onTakePhoto; // Fotoğraf Çek Butonuna Basılınca Çağrılan Callback'tir.
  final VoidCallback onCloudUpload; // Buluta Yükle Butonuna Basılınca Çağrılan Callback'tir.

  const ImageUploadCard({ // Tüm Field'ları Named Parameter Olarak Alan const Constructor'dır.
    super.key, // key'i Üst Class'a İletir.
    required this.selectedFile, // selectedFile Parametresini Zorunlu Yapar.
    required this.uploadUrl, // uploadUrl Parametresini Zorunlu Yapar.
    required this.isLoading, // isLoading Parametresini Zorunlu Yapar.
    required this.onGallerySelect, // onGallerySelect Parametresini Zorunlu Yapar.
    required this.onTakePhoto, // onTakePhoto Parametresini Zorunlu Yapar.
    required this.onCloudUpload, // onCloudUpload Parametresini Zorunlu Yapar.
  });

  @override // Üst Class'taki build Metodunu Override Eder.
  Widget build(BuildContext context) { // Kartın Widget Ağacını Oluşturan build Metodudur.
    return Card( // Kart Görünümü Sağlayan Card Döndürür.
      elevation: 0, // Kartın Gölgesini Kaldırır.
      shape: RoundedRectangleBorder( // Kartın Köşeleri Yuvarlatılmış Şeklini Tanımlar.
        borderRadius: BorderRadius.circular(16), // Köşeleri 16 Birim Yuvarlatır.
        side: BorderSide(color: Colors.grey.shade300), // Kartın Kenarına Açık Gri Border Ekler.
      ),
      child: Padding( // Kart İçeriğine İç Boşluk Ekleyen Padding'dir.
        padding: const EdgeInsets.all(16.0), // Her Yönden 16 Birim Boşluk Verir.
        child: Column( // İçerikleri Dikey Sıralayan Column'dur.
          crossAxisAlignment: CrossAxisAlignment.stretch, // Child'ları Yatayda Tam Genişliğe Yayar.
          children: [
            const Row( // Başlık İkonu ve Metnini Yan Yana Dizen Row'dur.
              children: [
                Icon(Icons.cloud_upload_outlined, color: Color(0xFF0047FF)), // Mavi Renkli Bulut Yükleme İkonunu Gösterir.
                SizedBox(width: 8), // İkon ile Metin Arasına 8 Birim Boşluk Koyar.
                Text( // Kart Başlığını Gösteren Text'tir.
                  'Supabase Media Uploader', // Başlık Metnini Belirler.
                  style: TextStyle( // Başlığın Yazı Stilini Tanımlar.
                    fontSize: 16, // Yazı Boyutunu 16 Yapar.
                    fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                    color: Color.fromARGB(255, 46, 121, 212), // Yazı Rengini ARGB ile Mavi Yapar.
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14), // Başlık ile Önizleme Alanı Arasına 14 Birim Boşluk Koyar.
            Container( // Görsel Önizleme Alanını Oluşturan Container'dır.
              height: 180, // Önizleme Alanının Yüksekliğini 180 Yapar.
              decoration: BoxDecoration( // Container'ın Görünümünü Tanımlar.
                color: Color.fromARGB(255, 12, 6, 37), // Arka Plan Rengini Koyu Lacivert Yapar.
                borderRadius: BorderRadius.circular(8), // Köşeleri 8 Birim Yuvarlatır.
                border: Border.all(color: Colors.grey.shade300), // Her Kenara Açık Gri Border Ekler.
              ),
              alignment: Alignment.center, // Child'ı Container'ın Ortasına Hizalar.
              child: selectedFile != null // Yerel Dosya Seçildiyse Onu Gösterir.
                  ? ClipRRect( // Görselin Köşelerini Yuvarlatarak Kırpan ClipRRect'tir.
                      borderRadius: BorderRadius.circular(12), // Kırpma Köşelerini 12 Birim Yuvarlatır.
                      child: Image.file( // Seçilen Yerel Dosyayı Görsel Olarak Gösterir.
                        selectedFile!, // Null Olmadığı Kesin Olan selectedFile'ı Verir.
                        fit: BoxFit.cover, // Görseli Alanı Tamamen Kaplayacak Şekilde Ölçekler.
                        width: double.infinity, // Görselin Genişliğini Mümkün Olan En Geniş Değere Ayarlar.
                        height: double.infinity, // Görselin Yüksekliğini Mümkün Olan En Yüksek Değere Ayarlar.
                      ),
                    )
                  : (uploadUrl != null // Yerel Dosya Yoksa uploadUrl'in Varlığını Kontrol Eder.
                        ? ClipRRect( // Network Görselinin Köşelerini Yuvarlatarak Kırpan ClipRRect'tir.
                            borderRadius: BorderRadius.circular(12), // Kırpma Köşelerini 12 Birim Yuvarlatır.
                            child: Image.network( // uploadUrl'deki Görseli Network'ten Yükleyip Gösterir.
                              uploadUrl!, // Null Olmadığı Kesin Olan uploadUrl'i Verir.
                              fit: BoxFit.cover, // Görseli Alanı Tamamen Kaplayacak Şekilde Ölçekler.
                              width: double.infinity, // Görselin Genişliğini Mümkün Olan En Geniş Değere Ayarlar.
                              height: double.infinity, // Görselin Yüksekliğini Mümkün Olan En Yüksek Değere Ayarlar.
                            ),
                          )
                        : Column( // Görsel Yoksa Boş Durum Mesajını Dikey Sıralayan Column'dur.
                            mainAxisAlignment: MainAxisAlignment.center, // Child'ları Dikeyde Ortalar.
                            children: [
                              Icon( // Boş Durumu Temsil Eden Görsel İkonunu Gösterir.
                                Icons.image_outlined, // Görsel İkonunu Belirler.
                                size: 48, // İkon Boyutunu 48 Yapar.
                                color: Colors.grey.shade500, // İkon Rengini Orta Gri Yapar.
                              ),
                              const SizedBox(height: 8), // İkon ile Metin Arasına 8 Birim Boşluk Koyar.
                              Text( // Henüz Görsel Seçilmediğini Bildiren Text'tir.
                                'No Image Selected Yet', // Boş Durum Mesajını Belirler.
                                style: TextStyle(color: Colors.grey.shade600), // Metin Rengini Koyu Gri Yapar.
                              ),
                            ],
                          )),
            ),
            if (isLoading) ...[ // Yükleme Sürüyorsa Aşağıdaki Widget'ları List'e Spread Eder.
              const SizedBox(height: 12), // Önizleme ile Progress Bar Arasına 12 Birim Boşluk Koyar.
              LinearProgressIndicator( // Yükleme İlerlemesini Yatay Çubukla Gösterir.
                // value Verilmediği için Çubuk Belirsiz (Indeterminate) Modda Animasyon Yapar.
                color: const Color.fromARGB(255, 8, 69, 3), // Çubuğun Dolu Kısmının Rengini Belirler.
                backgroundColor: Colors.grey.shade200, // Çubuğun Boş Kısmının Rengini Açık Gri Yapar.
                minHeight: 6, // Çubuğun Minimum Yüksekliğini 6 Yapar.
                borderRadius: BorderRadius.circular(4), // Çubuğun Köşelerini 4 Birim Yuvarlatır.
              ),
              const SizedBox(height: 4), // Progress Bar ile Yüzde Metni Arasına 4 Birim Boşluk Koyar.
              Text( // Yükleme Yüzdesini Gösteren Text'tir.
                'Uploading...', // Yükleme Sürerken Sabit Bir Metin Gösterir.
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Metni 12 Boyutunda ve Kalın Yapar.
              ),
            ],
            const SizedBox(height: 14), // Üstteki İçerik ile Butonlar Arasına 14 Birim Boşluk Koyar.
            Row( // Galeri ve Kamera Butonlarını Yan Yana Dizen Row'dur.
              children: [
                Expanded( // Galeri Butonunun Kalan Alanı Eşit Paylaşmasını Sağlar.
                  child: OutlinedButton.icon( // İkonlu Çerçeveli Galeri Butonudur.
                    onPressed: isLoading ? null : onGallerySelect, // Yükleme Sürüyorsa Butonu Devre Dışı Bırakır, Değilse onGallerySelect'i Çağırır.
                    label: const Text('Select From Gallery'), // Buton Metnini Belirler.
                    icon: const Icon(Icons.photo_library_outlined), // Buton İkonunu Galeri İkonu Yapar.
                  ),
                ),
                const SizedBox(width: 8), // İki Buton Arasına 8 Birim Boşluk Koyar.
                Expanded( // Kamera Butonunun Kalan Alanı Eşit Paylaşmasını Sağlar.
                  child: OutlinedButton.icon( // İkonlu Çerçeveli Kamera Butonudur.
                    onPressed: isLoading ? null : onTakePhoto, // Yükleme Sürüyorsa Butonu Devre Dışı Bırakır, Değilse onTakePhoto'yu Çağırır.
                    label: const Text('Take Photo'), // Buton Metnini Belirler.
                    icon: const Icon(Icons.camera_alt_outlined), // Buton İkonunu Kamera İkonu Yapar.
                  ),
                ),
              ],
            ),
            if (selectedFile != null) ...[ // Dosya Seçildiyse Yükleme Butonunu List'e Spread Eder.
              const SizedBox(height: 8), // Butonlar Arasına 8 Birim Boşluk Koyar.
              FilledButton.icon( // İkonlu Dolgulu Buluta Yükle Butonudur.
                onPressed: isLoading ? null : onCloudUpload, // Yükleme Sürüyorsa Butonu Devre Dışı Bırakır, Değilse onCloudUpload'u Çağırır.
                label: const Text('Upload To Cloud'), // Buton Metnini Belirler.
                style: FilledButton.styleFrom( // Butonun Stilini Özelleştirir.
                  backgroundColor: const Color.fromARGB(255, 165, 94, 0), // Butonun Arka Plan Rengini Belirler.
                ),
                icon: const Icon(Icons.cloud_upload_outlined), // Buton İkonunu Bulut Yükleme İkonu Yapar.
              ),
            ],
          ],
        ),
      ),
    );
  }
}
