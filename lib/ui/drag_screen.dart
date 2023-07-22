import 'package:flutter/material.dart';

import '../model/direction_model.dart';


class DraggableProfile extends StatefulWidget {
  final String photoUrl;
  final Function(Direction) onSwipe;

  const DraggableProfile({required Key key, required this.photoUrl, required this.onSwipe})
      : super(key: key);

  @override
  _DraggableProfileState createState() => _DraggableProfileState();
}

class _DraggableProfileState extends State<DraggableProfile> {
  double _cardOffsetX = 0.0;
  double _cardOffsetY = 0.0;
  double _dragThreshold = 100.0;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _cardOffsetX += details.delta.dx;
      _cardOffsetY += details.delta.dy;
    });
  }


  void _handleDragEnd(DragEndDetails details) {
    if (_cardOffsetY.abs() > _dragThreshold) {
      if (_cardOffsetY > 0) {
        widget.onSwipe(Direction.down);
        // Reset the card position when swiped down
        setState(() {
          _cardOffsetX = 0.0;
          _cardOffsetY = 0.0;
        });
      } else {
        widget.onSwipe(Direction.up);
      }
    } else if (_cardOffsetX.abs() > _dragThreshold) {
      if (_cardOffsetX > 0) {
        widget.onSwipe(Direction.right);
      } else {
        widget.onSwipe(Direction.left);
      }
      // Reset the card position after swiping left or right
      setState(() {
        _cardOffsetX = 0.0;
        _cardOffsetY = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onPanUpdate: _handleDragUpdate,
        onPanEnd: _handleDragEnd,
        child: Transform.translate(
          offset: Offset(_cardOffsetX, _cardOffsetY),
          child: Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.photoUrl,
                  fit: BoxFit.cover,
                  height: 400, // Adjust the height as needed
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}