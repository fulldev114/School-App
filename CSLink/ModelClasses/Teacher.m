//
//  Teacher.m
//  CSLink
//
//  Created by etech-dev on 6/27/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if ([NSUserDefaults emptyMessagesSetting]) {
            self.messages = [NSMutableArray new];
        }
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
//        JSQMessagesAvatarImage *jsqImage = [avatarFactory avatarImageWithUserInitials:@"JSQ"
//                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
//                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
//                                                                                 font:[UIFont systemFontOfSize:14.0f]];
//        
//        JSQMessagesAvatarImage *cookImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]];
//        
//        JSQMessagesAvatarImage *jobsImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]];
//        
//        JSQMessagesAvatarImage *wozImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_woz"]];
//        
//        self.avatars = @{ kJSQDemoAvatarIdSquires : jsqImage,
//                          kJSQDemoAvatarIdCook : cookImage,
//                          kJSQDemoAvatarIdJobs : jobsImage,
//                          kJSQDemoAvatarIdWoz : wozImage };
//        
//        
//        self.users = @{ kJSQDemoAvatarIdJobs : kJSQDemoAvatarDisplayNameJobs,
//                        kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
//                        kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
//                        kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires };
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

@end
