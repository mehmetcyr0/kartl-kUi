import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:sanalcuzdan/AddCardPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cüzdan Uygulaması',

      home: const WalletPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<Map<String, String>> cards = [];

  void _addCard(Map<String, String> cardData) {
    setState(() {
      cards.add(cardData);
    });
  }

  void _navigateToAddCard() async {
    final newCard = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCardPage()),
    );

    if (newCard != null && newCard is Map<String, String>) {
      _addCard(newCard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Kartlarım', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 61, 61, 61),
      ),
      body: cards.isEmpty
          ? const Center(child: Text('Henüz kart yok'))
          : ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return CreditCardWidget(
                  bankName: card["bankname"],
                  cardNumber: card['number']!,
                  expiryDate: card['expiry']!,
                  cardHolderName: card['name']!,

                  cvvCode: card['cvv']!,
                  showBackView: false,
                  isHolderNameVisible: true,
                  cardBgColor: const Color.fromARGB(255, 46, 44, 44),
                  onCreditCardWidgetChange: (_) {},
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 61, 61, 61),
        onPressed: _navigateToAddCard,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
