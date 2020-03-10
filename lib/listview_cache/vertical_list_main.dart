import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_context) => ScrollController(),
        child: const _ListPage(),
      ),
    );
  }
}

class _ListPage extends StatelessWidget {
  const _ListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: Provider.of(context),
        itemBuilder: (context, index) {
          return _ListItem.wrapped(index);
        },
      ),
    );
  }
}

class _ListItemObserver extends Disposable {
  _ListItemObserver({
    @required this.index,
    @required this.controller,
  }) {
    print('init:$index,'
        'offset:${controller.offset}');
  }

  final int index;
  final ScrollController controller;

  @override
  void dispose() {
    print('dispose:$index,'
        'offset:${controller.offset}');
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem._({Key key}) : super(key: key);

  static Widget wrapped(int index) {
    return DisposableProvider(
      create: (_context) => _ListItemObserver(
        index: index,
        controller: Provider.of(_context, listen: false),
      ),
      child: const _ListItem._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = Provider.of<_ListItemObserver>(context, listen: false).index;
    return Container(
      color: index % 2 == 0 ? Colors.amber : Colors.blue,
      height: MediaQuery.of(context).size.height,
      child: Text(index.toString()),
    );
  }
}
