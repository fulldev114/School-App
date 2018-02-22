//
//  Response.h
//  HappiJAR
//
//  Created by kETAN on 25/10/13.
//  Copyright (c) 2013 kETAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject {
    NSMutableDictionary *dictPermValues;
    id jsonData;
}

@property (nonatomic, strong) NSMutableDictionary *dictPermValues;
@property (nonatomic, strong) id jsonData;
@end
