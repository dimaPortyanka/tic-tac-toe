import 'dart:core';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tic_tac_toe/game/utils.dart';

class FieldPainter extends CustomPainter {
  FieldPainter({
    @required this.setField,
    @required this.matrix,
  });

  final Function(Offset, Offset, double) setField;
  final Map<String, Symb> matrix;

  @override
  void paint(Canvas canvas, Size size) {
    final fieldSize = math.min(size.width, size.height);
    final segmentSize = fieldSize/3;
    final x0 = (size.width - fieldSize)/2;
    final y0 = (size.height - fieldSize)/2;

    setField(
      Offset(x0, y0),
      Offset(x0+fieldSize, y0+fieldSize),
      segmentSize
    );

    final strokeBorders = Paint()
      ..color = Colors.black26
      ..strokeWidth = 10.0;

    canvas.drawLine(
      Offset(x0 + segmentSize, y0),
      Offset(x0 + segmentSize, y0 + fieldSize),
      strokeBorders,
    );

    canvas.drawLine(
      Offset(x0 + 2*segmentSize, y0),
      Offset(x0 + 2*segmentSize, y0 + fieldSize),
      strokeBorders,
    );

    canvas.drawLine(
      Offset(x0, y0 + segmentSize),
      Offset(x0+fieldSize, y0 + segmentSize),
      strokeBorders,
    );

    canvas.drawLine(
      Offset(x0, y0 + 2*segmentSize),
      Offset(x0+fieldSize, y0 + 2*segmentSize),
      strokeBorders,
    );

    final crossStroke = Paint()
      ..color = Colors.red
      ..filterQuality = FilterQuality.high
      ..strokeWidth = 5.0;

    final circleStroke = Paint()
      ..color = Colors.blue
      ..filterQuality = FilterQuality.high
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    this.matrix.forEach((key, value) {
      final positions = getPosition(key);
      final xIndex = positions[0];
      final yIndex = positions[1];

      final xPoint = x0+segmentSize*xIndex;
      final yPoint = y0+segmentSize*yIndex;

      if (value == Symb.X) {
        canvas.drawLine(
          Offset(
            xPoint,
            yPoint,
          ),
          Offset(
            xPoint+segmentSize,
            yPoint+segmentSize,
          ),
          crossStroke
        );

        canvas.drawLine(
          Offset(
            xPoint+segmentSize,
            yPoint,
          ),
          Offset(
            xPoint,
            yPoint+segmentSize,
          ),
          crossStroke
        );
      } else {
        canvas.drawCircle(
          Offset(xPoint+segmentSize/2, yPoint+segmentSize/2),
          segmentSize/2-4,
          circleStroke,
        );
      }
    });

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Field extends StatefulWidget {
  final Function(int, int) selectCell;
  final Map<String, Symb> matrix;
  Field({ Key key, @required this.selectCell, @required this.matrix });

  @override
  StateField createState() => StateField();
}

int getSegmentNum(double start, double end, double dx, double segmentSize) {
  if (dx < start) {
    return 0;
  }

  if (dx > end) {
    return 2;
  }

  return (dx - start)~/segmentSize;
}

class StateField extends State<Field> {
  Offset start;
  Offset end;
  double segmentSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
        onPanDown: (details) {
          final dx = details.localPosition.dx;
          final dy = details.localPosition.dy;

          widget.selectCell(
            getSegmentNum(start.dx, end.dx, dx, segmentSize),
            getSegmentNum(start.dy, end.dy, dy, segmentSize),
          );
        },
        child: CustomPaint(
          painter: new FieldPainter(
            matrix: widget.matrix,
            setField: (_start, _end, _segmentSize) {
              start = _start;
              end = _end;
              segmentSize = _segmentSize;
            }
          ),
        ),
      ),
    );
  }
}
