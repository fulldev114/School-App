//
//  User.h
//  Paytime2
//
//  Created by eTech Developer 8 on 01/01/16.
//  Copyright © 2016 etechmavens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeacherETechAsyncRequest.h"
//#import "ASINetworkQueue.h"
#import "Response.h"
#import "GeneralUtil.h"

typedef void (^RequestComplitionBlock)(NSObject *resObj);

@interface TeacherUser : NSObject {
}

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *persentNo;

@property (nonatomic, retain) NSString *persen1Name;
@property (nonatomic, retain) NSString *persen1Phone;
@property (nonatomic, retain) NSString *persen1Email;
@property (nonatomic, retain) NSString *persen2Name;
@property (nonatomic, retain) NSString *persen2Phone;
@property (nonatomic, retain) NSString *persen2Email;

@property (nonatomic, retain) NSString *verifyCode;
@property (nonatomic, retain) NSString *persentPin;
@property (nonatomic, retain) UIImageView *profileImg;

-(void)login:(RequestComplitionBlock) reqBlock;
-(void)registerPerent:(RequestComplitionBlock) reqBlock;
-(void)verifyCode:(RequestComplitionBlock) reqBlock;
-(void)registerDevice:(RequestComplitionBlock) reqBlock;
-(void)verifyPin:(NSString *)pincode :(RequestComplitionBlock) reqBlock;
-(void)forgotPin:(NSString *)email :(RequestComplitionBlock) reqBlock;

-(void)getStudantList:(NSString *)teacherId classId:(NSString *)cId :(RequestComplitionBlock) reqBlock;
-(void)getCheckedInStudentsList:(NSString *)teacherId classId:(NSString *)cId activityId:(NSString *)aId :(RequestComplitionBlock)reqBlock;
-(void)checkInStudent:(NSString *)teacherId studentId:(NSString *)sId activityId:(NSString *)aId :(RequestComplitionBlock)reqBlock;
-(void)getCheckedOutStudentsList:(NSString *)teacherId classId:(NSString *)cId activityId:(NSString *)aId :(RequestComplitionBlock)reqBlock;
-(void)checkOutStudent:(NSString *)teacherId studentId:(NSString *)sId activityId:(NSString *)aId checkOutType:(NSString *)checkType :(RequestComplitionBlock)reqBlock;
-(void)getStudentsList:(NSString *)teacherId classId:(NSString *)cId :(RequestComplitionBlock) reqBlock;
-(void)getActivities:(NSString *)teacherId :(RequestComplitionBlock)reqBlock;
-(void)getNotifications:(NSString *)teacherId :(RequestComplitionBlock)reqBlock;
-(void)getActivityDetails:(NSString *)activityID :(RequestComplitionBlock)reqBlock;
-(void)getStudentsInActivity:(NSString *)teacherId :(RequestComplitionBlock)reqBlock;
-(void)getRequestStudantList:(NSString *)schId teacherId:(NSString *)teacherId :(RequestComplitionBlock) reqBlock;
-(void)getTeacherClass:(NSString *)teacherId :(RequestComplitionBlock) reqBlock;

-(void)studRequestApproveOrReject:(NSString *)teacherId userId:(NSString *)userId parentId:(NSString *)parentId  value:(NSString *)value :(RequestComplitionBlock) reqBlock;

-(void)getTeacherDetail:(NSString *)teacherId :(RequestComplitionBlock) reqBlock;
-(void)updateTeacherDetail:(NSString *)name :(RequestComplitionBlock) reqBlock;

-(void)studCheckedDetail:(NSString *)teacherId childid:(NSString *)childId checkeddetail:(NSMutableDictionary *)checkedDetail :(RequestComplitionBlock) reqBlock;

-(void)getTeacherMsgHistory:(NSString *)teacherId :(RequestComplitionBlock) reqBlock;
//-(void)getAttendanceOfStud:(NSString *)classId date:(NSString *)Date :(RequestComplitionBlock) reqBlock;
-(void)getAttendanceOfStud:(NSString *)classId teacherId:(NSString *)teacherid date:(NSString *)Date :(RequestComplitionBlock) reqBlock;
-(void)sendMessageToStudant:(NSString *)teacherId classId:(NSString *)classId studId:(NSString *)studId message:(NSString *)msg :(RequestComplitionBlock) reqBlock;

-(void)getReposrtStudantList:(NSString *)schId gradeId:(NSString *)gradeId classId:(NSString *)classsId :(RequestComplitionBlock) reqBlock;
-(void)getAbsentStatestic:(NSString *)childId startdate:(NSString *)sdate endDate:(NSString *)edate :(RequestComplitionBlock) reqBlock;

