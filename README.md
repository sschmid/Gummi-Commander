## Gummi Commander
![Gummi Commander Logo](http://sschmid.com/Libs/Gummi-Commander/Gummi-Commander-128.png)

Gummi Commander is an Event Command Mapping System for Objective-C.
It uses [Gummi Injection] for Dependency Injection and [Gummi Dispatcher] as a Messaging System.

## Features
* Execute multiple commands by dispatching one event
* Add mappings with priority
* Prevent certain commands to execute, by adding Guards
* Inject the corresponding event and other objects of interest into commands

## Set up Gummi Commander
You can get started by simply allocating a commandMap.

The recommended way to use Gummi Commander is to put your configuration logic into extensions (GCGIExtension) and add them to the Injector.
The provided GummiCommanderModule should be added first.

```objective-c
GIInjector *injector = [GIInjector sharedInjector];
[injector addModule:[[GummiCommanderModule alloc] init]];

[injector addModule:[[ApplicationExtension alloc] init]];

// Maybe add this extension later in the code, right before the game starts
[injector addModule:[[GameExtension alloc] init]];
```

## The CommandMap
When an instance of MyEvent gets dispatched, all mapped commands get executed
```objective-c
[commandMap mapCommand:[MyCommand class] toEvent:[MyEvent class]];
[commandMap mapCommand:[MyOtherCommand class] toEvent:[MyEvent class] removeMappingAfterExecution:YES];
[commandMap mapCommand:[ACommand class] toEvent:[MyEvent class] priority: 5];
[commandMap mapCommand:[AnOtherCommand class] toEvent:[MyEvent class] priority: 10];
```

* Commands are short lived objects.
* Commands get created and executed when dispatching an event.
* Commands can inject the corresponding event, models and more...
* Commands get destroyed immediately after execution.

## Guards
* Guards do only one thing: approve.
* Guards decide, whether a command gets executed or not.
* Only when all guards approve, a command gets executed.

#### You can add guards like this:
```objective-c
[[commandMap mapCommand:[ServerResponseCommand class] toEvent:[ServerResponseEvent class]]
        withGuards:@[[ServerResponseGuard class]]];
```

## Extension
Put related configuration logic into extensions and add and remove them at will
```objective-c
@implementation ServiceExtension

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    // Map commands to events
    [[self mapCommand:[ServerResponseCommand class] toEvent:[ServerResponseEvent class]]
            withGuards:@[[ServerResponseGreater500Guard class]]];

    // Set injection rules
    [self mapEagerSingleton:[Service class] to:[Service class]];
}

- (void)unload {
    Service *service = [_injector getObject:[Service class]];
    [service close];

    // All mappings from the CommandMap and the Injector made in this module
    // get removed automatically.

    [super unload];
}
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
