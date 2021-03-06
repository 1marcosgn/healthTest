//
//  AppDelegate.m
//  healthTest
//
//  Created by Marcos Garcia on 5/6/15.
//  Copyright (c) 2015 marcos. All rights reserved.
//

#import "AppDelegate.h"
#import <HealthKit/HealthKit.h>
#import "mySingleton.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //Check Availability
    if (NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable]) {
        
        
        //Request Authorization
        HKHealthStore *healthStore = [[HKHealthStore alloc]init];
        
        //Share body mass, height and body mass index
        NSSet *shareObjectTypes = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],

                                   //Request authorization to share Sleep Analysis information
                                   [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis],
                                   
                                   nil];
        
        //Read date of birht, biological sex and step count
        NSSet *readObjectTypes = [NSSet setWithObjects:
                                  [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                  [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                  [HKObjectType characteristicTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                  
                                  nil];
        
        
        //Request access
        [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error){
                                           
                                               if (success == YES) {
                                                   //Store 'healthStore' in a Singleton
                                                   mySingleton *Singleton = [mySingleton sharedSinleton];
                                                   Singleton.healthStoreGlobal = healthStore;
                                               }
                                               else{
                                                   //Determine if it was an error or if the
                                                   //user just canceled the authorization request
                                               }
                                           
                                           }
         
         ];
        
    }
    else{
        NSLog(@"HealthKit not available =(...");
    }
    
    
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

@end
