//
//  User.h
//  Paytime2
//
//  Created by eTech Developer 8 on 01/01/16.
//  Copyright © 2016 etechmavens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentETechAsyncRequest.h"
//#import "ASINetworkQueue.h"
#import "Response.h"
#import "GeneralUtil.h"

typedef void (^RequestComplitionBlock)(NSObject *resObj);

@interface ParentUser : NSObject {
}

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *persentNo;

@property (nonatomic, retain) NSString *persen1Name;
@property (nonatomic, retain) NSString *persen1Phone;
@property (nonatomic, retain) NSString *persen1Email;
@property (nonatomic, retain) NSString *persen2Name;
@property (nonatomic, retain) NSString *persen2Phone;
@property (nonatomic, retain) NSString *persen2Email;
@property (nonatomic, retain) NSString *persen3Name;
@property (nonatomic, retain) NSString *persen3Phone;
@property (nonatomic, retain) NSString *persen3Email;

@property (nonatomic, retain) NSString *verifyCode;
@property (nonatomic, retain) NSString *persentPin;
@property (nonatomic, retain) UIImageView *profileImg;

-(void)login:(RequestComplitionBlock) reqBlock;
-(void)registerPerent:(RequestComplitionBlock) reqBlock;
-(void)verifyCode:(RequestComplitionBlock) reqBlock;
-(void)registerDevice:(RequestComplitionBlock) reqBlock;
-(void)verifyPin:(NSString *)pincode :(RequestComplitionBlock) reqBlock;
-(void)forgotPin:(NSString *)phone andParentNo:(NSString *)no :(RequestComplitionBlock) reqBlock;
-(void)getSchoolList:(RequestComplitionBlock) reqBlock;
-(void)getStudantList:(NSString *)schId graId:(NSString *)gid classId:(NSString *)cId :(RequestComplitionBlock) reqBlock;

-(void)getUserProfile:(NSString *)userId :(RequestComplitionBlock)reqBlock;
-(void)updateUserProfile:(NSString *)sId userName:(NSString *)uname :(RequestComplitionBlock)reqBlock;
-(void)getSelectedStudList:(NSString *)parentId :(RequestComplitionBlock) reqBlock;
-(void)addStudant:(NSString *)parentId studantId:(NSString *)sId :(RequestComplitionBlock) reqBlock;

-(void)getTeacherList:(NSString *)classId userid:(NSString *)userId :(RequestComplitionBlock)reqBlock;

-(void)getPerentList:(NSString *)userId :(RequestComplitionBlock) reqBlock;
-(void)getPeriodsAndResone:(NSString *)userId currDate:(NSString *)currdate :(RequestComplitionBlock) reqBlock;

-(void)sendAbsent:(NSString *)userId periodIds:(NSString *)periodeIds resone:(NSString *)resone date:(NSString *)date :(RequestComplitionBlock) reqBlock;

-(void)getAbsentNoticeList:(NSString *)userId isAbFlag:(NSString *)isAb :(RequestComplitionBlock) reqBlock;

-(void)changePincode:(NSString *)parentNo phoneNo:(NSString *)phoneno oldPin:(NSString *)oldpin newPin:(NSString *)newpin :(RequestComplitionBlock) reqBlock;

-(void)sendFeedback:(NSString *)name email:(NSString *)email message:(NSString *)message :(RequestComplitionBlock) reqBlock;

-(void)getStudStatistics:(NSString *)userId startDate:(NSString *)startdate endDate:(NSString *)endate :(RequestComplitionBlock) reqBlock;
-(void)uploadPdf:(NSString *)userId pdfFile:(NSString *)pdf :(RequestComplitionBlock)reqBlock;
-(void)getSemseterAndSubj:(NSString *)classId schoolId:(NSString *)schoolId userId:(NSString *)userId :(RequestComplitionBlock) reqBlock;

-(void)getSubjectAndMarks:(NSString *)classId year:(NSString *)year semesterId:(NSString *)semesterId userId:(NSString *)userId :(RequestComplitionBlock) reqBlock;

-(void)getStudantBehaviour:(NSString *)classId schoolId:(NSString *)schoolId userId:(NSString *)userId sDate:(NSString *)sDate eDate:(NSString *)eDate desceplineId:(NSString *)descID :(RequestComplitionBlock) reqBlock;

-(void)getCharecterAndGrade:(NSString *)classId year:(NSString *)year semesterId:(NSString *)semesterId userId:(NSString *)userId schoolId:(NSString *)schoolId :(RequestComplitionBlock) reqBlock;
-(void)getActivities:(NSString *)parentId :(RequestComplitionBlock)reqBlock;
-(void)getStudentsListByParent:(NSString *)parentId :(RequestComplitionBlock)reqBlock;
-(void)getAllEmgMessage:(NSString *)userId :(RequestComplitionBlock) reqBlock;
-(void)uploadPdfMarks:(NSString *)userId pdfFile:(NSString *)pdf :(RequestComplitionBlock)reqBlock;
-(void)uploadPdfCharecter:(NSString *)userId pdfFile:(NSString *)pdf :(RequestComplitionBlock)reqBlock;

-(void)downloadPdf:(NSMutableDictionary *)parameter isindividual:(BOOL)isindividual :(RequestComplitionBlock)reqBlock;

-(void)checkInStudent:(NSString *)teacherId studentId:(NSString *)sId activityId:(NSString *)aId :(RequestComplitionBlock)reqBlock;
-(void)checkOutStudent:(NSString *)teacherId studentId:(NSString *)sId activityId:(NSString *)aId checkOutType:(NSString *)checkType :(RequestComplitionBlock)reqBlock;


@end
