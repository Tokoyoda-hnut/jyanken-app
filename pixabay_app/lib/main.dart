import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PixabayPage());
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  //はじめはからのリストを入れておく
  List<PixabayImage>  pixabayImages = [];

  Future<void> fetchImages(String text) async {
    final Response response = await Dio().get(
      'https://pixabay.com/api',
      queryParameters : {
        'key' : '49704360-58b27d86557b88ec6ee3cc7f4',
        'q' : text,
        'image_type': 'photo',
        'per_page' : 100,
     // /?key=49704360-58b27d86557b88ec6ee3cc7f4&q=$text&image_type=photo&pretty=true&per_page=100',
      },
    );
    final List hits = response.data['hits'];
    print('取得件数: ${hits.length}'); // ← ここ追加！

    pixabayImages = hits.map(
        (e) {
        return PixabayImage.formMap(e);
    }, 
    ).toList();
    setState(() {});
  }

  Future<void> shareImage(String url) async {
    // ダウンロードしたデータをファイルに保存して共有する機能追加
    Response response = await Dio().get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    // ダウンロードしたデータをファイルに保存
    Directory dir = await getTemporaryDirectory();
    File imageFile = await File(
      '${dir.path}/image.png',
    ).writeAsBytes(response.data);

    await Share.shareXFiles([XFile(imageFile.path)], text: 'Check this out!');
  }

  // 最初に一回だけ呼ばれる処理を書くところ
  @override
  void initState() {
    super.initState();
    fetchImages('moon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: 'moon',
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            print(text);
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: pixabayImages.length,
        itemBuilder: (context, index) {
          final  pixabayImage = pixabayImages[index];
          //return Text(index.toString());
          return InkWell(
            onTap: () async {
              shareImage(pixabayImage.webformatURL);
            },
            child: Stack(
              children: [
                Image.network(
                    pixabayImage.previewURL, 
                    fit: BoxFit.cover),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: Colors.amber,
                    child: Row(
                      children: [
                        Icon(Icons.thumb_up_outlined, size: 14),
                        Text('${pixabayImage.likes}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PixabayImage {
    final String webformatURL;
    final String previewURL;
    final int likes;

  PixabayImage({
    required this.webformatURL, 
    required this.previewURL, 
    required this.likes,
    });

    factory PixabayImage.formMap(Map<String, dynamic> map)
    {
        return PixabayImage(
            webformatURL: map['webformatURL'], 
            previewURL: map['previewURL'], 
            likes: map['likes']);
    }
}

//final PixabayImage = PixabayImage(webformatURL: webformatURL, previewURL: previewURL, likes: likes)