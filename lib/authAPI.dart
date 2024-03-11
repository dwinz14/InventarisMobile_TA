import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventaris/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Barang {
  final int id;
  final String namaBarang;
  final int merekId;
  final int kategoriId;
  final String keterangan;
  final int stok;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.merekId,
    required this.kategoriId,
    required this.keterangan,
    required this.stok,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      namaBarang: json['nama_barang'],
      merekId: int.parse(json['merek_id'].toString()),
      kategoriId: int.parse(json['kategori_id'].toString()),
      keterangan: json['keterangan'],
      stok: json['stok'] is int
          ? json['stok']
          : int.parse(json['stok'].toString()),
    );
  }
}

class BarangMasuk {
  final int id;
  final int barangId;
  final String tanggal;
  final String keterangan;
  final int jumlah;

  BarangMasuk({
    required this.id,
    required this.barangId,
    required this.tanggal,
    required this.keterangan,
    required this.jumlah,
  });

  factory BarangMasuk.fromJson(Map<String, dynamic> json) {
    return BarangMasuk(
      id: json['id'],
      barangId: json['barang_id'],
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      jumlah: json['jumlah'],
    );
  }
}

class AuthAPI {
  static final String baseUrl =
      'http://inventaris-kantor.tifint.myhost.id/api'; // Ganti dengan URL API Laravel Anda

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/masukaja'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<void> logout() async {
    // Implementasikan jika diperlukan
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  static Future<Map<String, dynamic>> getUserInfo(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/infouser'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  Future<List<Barang>> _getDaftarBarang(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/barang'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((json) {
              try {
                return Barang.fromJson(json);
              } catch (e) {
                print('Error parsing JSON: $e');
                return null; // Menandai bahwa parsing gagal
              }
            })
            .whereType<Barang>()
            .toList();
      } else {
        throw Exception('Error loading daftar barang: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading daftar barang: $e');
    }
  }

  Future<List<Barang>> getDaftarBarang() async {
    try {
      final token = await _getToken();
      final daftarBarang = await _getDaftarBarang(token);
      return daftarBarang;
    } catch (e) {
      throw Exception('Error loading daftar barang masuk: $e');
    }
  }

  Future<Map<String, dynamic>> storeBarangMasuk(
    String selectedBarang,
    String tanggal,
    String jumlah,
    String keterangan,
  ) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/barang-masuk'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'barang_id': selectedBarang,
          'tanggal': tanggal,
          'jumlah': jumlah,
          'keterangan': keterangan,
        },
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error storing barang masuk: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error storing barang masuk: $e');
    }
  }

  Future<Map<String, dynamic>> storeBarangKeluar(
    String selectedBarang,
    String tanggal,
    String jumlah,
    String keterangan,
  ) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/barang-keluar'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'barang_id': selectedBarang,
          'tanggal': tanggal,
          'jumlah': jumlah,
          'keterangan': keterangan,
        },
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error storing barang keluar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error storing barang keluar: $e');
    }
  }
}
