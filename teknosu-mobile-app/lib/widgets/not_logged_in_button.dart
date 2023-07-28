import 'package:flutter/material.dart';

class NotLoggedInButton extends StatelessWidget {
  const NotLoggedInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You are not logged in!",
            style: Theme.of(context).textTheme.headline2,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'Log In',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
