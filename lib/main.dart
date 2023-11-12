import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/moedas",
    routes: {
      "/moedas": (context) => Moedas(),
      "/acoes": (context) => Acoes(),
      "/bitcoin": (context) => Bitcoin(),
    },
  ));
}

class ApiService {
  static ApiService? _instance;
  final String apiKey = f413ad1d';

  factory ApiService() {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance!;
  }

  ApiService._internal();

  Map<String, dynamic>? _cachedData;

  Future<Map<String, dynamic>?> fetchData() async {
    if (_cachedData != null) {
      return _cachedData;
    }

    final response = await http.get(
      Uri.parse(
        'https://api.hgbrasil.com/finance?key=$apiKey&format=json-cors',
      ),
    );

    if (response.statusCode == 200) {
      _cachedData = json.decode(response.body);
      return _cachedData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Moedas extends StatefulWidget {
  final ApiService apiService = ApiService();

  @override
  _MoedasState createState() => _MoedasState();
}

class _MoedasState extends State<Moedas> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final fetchedData = await widget.apiService.fetchData();
    if (fetchedData != null) {
      setState(() {
        data = fetchedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finanças de Hoje',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.green[900],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: data != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('Moedas', style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoMoeda(
                            'Dólar',
                            data?['results']['currencies']['USD'],
                          ),
                          buildInfoMoeda(
                            'Euro',
                            data?['results']['currencies']['EUR'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoMoeda(
                            'Peso',
                            data?['results']['currencies']['ARS'],
                          ),
                          buildInfoMoeda(
                            'Yen',
                            data?['results']['currencies']['JPY'],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/acoes");
                  },
                  child: Text('Ir para Ações', style: TextStyle(color: Colors.white)), 
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildInfoMoeda(
      String currencyName, Map<String, dynamic>? currencyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currencyName,
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              '${currencyData?['buy'].toStringAsFixed(4)}',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    currencyData?['variation'] < 0 ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currencyData?['variation'].toStringAsFixed(4)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Acoes extends StatefulWidget {
  final ApiService apiService = ApiService();

  @override
  _AcoesState createState() => _AcoesState();
}

class _AcoesState extends State<Acoes> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final fetchedData = await widget.apiService.fetchData();
    if (fetchedData != null) {
      setState(() {
        data = fetchedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finanças de Hoje',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.green[900],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: data != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('Ações', style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoAcoes(
                            'IBOVESPA',
                            data?['results']['stocks']['IBOVESPA'],
                          ),
                          buildInfoAcoes(
                            'IFIX',
                            data?['results']['stocks']['IFIX'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoAcoes(
                            'NASDAQ',
                            data?['results']['stocks']['NASDAQ'],
                          ),
                          buildInfoAcoes(
                            'DOWJONES',
                            data?['results']['stocks']['DOWJONES'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoAcoes(
                            'CAC',
                            data?['results']['stocks']['CAC'],
                          ),
                          buildInfoAcoes(
                            'NIKKEI',
                            data?['results']['stocks']['NIKKEI'],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/bitcoin");
                  },
                  child: Text('Ir para Bitcoin', style: TextStyle(color: Colors.white)), 
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildInfoAcoes(
      String currencyName, Map<String, dynamic>? currencyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currencyName,
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              '${currencyData?['points'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    currencyData?['variation'] < 0 ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currencyData?['variation'].toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Bitcoin extends StatefulWidget {
  final ApiService apiService = ApiService();

  @override
  _BitcoinState createState() => _BitcoinState();
}

class _BitcoinState extends State<Bitcoin> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final fetchedData = await widget.apiService.fetchData();
    if (fetchedData != null) {
      setState(() {
        data = fetchedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finanças de Hoje',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.green[900],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: data != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('BitCoin', style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoBitcoin(
                            'Blockchain.info',
                            data?['results']['bitcoin']['blockchain_info'],
                          ),
                          buildInfoBitcoin(
                            'Coinbase',
                            data?['results']['bitcoin']['coinbase'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                       
                        children: [
                          buildInfoBitcoin(
                            'bitstamp',
                            data?['results']['bitcoin']['bitstamp'],
                          ),
                          buildInfoBitcoin(
                            'foxbit',
                            data?['results']['bitcoin']['foxbit'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                       
                        children: [
                          buildInfoBitcoin(
                            'mercadobitcoin',
                            data?['results']['bitcoin']['mercadobitcoin'],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/moedas");
                  },
                  child: Text('Página Principal', style: TextStyle(color: Colors.white)), 
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildInfoBitcoin(
      String currencyName, Map<String, dynamic>? currencyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currencyName,
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              '${currencyData?['last'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    currencyData?['variation'] < 0 ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currencyData?['variation'].toStringAsFixed(3)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
