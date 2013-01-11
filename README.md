## Gummi Commander
![Gummi Commander Logo](http://sschmid.com/Libs/Gummi-Commander/Gummi-Commander-128.png)

Gummi Commander is a Command Event Mapping System for Objective-C.
It uses [Gummi Injection] for Dependency Injection and [Gummi Dispatcher] as a Messaging System.

## Set up Gummi

You can get started by simply allocating a commandMap.

To get the 'best experience' you may want to put your logic into different modules and add them to the Injector.
There is GummiCommanderModule provided, that sets up some basic mappings for you to get started.

```objective-c
GIInjector *injector = [GIInjector sharedInjector];
[injector addModule:[[GummiCommanderModule alloc] init]];
```

## CommandMap:

When an instance of MyEvent gets dispatched, all mapped commands get executed
```objective-c
[commandMap mapCommand:[MyCommand class] toEvent:[MyEvent class]];
[commandMap mapCommand:[MyOtherCommand class] toEvent:[MyEvent class] removeMappingAfterExecution:YES];
[commandMap mapCommand:[ACommand class] toEvent:[MyEvent class] priority: 5];
[commandMap mapCommand:[AnOtherCommand class] toEvent:[MyEvent class] priority: 10 removeMappingAfterExecution:NO];
```

* Commands are short lived objects.
* Commands get created and executed when dispatching an event.
* Commands can inject the corresponding event, models and more...
* Commands get destroyed immediately after execution.


## Guards

* Guards do only one thing: approve.
* Guards decide, whether a command gets executed or not.
* Only when all guards approve, a command gets executed.

#### You can add guards to command-event-mappings like this:

```objective-c
// Like so
[[commandMap mapCommand:[ServerResponseCommand class] toEvent:[ServerResponseEvent class]]
        withGuards:[NSArray arrayWithObject:[ServerResponseGuard class]]];


// Same
GCMapping *mapping = [commandMap mapCommand:[ServerResponseCommand class] toEvent:[ServerResponseEvent class]];
[mapping withGuards:[NSArray arrayWithObject:[ServerResponseGuard class]]];

// Get mapping
GCMapping *mapping = [commandMap mappingForCommand:[ServerResponseCommand class] event:[ServerResponseEvent class]];
[mapping withGuards:[NSArray arrayWithObject:[ServerResponseGuard class]]];
```

## Use Gummi Commander in your project

You find the source files you need in Gummi-Commander/Classes

#### Dependencies
Gummi Commander uses [Gummi Injection] for Dependency Injection and [Gummi Dispatcher] as a Messaging System.

## CocoaPods
Create a Podfile and put it into your root folder of your project

#### Edit your Podfile
```
platform :ios, '5.0'

pod 'Gummi-Commander'
```

#### Setup [CocoaPods], if not done already

```
$ sudo gem install cocoapods
$ pod setup
```

#### Add this remote
```
$ pod repo add sschmid-cocoapods-specs https://github.com/sschmid/cocoapods-specs
```

#### Install Gummi
```
$ cd path/to/project
$ pod install
```

## Other projects using Gummi Commander

If you enjoy using Gummi Commander in your projects let me know, and I'll mention your projects here.

[cocoapods]: http://cocoapods.org/
[Gummi Injection]: https://github.com/sschmid/Gummi-Injection/
[Gummi Dispatcher]: https://github.com/sschmid/Gummi-Dispatcher/
