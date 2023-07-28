// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

import '../providers/providers.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({Key? key}) : super(key: key);
  static const String routeName = '/manageCategory';
  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ManageCategoryScreen());
  }

  @override
  State<ManageCategoryScreen> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    bool _isUpdated = Provider.of<Categories>(context).isPatchExist;
    if (_isInit || _isUpdated) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Categories>(context).fetchAndSetCategories().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    Provider.of<Categories>(context, listen: false).setIsPatchExist(false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = Provider.of<Categories>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Manage Category',
        horizontalPaddingValue: 8.0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: categoryData.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return CategoryCard(category: categoryData.categories[index]);
              }),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    Key? key,
  }) : super(key: key);

  final Category category;
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/catalog', arguments: category);
                },
                child: Image.network(category.imageUrl,
                    width: 100, height: 80, fit: BoxFit.contain),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      category.name,
                      style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Status: ${category.status}',
                      style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              onPressed: () async {
                if (category.status == 'active') {
                  await Provider.of<Categories>(context, listen: false)
                      .deleteCategory(token: authData.token, id: category.id);
                } else {
                  await Provider.of<Categories>(context, listen: false)
                      .activateCategory(token: authData.token, id: category.id);
                }
              },
              child: category.status == 'active'
                  ? Text('Remove')
                  : Text('Activate'),
              style: category.status == 'active'
                  ? ElevatedButton.styleFrom(primary: Colors.red.shade500)
                  : ElevatedButton.styleFrom(primary: Colors.green.shade500),
            ),
          )
        ],
      ),
    );
  }
}
