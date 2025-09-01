import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../models/card_model.dart';

class CardDetailPage extends StatefulWidget {
  final CardModel card;

  const CardDetailPage({super.key, required this.card});

  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  bool showBackView = false;
  bool showSensitiveInfo = false;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label panoya kopyalandı'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          widget.card.bankName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 61, 61, 61),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              showSensitiveInfo ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showSensitiveInfo = !showSensitiveInfo;
              });
            },
          ),
          IconButton(
            icon: Icon(
              showBackView ? Icons.credit_card : Icons.credit_card_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showBackView = !showBackView;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CreditCardWidget(
              cardBgColor: const Color.fromARGB(255, 46, 44, 44),
              cardNumber: showSensitiveInfo ? widget.card.cardNumber : widget.card.maskedCardNumber,
              expiryDate: widget.card.expiryDate,
              cardHolderName: widget.card.cardHolderName,
              cvvCode: showSensitiveInfo ? widget.card.cvvCode : '***',
              bankName: widget.card.bankName,
              showBackView: showBackView,
              onCreditCardWidgetChange: (_) {},
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kart Bilgileri',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Banka',
                        widget.card.bankName,
                        Icons.account_balance,
                        () => _copyToClipboard(widget.card.bankName, 'Banka adı'),
                      ),
                      _buildInfoRow(
                        'Kart Türü',
                        widget.card.cardType,
                        Icons.credit_card,
                        null,
                      ),
                      _buildInfoRow(
                        'Kart Numarası',
                        showSensitiveInfo ? widget.card.cardNumber : widget.card.maskedCardNumber,
                        Icons.numbers,
                        () => _copyToClipboard(widget.card.cardNumber, 'Kart numarası'),
                      ),
                      _buildInfoRow(
                        'Kart Sahibi',
                        widget.card.cardHolderName,
                        Icons.person,
                        () => _copyToClipboard(widget.card.cardHolderName, 'Kart sahibi'),
                      ),
                      _buildInfoRow(
                        'Son Kullanma',
                        widget.card.expiryDate,
                        Icons.calendar_today,
                        () => _copyToClipboard(widget.card.expiryDate, 'Son kullanma tarihi'),
                      ),
                      _buildInfoRow(
                        'CVV',
                        showSensitiveInfo ? widget.card.cvvCode : '***',
                        Icons.security,
                        () => _copyToClipboard(widget.card.cvvCode, 'CVV'),
                      ),
                      _buildInfoRow(
                        'IBAN',
                        showSensitiveInfo ? widget.card.iban : widget.card.maskedIban,
                        Icons.account_balance_wallet,
                        () => _copyToClipboard(widget.card.iban, 'IBAN'),
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Eklenme: ${_formatDate(widget.card.createdAt)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.copy, size: 16, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}