# Gummi Commander
![Gummi Commander Logo](http://sschmid.com/Libs/Gummi-Commander/Gummi-Commander-128.png)

## Description
Gummi Commander is an Event Command Mapping System for Objective-C.

## Dependencies
Gummi Commander uses
* [Gummi Injection] (https://github.com/sschmid/Gummi-Injection) for Dependency Injection.
* [Gummi Dispatcher] (https://github.com/sschmid/Gummi-Dispatcher) as a Messaging System.

## Features
* Execute multiple commands by dispatching one event
* Supports nested Async and Sequence Commands
* Add mappings with priority
* Map blocks
* Auto map triggers
* Prevent certain commands to execute by adding Guards
* Inject the corresponding event and other objects of interest into commands

## How to use Gummi Commander
You can get started by simply allocating a commandMap.

The recommended way to use Gummi Commander is to put your configuration logic into `GCGIExtension` and add them to the Injector.
The provided `GummiCommanderModule` should be added first.

```objective-c
GIInjector *injector = [GIInjector sharedInjector];
[injector addModule:[[GummiCommanderModule alloc] init]];

[injector addModule:[[ApplicationExtension alloc] init]];
[injector addModule:[[TrackingExtension alloc] init]];

// Maybe add this extension later in the code,
// right before the game starts
[injector addModule:[[GameExtension alloc] init]];
```

## Commands
* Commands are short lived objects.
* Commands get created and executed when dispatching an event.
* Commands can inject the corresponding event, models and more...
* Commands get destroyed immediately after execution.

```objective-c
@implementation DropBombCommand
inject(@"event", @"model")

- (void)execute {
    self.model.bombs--;
    [self spawnBombAtPosition:self.event.position];
}
...
@end
```

## Async and Sequence Commands

Gummi Commander also supports nested Async and Sequence Commands.

* Sequence
  * Async
    * Command
    * Sequence
      * Async
      * Async
      * Command
    * Command
  * Async
* Async
* Command


With `stopWhenNoSuccess` you can decide, if a Sequence Command should stop or carry on, when any Command did execute without success.

A Sequence Command

```objective-c
@implementation MySequenceCommand

- (id)init {
    self = [super init];
    if (self) {

        self.stopWhenNoSuccess = NO; // Default

        [self addCommand:[MyAsyncCommand class]];
        [self addCommand:[MyCommand class]];
        [self addCommand:[MyOtherSequenceCommand class]];
    }

    return self;
}

@end
```

An Async Command

```objective-c
@implementation MyAsyncCommand

- (void)execute {
    [self performSelector:@selector(doSth) withObject:nil afterDelay:1];
}

- (void) doSth {
    [self didExecuteWithSuccess:YES];
}

@end
```

## The CommandMap
When an instance of MyEvent gets dispatched, all mapped commands get executed

```objective-c
[commandMap mapAction:[MyCommand class] toTrigger:[MyEvent class]];

[commandMap mapAction:[MyOtherCommand class] toTrigger:[MyEvent class]
                           removeMappingAfterExecution:YES];

[commandMap mapAction:[ACommand class] toTrigger:[MyEvent class]
                                        priority: 5];

[commandMap mapAction:[AnOtherCommand class] toTrigger:[MyEvent class]
                                              priority: 10];

// Will automatically map SomeCommand to SomeEvent
// Auto mapped triggers must follow the naming convention XyzEvent
// Commands must follow the naming convention XyzCommand
[commandMap autoMapTrigger:[SomeEvent class]];
```

Instead of commands, you can also map blocks

```objective-c
void (^myBlock)(GIInjector *injector);
myBlock = ^(GIInjector * injector) {
    MyEvent *event = [injector getObject:[MyEvent class]];
    ...
};

[commandMap mapAction:myBlock toTrigger:[FlagAndStringEvent class]];
```

## Guards
* Guards do only one thing: approve.
* Guards decide, whether a command gets executed or not.
* Only when all guards approve, a command gets executed.

```objective-c
@implementation IsInGridGuard
inject(@"event", @"grid")

- (BOOL)approve {
    return [self.grid containsPosition:self.event.position];    
}

@end
```

#### You can add guards like this:

```objective-c
[[commandMap mapAction:[DropBombCommand class]
                toTrigger:[DropBombEvent class]]
             withGuards:@[[IsInGridGuard class]]];
```

## Extensions
Put related configuration logic into extensions and add or remove them at will

```objective-c
@implementation GameExtension

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    // Map commands to events
    [[self mapAction:[DropBombCommand class]
              toTrigger:[DropBombEvent class]]
           withGuards:@[[IsInGridGuard class]]];

    // Set injection rules
    [self mapEagerSingleton:[MyService class] to:@protocol(RemoteService)];
}

- (void)unload {
    Service *service = [_injector getObject:@protocol(RemoteService)];
    [service close];

    // All mappings from the CommandMap and the Injector made
    // in this module get removed automatically.

    [super unload];
}
```

## Install Gummi Commander
You find the source files you need in Gummi-Commander/Classes.

You also need:
* [Gummi Dispatcher] (https://github.com/sschmid/Gummi-Dispatcher) - Observe and dispatch any objects
* [Gummi Injection] (https://github.com/sschmid/Gummi-Injection) - A lightweight dependency injection framework for Objective-C

## CocoaPods
Install [CocoaPods] (http://cocoapods.org) and add the Gummi Commander reference to your Podfile

```
platform :ios, '5.0'
  pod 'Gummi-Commander'
end
```

#### Add this remote

```
$ pod repo add sschmid-cocoapods-specs https://github.com/sschmid/cocoapods-specs
```

#### Install Gummi Commander

```
$ cd path/to/project
$ pod install
```
Open the created Xcode Workspace file.