import 'package:flutter/material.dart'; // Material Widget'larını Kullanmak için flutter/material Library'sini import Eder.

import '../models/student.dart'; // Student Model Class'ını import Eder.
import '../services/firestore_student_service.dart'; // Firestore İşlemlerini Yapan Service Class'ını import Eder.

String? _validatePoint(String? value) { // Puanın 0-100 Arasında Olup Olmadığını Kontrol Eden Validator Function'ıdır.
  final point = int.tryParse(value?.trim() ?? ''); // Girilen Metni int'e Çevirmeyi Dener, Başarısızsa null Verir.
  if (point == null || point < 0 || point > 100) { // Puan Geçersizse veya Aralık Dışındaysa Bu Bloğa Girer.
    return 'Point must be between 0 and 100.'; // Hata Mesajını Döndürür.
  }
  return null; // Geçerli Değer için null Döndürür.
}

class FirestoreManagementScreen extends StatefulWidget { // Firestore Yönetim Ekranını Temsil Eden StatefulWidget'tır.
  const FirestoreManagementScreen({super.key}); // key'i Üst Class'a İleten const Constructor'dır.

  @override // Üst Class'taki createState Metodunu Override Eder.
  State<FirestoreManagementScreen> createState() => // Bu Widget'ın State Nesnesini Oluşturur.
      _FirestoreManagementScreenState(); // _FirestoreManagementScreenState Nesnesini Döndürür.
}

class _FirestoreManagementScreenState extends State<FirestoreManagementScreen> { // Ekranın Değişken Durumunu Yöneten State Class'ıdır.
  final FirestoreStudentService _firestoreStudentService = // Firestore İşlemleri için Service Nesnesini Tutan Field'dır.
      FirestoreStudentService(); // Yeni Bir FirestoreStudentService Oluşturur.
  late final Stream<List<Student>> _studentsStream = // build Her Çalıştığında Yeniden Oluşmasın Diye Stream'i Bir Kez Tutan late Field'dır.
      _firestoreStudentService.watchStudents(); // Öğrencileri Canlı Dinleyen Stream'i Alır.

  final _formKey = GlobalKey<FormState>(); // Form'u Doğrulamak ve Sıfırlamak için GlobalKey'dir.
  final TextEditingController _nameSurnameController = TextEditingController(); // Ad Soyad Alanının Controller'ıdır.
  final TextEditingController _emailController = TextEditingController(); // email Alanının Controller'ıdır.
  final TextEditingController _projectNameController = TextEditingController(); // Proje Adı Alanının Controller'ıdır.
  final TextEditingController _pointController = TextEditingController(); // Puan Alanının Controller'ıdır.

  bool _isSaving = false; // Kayıt İşleminin Sürüp Sürmediğini Tutan Flag'dir.

  @override // Üst Class'taki dispose Metodunu Override Eder.
  void dispose() { // Widget Kaldırılırken Kaynakları Serbest Bırakan Metottur.
    _nameSurnameController.dispose(); // Ad Soyad Controller'ını dispose Eder.
    _emailController.dispose(); // email Controller'ını dispose Eder.
    _projectNameController.dispose(); // Proje Adı Controller'ını dispose Eder.
    _pointController.dispose(); // Puan Controller'ını dispose Eder.
    super.dispose(); // Üst Class'ın dispose Metodunu Çağırır.
  }

  void _showMessage(String message) { // Ekranın Altında SnackBar Mesajı Gösteren Metottur.
    ScaffoldMessenger.of(context) // Context'teki ScaffoldMessenger'ı Bulur.
        .showSnackBar(SnackBar(content: Text(message))); // message'ı İçeren SnackBar'ı Gösterir.
  }

