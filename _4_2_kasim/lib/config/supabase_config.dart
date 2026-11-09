// Supabase Proje Bilgilerini Tutan Sabitlerdir. Publishable Key Public Kullanım İçindir; Erişimi RLS Policy'leri Sınırlar.
// service_role / secret Key'i ASLA Buraya veya Uygulamaya Koyma.
class SupabaseConfig {
  static const String url = 'https://spcipojamrcvtcuopzdd.supabase.co'; // Supabase Project URL'idir.
  static const String publishableKey = 'sb_publishable_G3i3X2-o_CT8Et3OdDUL7w_w4drrlqd'; // Public (Publishable) API Key'idir.
  static const String bucket = 'uploads'; // Görsellerin Yüklendiği Storage Bucket Adıdır.
}
