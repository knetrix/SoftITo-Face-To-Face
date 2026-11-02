import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../models/transaction_model.dart'; // TransactionItem Model Class'ını import Eder.

class TransferFormScreen extends StatefulWidget { // Bakiye ve Transfer Geçmişini Gösteren StatefulWidget'tır.
  const TransferFormScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<TransferFormScreen> createState() => _TransferFormScreenState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _TransferFormScreenState extends State<TransferFormScreen> { // TransferFormScreen'in State'ini Yöneten Private Class'tır.
  double _balance = 148950.00; // Kullanılabilir Bakiyeyi Tutar.
  final List<TransactionItem> _history = []; // Transfer Geçmişini Tutan List'tir.

  @override // Superclass'taki initState Metodunun Override Edildiğini Belirtir.
  void initState() { // State İlk Oluşturulduğunda Bir Kez Çalışan Lifecycle Metodudur.
    super.initState(); // Superclass'ın initState Metodunu Çağırır.
    final now = DateTime.now(); // Şu Anki Tarih ve Saati Alır.
    _history.addAll([ // Başlangıç İçin Örnek İşlemleri _history'ye Ekler.
      TransactionItem( // Birinci Örnek Transferi Oluşturur.
        id: 'tx_init_1', // İşlemin id'sidir.
        title: 'Ahmet Yılmaz', // Alıcının Adıdır.
        category: 'Hızlı Transfer', // İşlemin Kategorisidir.
        date: DateTime(now.year, now.month, now.day, 11, 30), // Bugün Saat 11:30 Tarihini Verir.
        amount: 1500.00, // Transfer Tutarıdır.
        isExpense: true, // Bu İşlemin Bir Gider Olduğunu Belirtir.
        icon: Icons.send_rounded, // Gönder İkonunu Kullanır.
      ),
      TransactionItem( // İkinci Örnek Transferi Oluşturur.
        id: 'tx_init_2', // İşlemin id'sidir.
        title: 'Merve Demir', // Alıcının Adıdır.
        category: 'Hızlı Transfer', // İşlemin Kategorisidir.
        date: DateTime(now.year, now.month, now.day - 1, 15, 45), // Dün Saat 15:45 Tarihini Verir.
        amount: 2400.00, // Transfer Tutarıdır.
        isExpense: true, // Bu İşlemin Bir Gider Olduğunu Belirtir.
        icon: Icons.send_rounded, // Gönder İkonunu Kullanır.
      ),
    ]);
  }

  Future<void> _openTransferModal() async { // Transfer Formunu Bottom Sheet Olarak Açıp Sonucu İşler.
    final transaction = await showModalBottomSheet<TransactionItem>( // Bottom Sheet Açar ve Dönen TransactionItem'ı await İle Bekler.
      context: context, // Bottom Sheet'in Açılacağı BuildContext'tir.
      isScrollControlled: true, // Bottom Sheet'in Klavyeyle Birlikte Tam Yüksekliğe Çıkabilmesini Sağlar.
      useSafeArea: true, // Bottom Sheet'i Sistem Alanlarından Korur.
      builder: (context) => _TransferForm(balance: _balance), // Güncel Bakiyeyle _TransferForm'u Build Eder.
    );

    if (!mounted || transaction == null) return; // Widget Ağaçtan Kalktıysa veya İptal Edildiyse Metottan Çıkar.

    setState(() { // State'i Güncelleyip build() Metodunu Tetikler.
      _balance = ((_balance - transaction.amount) * 100).round() / 100; // Tutarı Bakiyeden Düşüp 2 Ondalığa Yuvarlar.
      _history.add(transaction); // Yeni İşlemi Geçmişe Ekler.
      _history.sort((a, b) => b.date.compareTo(a.date)); // Geçmişi Tarihe Göre Yeniden Eskiye Sort Eder.
    });

    ScaffoldMessenger.of(context).showSnackBar( // Ekranın Altında Bir SnackBar Gösterir.
      const SnackBar(content: Text('Örnek transfer geçmişe eklendi.')), // SnackBar'ın İçerik Metnidir.
    );
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Transfer Ekranının Widget Tree'sini Oluşturur.
    return SingleChildScrollView( // İçeriği Dikey Olarak Scroll Edilebilir Yapar.
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), // Sol, Üst, Sağ ve Alt Padding'leri Ayrı Ayrı Verir.
      child: Column( // child'ları Dikey Olarak Alt Alta Dizer.
        crossAxisAlignment: CrossAxisAlignment.stretch, // child'ları Yatayda Tam Genişliğe Uzatır.
        children: [ // Column İçindeki Widget Listesidir.
          Text('Para Transferi', // Sayfa Başlığını Gösterir.
              style: Theme.of(context).textTheme.headlineSmall), // Theme'deki headlineSmall Stilini Uygular.
          const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
          Card( // Bakiye Bilgisini Gösteren Card'ı Oluşturur.
            margin: EdgeInsets.zero, // Card'ın Varsayılan Margin'ini Sıfırlar.
            child: Padding( // Card İçeriğine Boşluk Ekler.
              padding: const EdgeInsets.all(20), // Her Yönden 20 Padding Verir.
              child: Column( // Card İçeriğini Dikey Olarak Dizer.
                crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
                children: [ // Column İçindeki Widget Listesidir.
                  const Text('Kullanılabilir Bakiye'), // Bakiye Başlığını Gösterir.
                  const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                  Text( // Bakiye Tutarını Gösteren Text'tir.
                    '₺${_balance.toStringAsFixed(2)}', // Bakiyeyi ₺ İşaretiyle ve 2 Ondalıkla Yazar.
                    style: Theme.of(context).textTheme.headlineMedium, // Theme'deki headlineMedium Stilini Uygular.
                  ),
                  const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                  const Text('Örnek veridir; gerçek para transferi yapılmaz.'), // Verinin Örnek Olduğunu Belirten Text'tir.
                ],
              ),
            ),
          ),
          const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
          FilledButton.icon( // İkonlu ve Dolgulu Bir Buton Oluşturur.
            onPressed: _openTransferModal, // Tıklanınca Transfer Modal'ını Açar.
            icon: const Icon(Icons.send_rounded), // Gönder İkonunu Gösterir.
            label: const Text('Yeni Transfer'), // Butonun label'ıdır.
          ),
          const SizedBox(height: 24), // Dikeyde 24 Birim Boşluk Bırakır.
          Text('Transfer Geçmişi', // Geçmiş Bölümünün Başlığını Gösterir.
              style: Theme.of(context).textTheme.titleLarge), // Theme'deki titleLarge Stilini Uygular.
          const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
          for (final transaction in _history) ...[ // Collection for ve Spread Operator İle Her İşlem İçin Widget'lar Üretir.
            Padding( // Satırın Etrafına Boşluk Ekler.
              padding: const EdgeInsets.symmetric(vertical: 12), // Dikeyde 12 Padding Verir.
              child: Row( // Avatar ve Bilgileri Yatay Olarak Dizer.
                crossAxisAlignment: CrossAxisAlignment.start, // child'ları Üste Hizalar.
                children: [ // Row İçindeki Widget Listesidir.
                  CircleAvatar(child: Icon(transaction.icon)), // İşlem İkonunu Yuvarlak Avatar İçinde Gösterir.
                  const SizedBox(width: 12), // Yatayda 12 Birim Boşluk Bırakır.
                  Expanded( // Row'daki Kalan Tüm Alanı Kaplar.
                    child: Column( // İşlem Bilgilerini Dikey Olarak Dizer.
                      crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
                      children: [ // Column İçindeki Widget Listesidir.
                        Text( // Alıcı Adını Gösteren Text'tir.
                          transaction.title, // İşlemin title Değerini Yazar.
                          style: const TextStyle(fontWeight: FontWeight.bold), // Text'i Bold Yapar.
                        ),
                        Text(transaction.category), // İşlemin Kategorisini Gösterir.
                        Text(_formatDate(transaction.date)), // Formatlanmış Tarihi Gösterir.
                        const SizedBox(height: 4), // Dikeyde 4 Birim Boşluk Bırakır.
                        Text( // Tutarı Gösteren Text'tir.
                          '-₺${transaction.amount.toStringAsFixed(2)}', // Tutarı Eksi İşaretiyle ve 2 Ondalıkla Yazar.
                          style: TextStyle(color: Colors.red.shade700), // Text Rengini Kırmızı Yapar.
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1), // İşlemler Arasına 1 Yükseklikte Divider Koyar.
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) { // Tarihi 'Bugün', 'Dün' veya gg.aa.yyyy Formatında String'e Çevirir.
    final now = DateTime.now(); // Şu Anki Tarih ve Saati Alır.
    final today = DateTime(now.year, now.month, now.day); // Saat Bilgisi Olmadan Bugünün Tarihini Oluşturur.
    final yesterday = DateTime(now.year, now.month, now.day - 1); // Dünün Tarihini Oluşturur.
    final day = DateTime(date.year, date.month, date.day); // Verilen Tarihin Sadece Gün Bilgisini Alır.
    final String label; // Gün Etiketini Tutacak final Değişkeni Tanımlar.
    if (day == today) { // Tarih Bugünse Bu Bloğa Girer.
      label = 'Bugün'; // label'a 'Bugün' Atar.
    } else if (day == yesterday) { // Tarih Dünse Bu Bloğa Girer.
      label = 'Dün'; // label'a 'Dün' Atar.
    } else { // Diğer Tüm Tarihler İçin Bu Bloğa Girer.
      label = '${date.day.toString().padLeft(2, '0')}.' // Günü padLeft İle 2 Haneli Yazar.
          '${date.month.toString().padLeft(2, '0')}.${date.year}'; // Ayı 2 Haneli Yazıp Yılı Ekler.
    }
    return '$label ${date.hour.toString().padLeft(2, '0')}:' // Etiket ve 2 Haneli Saati Yazar.
        '${date.minute.toString().padLeft(2, '0')}'; // 2 Haneli Dakikayı Ekleyerek Döndürür.
  }
}

class _TransferForm extends StatefulWidget { // Bottom Sheet İçinde Gösterilen Private Transfer Formu Widget'ıdır.
  const _TransferForm({required this.balance}); // balance'ı required Parametre Olarak Alan const Constructor'dır.

  final double balance; // Validation İçin Kullanılacak Güncel Bakiyedir.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<_TransferForm> createState() => _TransferFormState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _TransferFormState extends State<_TransferForm> { // _TransferForm'un State'ini Yöneten Private Class'tır.
  final _formKey = GlobalKey<FormState>(); // Form'u Validate Etmek İçin Kullanılan GlobalKey'dir.
  final _recipientController = TextEditingController(); // Alıcı Adı TextFormField'ının Controller'ıdır.
  final _amountController = TextEditingController(); // Tutar TextFormField'ının Controller'ıdır.

  @override // Superclass'taki dispose Metodunun Override Edildiğini Belirtir.
  void dispose() { // State Kalıcı Olarak Kaldırılırken Çalışan Lifecycle Metodudur.
    _recipientController.dispose(); // Memory Leak Olmaması İçin Controller'ı dispose Eder.
    _amountController.dispose(); // Memory Leak Olmaması İçin Controller'ı dispose Eder.
    super.dispose(); // Superclass'ın dispose Metodunu Çağırır.
  }

  double? _parseAmount(String value) { // Girilen Metni double'a Çevirir, Başarısızsa null Döndürür.
    return double.tryParse(value.trim().replaceAll(',', '.')); // Boşlukları Temizleyip Virgülü Noktaya Çevirerek Parse Eder.
  }

  void _submit() { // Formu Doğrulayıp Yeni TransactionItem İle Bottom Sheet'i Kapatır.
    if (!_formKey.currentState!.validate()) return; // Validation Başarısızsa Metottan Çıkar.

    final now = DateTime.now(); // Şu Anki Tarih ve Saati Alır.
    Navigator.of(context).pop( // Bottom Sheet'i Kapatıp Sonucu Geri Döndürür.
      TransactionItem( // Formdaki Verilerle Yeni Bir TransactionItem Oluşturur.
        id: 'tx_${now.microsecondsSinceEpoch}', // Zaman Damgasından Benzersiz Bir id Üretir.
        title: _recipientController.text.trim(), // Alıcı Adını Boşluklardan Temizleyerek Alır.
        category: 'Hızlı Transfer', // İşlemin Kategorisidir.
        date: now, // İşlem Tarihini Şu An Olarak Atar.
        amount: _parseAmount(_amountController.text)!, // Tutarı Parse Edip Null Olmadığını Garanti Eder.
        isExpense: true, // Bu İşlemin Bir Gider Olduğunu Belirtir.
        icon: Icons.send_rounded, // Gönder İkonunu Kullanır.
      ),
    );
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Transfer Formunun Widget Tree'sini Oluşturur.
    return Padding( // Klavye Açıldığında Formun Yukarı Kaymasını Sağlayan Padding'dir.
      padding: EdgeInsets.only( // Sadece Alt Tarafa Padding Verir.
        bottom: MediaQuery.of(context).viewInsets.bottom, // Klavyenin Yüksekliği Kadar Alt Boşluk Bırakır.
      ),
      child: SafeArea( // İçeriği Sistem Alanlarından Korur.
        top: false, // Üst Tarafta SafeArea Boşluğunu Uygulamaz.
        child: SingleChildScrollView( // Form İçeriğini Scroll Edilebilir Yapar.
          padding: const EdgeInsets.all(24), // Her Yönden 24 Padding Verir.
          child: Form( // TextFormField'ları Gruplayıp Validation Yönetimini Sağlar.
            key: _formKey, // Form'a GlobalKey'i Bağlar.
            child: Column( // Form Alanlarını Dikey Olarak Dizer.
              mainAxisSize: MainAxisSize.min, // Column'un Yüksekliğini İçeriği Kadar Yapar.
              crossAxisAlignment: CrossAxisAlignment.stretch, // child'ları Tam Genişliğe Uzatır.
              children: [ // Column İçindeki Widget Listesidir.
                Text('Yeni Transfer', // Form Başlığını Gösterir.
                    style: Theme.of(context).textTheme.titleLarge), // Theme'deki titleLarge Stilini Uygular.
                const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                Text( // Kullanılabilir Bakiyeyi Gösteren Text'tir.
                    'Kullanılabilir bakiye: ₺${widget.balance.toStringAsFixed(2)}'), // widget.balance Değerini 2 Ondalıkla Yazar.
                const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
                TextFormField( // Alıcı Adı Giriş Alanını Oluşturur.
                  controller: _recipientController, // Alana _recipientController'ı Bağlar.
                  textCapitalization: TextCapitalization.words, // Her Kelimenin İlk Harfini Büyük Yapar.
                  textInputAction: TextInputAction.next, // Klavyede 'İleri' Butonunu Gösterir.
                  decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                    labelText: 'Alıcı adı', // Alanın labelText'idir.
                    border: OutlineInputBorder(), // Alanın Etrafına Çerçeve Çizer.
                  ),
                  validator: (value) { // Alanın Değerini Doğrulayan validator Callback'idir.
                    if (value == null || value.trim().isEmpty) { // Değer Boşsa Bu Bloğa Girer.
                      return 'Alıcı adını girin.'; // Hata Mesajını Döndürür.
                    }
                    return null; // Hata Yoksa null Döndürür.
                  },
                ),
                const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                TextFormField( // Tutar Giriş Alanını Oluşturur.
                  controller: _amountController, // Alana _amountController'ı Bağlar.
                  keyboardType: const TextInputType.numberWithOptions( // Sayısal Klavye Açar.
                    decimal: true, // Ondalık Ayırıcı Girişine İzin Verir.
                  ),
                  textInputAction: TextInputAction.done, // Klavyede 'Bitti' Butonunu Gösterir.
                  decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                    labelText: 'Tutar', // Alanın labelText'idir.
                    prefixText: '₺ ', // Alanın Başına ₺ İşareti Ekler.
                    hintText: '1500,00', // Alan Boşken Gösterilen Örnek Değerdir.
                    border: OutlineInputBorder(), // Alanın Etrafına Çerçeve Çizer.
                  ),
                  validator: (value) { // Alanın Değerini Doğrulayan validator Callback'idir.
                    final text = (value ?? '').trim(); // Değer null İse Boş String Kullanıp Boşlukları Temizler.
                    final amount = _parseAmount(text); // Metni double'a Parse Eder.
                    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(text) || // RegExp İle En Fazla 2 Ondalıklı Sayı Formatını Kontrol Eder.
                        amount == null || // Parse Başarısızsa Geçersiz Sayar.
                        !amount.isFinite || // Sonsuz veya NaN Değerleri Geçersiz Sayar.
                        amount <= 0) { // Sıfır veya Negatif Değerleri Geçersiz Sayar.
                      return 'En fazla iki ondalıklı, pozitif bir tutar girin.'; // Hata Mesajını Döndürür.
                    }
                    if (amount > widget.balance) { // Tutar Bakiyeden Büyükse Bu Bloğa Girer.
                      return 'Yetersiz bakiye.'; // Hata Mesajını Döndürür.
                    }
                    return null; // Hata Yoksa null Döndürür.
                  },
                  onFieldSubmitted: (_) => _submit(), // Klavyede 'Bitti'ye Basılınca Formu Gönderir.
                ),
                const SizedBox(height: 24), // Dikeyde 24 Birim Boşluk Bırakır.
                FilledButton.icon( // İkonlu ve Dolgulu Onay Butonunu Oluşturur.
                  onPressed: _submit, // Tıklanınca Formu Gönderir.
                  icon: const Icon(Icons.send_rounded), // Gönder İkonunu Gösterir.
                  label: const Text('Örnek Transferi Onayla'), // Butonun label'ıdır.
                ),
                TextButton( // Düz Bir Metin Butonu Oluşturur.
                  onPressed: () => Navigator.of(context).pop(), // Tıklanınca Sonuç Döndürmeden Bottom Sheet'i Kapatır.
                  child: const Text('Vazgeç'), // Butonun Metnidir.
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
