import 'package:flutter/material.dart';
import 'package:project/palette.dart';

class ExpenseIconList{
  static const essentials = Icon(Icons.emoji_food_beverage_outlined, color: IponColors.white);
  static const data = Icon(Icons.phone, color: IponColors.white);
  static const games = Icon(Icons.games, color: IponColors.white);
  static const electricity = Icon(Icons.lightbulb_outline, color: IponColors.white);
  static const leisure = Icon(Icons.shopping_bag_outlined, color: IponColors.white);
  static const others = Icon(Icons.edit, color: IponColors.white);
  static const List<Icon> icons = [essentials, data, games, electricity, leisure, others];
}

enum ExpIconList{
  essentials, data, games, electricity, leisure, others
}

class IncomeIconList{
  static const job = Icon(Icons.business_center_outlined, color: IponColors.white);
  static const allowance = Icon(Icons.person_add, color: IponColors.white);
  static const interest = Icon(Icons.money, color: IponColors.white);
  static const others = Icon(Icons.edit, color: IponColors.white);
  static const List<Icon> icons = [job, allowance, interest, others];
}

enum IncIconList{
  job, allowance, interest, others
}