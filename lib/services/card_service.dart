import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_model.dart';

class CardService {
  static const String _cardsKey = 'saved_cards';

  static Future<List<CardModel>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = prefs.getStringList(_cardsKey) ?? [];
    
    return cardsJson.map((cardJson) {
      final Map<String, dynamic> cardMap = json.decode(cardJson);
      return CardModel.fromJson(cardMap);
    }).toList();
  }

  static Future<void> saveCard(CardModel card) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await getCards();
    cards.add(card);
    
    final cardsJson = cards.map((card) => json.encode(card.toJson())).toList();
    await prefs.setStringList(_cardsKey, cardsJson);
  }

  static Future<void> deleteCard(String cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await getCards();
    cards.removeWhere((card) => card.id == cardId);
    
    final cardsJson = cards.map((card) => json.encode(card.toJson())).toList();
    await prefs.setStringList(_cardsKey, cardsJson);
  }

  static Future<void> clearAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cardsKey);
  }
}