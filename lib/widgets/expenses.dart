import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerdExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 1200,
        date: DateTime.now(),
        category: Category.study),
    Expense(
        title: 'Cinema',
        amount: 1800,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerdExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerdExpenses.indexOf(expense);
    setState(() {
      _registerdExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${expense.title}を削除しました。'),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
          label: '元に戻す',
          onPressed: () {
            setState(() {
              _registerdExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('何も登録されていません。'),
    );
    if (_registerdExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registerdExpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('出費管理'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registerdExpenses),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
