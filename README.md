# stepper_touch
<a href="https://stackoverflow.com/questions/tagged/flutter?sort=votes">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>

 the concept of the widget inspired
 from [Nikolay Kuchkarov](https://dribbble.com/shots/3368130-Stepper-Touch).
 i extended  the functionality to be more useful in real world applications

# Thank _You_!
Please :star: this repo and share it with others

# gif
<img src="https://github.com/Rahiche/stepper_touch/blob/master/doc/steppergif.gif?raw=true" width="300"/>

### Created

* [Raouf Rahiche](https://github.com/Rahiche)
* ([@raoufrahiche](https://twitter.com/raoufrahiche))
* ([Youtube](https://www.youtube.com/channel/UCal0wCIwkxiKcrYPvBS6RiA))

## Usage example

```dart
import 'package:stepper_touch/stepper_touch.dart';
...
Container(
  padding: const EdgeInsets.all(8.0),
  child: StepperTouch(
    initialValue: 0,
    direction: Axis.vertical,
    withSpring: false,
    onChanged: (int value) => print('new value $value'),
  ),
),
...
```

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
