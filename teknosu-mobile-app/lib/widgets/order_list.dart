// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '_widgets.dart';

class OrderList extends StatefulWidget {
  const OrderList({
    Key? key,
    required this.orderList,
  }) : super(key: key);

  final List<Order> orderList;

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  String newStatus = "Processing";
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.orderList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ExpansionTile(
            leading: Icon(
              Icons.reviews,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              '${widget.orderList[index].createdAt.month}.${widget.orderList[index].createdAt.day}.${widget.orderList[index].createdAt.year} (${widget.orderList[index].status})',
              style: Theme.of(context).textTheme.headline3,
            ),
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    OrderInfoCard(
                      order: widget.orderList[index],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.orderList[index].products.length,
                      itemBuilder: (context2, index2) {
                        return OrderProductCard(
                          orderDate: widget.orderList[index].createdAt,
                          orderProduct:
                              widget.orderList[index].products[index2],
                          status: widget.orderList[index].status,
                          role: 'ProductManager',
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New status: ',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        OrderActionMenu(
                            onChanged: (value) {
                              setState(() {
                                newStatus =
                                    value ?? widget.orderList[index].status;
                              });
                            },
                            value: newStatus),
                        ElevatedButton(
                          onPressed: () async {
                            if (newStatus != "" &&
                                newStatus != widget.orderList[index].status) {
                              await Provider.of<Orders>(context, listen: false)
                                  .changeOrderStatusById(
                                      token: authData.token,
                                      orderId: widget.orderList[index].id,
                                      newStatus: newStatus);
                            }
                          },
                          child: Text('Save'),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
