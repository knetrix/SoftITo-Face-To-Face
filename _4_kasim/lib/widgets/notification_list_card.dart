import 'package:flutter/material.dart'; // Material Widget'larını Kullanmak için flutter/material Library'sini import Eder.

import '../models/notification_model.dart'; // NotificationModel Class'ını import Eder.

class NotificationListCard extends StatelessWidget { // FCM Token, Topic Aboneliği ve Bildirim Listesini Gösteren StatelessWidget'tır.
  final List<NotificationModel> notifications; // Gelen Bildirimlerin List'ini Tutan Field'dır.
  final String token; // Cihazın FCM Token'ını Tutan Field'dır.
  final bool isSubscribedToTopic; // Topic'e Abone Olunup Olunmadığını Tutan Flag'dir.
  final ValueChanged<bool> onSubscribeChange; // Abonelik Switch'i Değişince Çağrılan Callback'tir.

  const NotificationListCard({ // Tüm Field'ları Named Parameter Olarak Alan const Constructor'dır.
    super.key, // key'i Üst Class'a İletir.
    required this.notifications, // notifications Parametresini Zorunlu Yapar.
    required this.token, // token Parametresini Zorunlu Yapar.
    required this.isSubscribedToTopic, // isSubscribedToTopic Parametresini Zorunlu Yapar.
    required this.onSubscribeChange, // onSubscribeChange Parametresini Zorunlu Yapar.
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
        padding: const EdgeInsets.all(16), // Her Yönden 16 Birim Boşluk Verir.
        child: Column( // İçerikleri Dikey Sıralayan Column'dur.
          crossAxisAlignment: CrossAxisAlignment.stretch, // Child'ları Yatayda Tam Genişliğe Yayar.
          children: [
            Row( // Başlık ve Abonelik Switch'ini Yan Yana Dizen Row'dur.
              children: [
                const Icon(Icons.notifications, color: Color(0xFF006C4A)), // Yeşil Renkli Bildirim İkonunu Gösterir.
                const SizedBox(width: 8), // İkon ile Başlık Arasına 8 Birim Boşluk Koyar.
                const Expanded( // Başlığın Kalan Yatay Alanı Kaplamasını Sağlar.
                  child: Text( // Kart Başlığını Gösteren Text'tir.
                    'FCM Notification Center', // Başlık Metnini Belirler.
                    style: TextStyle( // Başlığın Yazı Stilini Tanımlar.
                      color: Color(0xFF0F172A), // Yazı Rengini Koyu Lacivert Yapar.
                      fontSize: 16, // Yazı Boyutunu 16 Yapar.
                      fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                    ),
                  ),
                ),
                Switch( // Topic Aboneliğini Açıp Kapatan Switch'tir.
                  value: isSubscribedToTopic, // Switch Durumunu isSubscribedToTopic'e Bağlar.
                  onChanged: onSubscribeChange, // Değişiklikte onSubscribeChange Callback'ini Çağırır.
                  activeThumbColor: const Color.fromARGB(255, 160, 40, 50), // Aktifken Thumb Rengini Belirler.
                ),
              ],
            ),
            const SizedBox(height: 8), // Başlık ile Abonelik Durumu Arasına 8 Birim Boşluk Koyar.
            Text( // Abonelik Durumunu Gösteren Text'tir.
              isSubscribedToTopic ? 'Subscribed' : 'Not Subscribed', // Aboneyse Subscribed, Değilse Not Subscribed Yazar.
              style: TextStyle( // Durum Metninin Stilini Tanımlar.
                color: isSubscribedToTopic // Abonelik Durumuna Göre Renk Seçer.
                    ? const Color.fromARGB(255, 24, 59, 17) // Aboneyse Yeşil Tonunu Kullanır.
                    : Colors.grey.shade600, // Abone Değilse Koyu Gri Kullanır.
                fontSize: 16, // Yazı Boyutunu 16 Yapar.
                fontWeight: FontWeight.w600, // Yazıyı Yarı Kalın Yapar.
              ),
            ),
            const SizedBox(height: 12), // Durum Metni ile Token Kutusu Arasına 12 Birim Boşluk Koyar.
            Container( // FCM Token'ı Gösteren Kutuyu Oluşturan Container'dır.
              padding: const EdgeInsets.all(10), // Her Yönden 10 Birim İç Boşluk Verir.
              decoration: BoxDecoration( // Container'ın Görünümünü Tanımlar.
                color: const Color(0xFF0F172A), // Arka Plan Rengini Koyu Lacivert Yapar.
                borderRadius: BorderRadius.circular(8), // Köşeleri 8 Birim Yuvarlatır.
              ),
              child: Column( // Token Etiketi ve Değerini Dikey Sıralayan Column'dur.
                crossAxisAlignment: CrossAxisAlignment.start, // Child'ları Sola Hizalar.
                children: [
                  const Text( // Token Etiketini Gösteren Text'tir.
                    "Device FCM Token", // Etiket Metnini Belirler.
                    style: TextStyle( // Etiketin Yazı Stilini Tanımlar.
                      color: Colors.white70, // Koyu Zeminde Okunması için Yazı Rengini Yarı Saydam Beyaz Yapar.
                      fontSize: 11, // Yazı Boyutunu 11 Yapar.
                    ),
                  ),
                  const SizedBox(height: 2), // Etiket ile Token Arasına 2 Birim Boşluk Koyar.
                  SelectableText( // Kullanıcının Kopyalayabileceği Seçilebilir Token Metnidir.
                    token.isEmpty ? 'Fetching Token...' : token, // Token Boşsa Yükleniyor Mesajını, Değilse Token'ı Gösterir.
                    style: const TextStyle( // Token Metninin Stilini Tanımlar.
                      color: Color(0xFF4ADE80), // Koyu Zeminde Okunması için Yazı Rengini Açık Yeşil Yapar.
                      fontSize: 11, // Yazı Boyutunu 11 Yapar.
                      fontFamily: 'monospace', // Yazı Tipini monospace Yapar.
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14), // Token Kutusu ile Liste Başlığı Arasına 14 Birim Boşluk Koyar.
            Text( // Gelen Bildirim Sayısını Gösteren Liste Başlığıdır.
              'Coming Notifications (${notifications.length}):', // Başlığa Bildirim Sayısını Interpolation ile Ekler.
              style: const TextStyle( // Liste Başlığının Stilini Tanımlar.
                color: Color(0xFF0F172A), // Yazı Rengini Koyu Lacivert Yapar.
                fontSize: 16, // Yazı Boyutunu 16 Yapar.
                fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
              ),
            ),
            const SizedBox(height: 8), // Liste Başlığı ile Liste Arasına 8 Birim Boşluk Koyar.
            notifications.isEmpty // Bildirim Listesinin Boş Olup Olmadığını Kontrol Eder.
                ? Container( // Liste Boşsa Boş Durum Mesajını Saran Container'dır.
                    padding: const EdgeInsets.all(24), // Her Yönden 24 Birim İç Boşluk Verir.
                    alignment: Alignment.center, // Mesajı Ortaya Hizalar.
                    child: Text( // Bildirim Olmadığını Bildiren Text'tir.
                      'No Notifications Available.', // Boş Durum Mesajını Belirler.
                      style: TextStyle( // Mesajın Yazı Stilini Tanımlar.
                        color: Colors.grey.shade600, // Yazı Rengini Koyu Gri Yapar.
                        fontSize: 14, // Yazı Boyutunu 14 Yapar.
                      ),
                    ),
                  )
                : ListView.separated( // Bildirimleri Aralarına Ayraç Koyarak Listeleyen ListView'dır.
                    shrinkWrap: true, // ListView'ın Sadece İçeriği Kadar Yer Kaplamasını Sağlar.
                    physics: const NeverScrollableScrollPhysics(), // Üst Scroll ile Çakışmaması için Kendi Scroll'unu Kapatır.
                    itemCount: notifications.length, // Liste Eleman Sayısını Belirler.
                    separatorBuilder: (_, _) => const Divider(height: 1), // Elemanlar Arasına 1 Birim Yüksekliğinde Divider Koyar.
                    itemBuilder: (context, index) { // Her index için Bir Satır Üreten Callback'tir.
                      final b = notifications[index]; // index'teki NotificationModel Nesnesini Alır.
                      return ListTile( // Bildirim Bilgilerini Gösteren ListTile Döndürür.
                        contentPadding: EdgeInsets.zero, // ListTile'ın Varsayılan İç Boşluğunu Kaldırır.
                        leading: const CircleAvatar( // Sol Tarafta Yuvarlak İkon Alanı Oluşturan CircleAvatar'dır.
                          backgroundColor: Color.fromARGB(255, 123, 238, 230), // CircleAvatar Arka Plan Rengini Belirler.
                          child: Icon( // CircleAvatar İçindeki Okunmamış Mail İkonudur.
                            Icons.mark_email_unread_outlined, // Okunmamış Mail İkonunu Belirler.
                            color: Color.fromARGB(255, 113, 25, 25), // İkon Rengini Belirler.
                            size: 20, // İkon Boyutunu 20 Yapar.
                          ),
                        ),
                        title: Text( // Bildirim Başlığını Gösteren Text'tir.
                          b.title, // NotificationModel'in title'ını Gösterir.
                          style: const TextStyle( // Başlığın Yazı Stilini Tanımlar.
                            fontSize: 14, // Yazı Boyutunu 14 Yapar.
                            fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                          ),
                        ),
                        subtitle: Text(b.body), // Alt Satırda Bildirimin body'sini Gösterir.
                        trailing: Text( // Sağ Tarafta Bildirim Saatini Gösteren Text'tir.
                          '${b.date.hour.toString().padLeft(2, '0')}:${b.date.minute.toString().padLeft(2, '0')}', // Saat ve Dakikayı İki Haneli ss:dd Biçiminde Yazar.
                          // Neden Const Kullanılmadı? ...
                          style: TextStyle( // Saat Metninin Stilini Tanımlar; Colors.grey.shade500 Runtime Değeri Olduğu için const Değildir.
                            color: Colors.grey.shade500, // Yazı Rengini Orta Gri Yapar.
                            fontSize: 12, // Yazı Boyutunu 12 Yapar.
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
