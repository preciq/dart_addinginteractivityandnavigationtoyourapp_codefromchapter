import 'package:addinginteractivityandnavigationtoyourapp_codefromchapter/platform_alert.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class StopWatch extends StatefulWidget {
  //initializing the stopwatch as a stateful widget
  //meaning its state (what it displays) can change

  final String name;
  final String email;
  const StopWatch({super.key, required this.name, required this.email});
  //adding these fields so that they may be passed in when StopWatch is instantiated

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  int milliseconds = 0;
  late Timer timer;
  bool isTicking = false;
  //in stateful widgets, it is customary to put variables that will change as fields
  //below, we will change the value of milliseconds and Timer
  //adding boolean flag to track if timer is still ticking (running)

  final laps = <int>[];
  //save number of laps (number of timer start/stop cycles)

  final itemHeight = 60.0;
  // sets the height (in pixels) of each element in the ListView (called below)
  final scrollController = ScrollController();
  // ScrollController is used in tandem with a scrollable widget
  // we can use it to specify a preset position that we should start at in a scrollable widget (the top, bottom, somewhere in the middle, etc.) (called below)

  /*
  This method is called when a stateful widget is initialized
    So in this case, it is called in the main.dart file when StopWatch is initialized for the home field
      Or any other place where StopWatch is initialized

  It initializes the timer variable (defined as a class level variable above) with a ticker (time measurement unit) of 1 second
   */

  void _onTick(Timer time) {
    if (mounted) {
      setState(() {
        milliseconds += 100;
      });
    }
  }
  /*
  This defines what happens on a tick (which is defined above in the Timer definition)
  A tick has been defined as 1 second above

  So basically, every time a "tick" occurs (1 second passes), we check if mounted is true
    "mounted" means has this widget (StopWatch) been instantiated and is a built in getter for Dart
  
  And if this is true, we call a built in method called "setState"
    This is responsible for changing the state of the widget
    So whatever we put inside of setState is first executed, and then setState forces the widget to be re-rendered with whatever updates we've made inside setState
    This is the crux of the Stateful widget, and how it is able to dynamically re-render when something changes

  In this case, we increase seconds by 1 with every tick
  seconds will most likely be displayed somewhere below; the widget gets redrawn with the incremented seconds with every tick
   */

  //creating the state (changeable parts) of the above StopWatch
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${widget.name}'),
        //prints the name of the logged in user on the stopwatch appbar
      ),
      body: Column(
        children: [
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay()),
          //now we have wrapped both the lap timer stuff and the lap counter display in an expanded widget (so they both take up the same amount of space)
          //we've put both in a column so one is on top of the other
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    //refactored to make organization of code easier
    return Container(
      color: Theme.of(context).primaryColor,
      //adding some coloring to the total column

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Lap: ${laps.length + 1}',
            //display the current lap we are on
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            _secondsText(milliseconds),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          _buildControls()
          /*
          Two buttons added here using ElevatedButton widget, with a sizedBox (width 20) separating them from one another
           */
        ],
      ),
    );
  }

  Widget _buildControls() {
    //extracted into its own method for simplicity
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: isTicking ? null : _startTimer,
          //  ternary operator; if isTicking is true, will do nothing when start button is pressed
          // if it is false, will start the timer
          child: const Text('Start'),
        ),
        const SizedBox(width: 20),

        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellow),
          ),
          onPressed: isTicking ? _lap : null,
          //adds the current time elapsed to the 'lap' list (_lap method is defined below)

          child: const Text('Lap'),
        ),
        const SizedBox(width: 20),
        //Addition of a lap button with appropriate sized boxes between the two other buttons

        Builder(
          builder: (context) {
            /*
            We must wrap the stop button with a Builder
            This is because the stop button has a sheet inside of it, which is pretty far down the tree when you think about the hierarchy
            And a sheet needs a scaffold to correctly render
            To ensure the sheet gets the scaffold it needs, we pass the TextButton inside of a builder
            Which kind of "Connects" the widget more firmly with the tree and lets it find the overarching scaffold
            We must also pass the context to the stopTimer, where the sheet is being generated, so that it gets the scaffold
             */
            return TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: isTicking ? () => _stopTimer(context) : null,
              //  ternary operator; if isTicking is true, will stop the timer when start button is pressed
              // if it is false, will do nothing
              child: const Text('Stop'),
            );
          }
        ),
      ],
    );
  }

  String _secondsText(int milliseconds) {
    final seconds = milliseconds / 1000;
    return '$seconds seconds';
  }

  Widget _buildLapDisplay() {
    return Scrollbar(
      //wrapped with a scrollBar, which...displays a scrollbar next to the scrollable element
      child: ListView.builder(
        controller: scrollController,
        itemExtent: itemHeight,

        itemCount: laps.length,
        //specifies a fixed length for the listview
        //infinite lists are generally not a good idea, performance wise
        //this just says the listview here will be the same length as the laps list

        itemBuilder: (context, index) {
          final milliseconds = laps[index];
          return ListTile(
            //the individual element widgets in a ListView
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            title: Text('Lap ${index + 1}'),
            trailing: Text(_secondsText(milliseconds)),
          );
        },
      ),
    );
  }
  //a more sophisticated version of ListView
  //allows us to do things like format the contents (contentPadding) and show multiple elements
  // and specify how tall each element in the ListView is going to be (itemHeight)
  // and use a scrollController so we always land at a certain starting position in the list

  @override
  void dispose() {
    timer.cancel();
    scrollController.dispose();
    //destroys the scrollController when the timer is disposed; we don't need it if the timer is gone

    super.dispose();
  }
  // this dispose method stops the timer when the application is closed or when this widget is removed from the tree (i.e. if we navigate away from it)
  // saves resources

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), _onTick);
    setState(() {
      milliseconds = 0;
      isTicking = true;

      laps.clear();
      //clears the existing list of laps when start button will be pressed
    });
  }
  //this is called when Start button is clicked
  //when it is pressed, will create a new instance of timer (create a new timer of duration 100 milliseconds for each tick)
  //will also set isTicking boolean to true
  //and set timers value to zero (restarting the timer)

  void _stopTimer(BuildContext context) {
    //connects this method and the sheet generation method within with the scaffold and the larger app
    //i suppose we'll have to do this anytime we use a sheet
    setState(() {
      timer.cancel();
      isTicking = false;
    });
    final controller = showBottomSheet(context: context, builder: _buildRunCompleteSheet);
    /*
    showBottomSheet is a built in method that lets us display...sheets at the bottom
    these are semi-persistent sheets that show temporary information and disappear after a certain amount of time
      inside the builder field, we specify how the contents of the sheet
     */

    Future.delayed(const Duration(seconds: 5)).then((_) {
      controller.close();
    });
    //asynchronously closing the bottom sheet (asynchronously doing so so that it doesn't block any other execution) after 5 seconds
  }
  //this is called when the Stop button is clicked
  //kills the currently running timer and sets isTicking to false

  Widget _buildRunCompleteSheet(BuildContext context) {
    final totalRuntime = laps.fold(milliseconds, (total, lap) => total + lap);
    //calulates the total run time by adding together all the current laps
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
        child: Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Run Finished!', style: textTheme.headlineSmall),
            Text('Total Run Time is ${_secondsText(totalRuntime)}.')
          ])),
    ));
  }
  //all of these should be familiar widgets that basically represent what we will display on the generated bottom sheet

  void _lap() {
    setState(() {
      laps.add(milliseconds);
      milliseconds = 0;
      //resets the timer with every lap, to zero
    });

    scrollController.animateTo(
      itemHeight * laps.length,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    /*
    Every time a lap completes, this uses the scrollController to go all the way to the bottom of the listview the scrollcontroller is attached to (_buildLapDisplay in this case)
    It (the scroll down) is actually an animation, which is why the curve and duration are there
     */
  }
  //will be called when stop is pressed
  //saves the current time in the list create at the top of this class (for display later)

  //as these two both initialize and kill the timer, we do not need an init method anymore
}

/*

 */