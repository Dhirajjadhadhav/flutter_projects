import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget{
    @override
    Widget build(BuildContext context){
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DrawingBoard(),
      );
    }
}


class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint?>drawingpoints = [];
  List<Color>colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details){
              setState(() {
                  drawingpoints.add(
                    DrawingPoint(
                      details.localPosition, Paint()..color = selectedColor 
                      ..isAntiAlias = true
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),
                );
              });
            },
            onPanUpdate: (details){
              setState(() {
                    drawingpoints.add(
                      DrawingPoint(
                        details.localPosition, Paint()..color = selectedColor 
                        ..isAntiAlias = true
                        ..strokeWidth = strokeWidth
                        ..strokeCap = StrokeCap.round,
                  ),
                );
              });
            },
            onPanEnd: (details){
              setState(() {
                  drawingpoints.add(null);
              });
            },
              child: CustomPaint(
                painter: _DrawingPainter(drawingpoints),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width:MediaQuery.of(context).size.width ,
              ),
              ),
          ),
          Positioned(
            top:40,
            right: 30,
            child: Row(
              children: [
                Slider(
                  min : 0,
                  max:40,
                  value: strokeWidth, onChanged: (val)=>
                  setState(() =>strokeWidth = val),
                ),
                ElevatedButton.icon(onPressed: ()=>setState(()=>drawingpoints = []), 
                  icon: Icon(Icons.clear), 
                  label:Text("Clear Board")),
              ],
            ),
           ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: 
             List.generate(colors.length, (index) =>  _builColorChose(colors[index])),
          ),
        ),
      ),
    );
  }

Widget _builColorChose(Color color) {
    
    bool isSelected = selectedColor == color;

    return GestureDetector(
      onTap: ()=>setState(()=>selectedColor = color),
  
      child: Container(
                height: isSelected? 47 : 40,
                width: isSelected? 47 : 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected? Border.all(
                    color: Colors.white,
                    width: 3
                  ):
                  null,
                ),
              ),
    );
  }
}


class _DrawingPainter extends CustomPainter{
 final List<DrawingPoint?> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset>offsetList = [];
  @override
  void paint(Canvas canvas, Size size) {
    for(int i = 0; i<drawingPoints.length; ++i){
      if(drawingPoints[i]!= null){
        log("${i} offset x = ${drawingPoints[i]!.offset.dx}\n");
        log("offset y = ${drawingPoints[i]!.offset.dy}\n");

      }
      if(drawingPoints[i]!=null && drawingPoints[i+1] != null){
        canvas.drawLine(drawingPoints[i]!.offset,drawingPoints[i+1]!.offset, drawingPoints[i]!.paint);
      }else if(drawingPoints[i]!=null && drawingPoints[i+1] == null){
        offsetList.clear();

        offsetList.add(drawingPoints[i]!.offset);

        canvas.drawPoints(PointMode.points, offsetList, drawingPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;

}

class DrawingPoint{
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}