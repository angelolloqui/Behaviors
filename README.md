iOS Behaviors 
======
[![Swift](https://img.shields.io/badge/swift-2.3-green.svg?style=flat)](https://developer.apple.com/swift/)
[![Build Status](https://travis-ci.org/angelolloqui/Behaviors.svg?branch=develop)](https://travis-ci.org/angelolloqui/Behaviors.svg?branch=develop)


This Swift library contains a set of usefulf behaviors implemented to simplify your iOS projects. The concept behind this approach is explored in [objc.ios Issue 13](http://www.objc.io/issue-13/behaviors.html).


Why use Behaviors?
---------------

Check out the [objc.io issue 13](http://www.objc.io/issue-13/behaviors.html) for extra details, but basically Behaviors allow you to write better code by pushing to the maximum extent concepts like Composition and Single Responsibility Principle. By using Behaviors, you can compose your views with multiple small objects from your InterfaceBuilder and dramatically reduce the amount of lines in your `UIViewController`. 
The resulting code is more reusable and testable.


List of behaviours
---------------

This is the list of current and posible future behaviors that will be implemented.

- Animations
	- [x] Hide navigation/tabbar on scroll: `NavigationHideScrollBehavior`
	- [ ] Background Parallax: TODO
	- [ ] Scroll View Parallax: TODO
	- [ ] Table row appear animation: TODO
	- [ ] Shake: TODO
 	- [ ] Pull to expand view: TODO	
	
- Forms
	- [x] Autoscrolling on textfield focus: `TextFieldScrollBehavior`
	- [x] Focus on next control: `TextFieldResponderBehavior`
	- [x] Move view on top of keyboard: `ViewPositionKeyboardBehavior`
	- [x] Regex validator: `TextFieldRegexValidatorBehavior`
	- [x] Email validator: `TextFieldEmailValidatorBehavior`
	- [x] Phone validator: `TextFieldPhoneValidatorBehavior`
	- [x] Credit card validator: `TextFieldCreditCardValidatorBehavior`
	- [ ] Button enabler: TODO
	- [ ] Textfield effects (selected, required, error...): TODO

- Others
	- [x] Scroll offset listener: `ScrollingTriggerBehavior`
	- [x] Keyboard lister: `KeyboardTriggerBehavior`
	- [ ] Delegate multiplexor: TODO
	- [ ] Autolayout view visibility gone: TODO
	
	

License
-------

Made available under the MIT License.


Collaboration
-------------

Forks, patches and other feedback are always welcome.


Credits
-------

Behaviors is brought to you by [Angel Garcia Olloqui](http://angelolloqui.com). You can contact me on:

Project Page: [Behaviors](https://github.com/angelolloqui/Behaviors)

Personal webpage: [angelolloqui.com](http://angelolloqui.com)

Twitter: [@angelolloqui](http://twitter.com/angelolloqui)

LinkedIn: [angelolloqui](http://www.linkedin.com/in/angelolloqui)


