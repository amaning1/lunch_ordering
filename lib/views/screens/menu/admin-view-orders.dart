import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components.dart';
import '../../../constants.dart';
import '../../../models/orders.dart';
import '../../../controllers/providers/food_providers.dart';

class AdminViewOrders extends StatefulWidget {
  const AdminViewOrders({Key? key}) : super(key: key);

  @override
  State<AdminViewOrders> createState() => _AdminViewOrdersState();
}

class _AdminViewOrdersState extends State<AdminViewOrders> {
  late FoodProvider foodVm;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height, width;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final foodProvider = Provider.of<FoodProvider>(context);

    void selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: ordersDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: darkBlue,
                onPrimary: Colors.white,
                onSurface: darkBlue,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: darkBlue, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          ordersDate = picked;
        });
        await Provider.of<FoodProvider>(context, listen: false)
            .getNewOrders(context);
        setState(() {
          OrdersWidget(
              orders: foodProvider.listOrders, height: height, width: width);
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: const NavDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: height * 0.05, left: width * 0.05, right: width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
                SizedBox(
                  width: width,
                  child: Button(
                    text: "${ordersDate.toLocal()}".split(' ')[0],
                    isLoading: false,
                    onPressed: () {
                      selectDate(context);
                    },
                  ),
                ),
                foodProvider.listOrders.isEmpty
                    ? ChefCards(
                        height: height,
                        width: width,
                        number: '0',
                        text: 'Orders',
                        icon: Icons.fastfood)
                    : RefreshIndicator(
                        onRefresh: () async {
                          await foodProvider.getOrders(context);
                          return Future<void>.delayed(const Duration(seconds: 3));
                        },
                        child: OrdersWidget(
                            orders: foodProvider.listOrders,
                            height: height,
                            width: width),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrdersWidget extends StatefulWidget {
  OrdersWidget({
    Key? key,
    required this.orders,
    required this.height,
    required this.width,
  }) : super(key: key);

  final List<Orders>? orders;
  var height;
  var width;

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.orders?.length,
        itemBuilder: (BuildContext context, int index) {
          // var foodCount = orders![index].food.length;
          // var drinkCount = orders![index].drink.length;
          // var commentCount = orders![index].comment?.length;

          return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: widget.width * 0.05,
                    left: widget.width * 0.05,
                    right: widget.width * 0.05,
                    bottom: widget.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            text: widget.orders![index].name! + ' ,',
                            style: KTextStyle1,
                            children: const [
                          TextSpan(text: '  ' 'Name', style: KTextStyle2)
                        ])),
                    SizedBox(height: widget.height * 0.02),
                    RichText(
                        text: TextSpan(
                            text: widget.orders![index].food + ' ,',
                            style: KTextStyle1,
                            children: const [
                          TextSpan(text: '  ' 'Food', style: KTextStyle2)
                        ])),
                    SizedBox(height: widget.height * 0.02),
                    RichText(
                        text: TextSpan(
                            text: widget.orders![index].drink + ' ,',
                            style: KTextStyle1,
                            children: const [
                          TextSpan(text: '  ' 'Drink', style: KTextStyle2)
                        ])),
                    SizedBox(height: widget.height * 0.03),
                    const Text(
                      'Comments',
                      style: KTextStyle2,
                    ),
                    Text(widget.orders![index].comment!, style: KTextStyle4),
                  ],
                ),
              ));
        });
  }
}
