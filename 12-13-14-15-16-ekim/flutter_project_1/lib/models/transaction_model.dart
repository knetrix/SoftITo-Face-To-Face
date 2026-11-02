import 'package:flutter/material.dart'; // IconData Tipi İçin Flutter'ın Material Library'sini import Eder.

class TransactionItem { // Tek Bir Finansal İşlemin Verisini Tutan Model Class'ıdır.
  final String id; // İşlemin Benzersiz id'sidir.
  final String title; // İşlemin Başlığıdır.
  final String category; // İşlemin Ait Olduğu Kategoridir.
  final DateTime date; // İşlemin Gerçekleştiği Tarih ve Saattir.
  final double amount; // İşlemin Tutarıdır.
  final bool isExpense; // İşlem Gider İse true, Gelir İse false Olur.
  final IconData icon; // İşlemi Temsil Eden İkondur.

  const TransactionItem({
    required this.id, // id Field'ını required Yapar.
    required this.title, // title Field'ını required Yapar.
    required this.category, // category Field'ını required Yapar.
    required this.date, // date Field'ını required Yapar.
    required this.amount, // amount Field'ını required Yapar.
    required this.isExpense, // isExpense Field'ını required Yapar.
    required this.icon, // icon Field'ını required Yapar.
  });
}
