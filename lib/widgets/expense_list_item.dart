import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/tag.dart';

/// A reusable widget for displaying an expense item in a list.
/// 
/// This widget encapsulates the UI for displaying expense details,
/// including title, amount, date, and associated tags.
class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final List<Tag> tags;
  final VoidCallback? onTap;
  
  const ExpenseListItem({
    Key? key,
    required this.expense,
    this.tags = const [],
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();
    final currencyFormat = NumberFormat.currency(
      symbol: _getCurrencySymbol(expense.currency),
      decimalDigits: 2,
    );
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (expense.description != null && expense.description!.isNotEmpty) ...[  
                          const SizedBox(height: 4),
                          Text(
                            expense.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    currencyFormat.format(expense.amount),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormat.format(expense.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  if (expense.updatedAt != expense.createdAt)
                    Text(
                      'Edited',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
              if (tags.isNotEmpty) ...[  
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) => _buildTagChip(context, tag)).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTagChip(BuildContext context, Tag tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(tag.color).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag.name,
        style: TextStyle(
          fontSize: 12,
          color: Color(tag.color),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'VND':
        return '₫';
      default:
        return currencyCode;
    }
  }
}