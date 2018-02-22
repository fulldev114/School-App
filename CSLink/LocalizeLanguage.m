//
//  LocalizeLanguage.m
//  CSLink
//
//  Created by etech-dev on 8/2/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "LocalizeLanguage.h"

@implementation LocalizeLanguage

static NSBundle *bundle = nil;

+(void)initialize {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *current = [languages objectAtIndex:0];
    [self setLocalizeLanguage:current];
}

+(void)setLocalizeLanguage:(NSString *)lang {
    NSLog(@"LocalizeLanguage > preferredLang: %@", lang);
    NSString *path = [[ NSBundle mainBundle ] pathForResource:lang ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
}

+(NSString *)get:(NSString *)key alter:(NSString *)alternate {
    return [bundle localizedStringForKey:key value:alternate table:nil];
}

@end
