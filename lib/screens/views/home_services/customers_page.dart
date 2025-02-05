import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/customers_model.dart';
import '../../../providers/customers_provider.dart';

class CustomersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: ListView.builder(
        itemCount: customerProvider.customers.length,
        itemBuilder: (context, index) {
          final customer = customerProvider.customers[index];
          return ListTile(
            title: Text(customer.name),
            subtitle: Text(customer.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit customer page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCustomerPage(customer: customer),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    customerProvider.deleteCustomer(customer.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add customer page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCustomerPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddCustomerPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final customer = Customer(
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      createdAt: DateTime.now(),
                    );
                    customerProvider.addCustomer(customer);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditCustomerPage extends StatelessWidget {
  final Customer customer;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  EditCustomerPage({required this.customer}) {
    _nameController.text = customer.name;
    _emailController.text = customer.email;
    _phoneController.text = customer.phone;
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedCustomer = Customer(
                      id: customer.id,
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      createdAt: customer.createdAt,
                    );
                    customerProvider.updateCustomer(updatedCustomer);
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}