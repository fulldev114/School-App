//
//  BundleEx.h
//  CSAdmin
//
//  Created by etech-dev on 6/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BundleEx : NSBundle

@end

@interface NSBundle (Language)

+(void)setLanguage:(NSString*)language;

@end