  Future<void> _newStudentSave() async { // Form Verisiyle Yeni Öğrenciyi Firestore'a Kaydeden async Metottur.
    if (!_formKey.currentState!.validate()) return; // Form Geçersizse Metottan Çıkar.

    setState(() => _isSaving = true); // Kayıt Başladığı için _isSaving'i true Yapıp UI'ı Yeniler.
    try { // Hata Oluşabilecek Kayıt İşlemini try Bloğuna Alır.
      await _firestoreStudentService.addStudent( // Service Üzerinden Öğrenciyi Ekler ve Bitmesini Bekler.
        student: Student( // Form Değerleriyle Yeni Bir Student Oluşturur.
          id: '', // id'yi Firestore Üreteceği için Boş Bırakır.
          nameSurname: _nameSurnameController.text.trim(), // Ad Soyadı Boşluklarından Temizleyerek Atar.
          email: _emailController.text.trim(), // email'i Boşluklarından Temizleyerek Atar.
          projectName: _projectNameController.text.trim(), // Proje Adını Boşluklarından Temizleyerek Atar.
          point: int.parse(_pointController.text.trim()), // Puan Metnini int'e Çevirerek Atar.
          registrationDate: DateTime.now(), // Kayıt Tarihi Olarak Şu Anki Zamanı Atar.
        ),
      );
      if (!mounted) return; // Widget Ağaçtan Kaldırıldıysa Metottan Çıkar.
      _formKey.currentState!.reset(); // Form'un Doğrulama Durumunu Sıfırlar.
      _nameSurnameController.clear(); // Ad Soyad Alanını Temizler.
      _emailController.clear(); // email Alanını Temizler.
      _projectNameController.clear(); // Proje Adı Alanını Temizler.
      _pointController.clear(); // Puan Alanını Temizler.
      FocusScope.of(context).unfocus(); // Odağı Kaldırıp Klavyeyi Kapatır.
      _showMessage('Student saved.'); // Başarılı Kayıt Mesajını Gösterir.
    } catch (e) { // Oluşan Hatayı Yakalar.
      if (mounted) _showMessage('Error: $e'); // Widget Hâlâ Ağaçtaysa Hata Mesajını Gösterir.
    } finally { // Hata Olsa da Olmasa da Bu Bloğu Çalıştırır.
      if (mounted) setState(() => _isSaving = false); // Widget Hâlâ Ağaçtaysa _isSaving'i false Yapıp UI'ı Yeniler.
    }
  }

  Future<bool> _deleteStudent(Student student) async { // Öğrenciyi Silip Sonucu bool Olarak Döndüren async Metottur.
    try { // Hata Oluşabilecek Silme İşlemini try Bloğuna Alır.
      await _firestoreStudentService.deleteStudent(id: student.id); // Service Üzerinden Öğrenciyi Siler.
      if (mounted) _showMessage('${student.nameSurname} deleted from cloud.'); // Widget Hâlâ Ağaçtaysa Silindi Mesajını Gösterir.
      return true; // Dismissible'ın Satırı Kaldırması için true Döndürür.
    } catch (e) { // Oluşan Hatayı Yakalar.
      if (mounted) _showMessage('Delete failed: $e'); // Widget Hâlâ Ağaçtaysa Hata Mesajını Gösterir.
      return false; // Satırın Listede Kalması için false Döndürür.
    }
  }

  Future<void> _pointUpdateDialog(Student student) async { // Puan Güncelleme Dialog'unu Açıp Sonucu Kaydeden async Metottur.
    final newPoint = await showDialog<int>( // Dialog'u Açar ve Döndüreceği int Değeri Bekler.
      context: context, // Dialog'un Açılacağı context'i Verir.
      builder: (_) => _PointUpdateDialog(student: student), // Dialog İçeriği Olarak _PointUpdateDialog Oluşturur.
    );
    if (newPoint == null || newPoint == student.point) return; // İptal Edildiyse veya Puan Değişmediyse Metottan Çıkar.

    try { // Hata Oluşabilecek Güncelleme İşlemini try Bloğuna Alır.
      await _firestoreStudentService.pointUpdate( // Service Üzerinden Puanı Günceller.
        id: student.id, // Güncellenecek Öğrencinin id'sini Verir.
        newPoint: newPoint, // Yeni Puanı Verir.
      );
      if (mounted) _showMessage('${student.nameSurname} point updated.'); // Widget Hâlâ Ağaçtaysa Güncellendi Mesajını Gösterir.
    } catch (e) { // Oluşan Hatayı Yakalar.
      if (mounted) _showMessage('Update failed: $e'); // Widget Hâlâ Ağaçtaysa Hata Mesajını Gösterir.
    }
  }

