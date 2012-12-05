## Gummi

Gummi is an Event Command Mapping System for Objective-C.
It uses [SDObjection] for Dependency Injection.

## How to use:

See examples:
* Greetings
* Service

## Set up Gummi

```objective-c
// Init Gummi
JSObjectionInjector *injector = [JSObjection createInjector];
[JSObjection setDefaultInjector:injector];
[injector addModule:[[GummiModule alloc] init]];

// Plug in example
[injector addModule:[[GreetingsModule alloc] init]];

// Logs greeting
[GreetingEvent greet:@"Hello World!"];

// Does not greet anymore
[injector removeModuleClass:[GreetingsModule class]];
[GreetingEvent greet:@"No one hears me :("];
```

#### GreetingModule

```objective-c

- (void)configure {
    [super configure];

    [self mapEventClass:[GreetingEvent class] toCommandClass:[GreetingCommand class]];
    
    // Mappings get automatically unmapped, when module gets removed.
}
```

#### CommandMap supports:

```objective-c
[commandMap mapEventClass:[MyEvent class] toCommandClass:[MyCommand class]];
[commandMap mapEventClass:[MyEvent class] toCommandClass:[MyOtherCommand class] removeMappingAfterExecution:YES];
[commandMap mapEventClass:[MyEvent class] toCommandClass:[ACommand class] priority: 5];
[commandMap mapEventClass:[MyEvent class] toCommandClass:[AnOtherCommand class] priority: 10 removeMappingAfterExecution:NO];

and more...
```

* Commands are short lived objects.
* Commands get created and executed when posting an event.
* Commands can inject the corresponding event, models and more...
* Commands get destroyed immediately after execution.


## Guards

* Guards do only one thing: approve.
* Guards decide, whether a command gets executed or not.
* Only when all guards approve, a command gets executed.

#### You can add guards to event-command-mappings like this:

```objective-c
// Like so
[[commandMap mapEventClass:[ServerResponseEvent class] toCommandClass:[ServerResponseCommand class]]
	withGuards:[NSArray arrayWithObject:[ServerResponseGuard class]]];


// Same
SDEventCommandMapping *mapping = [commandMap mapEventClass:[ServerResponseEvent class] toCommandClass:[ServerResponseCommand class]];
[mapping withGuards:[NSArray arrayWithObject:[ServerResponseGuard class]]];

// Get mapping
SDEventCommandMapping *mapping = [commandMap mappingForEventClass:[ServerResponseEvent class] commandClass:[ServerResponseCommand class]];
[mapping withGuards:[NSArray arrayWithObject:[ServerResponseGuard class]]];
```

## Use Gummi in your project

You find the source files you need in Gummi/Classes

Create a Podfile and put it into your root folder of your project

#### Edit your Podfile
```
platform :ios, '5.0'

pod 'Gummi'
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

[cocoapods]: http://cocoapods.org/
[SDObjection]: https://github.com/sschmid/SDObjection
