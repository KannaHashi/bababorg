import 'package:flutter/material.dart';
import 'package:progress_border/progress_border.dart';

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp>
    with SingleTickerProviderStateMixin {
// animationController
  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );
  // restart method to implement
  // the progress border
  void restart() {
    if (animationController.status == AnimationStatus.forward ||
        animationController.value >= 1) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Border Loader"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(100),
                        shape: BoxShape.circle,
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(100),
                        borderRadius: BorderRadius.circular(16),
                        border: ProgressBorder.all(
                          color: Colors.green,
                          width: 8,
                          progress: animationController.value,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(100),
                        border: ProgressBorder.all(
                          color: Colors.green,
                          width: 8,
                          progress: animationController.value,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(100),
                        border: animationController.value >= 1
                            ? Border.all(
                                color: Colors.green,
                                width: 8,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            // material button to
            // start the animation
            MaterialButton(
              // calling restart method
              onPressed: restart,
              child: Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
