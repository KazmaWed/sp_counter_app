import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  // 保存した値ロード
  Future<int> _futureLoadedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 保存した値がなければゼロ
    return prefs.getInt('counterValue') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // 保存した値ロード
    final futureLoadedValue = _futureLoadedValue();

    return FutureBuilder(
      future: futureLoadedValue,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // 値ロード中プログレスバー
          return Scaffold(
            appBar: AppBar(title: const Text('SP COUNTER APP')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // ロード失敗
          return Scaffold(
            appBar: AppBar(title: const Text('SP COUNTER APP')),
            body: Center(child: Text(snapshot.error.toString())),
          );
        } else {
          // ロード後
          return CounterView(initialValue: snapshot.data!);
        }
      },
    );
  }
}

// ロード後のメインのビュー
class CounterView extends StatefulWidget {
  const CounterView({Key? key, required this.initialValue}) : super(key: key);
  final int initialValue;

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  // 初回ビルド判定
  bool firstBuild = true;
  late int counter;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      counter = widget.initialValue;
      firstBuild = false;
    }

    // 値の保存
    void _saveValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('counterValue', counter);
    }

    // 値のインクリメント＆保存まで実行
    void _incrementCounter() {
      setState(() {
        counter = counter + 1;
      });
      _saveValue();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('SP COUNTER APP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
