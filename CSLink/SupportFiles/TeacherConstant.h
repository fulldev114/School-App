//
//  Constant.h
//  Redbf
//
//  Created by etech4 on 28/12/12.
//  Copyright (c) 2012 Ketan Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "TeacherUser.h"
#import "GeneralUtil.h"
#import "UIImageView+AFNetworking.h"
#import "DatabaseHelper.h"
#include <AudioToolbox/AudioToolbox.h>

#define APP_SEM_END_DATE_MONTH  02
//#define TEACHER_BASE_URL                @"http://cslink.no/api/ipad/"
#define TEACHER_BASE_URL                @"http://192.168.14.55:9083/apis/mteacher/"
#define SFO_BASE_URL                @"http://192.168.14.55:9083/apis/msfo/"
//#define TEACHER_BASE_URL                @"http://cslink.no/apis/mteacher/"
//#define TEACHER_BASE_URL                @"http://192.168.6.30/cslink/api/ipad/"
//
//#define RGB(r, g, b)    [UIColor colorWithRed:r green:g blue:b alpha:1.0]
//#define RGB_ALPHA(r, g, b, a)    [UIColor colorWithRed:r green:g blue:b alpha:a]
//
//#define COLOR_NAVIGATION_BAR [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)47/255 blue:(CGFloat)86/255 alpha:1.0]
//#define COLOR_NAVIGATION_BAR_TEXT [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1.0]
//#define COLOR_NAVIGATION_BACKBUTTON [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] 
//
//#define BTN_BACKGROUD_COLOR [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)202/255 blue:(CGFloat)251/255 alpha:1.0]
//
//#define APP_BACKGROUD_COLOR [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)64/255 blue:(CGFloat)98/255 alpha:1.0]
//
//#define TEXT_COLOR_CYNA [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)202/255 blue:(CGFloat)251/255 alpha:1.0]
//
//#define TEXT_COLOR_GRAY [UIColor lightGrayColor]
//
//#define TEXT_COLOR_BLACK [UIColor blackColor]
//
//#define TEXT_COLOR_LIGHT_GREEN [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)255/255 blue:(CGFloat)185/255 alpha:1.0]
//
#define TEXT_COLOR_GREEN [UIColor colorWithRed:(CGFloat)134/255 green:(CGFloat)206/255 blue:(CGFloat)78/255 alpha:1.0]
//
//#define TEXT_COLOR_LIGHT_YELLOW [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)183/255 blue:(CGFloat)58/255 alpha:1.0]
//
//#define TEXT_COLOR_WHITE [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1.0]
//
//#define SEPERATOR_COLOR [UIColor colorWithRed:(CGFloat)35/255 green:(CGFloat)102/255 blue:(CGFloat)127/255 alpha:1.0]
//
//#define TEXT_COLOR_LIGHT_BLUE [UIColor colorWithRed:(CGFloat)51/255 green:(CGFloat)98/255 blue:(CGFloat)124/255 alpha:1.0]
//#define TEXT_COLOR_LIGHT_CYNA [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)156/255 blue:(CGFloat)183/255 alpha:1.0]
//#define TEXT_COLOR_DARK_BLUE [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)43/255 blue:(CGFloat)82/255 alpha:1.0]
//
//#define TEXT_COLOR_LIGHT_GRAY [UIColor colorWithRed:(CGFloat)234/255 green:(CGFloat)234/255 blue:(CGFloat)234/255 alpha:1.0]
//
//#define FONT_NAVIGATION_TITLE [UIFont fontWithName:@"Signika-Regular" size:18]
//#define FONT_NAVIGATION_BACKBUTTON [UIFont fontWithName:@"Signika-Regular" size:13]
//
////BUTTON
//#define FONT_BTN_TITLE_15  IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:22] : [UIFont fontWithName:@"Signika-Bold" size:15]
//#define FONT_BTN_TITLE_17  IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:24] : [UIFont fontWithName:@"Signika-Bold" size:17]
//#define FONT_BTN_TITLE_18  [UIFont fontWithName:@"Signika-Bold" size:18]
//#define FONT_TBL_ROW_TITLE  [UIFont fontWithName:@"Signika-Bold" size:18]
//#define FONT_TBL_ROW_DETAIL  [UIFont fontWithName:@"Signika-Regular" size:15]
//
//#define FONT_12_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:22] : [UIFont fontWithName:@"Signika-Regular" size:12]
//#define FONT_12_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:22] : [UIFont fontWithName:@"Signika-Semibold" size:12]
//#define FONT_12_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:22] : [UIFont fontWithName:@"Signika-Light" size:12]
//#define FONT_12_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:22] : [UIFont fontWithName:@"Signika-Bold" size:12]
//
//#define FONT_14_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:24] : [UIFont fontWithName:@"Signika-Regular" size:14]
//#define FONT_14_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:24] : [UIFont fontWithName:@"Signika-Semibold" size:14]
//#define FONT_14_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:24] : [UIFont fontWithName:@"Signika-Light" size:14]
//#define FONT_14_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:23] : [UIFont fontWithName:@"Signika-Bold" size:14]
//
//#define FONT_15_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:25] : [UIFont fontWithName:@"Signika-Regular" size:15]
//#define FONT_15_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:25] : [UIFont fontWithName:@"Signika-Semibold" size:15]
//#define FONT_15_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:25] : [UIFont fontWithName:@"Signika-Light" size:15]

