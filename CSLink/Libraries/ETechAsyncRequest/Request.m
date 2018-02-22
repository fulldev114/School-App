//
//  Request.m
//  HappiJAR
//
//  Created by kETAN on 25/10/13.
//  Copyright (c) 2013 kETAN. All rights reserved.
//

#import "Request.h"
#import "ParentConstant.h"

@implementation Request
@synthesize dictPermValues;

-(id)init {
    
    if([super init]) {
        dictPermValues = [[NSMutableDictionary alloc] init];
//        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
//
//        [dictPermValues setValue:PARA_DEBUG forKey:@"debug"];
//        [dictPermValues setValue:language forKey:@"language"];
//        [dictPermValues setValue:appDelegate.appUser.device forKey:@"device"];
//        [dictPermValues setValue:appDelegate.appUser.os_version forKey:@"os_version"];
//        [dictPermValues setValue:appDelegate.appUser.app_version forKey:@"app_version"];
//        [dictPermValues setValue:PARA_OS_FLAG forKey:@"os"];
        
        if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
            [dictPermValues setValue:@"no" forKey:@"language"];
        }
        else {
            [dictPermValues setValue:[GeneralUtil getUserPreference:key_selLang] forKey:@"language"];
        }
    }
    
    return self;
}

@end
