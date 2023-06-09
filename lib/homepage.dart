import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'appbar.dart';
import 'profile.dart';
import 'history.dart';
import 'products.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'articles.dart';
import 'loginpage.dart';

class HomePage extends StatefulWidget {
  final String token;
  final String fullname;

  const HomePage({required this.token, required this.fullname});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Dio dio = Dio();
  var profile;
  List<dynamic>? history;
  List<dynamic>? products;
  List<dynamic>? articles;

  static const ColorScheme _colorScheme = ColorScheme.light(
    primary: Colors.green,
    onPrimary: Colors.white,
    primaryVariant: Colors.green,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  Future<bool> onBackPressed() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false; // Menahan navigasi kembali
    } else {
      bool shouldLogout = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi Logout'),
            content: Text('Apakah Anda yakin ingin logout?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false); // Menutup dialog
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          );
        },
      );

      return shouldLogout;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  fetchAPI() async {
    try {
      // Fetch Profile Information
      Response profileResponse = await dio.get(
        'https://ternaku-dev-test.et.r.appspot.com/api/profile',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );
      profile = profileResponse.data['profile'];

      // Fetch Products
      Response productsResponse = await dio.get(
        'https://ternaku-dev-test.et.r.appspot.com/api/products',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );
      products = productsResponse.data;

      // Fetch History
      Response historyResponse = await dio.get(
        'https://ternaku-dev-test.et.r.appspot.com/api/profile/history',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );
      history = historyResponse.data['history'];

      Response response = await dio.get(
        'https://ternaku-dev-test.et.r.appspot.com/api/articles',
      );
      articles = response.data['articles'];
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget buildHaloSection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHaloCard(),
          SizedBox(height: 10),
          buildFiturSection(),
          SizedBox(height: 20),
          buildArtikelSection(),
        ],
      ),
    );
  }

  Widget buildHaloCard() {
    return Center(
      // Tambahkan widget Center di luar Card
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                // Tambahkan widget Center di dalam Column
                child: Text(
                  'Halo! ${widget.fullname}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                // Tambahkan widget Center di dalam Column
                child: Text(
                  'Selamat datang di Ternaku',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFiturSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitur',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height *
                      0.4, // Ukuran tinggi showModalBottomSheet
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Pilih Hewan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  navigateToScanPage(context, 'sapi');
                                },
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: SizedBox(
                                    width: 150,
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              'assets/sapi.png',
                                              width: 100,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'SAPI',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  navigateToScanPage(context, 'kambing');
                                },
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: SizedBox(
                                    width: 150,
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              'assets/kambing.png',
                                              width: 100,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'KAMBING',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Warna bayangan
                  spreadRadius: 2, // Jarak penyebaran bayangan
                  blurRadius: 2, // Besar kabur bayangan
                  offset: Offset(0, 2), // Offset (dx, dy) bayangan
                ),
              ],
            ),
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 25,
                  color: Colors.green,
                ),
                SizedBox(width: 16.0),
                Text(
                  'Scan Mata Hewan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildArtikelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Artikel',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              if (articles != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllArticlesPage(articles: articles!),
                      ),
                    );
                  },
                  child: Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 5),
        if (articles != null)
          Container(
            height: 200,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.8,
              ),
              scrollDirection: Axis.horizontal,
              physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: articles!.length,
              itemBuilder: (context, index) {
                final article = articles![index];
                return GestureDetector(
                  onTap: () {
                    navigateToArticlePage(context, article);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    width: 200,
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8.0),
                            ),
                            child: Image.network(
                              article['img_url'],
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              article['title'],
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget buildSection() {
    switch (_selectedIndex) {
      case 0:
        return buildHaloSection();
      case 1:
        return ProductsPage(products: products);
      case 2:
        return HistoryPage(history: history ?? [], onRefresh: fetchAPI);
      case 3:
        return ProfilePage(profile: profile);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
          appBar: CustomAppBar(),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  buildSection(),
                ],
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  selectedIndex: _selectedIndex,
                  onTabChange: _onItemTapped,
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: _colorScheme.primary,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: _colorScheme.surface,
                  color: _colorScheme.onSurface.withOpacity(0.6),
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Homepage',
                    ),
                    GButton(
                      icon: Icons.store,
                      text: 'Products',
                    ),
                    GButton(
                      icon: Icons.history,
                      text: 'History',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white),
    );
  }

  void navigateToArticlePage(BuildContext context, dynamic article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(article: article),
      ),
    );
  }

  void navigateToScanPage(BuildContext context, String animalType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanPage(
          animalType: animalType,
          backendUrl: 'https://ternaku-dev-test.et.r.appspot.com',
          token: widget.token,
        ),
      ),
    );
  }
}

class ScanMataHewanPage extends StatelessWidget {
  final String backendUrl;
  final String token;

  ScanMataHewanPage({required this.backendUrl, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Mata Hewan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled:
                      true, // Perbesar ukuran showModalBottomSheet
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height *
                          0.7, // Ukuran tinggi showModalBottomSheet
                      child: Wrap(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  navigateToScanPage(context, 'sapi');
                                },
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: SizedBox(
                                    width: 150,
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              'assets/sapi.png',
                                              width: 100,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'SAPI',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  navigateToScanPage(context, 'kambing');
                                },
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: SizedBox(
                                    width: 150,
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              'assets/kambing.png',
                                              width: 100,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'KAMBING',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SizedBox(
                  width: 200,
                  height: 250,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/sapi.png',
                            width: 150,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'SAPI',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled:
                      true, // Perbesar ukuran showModalBottomSheet
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height *
                          0.7, // Ukuran tinggi showModalBottomSheet
                      child: Wrap(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  navigateToScanPage(context, 'sapi');
                                },
                                child: Card(
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: SizedBox(
                                    width: 150,
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              'assets/kambing.png',
                                              width: 100,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'KAMBING',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SizedBox(
                  width: 200,
                  height: 250,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/kambing.png',
                            width: 150,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'KAMBING',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToScanPage(BuildContext context, String animalType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanPage(
          animalType: animalType,
          backendUrl: backendUrl,
          token: token,
        ),
      ),
    );
  }
}

class ScanPage extends StatefulWidget {
  final String animalType;
  final String backendUrl;
  final String token;
  ScanPage({
    required this.animalType,
    required this.backendUrl,
    required this.token,
  });

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _error;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _error = null;
      }
    });
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hasil Prediksi'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _predictImage() async {
    if (_imageFile == null) {
      setState(() {
        _error = 'Please select an image first.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url =
          Uri.parse('${widget.backendUrl}/api/predict${widget.animalType}');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer ${widget.token}';
      request.files
          .add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = utf8.decode(responseData);

      if (response.statusCode == 200) {
        final decodedData = json.decode(responseString);
        final result = decodedData['class'];
        _showResultDialog(result);
      } else {
        throw Exception('Failed to predict image.');
      }
    } catch (error) {
      setState(() {
        _error = 'Failed to predict image.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Hewan ${widget.animalType}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(
                'Pilih Gambar',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16.0),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    width: 200,
                    height: 200,
                  )
                : Container(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _predictImage,
              child: Text(
                'Prediksi Gambar',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16.0),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