#define FONT_15_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:25] : [UIFont fontWithName:@"Signika-Bold" size:15]
//
//#define FONT_16_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:26] : [UIFont fontWithName:@"Signika-Regular" size:16]
//#define FONT_16_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:26] : [UIFont fontWithName:@"Signika-Semibold" size:16]
//#define FONT_16_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:26] : [UIFont fontWithName:@"Signika-Light" size:16]
//#define FONT_16_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:26] : [UIFont fontWithName:@"Signika-Bold" size:16]
//
//#define FONT_18_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:26] : [UIFont fontWithName:@"Signika-Regular" size:18]
//#define FONT_18_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:26] : [UIFont fontWithName:@"Signika-Semibold" size:18]
//#define FONT_18_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:26] : [UIFont fontWithName:@"Signika-Light" size:18]
//#define FONT_18_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:26] : [UIFont fontWithName:@"Signika-Bold" size:18]
//
//#define FONT_17_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:27] : [UIFont fontWithName:@"Signika-Regular" size:17]
//#define FONT_17_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:27] : [UIFont fontWithName:@"Signika-Semibold" size:17]
//#define FONT_17_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:27] : [UIFont fontWithName:@"Signika-Light" size:17]
//#define FONT_17_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:27] : [UIFont fontWithName:@"Signika-Bold" size:17]
//
//#define FONT_30_REGULER         [UIFont fontWithName:@"Signika-Regular" size:30]
//#define FONT_30_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:30]
//#define FONT_30_LIGHT           [UIFont fontWithName:@"Signika-Light" size:30]
//#define FONT_30_BOLD            [UIFont fontWithName:@"Signika-Bold" size:30]
//
//#define FONT_8_REGULER         [UIFont fontWithName:@"Signika-Regular" size:8]
//#define FONT_8_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:8]
//#define FONT_8_LIGHT           [UIFont fontWithName:@"Signika-Light" size:8]
//#define FONT_8_BOLD            [UIFont fontWithName:@"Signika-Bold" size:8]
//
//#define FONT_20_REGULER         [UIFont fontWithName:@"Signika-Regular" size:20]
//#define FONT_20_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:20]
//#define FONT_20_LIGHT           [UIFont fontWithName:@"Signika-Light" size:20]
//#define FONT_20_BOLD            [UIFont fontWithName:@"Signika-Bold" size:20]
//
//#define FONT_35_REGULER         [UIFont fontWithName:@"Signika-Regular" size:35]
//#define FONT_35_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:35]
//#define FONT_35_LIGHT           [UIFont fontWithName:@"Signika-Light" size:35]
//#define FONT_35_BOLD            [UIFont fontWithName:@"Signika-Bold" size:35]
//
//#define FONT_40_REGULER         [UIFont fontWithName:@"Signika-Regular" size:40]
//#define FONT_40_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:40]
//#define FONT_40_LIGHT           [UIFont fontWithName:@"Signika-Light" size:40]
//#define FONT_40_BOLD            [UIFont fontWithName:@"Signika-Bold" size:40]
//
//#define FONT_50_REGULER         [UIFont fontWithName:@"Signika-Regular" size:50]
//#define FONT_50_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:50]
//#define FONT_50_LIGHT           [UIFont fontWithName:@"Signika-Light" size:50]
//#define FONT_50_BOLD            [UIFont fontWithName:@"Signika-Bold" size:50]
//
//#define FONT_22_REGULER         [UIFont fontWithName:@"Signika-Regular" size:22]
//#define FONT_22_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:22]
//#define FONT_22_LIGHT           [UIFont fontWithName:@"Signika-Light" size:22]
//#define FONT_22_BOLD            [UIFont fontWithName:@"Signika-Bold" size:22]
//
//#define FONT_25_REGULER         [UIFont fontWithName:@"Signika-Regular" size:25]
//#define FONT_25_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:25]
//#define FONT_25_LIGHT           [UIFont fontWithName:@"Signika-Light" size:25]
//#define FONT_25_BOLD            [UIFont fontWithName:@"Signika-Bold" size:25]
//
//#define FONT_27_REGULER         [UIFont fontWithName:@"Signika-Regular" size:27]
//#define FONT_27_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:27]
//#define FONT_27_LIGHT           [UIFont fontWithName:@"Signika-Light" size:27]
//#define FONT_27_BOLD            [UIFont fontWithName:@"Signika-Bold" size:27]
//
////Req paramater
//#define TXT_REQ_OBJ                             @"res_object"
//#define TXT_REQ_CODE                            @"res_code"
//#define TXT_REQ_MSG                             @"res_msg"
//
//#define PARA_DEBUG              @"0"
//
////RESPONSE
//#define RES_CODE_00                             0
//#define RES_CODE_01                             1
//#define RES_CODE_02                             2
//#define RES_CODE_03                             3
//#define RES_CODE_04                             4
//#define RES_CODE_INVALID_FORMAT                 11
//
//
////UserDefuilt ALL KEY
//
//#define key_flag                            @"flag"
//#define key_msg                             @"msg"
//#define key_userpass                        @"user_pass"
#define key_My_phoneNumber                  @"phoneNumber"
//
#define key_My_Email                        @"userEmailId"
#define key_UserName                        @"userName"
#define key_UserImage                       @"userImage"
//
//#define key_teacherId                       @"TeacherID"
//#define key_schoolId                        @"SchoolId"
//#define key_incharge                        @"incharge"
//
#define key_jid                             @"jid"
#define key_jpassword                       @"jpassword"
//
//#define key_islogin                         @"is_login"
//#define key_isfromlogin                     @"is_fromlogin"
//#define key_sucessLoginNow                  @"SucessLoginNow"
//
//#define str_successLogin                    @"SuccessLogin"
//
//#define key_parentIdSave @""
//#define key_isStudantSelected               @"isSelecteStudant"
//#define key_StudantSelected                 @"SelecteStudant"
//#define key_saveChild                       @"SaveChild"
////xue
//#define key_myParentNo                      @"my_parentNo"
//#define key_myParentPhone                   @"perentPhone"
//#define key_ParentStatus                    @"parent_status"
//#define key_UserId                          @"UserId"
//
//#define key_device_tokan                @"deviceTokan"
//
//#define key_selLang                             @"sel_lang"
//#define value_LangEglish                        @"en"
//#define value_LangNorwegian                     @"nb"
//
//#define   key_emergancy_msg                  @"emergancy_msg"
//#define   key_emg_msg_read                   @"emg_read"
//
#define key_studant_req_badge                   @"studantBadge"
#define key_teacher_badge                   @"internal_badge"
#define key_register_badge                   @"register_badge"
//#define key_chat_badge                          @"chat_badge"

