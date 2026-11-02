// setState() Bulunduğu State Nesnesinin build() Metodunu Baştan Aşağı Tetikler.
// Scaffold, appbar, tabbar ve Eğer Varsa 20 Tane Container Baştan Hesaplanır.

import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import 'package:go_router/go_router.dart'; // Routing İçin go_router Package'ını import Eder.

import 'screens/cart.dart'; // CartScreen ve CartController Class'larını import Eder.
import 'screens/profile.dart'; // ProfileScreen Class'ını import Eder.
import 'screens/showcase.dart'; // Ürünlerin Listelendiği ShowcaseScreen Class'ını import Eder.

void main() { // Uygulamanın Entry Point'idir.
  runApp(const MyApp()); // MyApp'i Root Widget Olarak Çalıştırıp Uygulamayı Başlatır.
}

class MyApp extends StatelessWidget { // Uygulamanın Root Widget'ıdır, State Tutmayan Bir StatelessWidget'tır.
  const MyApp({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  // go_router Documentation: https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html
  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Uygulamanın Widget Tree'sini Oluşturur.
    return MaterialApp.router( // Navigation'ı Router Üzerinden Yöneten MaterialApp Döndürür.
      title: 'Test Uygulama', // İşletim Sisteminin Görev Yöneticisinde Görünen Uygulama title'ıdır.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Banner'ını Gizler.
      routerConfig: appRoutes, // Router Config Olarak Aşağıda Tanımlı appRoutes'u Kullanır.
    );
  }
}

class MainShellScreen extends StatelessWidget { // NavigationBar'ı Tüm Sayfalarda Sabit Tutan Shell Ekranıdır.
  final Widget screenBody; // O An Aktif Olan Sayfanın Widget'ını Tutar.
  const MainShellScreen({super.key, required this.screenBody}); // screenBody'yi required Parametre Olarak Alan const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Shell Ekranın Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      body: screenBody, // body Alanında Aktif Sayfayı Gösterir.
      bottomNavigationBar: NavigationBar( // Ekranın Altına NavigationBar Ekler.
        selectedIndex: _findActiveIndex(context), // Mevcut Route'a Göre Seçili Sekmenin Index'ini Belirler.
        onDestinationSelected: (newIndex) { // Bir Destination Seçildiğinde Çalışan Callback'tir.
          if (newIndex == 0) context.go('/showcase'); // Index 0 Seçilince /showcase Route'una Gider.
          if (newIndex == 1) context.go('/cart'); // Index 1 Seçilince /cart Route'una Gider.
          if (newIndex == 2) context.go('/profile'); // Index 2 Seçilince /profile Route'una Gider.
        },
        destinations: [ // NavigationBar'daki Destination Listesidir.
          const NavigationDestination(icon: Icon(Icons.store), label: 'Vitrin'), // store İkonlu Vitrin Destination'ıdır.
          NavigationDestination( // Sepet Destination'ını Tanımlar.
            icon: ValueListenableBuilder<int>( // itemCount Değiştikçe Yalnızca İkonu Rebuild Eder.
              valueListenable: CartController.instance.itemCount, // CartController'daki itemCount ValueNotifier'ını Dinler.
              builder: (context, count, child) { // Güncel count Değeriyle İkonu Build Eder.
                return Badge( // İkonun Üzerine Bir Badge Ekler.
                  label: Text('$count'), // Badge Üzerinde Sepetteki Ürün Sayısını Yazar.
                  isLabelVisible: count > 0, // count 0 İse Badge'i Gizler.
                  child: const Icon(Icons.shopping_cart), // Badge'in child'ı Olan Sepet İkonudur.
                );
              },
            ),
            label: 'Sepet', // Destination'ın Altında Görünen label'dır.
          ),
          const NavigationDestination( // Profil Destination'ını Tanımlar.
            icon: Icon(Icons.person), // person İkonunu Gösterir.
            label: 'Profil', // Destination'ın Altında Görünen label'dır.
          ),
        ],
      ),
    );
  }

  int _findActiveIndex(BuildContext context) { // Mevcut Route'a Karşılık Gelen Sekme Index'ini Bulur.
    final String location = GoRouterState.of(context).uri.toString(); // GoRouterState'ten Mevcut URI'yi String Olarak Alır.
    if (location.startsWith('/cart')) return 1; // Route /cart İle Başlıyorsa 1 Döndürür.
    if (location.startsWith('/profile')) return 2; // Route /profile İle Başlıyorsa 2 Döndürür.
    return 0; // Diğer Durumlarda Vitrin Index'i Olan 0'ı Döndürür.
  }
}

final GoRouter appRoutes = GoRouter( // Uygulamanın Tüm Route Tanımlarını Tutan GoRouter Nesnesidir.
  initialLocation: '/showcase', // Uygulama /showcase Route'uyla Açılır.
  routes: [ // Üst Seviye Route Listesidir.
    ShellRoute( // Alt Route'ları Ortak Bir Shell İçinde Gösterir.
      builder: (BuildContext context, GoRouterState state, Widget child) { // Shell'i Aktif Sayfanın child Widget'ıyla Build Eder.
        return MainShellScreen(screenBody: child); // Aktif Sayfayı MainShellScreen'e screenBody Olarak Verir.
      },
      routes: [ // Shell İçinde Gösterilecek Alt Route'lardır.
        GoRoute( // Vitrin Sayfasının GoRoute Tanımıdır.
          path: '/showcase', // Vitrin Sayfasının Path'idir.
          builder: (context, state) => const ShowcaseScreen(), // Bu Path'te ShowcaseScreen'i Build Eder.
        ),
        GoRoute( // Sepet Sayfasının GoRoute Tanımıdır.
          path: '/cart', // Sepet Sayfasının Path'idir.
          builder: (context, state) => const CartScreen(), // Bu Path'te CartScreen'i Build Eder.
        ),
        GoRoute( // Profil Sayfasının GoRoute Tanımıdır.
          path: '/profile', // Profil Sayfasının Path'idir.
          builder: (context, state) => const ProfileScreen(), // Bu Path'te ProfileScreen'i Build Eder.
        ),
      ],
    ),
  ],
);