  Color _pointColor(int point) { // Puana Göre Renk Döndüren Metottur.
    if (point >= 80) return Colors.green; // 80 ve Üzeri için Yeşil Döndürür.
    if (point > 50) return Colors.orange; // 51-79 Arası için Turuncu Döndürür.
    return Colors.red; // 50 ve Altı için Kırmızı Döndürür.
  }

  @override // Üst Class'taki build Metodunu Override Eder.
  Widget build(BuildContext context) { // Ekranın Widget Ağacını Oluşturan build Metodudur.
    return Scaffold( // Sayfa İskeletini Sağlayan Scaffold Döndürür.
      appBar: AppBar( // Üst Başlık Çubuğunu Oluşturur.
        title: const Text('Live Firestore Management Screen'), // AppBar Başlığını Belirler.
        backgroundColor: Colors.amber.shade600, // AppBar Arka Plan Rengini Belirler.
      ),
      body: CustomScrollView( // Form ve Listeyi Tek Kaydırma Alanında Birleştiren CustomScrollView'dır.
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Kaydırınca Klavyeyi Kapatır.
        slivers: [ // Kaydırma Alanındaki Sliver Listesidir.
          SliverToBoxAdapter(child: _buildForm()), // Form Widget'ını Sliver İçine Yerleştirir.
          const SliverToBoxAdapter(child: Divider(thickness: 2)), // Form ile Liste Arasına Ayırıcı Çizgi Koyar.
          StreamBuilder<List<Student>>( // Stream'den Gelen Veriye Göre UI Çizen StreamBuilder'dır.
            stream: _studentsStream, // Dinlenecek Öğrenci Stream'ini Verir.
            builder: (context, snapshot) { // Stream'in Durumuna Göre Sliver Döndüren Builder Callback'idir.
              if (snapshot.hasError) { // Stream Hata Verdiyse Bu Bloğa Girer.
                return SliverFillRemaining( // Kalan Alanı Dolduran Sliver Döndürür.
                  hasScrollBody: false, // İçeriğin Kendi Kaydırması Olmadığını Belirtir.
                  child: Center(child: Text('Cloud Error: ${snapshot.error}')), // Hata Mesajını Ortada Gösterir.
                );
              }
              if (!snapshot.hasData) { // Henüz Veri Gelmediyse Bu Bloğa Girer.
                return const SliverFillRemaining( // Kalan Alanı Dolduran Sliver Döndürür.
                  hasScrollBody: false, // İçeriğin Kendi Kaydırması Olmadığını Belirtir.
                  child: Center(child: CircularProgressIndicator()), // Ortada Yükleniyor Göstergesi Gösterir.
                );
              }
              final students = snapshot.data!; // Gelen Öğrenci Listesini null Olmadığı Kabul Edilerek Alır.
              if (students.isEmpty) { // Liste Boşsa Bu Bloğa Girer.
                return const SliverFillRemaining( // Kalan Alanı Dolduran Sliver Döndürür.
                  hasScrollBody: false, // İçeriğin Kendi Kaydırması Olmadığını Belirtir.
                  child: Center(child: Text('No Students Found In Cloud.')), // Öğrenci Bulunamadı Mesajını Gösterir.
                );
              }
              return SliverList.builder( // Öğrencileri Lazy Olarak Çizen SliverList Döndürür.
                itemCount: students.length, // Liste Eleman Sayısını Belirler.
                itemBuilder: (context, index) => // Her index için Bir Satır Üreten Callback'tir.
                    _buildStudentTile(students[index]), // index'teki Öğrenci için Satır Widget'ı Oluşturur.
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm() { // Öğrenci Ekleme Form'unu Oluşturan Metottur.
    return Padding( // Form'un Etrafına Boşluk Ekler.
      padding: const EdgeInsets.all(12.0), // Her Yönden 12 Birim Padding Verir.
      child: Form( // Alanları Birlikte Doğrulayan Form Widget'ıdır.
        key: _formKey, // Form'a GlobalKey'i Bağlar.
        child: Column( // Alanları Alt Alta Dizen Column'dur.
          children: [ // Column'un Çocuk Widget Listesidir.
            TextFormField( // Ad Soyad Giriş Alanıdır.
              controller: _nameSurnameController, // Alanı Ad Soyad Controller'ına Bağlar.
              textInputAction: TextInputAction.next, // Klavyede Sonraki Alana Geçme Tuşunu Gösterir.
              decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                labelText: 'Name Surname', // Alan Etiketini Belirler.
                prefixIcon: Icon(Icons.person), // Başa Kişi İkonu Ekler.
                border: OutlineInputBorder(), // Çerçeveli Kenarlık Kullanır.
              ),
              validator: (value) => (value == null || value.trim().isEmpty) // Değer Boşsa Hata, Doluysa null Döndüren Validator'dır.
                  ? 'Name Surname is required.' // Boş Değer için Hata Mesajıdır.
                  : null, // Geçerli Değer için null Döndürür.
            ),
            const SizedBox(height: 8), // Alanlar Arasına 8 Birim Dikey Boşluk Koyar.
            TextFormField( // email Giriş Alanıdır.
              controller: _emailController, // Alanı email Controller'ına Bağlar.
              keyboardType: TextInputType.emailAddress, // email'e Uygun Klavye Açar.
              textInputAction: TextInputAction.next, // Klavyede Sonraki Alana Geçme Tuşunu Gösterir.
              decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                labelText: 'Email', // Alan Etiketini Belirler.
                prefixIcon: Icon(Icons.email), // Başa email İkonu Ekler.
                border: OutlineInputBorder(), // Çerçeveli Kenarlık Kullanır.
              ),
              validator: (value) { // email Formatını Kontrol Eden Validator'dır.
                final email = value?.trim() ?? ''; // Değeri Boşluklarından Temizler, null İse Boş String Kullanır.
                final isValid = RegExp( // email Kalıbını Tanımlayan RegExp Oluşturur.
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$', // Bir @ ve Noktalı Domain İçeren Metni Eşleyen Pattern'dir.
                ).hasMatch(email); // email'in Pattern'e Uyup Uymadığını Kontrol Eder.
                return isValid ? null : 'Enter a valid email.'; // Geçerliyse null, Değilse Hata Mesajı Döndürür.
              },
            ),
            const SizedBox(height: 8), // Alanlar Arasına 8 Birim Dikey Boşluk Koyar.
            TextFormField( // Proje Adı Giriş Alanıdır.
              controller: _projectNameController, // Alanı Proje Adı Controller'ına Bağlar.
              textInputAction: TextInputAction.next, // Klavyede Sonraki Alana Geçme Tuşunu Gösterir.
              decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                labelText: 'Project Name', // Alan Etiketini Belirler.
                prefixIcon: Icon(Icons.work), // Başa İş İkonu Ekler.
                border: OutlineInputBorder(), // Çerçeveli Kenarlık Kullanır.
              ),
              validator: (value) => (value == null || value.trim().isEmpty) // Değer Boşsa Hata, Doluysa null Döndüren Validator'dır.
                  ? 'Project Name is required.' // Boş Değer için Hata Mesajıdır.
                  : null, // Geçerli Değer için null Döndürür.
            ),
            const SizedBox(height: 8), // Alanlar Arasına 8 Birim Dikey Boşluk Koyar.
            TextFormField( // Puan Giriş Alanıdır.
              controller: _pointController, // Alanı Puan Controller'ına Bağlar.
              keyboardType: TextInputType.number, // Sayısal Klavye Açar.
              textInputAction: TextInputAction.done, // Klavyede Bitti Tuşunu Gösterir.
              decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                labelText: 'Point (0-100)', // Alan Etiketini Belirler.
                prefixIcon: Icon(Icons.grade), // Başa Not İkonu Ekler.
                border: OutlineInputBorder(), // Çerçeveli Kenarlık Kullanır.
              ),
              validator: _validatePoint, // Puanı _validatePoint Function'ı ile Doğrular.
            ),
            const SizedBox(height: 12), // Buton Öncesine 12 Birim Dikey Boşluk Koyar.
            ElevatedButton.icon( // İkonlu Kaydet Butonudur.
              style: ElevatedButton.styleFrom( // Butonun Stilini Tanımlar.
                backgroundColor: Colors.pink, // Buton Arka Planını Pembe Yapar.
                foregroundColor: Colors.white, // Yazı ve İkon Rengini Beyaz Yapar.
                minimumSize: const Size.fromHeight(44), // Butonu Tam Genişlik ve 44 Yükseklik Yapar.
              ),
              onPressed: _isSaving ? null : _newStudentSave, // Kayıt Sürerken Butonu Devre Dışı Bırakır, Değilse Kaydı Başlatır.
              icon: _isSaving // Kayıt Durumuna Göre İkon Seçer.
                  ? const SizedBox( // Kayıt Sürerken Küçük Bir Alan İçinde Gösterge Gösterir.
                      width: 18, // Gösterge Genişliğini Belirler.
                      height: 18, // Gösterge Yüksekliğini Belirler.
                      child: CircularProgressIndicator( // Dönen Yükleniyor Göstergesidir.
                        strokeWidth: 2, // Çizgi Kalınlığını Belirler.
                        color: Colors.white, // Gösterge Rengini Beyaz Yapar.
                      ),
                    )
                  : const Icon(Icons.cloud_upload), // Kayıt Yokken Bulut Yükleme İkonunu Gösterir.
              label: Text(_isSaving ? 'Saving...' : 'Save Cloud.'), // Kayıt Durumuna Göre Buton Yazısını Değiştirir.
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentTile(Student student) { // Tek Bir Öğrenci Satırını Oluşturan Metottur.
    return Dismissible( // Kaydırarak Silinebilen Satır Widget'ıdır.
      key: ValueKey(student.id), // Satırı id ile Benzersiz Tanımlayan Key'dir.
      direction: DismissDirection.endToStart, // Sadece Sağdan Sola Kaydırmaya İzin Verir.
      background: Container( // Kaydırırken Arkada Görünen Alandır.
        alignment: Alignment.centerRight, // İçeriği Sağ Ortaya Hizalar.
        padding: const EdgeInsets.only(right: 20), // Sağdan 20 Birim Padding Verir.
        color: Colors.red, // Arka Planı Kırmızı Yapar.
        child: const Icon(Icons.delete_forever, color: Colors.white), // Beyaz Silme İkonu Gösterir.
      ),
      confirmDismiss: (_) => _deleteStudent(student), // Satır Kaldırılmadan Önce Silme Sonucunu Bekler.
      child: ListTile( // Öğrenci Bilgilerini Gösteren ListTile'dır.
        leading: CircleAvatar( // Solda Puanı Gösteren Yuvarlak Avatar'dır.
          backgroundColor: _pointColor(student.point), // Avatar Rengini Puana Göre Belirler.
          child: Text( // Avatar İçindeki Puan Yazısıdır.
            '${student.point}', // Puanı String Olarak Gösterir.
            style: const TextStyle( // Yazı Stilini Tanımlar.
              color: Colors.white, // Yazı Rengini Beyaz Yapar.
              fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
            ),
          ),
        ),
        title: Text( // Başlıkta Ad Soyadı Gösteren Text'tir.
          student.nameSurname, // Öğrencinin Ad Soyadını Verir.
          style: const TextStyle(fontWeight: FontWeight.bold), // Başlığı Kalın Yapar.
        ),
        subtitle: Text('${student.email} - Project: ${student.projectName}\n${formatStudentDates(student)}'), // Alt Satırda email, Proje Adı ve Tarihleri Gösterir.
        isThreeLine: true, // Tarih Satırı için ListTile'ı Üç Satırlık Yapar.
        trailing: IconButton( // Sağda Puan Düzenleme Butonudur.
          onPressed: () => _pointUpdateDialog(student), // Basınca Puan Güncelleme Dialog'unu Açar.
          icon: const Icon(Icons.edit, color: Colors.amberAccent), // amberAccent Renkli Düzenleme İkonunu Gösterir.
        ),
      ),
    );
  }
}

class _PointUpdateDialog extends StatefulWidget { // Puan Güncelleme Dialog'unu Temsil Eden Private StatefulWidget'tır.
  const _PointUpdateDialog({required this.student}); // Güncellenecek student'ı Zorunlu Alan const Constructor'dır.

  final Student student; // Puanı Güncellenecek Öğrenciyi Tutan Field'dır.

  @override // Üst Class'taki createState Metodunu Override Eder.
  State<_PointUpdateDialog> createState() => _PointUpdateDialogState(); // Dialog'un State Nesnesini Oluşturur.
}

class _PointUpdateDialogState extends State<_PointUpdateDialog> { // Dialog'un Değişken Durumunu Yöneten State Class'ıdır.
  final _formKey = GlobalKey<FormState>(); // Dialog Form'unu Doğrulamak için GlobalKey'dir.
  late final TextEditingController _controller = TextEditingController( // widget'a Erişebilmek için late Tanımlanan Puan Controller'ıdır.
    text: '${widget.student.point}', // Alanı Mevcut Puanla Başlatır.
  );

  @override // Üst Class'taki dispose Metodunu Override Eder.
  void dispose() { // Dialog Kapanırken Kaynakları Serbest Bırakan Metottur.
    _controller.dispose(); // Puan Controller'ını dispose Eder.
    super.dispose(); // Üst Class'ın dispose Metodunu Çağırır.
  }

  void _submit() { // Form'u Doğrulayıp Yeni Puanı Geri Döndüren Metottur.
    if (!_formKey.currentState!.validate()) return; // Form Geçersizse Metottan Çıkar.
    Navigator.pop(context, int.parse(_controller.text.trim())); // Dialog'u Kapatıp Yeni Puanı Sonuç Olarak Döndürür.
  }

  @override // Üst Class'taki build Metodunu Override Eder.
  Widget build(BuildContext context) { // Dialog'un Widget Ağacını Oluşturan build Metodudur.
    return AlertDialog( // Başlık, İçerik ve Butonlardan Oluşan AlertDialog Döndürür.
      title: Text('${widget.student.nameSurname} - Update Point'), // Dialog Başlığında Öğrencinin Adını Gösterir.
      content: Form( // Puan Alanını Doğrulayan Form Widget'ıdır.
        key: _formKey, // Form'a GlobalKey'i Bağlar.
        child: TextFormField( // Yeni Puan Giriş Alanıdır.
          controller: _controller, // Alanı Puan Controller'ına Bağlar.
          autofocus: true, // Dialog Açılınca Alana Otomatik Odaklanır.
          keyboardType: TextInputType.number, // Sayısal Klavye Açar.
          decoration: const InputDecoration(labelText: 'New Point (0-100)'), // Alan Etiketini Belirler.
          validator: _validatePoint, // Puanı _validatePoint Function'ı ile Doğrular.
          onFieldSubmitted: (_) => _submit(), // Klavyeden Onaylanınca _submit'i Çağırır.
        ),
      ),
      actions: [ // Dialog'un Alt Kısmındaki Buton Listesidir.
        TextButton( // İptal Butonudur.
          onPressed: () => Navigator.pop(context), // Sonuç Döndürmeden Dialog'u Kapatır.
          child: const Text('Cancel'), // Buton Yazısını Belirler.
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Update')), // Basınca _submit'i Çağıran Güncelle Butonudur.
      ],
    );
  }
}
