import 'package:ffmpeg_flutter_test/initial/RandomWords.dart';
import 'package:ffmpeg_flutter_test/initial/send_button.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/rendering.dart';
// import 'package:flutter_app/video_detail_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<ResultProvider>(
        create: (content) => ResultProvider(),
      ),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: LikePage(),
    );
  }
}

class VideoDetailPage extends StatelessWidget {
  VideoDetailPage(this.movie_id);
  int movie_id;
  @override
  Widget build(BuildContext context) {
    return Consumer<ResultProvider>(builder: (context, model, child) {
      return WillPopScope(
          onWillPop: () async {
            model.echoText();

            Navigator.pop(context);
            return Future.value(false);
          },
          child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Text('動画'),
                actions: [
                  SizedBox(
                    width: 44,
                    child: TextButton(
                        onPressed: () {
                          model.updateText('!更新');
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                  ),
                  SizedBox(
                    width: 44,
                    child: TextButton(
                        onPressed: () {},
                        child: Icon(Icons.more_vert, color: Colors.black)),
                  ),
                ],
              ),
              body: MovieDetail(movie_id, model)));
    });
  }
}

class MovieDetail extends StatefulWidget {
  MovieDetail(this.movie_id, this.model);
  int movie_id;
  ResultProvider model;

  @override
  _MovieDetailState createState() => _MovieDetailState(movie_id, model);
}

class _MovieDetailState extends State<MovieDetail> {
  _MovieDetailState(this.movie_id, this.model);
  int movie_id;
  ResultProvider model;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            child: ListView(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 280,
              child: Image.asset(
                'assets/${movie_id}.png',
                fit: BoxFit.cover,
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 6,
                    left: 10,
                  ),
                  child: Row(
                    //flexboxのように左寄せ右よせ
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('【癒し】ペルシャ猫まろんの日常 Part${movie_id}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 19,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.arrow_downward_sharp,
                          size: 20,
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, left: 20),
              child: Container(
                  width: double.infinity,
                  child: Text(
                    '7万 回視聴・2 週間前',
                    textAlign: TextAlign.left,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      child: Column(
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 26,
                          ),
                          Text('1,7万')
                        ],
                      ),
                      onTap: () {
                        model.setLike("いいね");
                        model.setLikes(movie_id);
                      }),
                  Column(
                    children: [
                      Icon(
                        Icons.thumb_down_outlined,
                        size: 26,
                      ),
                      Text('34')
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.share,
                        size: 26,
                      ),
                      Text('共有')
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.add_box_outlined,
                        size: 26,
                      ),
                      Text('保存')
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.download,
                        size: 26,
                      ),
                      Text('オフライン')
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              //丸いアイコン画像
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/2.png',
                                ),
                                fit: BoxFit.fill,
                              )),
                          width: 50,
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'maropook',
                              ),
                              Text(
                                'チャンネル登録者数 4580人',
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 9.0),
                      child: Text('チャンネル登録',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 6,
                    left: 10,
                  ),
                  child: Row(
                    //flexboxのように左寄せ右よせ
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('コメント　579',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, bottom: 10),
                        child: Icon(
                          Icons.arrow_downward_sharp,
                          size: 20,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            //丸いアイコン画像
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/1.png',
                              ),
                              fit: BoxFit.fill,
                            )),
                        width: 35,
                        height: 35,
                      ),
                    ),
                    Expanded(
                      child: Text(
                          "Very long text. Very long text. Very long text. Very long text. Very long text. Veryt. "),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Divider(
                color: Colors.grey,
                thickness: 8.0,
                height: 8,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 280,
              child: Image.asset(
                'assets/6.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            //丸いアイコン画像
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/2.png',
                              ),
                              fit: BoxFit.fill,
                            )),
                        width: 42,
                        height: 42,
                      ),
                    ),
                    Expanded(
                      child: Text(
                          "Very long text. Very long text. Very long text. Very long text. Very long text. Veryt. ",
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0, bottom: 20),
                      child: Icon(Icons.more_vert),
                    )
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 55),
                child:
                    Text('maropook・16万回視聴・5か月', style: TextStyle(fontSize: 10)))
          ],
        )),
      ],
    ));
  }
}

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ResultProvider>(
      builder: (context, model, child) {
        return WillPopScope(
            onWillPop: () {
              model.updateText('Thank you from 戻るアイコン'); // ResultProviderのメソッド
              Navigator.pop(context);
              return Future.value(false);
            },
            child: _EditPage());
      },
    );
  }
}

class LikedListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ResultProvider>(
      builder: (context, model, child) {
        return WillPopScope(
            onWillPop: () {
              // ResultProviderのメソッド
              Navigator.pop(context);

              return Future.value(false);
            },
            child: _LikedPage(model));
      },
    );
  }
}

class _LikedPage extends StatefulWidget {
  _LikedPage(this.model);

  ResultProvider model;

  @override
  _LikedPageState createState() => _LikedPageState(model);
}

