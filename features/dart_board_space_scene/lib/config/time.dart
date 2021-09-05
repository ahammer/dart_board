/// This method serves as a proxy for DateTime.now();
/// It is used to inject a specific time into the clock to allow
/// us to instrument it for testing
DateTime get spaceClockTime => DateTime.now();

//Fixed timee
//DateTime get spaceClockTime => DateTime.utc(2000,1,1,0,0,0);
//DateTime get spaceClockTime => DateTime.utc(2000,1,1,3,15,15);
//DateTime get spaceClockTime => DateTime.utc(2000,1,1,6,30,30);
//DateTime get spaceClockTime => DateTime.utc(2000,1,1,9,45,45);


//Eclipses
//DateTime get spaceClockTime => DateTime.utc(2000,1,1,0,0,0);
//DateTime get spaceClockTime => DateTime.utc(2000,1,1,3,16,15);
//DateTime get spaceClockTime => DateTime.utc(2000,1,1,6,32,45);
//DateTime get spaceClockTime => DateTime.utc(2000,1,1,9,49,05);


// Or just want to see it really fast
// DateTime get spaceClockTime => DateTime.fromMillisecondsSinceEpoch(
//   DateTime.now().millisecondsSinceEpoch * 30);
