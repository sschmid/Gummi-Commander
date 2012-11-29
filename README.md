Gummi
====
Event Command Mapping System for Objective-C

How to use:
====
See examples.


Set up Gummi
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

GreetingModule
```objective-c

- (void)configure:(JSObjectionInjector *)injector {
    [super configure:injector];

    [self mapEventClass:[GreetingEvent class] toCommandClass:[GreetingCommand class]];
}
```

CommandMap supports:
```objective-c
[commandMap mapEventClass:[MyEvent class] toCommandClass:[MyCommand class]];
[commandMap mapEventClass:[MyEvent class] toCommandClass:[MyOtherCommand class] removeMappingAfterExecution:YES];
[commandMap mapEventClass:[MyEvent class] toCommandClass:[ACommand class] priority: 5];
[commandMap mapEventClass:[MyEvent class] toCommandClass:[AnOtherCommand class] priority: 10 removeMappingAfterExecution:NO];

and more...
```

Commands are short lived objects.
Commands get created and executed when posting an event.
Commands can inject the corresponding event, models and more...
Commands get destroyed immediately after execution.

Gummi uses SDObjection for Dependency Injection.


Use Gummi in your project
===============================

You find the source files you need in Gummi/Classes

Create a Podfile and put it into your root folder of your project
Podfile
```
pod 'Gummi'
```

Setup [CocoaPods], if not done already

```
$ sudo gem install cocoapods
$ pod setup
```

Add this remote
```
$ pod repo add sschmid-cocoapods-specs https://github.com/sschmid/cocoapods-specs
```

Install Gummi
```
$ cd path/to/project
$ pod install
```

[cocoapods]: http://cocoapods.org/
[SDObjection]: https://github.com/sschmid/SDObjection