class _LikedPageState extends State<_LikedPage> {
  _LikedPageState(this.model);
  ResultProvider model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ああ'),
        ),
        body: ListView.builder(
            itemCount: model._liked.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                      '【癒し】ペルシャ猫マロンの日常 Part${model._liked.elementAt(index)}'),
                  onTap: () {
                    model.deleteLikes(model._liked.elementAt(index));
                    setState(() {});
                  },
                ),
              );
            }));
  }
}

class _EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<_EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ああ'),
      ),
      body: Text("ああ"),
    );
  }
}

class ResultProvider extends ChangeNotifier {
  String _result = "初めまして";
  String _like = "";
  Set _liked = {};

  ResultProvider() {
    initValue();
  }

  void initValue() {
    this._result = "遷移先に移動";
  }

  void refresh() {
    initValue();
    notifyListeners(); // Providerを介してConsumer配下のWidgetがリビルドされる
  }

  void updateText(String str) {
    _result = str;
  }

  void setLike(String str) {
    _like = str;
  }

  void deleteLikes(int index) {
    print('remove${index}');
    _liked.remove(index);
    print(_liked.length);
  }

  void setLikes(int index) {
    print('add${index}');
    _liked.add(index);
    print(_liked.length);
  }

  void notify() {
    notifyListeners();
  }

  void echoText() {
    print(this._result);
  }
}

class LikePage extends StatefulWidget {
  LikePage({
    Key? key,
  }) : super(key: key);

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  final radius = 40;
  final items = List<String>.generate(11, (i) => "Item $i");
  bool _like = false;
  String _likecomment = 'チャンネル登録';

  void _pushRandomWords() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RandomWords(),
        ));
  }

  void _pushSendButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SendButton(),
        ));
  }

  void _likesetup() {
    setState(() {
      if (_like) {
        _like = false;
        _likecomment = 'チャンネル登録';
      } else {
        _like = true;
        _likecomment = '登録解除';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Icon(Icons.videocam),
        title: Text('Youtube'),
        actions: [
          SizedBox(
            width: 44,
            child: TextButton(
              onPressed: () {
                _pushRandomWords();
              },
              child: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: TextButton(
              onPressed: () {
                _pushSendButton();
              },
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ResultProvider>(builder: (contxst, model, _) {
        return _youtubeList(model);
      }),
    );
  }

  Widget _detilButton(ResultProvider model) {
    return ElevatedButton(
      child: Text('Go to Edit Page'),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderPage(),
          ),
        );
        model.notify(); // ResultProviderのメソッド
      },
    );
  }

  Widget _likedListButton(ResultProvider model) {
    return ElevatedButton(
      child: Text('いいね一覧'),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LikedListPage(),
          ),
        );
        model.notify(); // ResultProviderのメソッド
      },
    );
  }

  Widget _youtubeList(ResultProvider model) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          Column(
            children: [
              Text(model._result),
              Text(model._like),
              _detilButton(model),
              _likedListButton(model),
            ],
          )
        ])),
        _detailUser(),

        _detailUserMovie(model),

        _detailList(model),
        // _detailList(),
      ],
    );
  }

  Widget _detailList(ResultProvider model) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return _detailMovie(index, model);
      },
      childCount: items.length,
    ));
  }

  Widget _detailMovie(index, ResultProvider model) {
    return InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoDetailPage(index)),
          );
          model.notify();
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 7, right: 8),
                child: Container(
                  child: Image.asset(
                    'assets/${index}.png',
                    fit: BoxFit.cover,
                  ),
                  width: 155,
                  height: 95,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('【癒し】ペルシャ猫マロンの日常 Part${index}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        )),
                    Text('100回再生 10日前', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.more_vert),
            ],
          ),
        ));
  }

  Widget _detailUser() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 130,
                  child: Image.asset(
                    'assets/8.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 14.0,
                    bottom: 8,
                    left: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            //丸いアイコン画像
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/3.png',
                              ),
                              fit: BoxFit.fill,
                            )),
                        width: 83,
                        height: 83,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2, top: 0, bottom: 0),
                            child: Text(
                              'hasegawaitsuki',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2, top: 0, bottom: 4),
                            child: Text(
                              'チャンネル登録者数994万人',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              _likecomment,
                              style: TextStyle(
                                color: _like ? Colors.grey : Colors.red,
                              ),
                            ),
                            onPressed: () {
                              _likesetup();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _detailUserMovie(ResultProvider model) {
    int video_id = Random().nextInt(11);

    return SliverList(
      delegate: SliverChildListDelegate([
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoDetailPage(video_id)),
            );
            model.notify(); //
          },
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: Image.asset(
                    'assets/${video_id}.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                //丸いアイコン画像
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/3.png',
                                  ),
                                  fit: BoxFit.fill,
                                )),
                            width: 42,
                            height: 42,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Verylong text. Very long text. Very long text. Very long text. Very long text. Veryt. ",
                                  style: TextStyle(fontSize: 16)),
                              Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: Text('maropook・16万回視聴・5か月',
                                      style: TextStyle(fontSize: 13))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 0, bottom: 20),
                          child: Icon(Icons.more_vert),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 8, top: 12, bottom: 0),
            child: Text('アップロード動画', style: TextStyle(fontSize: 19))),
      ]),
    );
  }
}
