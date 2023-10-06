import 'package:flutter/material.dart';
import 'package:mobileapps/Qris.dart';
import 'package:mobileapps/GlobalVariabel.dart';

void main() {
  runApp(const Finance());
}

class Coin {
  final ValueNotifier<double> jumlah;
  final double harga;
  final String symbol;

  Coin({required this.jumlah, required this.harga, required this.symbol});
}

double money = GlobalData.money;

class Finance extends StatelessWidget {
  const Finance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bitcoin = Coin(
      symbol: 'BTC',
      harga: 29850.0,
      jumlah: ValueNotifier<double>(0),
    );

    final ethereum = Coin(
      symbol: 'ETH',
      harga: 10560.0,
      jumlah: ValueNotifier<double>(0),
    );

    final litecoin = Coin(
      symbol: 'LTC',
      harga: 3676.0,
      jumlah: ValueNotifier<double>(0),
    );

    final ripple = Coin(
      symbol: 'XRP',
      harga: 5240.0,
      jumlah: ValueNotifier<double>(0),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Navbar(),
              Bitcoin(coin: bitcoin),
              BuySellButton(coin: bitcoin),
              ETH(coin: ethereum),
              BuySellButton(coin: ethereum),
              LTC(coin: litecoin),
              BuySellButton(coin: litecoin),
              XRP(coin: ripple),
              BuySellButton(coin: ripple),
              BNBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          const Positioned(
            left: 20,
            top: 75, // Mengatur top ke 0 agar tetap di atas
            child: Text(
              'History',
              style: TextStyle(
                color: Color(0xFF118EEA),
                fontSize: 36,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w700,
                height: 0.03,
                letterSpacing: 0.38,
              ),
            ),
          ),
          Positioned(
            left: 327,
            top: 25, // Mengatur top ke 9 agar tetap di atas
            child: Container(
              width: 28,
              height: 28,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/profileicon.png'),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 20,
            top: 25, // Mengatur top ke 9 agar tetap di atas
            child: Text(
              'ECO-M',
              style: TextStyle(
                color: Color(0xFF118EEA),
                fontSize: 18,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuySellButton extends StatefulWidget {
  final Coin coin;

  BuySellButton({required this.coin});

  @override
  _BuySellButtonState createState() => _BuySellButtonState();
}

class _BuySellButtonState extends State<BuySellButton> {
  TextEditingController btcController = TextEditingController();
  double btcAmount = 0;

  void buyCoin() {
    double amountToBuy = double.parse(btcController.text);
    double cost = amountToBuy * widget.coin.harga;
    if (cost <= money) {
      setState(() {
        widget.coin.jumlah.value += amountToBuy;
        money -= cost;
        btcController.clear();
      });
    } else {
      // Handle insufficient funds.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Insufficient Funds'),
            content: Text(
                'You do not have enough money to buy this amount of ${widget.coin.symbol}.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void sellCoin() {
    double amountToSell = double.parse(btcController.text);
    if (amountToSell <= widget.coin.jumlah.value) {
      setState(() {
        widget.coin.jumlah.value -= amountToSell;
        money += amountToSell * widget.coin.harga;
        btcController.clear();
      });
    } else {
      // Handle insufficient coin balance.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Insufficient ${widget.coin.symbol} Balance'),
            content: Text(
                'You do not have enough ${widget.coin.symbol} to sell this amount.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(4),
        width: double.infinity,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0, right: 4),
              child: ElevatedButton(
                onPressed: buyCoin,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                ),
                child: Text(
                  'Buy',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  left: 4,
                  right: 4,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 150,
                  ),
                  child: TextField(
                    controller: btcController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah ${widget.coin.symbol}',
                      hintText: 'Masukkan jumlah ${widget.coin.symbol}',
                      labelStyle: TextStyle(
                        fontSize: 12,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0, left: 4),
              child: ElevatedButton(
                onPressed: sellCoin,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                ),
                child: Text(
                  'Sell',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class Bitcoin extends StatelessWidget {
  final Coin coin;

  Bitcoin({required this.coin});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Opacity(
                    opacity: 0.10,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF6533D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    width: 23,
                    height: 23,
                    padding: const EdgeInsets.symmetric(horizontal: 3.33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset('assets/bitcoin-logo.png'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 36,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BTC',
                  style: TextStyle(
                    color: Color(0xFF17171A),
                    fontSize: 15,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.08,
                    letterSpacing: -0.41,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    '+1.6%',
                    style: TextStyle(
                      color: Color(0xFF118EEA),
                      fontSize: 13,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      height: 0.09,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Container(
            width: 90,
            height: 90,
            child: Stack(
              children: [
                Positioned(
                  left: -15,
                  top: -25,
                  child: Container(
                    width: 110,
                    height: 130,
                    padding: const EdgeInsets.symmetric(horizontal: 3.33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset('assets/bitcoingraph.png'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Container(
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${coin.harga.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Color(0xFF17171A),
                    fontSize: 17,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.08,
                    letterSpacing: -0.41,
                  ),
                ),
                SizedBox(height: 15),
                ValueListenableBuilder<double>(
                  valueListenable: coin.jumlah,
                  builder: (context, value, child) {
                    return Text(
                      '${coin.jumlah.value} ${coin.symbol}',
                      style: TextStyle(
                        color: Color(0xFF118EEA),
                        fontSize: 15,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                        height: 0.09,
                        letterSpacing: -0.24,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ETH extends StatelessWidget {
  final Coin coin;

  ETH({required this.coin});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Opacity(
                    opacity: 0.10,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF6533D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    width: 25,
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 3.33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset('assets/ethlogo.png'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 36,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ETH',
                  style: TextStyle(
                    color: Color(0xFF17171A),
                    fontSize: 15,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.08,
                    letterSpacing: -0.41,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    '+0.8%',
                    style: TextStyle(
                      color: Color(0xFF118EEA),
                      fontSize: 13,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      height: 0.09,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Container(
            width: 90,
            height: 90,
            child: Stack(
              children: [
                Positioned(
                  left: -15,
                  top: -25,
                  child: Container(
                    width: 110,
                    height: 130,
                    padding: const EdgeInsets.symmetric(horizontal: 3.33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset('assets/ethgraph.png'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Container(
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${coin.harga.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Color(0xFF17171A),
                    fontSize: 17,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.08,
                    letterSpacing: -0.41,
                  ),
                ),
                SizedBox(height: 15),
                ValueListenableBuilder<double>(
                  valueListenable: coin.jumlah,
                  builder: (context, value, child) {
                    return Text(
                      '${coin.jumlah.value} ${coin.symbol}',
                      style: TextStyle(
                        color: Color(0xFF118EEA),
                        fontSize: 15,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                        height: 0.09,
                        letterSpacing: -0.24,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LTC extends StatelessWidget {
  final Coin coin;

  LTC({required this.coin});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Opacity(
                    opacity: 0.10,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF6533D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    width: 23,
                    height: 23,
                    padding: const EdgeInsets.symmetric(horizontal: 3.33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset('assets/ltc.png'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 36,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LTC',
                  style: TextStyle(
                    color: Color(0xFF17171A),
                    fontSize: 15,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.08,
                    letterSpacing: -0.41,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    '+0.4%',
                    style: TextStyle(
                      color: Color(0xFF118EEA),
                      fontSize: 13,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      height: 0.09,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Container(
            width: 90,
            height: 90,
            child: Stack(
              children: [
                Positioned(
                  left: -15,
                  top: -25,
                  child: Container(
                    width: 110,
                    height: 130,
                    padding: const EdgeInsets.symmetric(horizontal: 3.33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset('assets/ltcgraph.png'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Container(
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${coin.harga.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Color(0xFF17171A),
                    fontSize: 17,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.08,
                    letterSpacing: -0.41,
                  ),
                ),
                SizedBox(height: 15),
                ValueListenableBuilder<double>(
                  valueListenable: coin.jumlah,
                  builder: (context, value, child) {
                    return Text(
                      '${coin.jumlah.value} ${coin.symbol}',
                      style: TextStyle(
                        color: Color(0xFF118EEA),
                        fontSize: 15,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                        height: 0.09,
                        letterSpacing: -0.24,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class XRP extends StatelessWidget {
  final Coin coin;

  XRP({required this.coin});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Opacity(
                    opacity: 0.10,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF6533D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    width: 23,
                    height: 23,
                    padding: const EdgeInsets.symmetric(horizontal: 3.33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset('assets/xrplogo.png'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 36,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'XRP',
                  style: TextStyle(
                    color: Color(0xFF17171A),
                    fontSize: 15,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.08,
                    letterSpacing: -0.41,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    '+0.1%',
                    style: TextStyle(
                      color: Color(0xFF118EEA),
                      fontSize: 13,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      height: 0.09,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Container(
            width: 90,
            height: 90,
            child: Stack(
              children: [
                Positioned(
                  left: -15,
                  top: -25,
                  child: Container(
                    width: 110,
                    height: 130,
                    padding: const EdgeInsets.symmetric(horizontal: 3.33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset('assets/xrpgraph.png'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Container(
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${coin.harga.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Color(0xFF17171A),
                    fontSize: 17,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.08,
                    letterSpacing: -0.41,
                  ),
                ),
                SizedBox(height: 15),
                ValueListenableBuilder<double>(
                  valueListenable: coin.jumlah,
                  builder: (context, value, child) {
                    return Text(
                      '${coin.jumlah.value} ${coin.symbol}',
                      style: TextStyle(
                        color: Color(0xFF118EEA),
                        fontSize: 15,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                        height: 0.09,
                        letterSpacing: -0.24,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BNBar extends StatelessWidget {
  const BNBar({super.key});

  void _openQRISPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Qris(),
    ));
  }

  void _openFinancePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          const Finance(), // Pastikan Qris sesuai dengan nama file/halaman Anda
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 0.0),
        child: Column(
          children: [
            Container(
              width: 460,
              height: 49,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Color.fromRGBO(17, 142, 234, 0.149)),
                  top: BorderSide(width: 1, color: Color(0x26118EEA)),
                  right: BorderSide(color: Color(0x26118EEA)),
                  bottom: BorderSide(color: Color(0x26118EEA)),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 112,
                    top: 0,
                    child: Container(
                      width: 99,
                      padding: const EdgeInsets.only(
                          top: 13, left: 49.78, right: 25.22),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Image.asset('assets/homeicon.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 241,
                    top: -5,
                    child: InkWell(
                      onTap: () => _openQRISPage(context),
                      child: Container(
                        width: 100,
                        height: 60,
                        padding: const EdgeInsets.symmetric(vertical: 9.55),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 60,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(),
                              child: Image.asset('assets/qrisicon.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: -4,
                    child: InkWell(
                      onTap: () => _openFinancePage(context),
                      child: Container(
                        width: 100,
                        height: 60,
                        padding: const EdgeInsets.symmetric(vertical: 9.55),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(),
                              child: Image.asset('assets/financeicon.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
