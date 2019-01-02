#include <dlfcn.h>
#include <objc/message.h>

%ctor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/io.atoi.tweak.revealinjector.plist"];
    NSString *enableKey = [NSString stringWithFormat:@"RevealEnabled-%@", [[NSBundle mainBundle] bundleIdentifier]];
    NSString *libraryPath = @"/usr/lib/TweakInject/RevealServer.framework/RevealServer";

    do {
        if (![[prefs objectForKey:enableKey] boolValue]) { break; }
        if (![[NSFileManager defaultManager] fileExistsAtPath:libraryPath]){ 
            NSLog(@"<RevealInjector> Library not found: %@", libraryPath);
            break; 
        }

        void *handle = dlopen([libraryPath UTF8String], RTLD_NOW);
        if (handle == NULL) {
            NSLog(@"Reveal Injector dlopen error: %s", dlerror());
            break;
        }
//        Class clazz = objc_getClass("IBARevealLoader");
//        if (clazz == nil) { 
//            NSLog(@"<RevealInjector> class IBARevealLoader not found");
//            break; 
//        }
//        Class metaClass = object_getClass(clazz);
//        if (metaClass == nil) { 
//            NSLog(@"<RevealInjector> metaClass of IBARevealLoader not found");
//            break; 
//        }
//        SEL selector = sel_registerName("startServer");
//        if (!class_respondsToSelector(metaClass, selector)) { 
//            NSLog(@"<RevealInjector> selector startServer not found");
//            break; 
//        }
//        void(*startServer)(id, SEL) = (__typeof(startServer))objc_msgSend;
//        startServer(clazz, selector);
        
        NSLog(@"<RevealInjector> dylib load: %@", libraryPath);
    } while (false);

    [pool drain];
}

