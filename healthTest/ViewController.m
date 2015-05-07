//
//  ViewController.m
//  healthTest
//
//  Created by Marcos Garcia on 5/6/15.
//  Copyright (c) 2015 marcos. All rights reserved.
//

#import "ViewController.h"
#import "mySingleton.h"
#import <HealthKit/HealthKit.h>

@interface ViewController (){
    
    HKHealthStore *healthStore;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    mySingleton *singleton = [mySingleton sharedSinleton];
    
    healthStore = singleton.healthStoreGlobal;
    
    
    //Test methods..
    [self showBiologicalUserSex];
    [self updateUserWeight];
    
    
}

-(void)showBiologicalUserSex{
    
    NSError *error;
    HKBiologicalSexObject *bioSex = [healthStore biologicalSexWithError:&error];
    
    switch (bioSex.biologicalSex) {
        case HKBiologicalSexNotSet:
            NSLog(@"undefined");
            break;
            
        case HKBiologicalSexFemale:
            NSLog(@"female");
            break;
            
        case HKBiologicalSexMale:
            NSLog(@"male");
            break;
            
        default:
            break;
    }
    
}


-(void)updateUserWeight{
    
    //Some weight in gram
    double weightInGram = 83400.f;
    
    // Create an instance of HKQuantityType and
    // HKQuantity to specify the data type and value
    // you want to update...
    
    NSDate *now = [NSDate date];
    HKQuantityType *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantity *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:weightInGram];
    
    //Create the concrete sample
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType
                                                                     quantity:hkQuantity
                                                                    startDate:now
                                                                      endDate:now];
    
    
    //Update the weight in the health store
    [healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error){
        
        NSLog(@"information stored");
    
    }];
    
    
    
}


-(void)createNewSleepAnalysisRegister{
    
    // Create an instance of HKCategoryType
    // to specify the data type that it's going to be updated
    HKCategoryType *hkCategoryType = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [self getEndDate];
    
    // The value has to be selected between two options 'HKCategoryValueSleepAnalysisAsleep' or 'HKCategoryValueSleepAnalysisInBed'
    // HealthKit uses two or more samples with overlapping times.
    HKCategorySample *sleepSample = [HKCategorySample categorySampleWithType:hkCategoryType
                                                                       value:HKCategoryValueSleepAnalysisAsleep
                                                                   startDate:startDate
                                                                     endDate:endDate];

    //Update the sleep activity in the health store
    [healthStore saveObject:sleepSample withCompletion:^(BOOL success, NSError *error){
    
        NSLog(@"Sleep activity stored");
    
    }];
    
    
}

-(NSDate*)getEndDate{
    
    NSDate *currentDate = [NSDate date];
    NSDate *datePlus = [currentDate dateByAddingTimeInterval:60];
    return datePlus;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addSleep:(id)sender {
    
    [self createNewSleepAnalysisRegister];
    
}


@end
