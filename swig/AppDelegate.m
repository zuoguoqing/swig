//
//  AppDelegate.m
//  swig
//
//  Created by Pierre-Marc Airoldi on 2014-08-14.
//  Copyright (c) 2014 PeteAppDesigns. All rights reserved.
//

#import "AppDelegate.h"
#import "Swig.h"

#import "pjsua.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self configureEndpoint];
    
    [self addDIDAccount];
//    [self addSIPAccount];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

#pragma SWIG

-(void)configureEndpoint {
    
    SWTransportConfiguration *tcp = [SWTransportConfiguration configurationWithTransportType:SWTransportTypeTCP];
        SWTransportConfiguration *udp = [SWTransportConfiguration configurationWithTransportType:SWTransportTypeUDP];
    
    SWEndpointConfiguration *endpointConfiguration = [SWEndpointConfiguration configurationWithTransportConfigurations:@[udp,tcp]];
    endpointConfiguration.logConsoleLevel = 0;
    endpointConfiguration.logLevel = 0;
    
    SWEndpoint *endpoint = [SWEndpoint sharedEndpoint];
    
    [endpoint configure:endpointConfiguration completionHandler:^(NSError *error) {
        
        if (error) {
            
            DDLogDebug(@"%@", [error description]);
            
            [endpoint reset:^(NSError *error) {
                if(error) DDLogDebug(@"%@", [error description]);
            }];
        }
    }];
    
    [endpoint setIncomingCallBlock:^(SWAccount *account, SWCall *call) {
        
        DDLogDebug(@"\n\nIncoming Call : %d\n\n", (int)call.callId);

//        [call answer:^(NSError *error) {
//           
//            DDLogDebug(@"%@",[error description]);
//        }];
    }];
    
    [endpoint setAccountStateChangeBlock:^(SWAccount *account) {
        
        DDLogDebug(@"\n\nAccount State : %ld\n\n", (long)account.accountState);
    }];
    
    [endpoint setCallStateChangeBlock:^(SWAccount *account, SWCall *call) {
        
        DDLogDebug(@"\n\nCall State : %ld\n\n", (long)call.callState);
    }];
    
    [endpoint setCallMediaStateChangeBlock:^(SWAccount *account, SWCall *call) {
        
        DDLogDebug(@"\n\nMedia State Changed\n\n");
    }];
}

-(void)addDIDAccount {
    
    SWAccount *account = [SWAccount new];
    
    SWAccountConfiguration *configuration = [SWAccountConfiguration new];
    configuration.username = @"161672_6001";
    configuration.password = @"Asdf6001";
    configuration.domain = @"toronto3.voip.ms";
    
    [account configure:configuration completionHandler:^(NSError *error) {
       
        if (error) {
            DDLogDebug(@"%@", [error description]);
        }
        
        else {
            
            [account connect:^(NSError *error) {
                DDLogDebug(@"%@", [error description]);
                                
                [[SWEndpoint sharedEndpoint] addAccount:account];
            }];
        }
    }];
}

-(void)addSIPAccount {
    
    SWAccount *account = [SWAccount new];
    
    SWAccountConfiguration *configuration = [SWAccountConfiguration new];
    configuration.username = @"getonsip_mobila";
    configuration.password = @"NQFxmwxw4wQMEfp3";
    configuration.domain = @"getonsip.com;transport=tcp";
    configuration.address = [SWAccountConfiguration addressFromUsername:@"mobila" domain:configuration.domain];
    configuration.proxy = @"sip.onsip.com";
    
    [account configure:configuration completionHandler:^(NSError *error) {
        
        if (error) {
            DDLogDebug(@"%@", [error description]);
        }
        
        else {
            
            [account connect:^(NSError *error) {
                if (error) DDLogDebug(@"%@", [error description]);
            }];
        }
    }];
}

//-(void)sipCall {
//
//    SWUserAgent *userAgent = [SWUserAgent sharedInstance];
//
//    SWAccountConfiguration *accountConfiguration = [[SWAccountConfiguration alloc] initWithURI:@"sip:mobila@getonsip.com"];
//
//    NSMutableArray *auth = [accountConfiguration.sipConfig.authCreds mutableCopy];
//
//    SWAuthCredInfo *authInfo = [SWAuthCredInfo new];
//    authInfo.scheme = @"digest";
//    authInfo.realm = @"*";
//    authInfo.username = @"getonsip_mobila";
//    authInfo.data = @"NQFxmwxw4wQMEfp3";
//
//    [auth addObject:authInfo];
//
//    accountConfiguration.sipConfig.authCreds = auth;
//
//    NSMutableArray *proxy = [accountConfiguration.sipConfig.proxies mutableCopy];
//
//    [proxy addObject:@"sip:sip.onsip.com"];
//
//    accountConfiguration.sipConfig.proxies = proxy;
//
//    accountConfiguration.regConfig.registrarUri = @"sip:getonsip.com;transport=tcp";
//
//    SWAccount *account = [[SWAccount alloc] initWithAccountConfiguration:accountConfiguration];
//
//    [userAgent addAccount:account];
//}

@end
