import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/sale_model.dart';
import '../../../providers/sale_provider.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch sales data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SaleProvider>(context, listen: false).fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final aggregatedSales = saleProvider.getAggregatedSales();

    // Filter customers based on search query
    final filteredCustomers = aggregatedSales.entries.where((entry) {
      return entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomerSearchDelegate(aggregatedSales.entries.toList()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Customers',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: saleProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final entry = filteredCustomers[index];
                final customerName = entry.key;
                final sales = entry.value;

                // Calculate total purchase amount (sum of all products sold)
                double totalPurchaseAmount = sales.fold(0, (sum, sale) {
                  return sum + sale.totalPrice; // Assuming totalPrice is the total purchase amount for the sale
                });

                // Get customer details from the first sale (assuming all sales have the same customer details)
                final customerDetails = sales.first;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    title: Text(customerName),
                    subtitle: Text('Total Purchase Amount: \$${totalPurchaseAmount.toStringAsFixed(2)}'),
                    children: [
                      ListTile(
                        title: Text('Email: ${customerDetails.customerEmail}'),
                      ),
                      ListTile(
                        title: Text('Mobile: ${customerDetails.customerPhone}'),
                      ),
                      ListTile(
                        title: Text('Address: ${customerDetails.customerAddress ?? 'N/A'}'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom search delegate for customers
class CustomerSearchDelegate extends SearchDelegate<String> {
  final List<MapEntry<String, List<Sale>>> customers;

  CustomerSearchDelegate(this.customers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Provide a default value instead of null
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = customers.where((entry) {
      return entry.key.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final entry = results[index];
        final customerName = entry.key;
        final sales = entry.value;

        // Calculate total purchase amount (sum of all products sold)
        double totalPurchaseAmount = sales.fold(0, (sum, sale) {
          return sum + sale.totalPrice; // Assuming totalPrice is the total purchase amount for the sale
        });

        return ListTile(
          title: Text(customerName),
          subtitle: Text('Total Purchase Amount: \$${totalPurchaseAmount.toStringAsFixed(2)}'),
          onTap: () {
            close(context, customerName); // Pass customerName instead of null
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