#define key_charge_type                         @"charge_type"
//
//#define NOTIFICATION_LANGUAGE_CHANGE            @"LanguageChanged"
//
#define ACTION_TEACHER_LOGIN                            @"get_verifycode_by_email_teacher"
#define ACTION_TEACHER_VERIFY_CODE                      @"verifycode_by_email_teacher"
#define ACTION_TEACHER_REGISTER_DEVICE                  @"device_reg"
#define ACTION_TEACHER_VIRIFY_PINCODE                   @"teacherlogin_by_email_teacher"
#define ACTION_TEACHER_FORGOT_PINCODE                   @"forgot_pincode_by_email_teacher"
#define ACTION_TEACHER_REGISTER_PERENT                  @"new_register_by_phone"
#define ACTION_TEACHER_GET_STUDANT_LIST                 @"message_list"
#define ACTION_TEACHER_GET_STUDENTS_LIST                @"get_students_by_teacher"
#define ACTION_TEACHER_GET_CHECKEDIN_STUDENTS_LIST      @"get_checked_in_students_by_teacher"
#define ACTION_TEACHER_GET_CHECKEDOUT_STUDENTS_LIST     @"get_checked_out_students_by_teacher"
#define ACTION_TEACHER_GET_ACTIVITY_DETAILS             @"get_activity_details"
#define ACTION_TEACHER_GET_ACTIVITIES                   @"get_activities_by_teacher"
#define ACTION_TEACHER_GET_STUDENTS_IN_ACTIVITY         @"get_students_in_activity_by_teacher"
#define ACTION_TEACHER_GET_NOTIFICATIONS                @"get_notifications_by_teacher"
#define ACTION_TEACHER_GET_REQUEST_STUDANT_LIST         @"get_students_and_parent_teacher"
#define ACTION_TEACHER_GET_TEACHER_CLASS_LIST           @"get_class_by_teacher"
#define ACTION_TEACHER_REQUEST_APPROVE_OR_REJECT        @"set_students_and_parent_teacher"
#define ACTION_TEACHER_GET_TEACHER_DETAIL               @"get_teacher_details"
#define ACTION_TEACHER_UPDATE_TEACHER_DETAIL            @"update_teacher_details"
#define ACTION_TEACHER_UPDATE_STUD_CHECKED_DETAIL       @"set_student_setting_checked_teacher"
#define ACTION_TEACHER_GET_MSG_HISTORY                  @"get_group_msg_teacher"
#define ACTION_TEACHER_GET_ATTENDANC_OF_STUD            @"get_attendance_by_class_teacher_1"
#define ACTION_TEACHER_SEND_MESSAGE_TO_STUD             @"create_new_message_teacher"
#define ACTION_TEACHER_GET_REPOSRT_STUDANT_LIST         @"get_students_teacher"
#define ACTION_TEACHER_STATISTICS_BY_TECHER             @"statistics_by_userid_teacher"
#define ACTION_TEACHER_STATISTICS_BY_TECHER_OF_CLASS    @"statistics_by_class_teacher"
#define ACTION_TEACHER_GET_TEACHER_LIST                 @"get_other_teacher_details"
#define ACTION_TEACHER_SAVE_ABSENT_REPORT_TECHER        @"set_attendance_by_class_teacher_1"
#define ACTION_TEACHER_SEND_ABSENT_NOTICE_TEACHER       @"send_absent_notice_teacher_1"
//#define ACTION_UPLOAD_PDF                             @"uploadpdf_teacher.php"
//#define ACTION_UPLOAD_MARKS_PDF                       @"uploadpdf_teacher.php"
#define ACTION_TEACHER_CAHNGE_PINCODE                   @"change_pin_teacher"
//#define ACTION_CONTECT_US                             @"contact_us.php"