-(void)sendStatisticeOfClass:(NSString *)teacherId schoolId:(NSString *)schId gradeId:(NSString *)gradeId classId:(NSString *)classsId sdate:(NSString *)sdate edate:(NSString *)edate :(RequestComplitionBlock) reqBlock;
-(void)uploadPdf:(NSString *)teacherId pdfFile:(NSString *)pdf isSend:(NSString *)isSend :(RequestComplitionBlock)reqBlock;
-(void)saveAbsentReport:(NSString *)teacherId classId:(NSString *)classsId date:(NSString *)date data:(NSString *)data changenotices:(NSString *)changenotices addnotices:(NSString *)addnotices notices:(NSString *)notices absentReason:(NSString *)absentreason noticesReason:(NSString *)noticereason :(RequestComplitionBlock) reqBlock;

-(void)sendAbsentReport:(NSString *)teacherId date:(NSString *)date classId:(NSString *)classsId :(RequestComplitionBlock) reqBlock;

-(void)changePincode:(NSString *)teacherId oldPin:(NSString *)oldpin newPin:(NSString *)newpin :(RequestComplitionBlock) reqBlock;
-(void)sendFeedback:(NSString *)teacherId email:(NSString *)email message:(NSString *)message :(RequestComplitionBlock) reqBlock;
-(void)getAllTeacherList:(NSString *)teacherId :(RequestComplitionBlock) reqBlock;

-(void)getSemseterAndSubj:(NSString *)classId schoolId:(NSString *)schoolId userId:(NSString *)userId :(RequestComplitionBlock) reqBlock;

-(void)addStudantMark:(NSString *)classId year:(NSString *)year subjectId:(NSString *)subjectId userId:(NSString *)userId semId:(NSString *)semId examNo:(NSString *)exno marks:(NSString *)marks comments:(NSString *)comments image:(UIImage *)img removeimage:(NSString *)removeimage examDate:(NSString *)exDate examAbout:(NSString *)exabout teacherId:(NSString *)techerId :(RequestComplitionBlock) reqBlock;

-(void)addStudantCharecter:(NSString *)classId year:(NSString *)year gradeId:(NSString *)gradeId userId:(NSString *)userId semId:(NSString *)semId comments:(NSString *)comments :(RequestComplitionBlock) reqBlock;

-(void)addStudantBehaviyore:(NSString *)classId date:(NSString *)date desciplineId:(NSString *)desciplineId userId:(NSString *)userId teacherId:(NSString *)teacherId remarksId:(NSString *)remarksId comments:(NSString *)comments type:(NSString *)type :(RequestComplitionBlock) reqBlock;

-(void)getStudantBehaviour:(NSString *)classId schoolId:(NSString *)schoolId userId:(NSString *)userId sDate:(NSString *)sDate eDate:(NSString *)eDate desceplineId:(NSString *)descID :(RequestComplitionBlock) reqBlock;

-(void)deleteStudantBehaviour:(NSString *)BehaviourId :(RequestComplitionBlock) reqBlock;

-(void)deleteActivity:(NSString *)activityId :(RequestComplitionBlock) reqBlock;

-(void)getSubjectAndMarks:(NSString *)classId year:(NSString *)year semesterId:(NSString *)semesterId userId:(NSString *)userId :(RequestComplitionBlock) reqBlock;

-(void)getCharecterAndGrade:(NSString *)classId year:(NSString *)year semesterId:(NSString *)semesterId userId:(NSString *)userId schoolId:(NSString *)schoolId :(RequestComplitionBlock) reqBlock;

-(void)getAllEmgMessage:(NSString *)userId :(RequestComplitionBlock) reqBlock;
//-(void)sendEmgMessage:(NSString *)userId  schoolId:(NSString *)schoolId message:(NSString *)message :(RequestComplitionBlock) reqBlock;

-(void)updateStudantProfile:(NSString *)userId  image:(UIImageView *)img :(RequestComplitionBlock) reqBlock;
-(void)uploadPdfMarks:(NSString *)teacherId pdfFile:(NSString *)pdf isSend:(NSString *)isSend :(RequestComplitionBlock)reqBlock;
-(void)uploadPdfCharecter:(NSString *)teacherId pdfFile:(NSString *)pdf isSend:(NSString *)isSend :(RequestComplitionBlock)reqBlock;

-(void)downloadPdf:(NSMutableDictionary *)parameter isindividual:(BOOL)isindividual :(RequestComplitionBlock)reqBlock;

-(void)getAllGroupOfSchool:(NSString *)schoolId :(RequestComplitionBlock) reqBlock;
-(void)sendEmgMessage:(NSString *)userId  groupid:(NSString *)groupId memberid:(NSString *)memberId message:(NSString *)message :(RequestComplitionBlock) reqBlock;

-(void)getCalendarData:(NSString *)fromDate toDate:(NSString *)toDate :(RequestComplitionBlock)reqBlock;
-(void)getStudentDetail:(NSString *)studentId Language:(NSString *)lang :(RequestComplitionBlock)reqBlock;
-(void)sendCheckOutRule:(NSString *)studentId rules:(NSMutableArray *)rules :(RequestComplitionBlock) reqBlock;
-(void)editStudentDetail:(NSString*) studentId Language:(NSString *)lang Data:(NSDictionary *)dic :(RequestComplitionBlock)reqBlock;

@end
