library rating_dialog;

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewDialog extends StatefulWidget {
  /// The dialog's title
  final Text title;

  /// The dialog's message/description text
  final Text? message;

  /// The top image used for the dialog to be displayed
  final Widget? image;

  /// The rating bar (star icon & glow) color
  final Color starColor;

  /// The size of the star
  final double starSize;

  /// Disables the cancel button and forces the user to leave a rating
  final bool force;

  /// Show or hide the close button
  final bool showCloseButton;

  /// The initial rating of the rating bar
  final double rating;

  /// Display comment input area
  final bool enableComment;

  /// The comment's TextField hint text
  final String commentHint;

  /// The submit button's label/text
  final String approveButtonText;
  final String disapproveButtonText;

  /// The submit button's label/text
  final TextStyle submitButtonTextStyle;

  /// Returns a RatingDialogResponse with user's rating and comment values
  final Function() onApproved;
  final Function() onDisapproved;

  /// called when user cancels/closes the dialog
  final Function? onCancelled;

  const ReviewDialog({
    required this.title,
    this.message,
    this.image,
    required this.approveButtonText,
    required this.disapproveButtonText,
    this.submitButtonTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
    required this.onApproved,
    required this.onDisapproved,
    this.starColor = Colors.amber,
    this.starSize = 40.0,
    this.onCancelled,
    this.showCloseButton = true,
    this.force = false,
    this.rating = 0,
    this.enableComment = true,
    this.commentHint = 'Tell us your comments',
  });

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _content = Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                widget.image != null
                    ? Padding(
                        child: widget.image,
                        padding: const EdgeInsets.only(top: 25, bottom: 25),
                      )
                    : Container(),
                widget.title,
                const SizedBox(height: 15),
                widget.message ?? Container(),
                const SizedBox(height: 10),
                Center(
                  child: RatingBarIndicator(
                    rating: widget.rating,
                    itemSize: widget.starSize,
                    direction: Axis.horizontal,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: widget.starColor,
                    ),
                  ),
                ),
                widget.enableComment
                    ? TextField(
                        controller: _commentController,
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: widget.commentHint,
                        ),
                      )
                    : const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(
                        widget.approveButtonText,
                        style: widget.submitButtonTextStyle,
                      ),
                      onPressed: () {
                        if (!widget.force) Navigator.pop(context);
                        widget.onApproved.call();
                      },
                    ),
                    TextButton(
                      child: Text(
                        widget.disapproveButtonText,
                        style: widget.submitButtonTextStyle,
                      ),
                      onPressed: () {
                        if (!widget.force) Navigator.pop(context);
                        widget.onDisapproved.call();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!widget.force &&
            widget.onCancelled != null &&
            widget.showCloseButton) ...[
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              Navigator.pop(context);
              widget.onCancelled!.call();
            },
          )
        ]
      ],
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: _content,
    );
  }
}
