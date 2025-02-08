import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/account_payable_provider.dart';
import 'add_account_payable_page.dart';
import 'edit_account_payable_page.dart';

class AccountPayablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accountPayableProvider = Provider.of<AccountPayableProvider>(context);

    // Fetch account payables when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountPayableProvider.fetchAccountPayables();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts Payable'),
      ),
      body: ListView.builder(
        itemCount: accountPayableProvider.accountPayables.length,
        itemBuilder: (context, index) {
          final accountPayable = accountPayableProvider.accountPayables[index];
          return ListTile(
            title: Text(accountPayable.supplierName),
            subtitle: Text('Amount Due: \$${accountPayable.amountDue.toStringAsFixed(2)} - Due Date: ${accountPayable.dueDate.toLocal().toString().split(' ')[0]}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit account payable page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAccountPayablePage(accountPayable: accountPayable),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    accountPayableProvider.deleteAccountPayable(accountPayable.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add account payable page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAccountPayablePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}