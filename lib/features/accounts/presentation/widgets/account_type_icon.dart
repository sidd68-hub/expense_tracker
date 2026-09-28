import 'package:flutter/material.dart';

import '../../domain/entities/account_type.dart';

class AccountTypeIcon extends StatelessWidget {
  const AccountTypeIcon({super.key, required this.type});

  final AccountType type;

  IconData get _icon => switch (type) {
        AccountType.bank => Icons.account_balance_outlined,
        AccountType.cash => Icons.payments_outlined,
        AccountType.card => Icons.credit_card_outlined,
        AccountType.upi => Icons.qr_code,
        AccountType.wallet => Icons.account_balance_wallet_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: Icon(_icon, color: Theme.of(context).colorScheme.onSecondaryContainer),
    );
  }
}
