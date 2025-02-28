import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../auth/data/model/user_hive_model.dart';
import '../../../../app/constant/api_config.dart';
import '../../../product/presentation/view_model/bloc/shopping_bloc.dart';
import '../../../product/presentation/view_model/bloc/shopping_state.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
enum PaymentMethod {
  stripe('Stripe (Card Payment)'),
  cod('Cash on Delivery');

  final String displayName;

  const PaymentMethod(this.displayName);
}
class CheckoutPage extends StatefulWidget {
  final double totalAmount;

  CheckoutPage({required this.totalAmount});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _phoneNoController = TextEditingController();
PaymentMethod _selectedPaymentMethod = PaymentMethod.stripe;
  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pinCodeController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

 Future<void> _proceedToPayment(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authBox = Hive.box<UserHiveModel>('authBox');
      final userHiveModel = authBox.get('currentUser');
      final token = userHiveModel?.token;

      if (token == null) {
        Fluttertoast.showToast(
          msg: "Please log in to proceed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // Get cart items from ShoppingBloc state
      final state = context.read<ShoppingBloc>().state;
      if (state is ShoppingLoaded) {
        final orderItems = state.cart.map((item) => {
              'name': item.name,
              'price': item.price,
              'quantity': 1, // Assuming 1 for simplicity; extend if needed
              'image': item.imageUrl,
              'product': item.id,
            }).toList();

        // Calculate prices
        final itemsPrice = widget.totalAmount; // Sum of cart items' prices
        const taxPrice = 5.0; // Example fixed tax; adjust as needed
        const shippingPrice = 10.0; // Example fixed shipping; adjust as needed
        final totalPrice = itemsPrice + taxPrice + shippingPrice;

        // Shipping Info
        final shippingInfo = {
          'address': _addressController.text,
          'city': _cityController.text.isEmpty ? null : _cityController.text,
          'state': _stateController.text,
          'country': _countryController.text,
          'pinCode': _pinCodeController.text.isEmpty ? null : _pinCodeController.text,
          'phoneNo': int.tryParse(_phoneNoController.text) ?? 0,
        };

        // Payment Info (placeholder, adjust based on your payment system)
        final paymentInfo = {
          'id': 'payment_${DateTime.now().millisecondsSinceEpoch}', // Dummy ID
          'status': 'Pending', // Example status
        };

        // Prepare request body
        final orderData = {
          'shippingInfo': shippingInfo,
          'orderItems': orderItems,
          'paymentInfo': paymentInfo,
          'itemsPrice': itemsPrice,
          'taxPrice': taxPrice,
          'shippingPrice': shippingPrice,
          'totalPrice': totalPrice,
        };
log("auth Bearer $token}");
if (_selectedPaymentMethod == PaymentMethod.stripe) {
            // Stripe payment flow
            final clientSecret = "";
            if (clientSecret == null) throw Exception('No client secret returned');

            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: clientSecret,
                merchantDisplayName: 'Your Shop Name',
              ),
            );

            await Stripe.instance.presentPaymentSheet();
            orderData['paymentInfo'] = 'Completed'; // Update status on success
          } else {
            // COD: No payment sheet needed
            Fluttertoast.showToast(
              msg: "Order placed as Cash on Delivery!",
              backgroundColor: Colors.orange,
            );
          }
        try {
          final response = await http.post(
            Uri.parse('${ApiConfig.baseUrl}/order/new'),
            headers: {
              'Content-Type': 'application/json',
              'Cookie': 'token=$token',
            },
            body: json.encode(orderData),
          );
log("message ${json.decode(response.body)}");
          if (response.statusCode == 201) {
            Fluttertoast.showToast(
              msg: "Order placed successfully! Total: \$${totalPrice.toStringAsFixed(2)}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pop(context); // Return to CartPage
          } else {
            Fluttertoast.showToast(
              msg: "Failed to place order: ${response.statusCode}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } catch (e) {
          Fluttertoast.showToast(
            msg: "Error placing order: $e",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Cart not loaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Shipping Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your state';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your country';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _pinCodeController,
                      decoration: InputDecoration(
                        labelText: 'Pin Code (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneNoController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ListTile(
                title: Text('Stripe (Card Payment)'),
                leading: Radio<PaymentMethod>(
                  value: PaymentMethod.stripe,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Cash on Delivery'),
                leading: Radio<PaymentMethod>(
                  value: PaymentMethod.cod,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
               onPressed: () => _proceedToPayment(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}