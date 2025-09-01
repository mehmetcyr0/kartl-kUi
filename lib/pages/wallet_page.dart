import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../models/card_model.dart';
import '../services/card_service.dart';
import 'add_card_page.dart';
import 'card_detail_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<CardModel> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedCards = await CardService.getCards();
      setState(() {
        cards = loadedCards;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kartlar yüklenirken hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _navigateToAddCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCardPage()),
    );

    if (result == true) {
      _loadCards();
    }
  }

  Future<void> _deleteCard(CardModel card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kartı Sil'),
        content: Text('${card.bankName} kartını silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await CardService.deleteCard(card.id);
        _loadCards();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kart başarıyla silindi!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kart silinirken hata: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Kartlarım', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 61, 61, 61),
        actions: [
          if (cards.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Bilgi'),
                    content: Text('Toplam ${cards.length} kart kayıtlı'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tamam'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.credit_card_off,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Henüz kart yok',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'İlk kartınızı eklemek için + butonuna tıklayın',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadCards,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CardDetailPage(card: card),
                              ),
                            );
                          },
                          onLongPress: () => _deleteCard(card),
                          child: CreditCardWidget(
                            bankName: card.bankName,
                            cardNumber: card.cardNumber,
                            expiryDate: card.expiryDate,
                            cardHolderName: card.cardHolderName,
                            cvvCode: card.cvvCode,
                            showBackView: false,
                            isHolderNameVisible: true,
                            cardBgColor: const Color.fromARGB(255, 46, 44, 44),
                            onCreditCardWidgetChange: (_) {},
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 61, 61, 61),
        onPressed: _navigateToAddCard,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Kart Ekle',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}