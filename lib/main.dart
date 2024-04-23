import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    ThemeManager(
      child: OrderApp(),
    ),
  );
}

class OrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      home: PlaceOrderScreen(),
    );
  }
}

class Chocolate {
  final String name;
  final List<ChocolateVariant> variants;

  Chocolate({required this.name, required this.variants});
}

class ChocolateVariant {
  final String name;
  final int price;

  ChocolateVariant({required this.name, required this.price});
}

class PlaceOrderScreen extends StatefulWidget {
  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final List<Chocolate> chocolates = [
    Chocolate(
      name: 'Munch',
      variants: [
        ChocolateVariant(name: '10g', price: 10),
        ChocolateVariant(name: '35g', price: 20),
        ChocolateVariant(name: '110g', price: 50),
      ],
    ),
    Chocolate(
      name: 'DairyMilk',
      variants: [
        ChocolateVariant(name: '10g', price: 10),
        ChocolateVariant(name: '35g', price: 30),
        ChocolateVariant(name: '110g', price: 80),
        ChocolateVariant(name: '110g - Silk', price: 95),
      ],
    ),
    Chocolate(
      name: 'KitKat',
      variants: [
        ChocolateVariant(name: '20g', price: 15),
        ChocolateVariant(name: '50g', price: 40),
        ChocolateVariant(name: '100g', price: 75),
      ],
    ),
    Chocolate(
      name: 'FiveStar',
      variants: [
        ChocolateVariant(name: '20g', price: 20),
        ChocolateVariant(name: '50g', price: 50),
        ChocolateVariant(name: '100g', price: 90),
      ],
    ),
    Chocolate(
      name: 'Perk',
      variants: [
        ChocolateVariant(name: '25g', price: 10),
        ChocolateVariant(name: '50g', price: 20),
        ChocolateVariant(name: '100g', price: 35),
      ],
    ),
  ];

  Map<String, Map<String, int>> _selectedProducts = {};

  void _incrementProductCount(String productName, String variant) {
    setState(() {
      if (_selectedProducts.containsKey(productName)) {
        if (_selectedProducts[productName]!.containsKey(variant)) {
          _selectedProducts[productName]![variant] =
              _selectedProducts[productName]![variant]! + 1;
        } else {
          _selectedProducts[productName]![variant] = 1;
        }
      } else {
        _selectedProducts[productName] = {variant: 1};
      }
    });
  }

  void _decrementProductCount(String productName, String variant) {
    setState(() {
      if (_selectedProducts.containsKey(productName) &&
          _selectedProducts[productName]!.containsKey(variant) &&
          _selectedProducts[productName]![variant]! > 0) {
        _selectedProducts[productName]![variant] =
            _selectedProducts[productName]![variant]! - 1;
        if (_selectedProducts[productName]![variant] == 0) {
          _selectedProducts[productName]!.remove(variant);
          if (_selectedProducts[productName]!.isEmpty) {
            _selectedProducts.remove(productName);
          }
        }
      }
    });
  }

  void _viewSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryScreen(
          selectedProducts: _selectedProducts,
          updateProducts: _updateProducts,
          chocolates: chocolates,
        ),
      ),
    );
  }

  void _updateProducts(Map<String, Map<String, int>> updatedProducts) {
    setState(() {
      _selectedProducts = updatedProducts;
    });
  }

  void _discardProducts() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Discard Products?'),
          content:
          Text('Are you sure you want to discard all selected products?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedProducts.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Place Order',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor:
        Colors.pinkAccent[100], // Set the app bar background color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Chocolates:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: chocolates.length,
                itemBuilder: (context, index) {
                  final chocolate = chocolates[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: Text(chocolate.name),
                        children: chocolate.variants.map((variant) {
                          final count = _selectedProducts[chocolate.name]
                              ?.containsKey(variant.name) ==
                              true
                              ? _selectedProducts[chocolate.name]![
                          variant.name] ??
                              0
                              : 0;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  variant.name,
                                  textAlign:
                                  TextAlign.start, // Align text to the left
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _decrementProductCount(
                                        chocolate.name, variant.name),
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text(count.toString()),
                                  IconButton(
                                    onPressed: () => _incrementProductCount(
                                        chocolate.name, variant.name),
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _viewSummary,
              child: Text('View Summary'),
            ),
          ],
        ),
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: _discardProducts,
      //  child: Icon(Icons.delete),
      floatingActionButton: ElevatedButton(
        onPressed: _discardProducts,
        style: ElevatedButton.styleFrom(
          //primary: Colors.red, // Set the background color of the button
        ),
        child: Text('Cancel Order'), // Set the text of the button
      ),
      //),
    );
  }
}

class OrderSummaryScreen extends StatelessWidget {
  final Map<String, Map<String, int>> selectedProducts;
  final Function(Map<String, Map<String, int>>) updateProducts;
  final List<Chocolate> chocolates;

  OrderSummaryScreen({
    required this.selectedProducts,
    required this.updateProducts,
    required this.chocolates,
  });

  @override
  Widget build(BuildContext context) {
    int totalCost = 0;

    selectedProducts.forEach((productName, variants) {
      variants.forEach((variant, quantity) {
        final chocolate = chocolates.firstWhere(
              (c) => c.name == productName,
          orElse: () => Chocolate(name: '', variants: []),
        );
        final selectedVariant = chocolate.variants.firstWhere(
              (v) => v.name == variant,
          orElse: () => ChocolateVariant(name: '', price: 0),
        );
        totalCost += quantity * selectedVariant.price;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: selectedProducts.length,
          itemBuilder: (context, index) {
            final productName = selectedProducts.keys.elementAt(index);
            final variants = selectedProducts[productName]!.keys.toList();
            return Column(
              children: [
                Text(
                  productName,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: variants.map((variant) {
                    final quantity = selectedProducts[productName]![variant]!;
                    final price = getPrice(productName, variant);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(variant),
                        Text('Quantity: $quantity'),
                        Text('Total: ${quantity * price} INR'),
                      ],
                    );
                  }).toList(),
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Spacer(),
              Text('Total Cost: $totalCost INR'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDownloadDialog(context);
        },
        child: Icon(Icons.download),
      ),
    );
  }

  int getPrice(String productName, String variant) {
    final chocolate = getChocolate(productName);
    if (chocolate != null) {
      final selectedVariant = chocolate.variants.firstWhere(
              (v) => v.name == variant,
          orElse: () => ChocolateVariant(name: '', price: 0));
      return selectedVariant.price;
    }
    return 0;
  }

  Chocolate? getChocolate(String productName) {
    return chocolates.firstWhere((c) => c.name == productName,
        orElse: () => Chocolate(name: '', variants: []));
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invoice Downloaded'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showInvoiceDialog(context);
                },
                child: Text('View Invoice'),
              ),
              SizedBox(height: 10),
              Text('The invoice has been downloaded on your device.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _showInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invoice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: selectedProducts.length,
                itemBuilder: (context, index) {
                  final productName = selectedProducts.keys.elementAt(index);
                  final variants = selectedProducts[productName]!.keys.toList();
                  return Column(
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: variants.map((variant) {
                          final quantity =
                          selectedProducts[productName]![variant]!;
                          final price = getPrice(productName, variant);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(variant),
                              Text('Quantity: $quantity'),
                              Text('Total: ${quantity * price} INR'),
                            ],
                          );
                        }).toList(),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThemeManager extends StatelessWidget {
  final Widget child;

  const ThemeManager({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}