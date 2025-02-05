import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/account_payable_model.dart';
import '../../../providers/account_payable_provider.dart';

class EditAccountPayablePage extends StatelessWidget {
  final AccountPayable accountPayable;
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  final _amountDueController = TextEditingController();
  final _dueDateController = TextEditingController();

  EditAccountPayablePage({required this.accountPayable}) {
    _supplierNameController.text = accountPayable.supplierName;
    _amountDueController.text = accountPayable.amountDue.toString();
    _dueDateController.text = accountPayable.dueDate.toIso8601String().split('T')[0];
  }

  @override
  Widget build(BuildContext context) {
    final accountPayableProvider = Provider.of<AccountPayableProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account Payable'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _supplierNameController,
                decoration: InputDecoration(labelText: 'Supplier Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a supplier name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountDueController,
                decoration: InputDecoration(labelText: 'Amount Due'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount due';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a due date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedAccountPayable = AccountPayable(
                      id: accountPayable.id,
                      supplierName: _supplierNameController.text,
                      amountDue: double.parse(_amountDueController.text),
                      dueDate: DateTime.parse(_dueDateController.text),
                    );
                    accountPayableProvider.updateAccountPayable(updatedAccountPayable);
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Account Payable'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}