#define ACTION_TEACHER_SET_CHECKIN_BY_TEACHER           @"check_in_by_teacher"
#define ACTION_TEACHER_SET_CHECKOUT_BY_TEACHER          @"check_out_by_teacher"

#define ACTION_TEACHER_GET_ALL_SEM_SUBJ                 @"get_subject_by_class"
#define ACTION_TEACHER_GET_DESCIPINE_AND_BEHAV          @"view_descipline_by_teacher"
#define ACTION_TEACHER_DELETE_DESCIPINE_AND_BEHAV       @"delete_descipline_by_teacher"
#define ACTION_TEACHER_ADD_MARKS_STUD                   @"add_marks_by_teacher"
//#define ACTION_ADD_CHARECTER_STUD                     @"add_character_by_teacher.php"
#define ACTION_TEACHER_ADD_CHARECTER_STUD               @"add_descipline_by_teacher"
#define ACTION_TEACHER_GET_MARK_DEATIL                  @"view_marks_by_parent"
#define ACTION_TEACHER_GET_CHERACTER_DEATIL             @"view_character_by_parent"

#define ACTION_DELETE_ACTIVITY                          @"delete_activity"
#define ACTION_TEACHER_GET_EMG_MESSAGE                  @"message_alert_list"

//#define ACTION_SEND_EMG_MESSAGE         @"message_alert.php"

#define ACTION_TEACHER_SEND_EMG_MESSAGE                 @"send_emeregency_message"

#define ACTION_TEACHER_GET_ALL_GROUP                    @"get_group_by_school"

#define ACTION_TEACHER_UPLOAD_STUDENT_PROFILE           @"upload_student_profile_teacher"

#define ACTION_TEACHER_DOWNLOAD_PDF                     @"generateReport"

#define ACTION_CALENDAR_DATA                            @"get_sessions_by_date"
#define ACTION_GET_STUDENT_DETAIL                       @"get_student_details"
#define ACTION_SET_STUDENT_DETAIL                       @"edit_student_details"

//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
//
//#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//
//#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
////#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
//
//// Devices height width
//#define ScreenHeight                    MAX([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)
//#define ScreenWidth                     MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)
//
//#if DEBUG
//#include <libgen.h>
//#define ZDebug(fmt, args...)  NSLog(@"[%s:%d] %@\n", basename(__FILE__), __LINE__, [NSString stringWithFormat:fmt, ##args])
//#else
//#define ZDebug(fmt, args...)  ((void)0)
//#endif
//
//

enum SFO_STATUS{
    NOT_ARRIVED = 0,
    SFO_CHECKEDIN = 1,
    ACTIVITY_CHECKEDIN = 2,
    CHECKEDOUT = 3
};
