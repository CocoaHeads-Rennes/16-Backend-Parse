//
//  CHAppDelegate.m
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHAppDelegate.h"

@implementation CHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Ici, on fait l'init du SDK parse
    // Il s'agit de lui transmettre les clefs d'API
    // Et lui signifier le lancement de l'application
    
    [Parse setApplicationId:@"itm22LzOBrrbpO8YbUgiWJ8z68ScDgAumdTgtegj"
                  clientKey:@"OasPclBWYZxlMDuXtODUNYZ42uAVlVn82u8p0fX3"];
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
	return YES;
}

@end
