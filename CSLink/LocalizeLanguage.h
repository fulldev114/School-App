//
//  LocalizeLanguage.h
//  Onjyb
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizeLanguage : NSObject

+(void)setLocalizeLanguage:(NSString *)lang;
+(NSString *)get:(NSString *)key alter:(NSString *)alternate;

@end

