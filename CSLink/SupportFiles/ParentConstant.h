//
//  Constant.h
//  Redbf
//
//  Created by etech4 on 28/12/12.
//  Copyright (c) 2012 Ketan Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "UIViewController+MJPopupViewController.h"
#import "AppDelegate.h"
#import "ParentUser.h"
#import "GeneralUtil.h"
#import "UIImageView+AFNetworking.h"
#import "DatabaseHelper.h"
#include <AudioToolbox/AudioToolbox.h>


#define KEY_APP_VERSION         @"appVersion"
#define KEY_APP_DETAIL          @"appDetail"

#define APPNAME                 @"CSlink"
#define DATABASE_NAME                        @"messageDB.sqlite"

#define TBL_MESSAGE_DELIVERY_STATUS            @"tbl_delivery_status"
#define TBL_RECEIVE_MESSAGE                    @"tbl_receive_msg"

#define TBL_CELL_WIDTH          230

#define APP_START_DATE_MONTH    8
#define APP_START_DATE_DAY      15
#define APP_END_DATE_DAY        14

//#define BASE_URL                @"http://192.168.1.124/api/"

//#define BASE_URL                @"http://constore.no/cslink/api/"
//#define UPLOAD_URL              @"http://constore.no/cslink/uploads/"
//
//#define BASE_URL2                @"http://constore.no/cslink/"

//#define PARENT_BASE_URL         @"http://cslink.no/api/"
//#define PARENT_BASE_URL                @"http://192.168.6.30/cslink/apis/mparent/"
#define PARENT_BASE_URL                @"http://192.168.14.55:9083/apis/mparent/"
#define SFO_BASE_URL                @"http://192.168.14.55:9083/apis/msfo_parent/"
#define UPLOAD_URL              @"http://cslink.no/uploads/"

#define BASE_URL2                @"http://cslink.no/"
//#define BASE_URL2                @"http://192.168.6.30/cslink/apis/mparent/"

#define LINK_URL                    @"www.cslink.no"
#define SUPPORT_URL                 @"support@cslink.no"

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication]delegate])

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

// Devices height width
#define ScreenHeight                    MAX([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth                     MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)

#define RGB(r, g, b)    [UIColor colorWithRed:r green:g blue:b alpha:1.0]
#define RGB_ALPHA(r, g, b, a)    [UIColor colorWithRed:r green:g blue:b alpha:a]

#define COLOR_NAVIGATION_BAR [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)47/255 blue:(CGFloat)86/255 alpha:1.0]
#define COLOR_NAVIGATION_BAR_TEXT [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1.0]
#define COLOR_NAVIGATION_BACKBUTTON [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] 

#define APP_BACKGROUD_COLOR [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)64/255 blue:(CGFloat)98/255 alpha:1.0]

#define BTN_BACKGROUD_COLOR [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)202/255 blue:(CGFloat)251/255 alpha:1.0]

#define CELL_BACKGROUD_COLOR_YELLOW [UIColor colorWithRed:(CGFloat)254/255 green:(CGFloat)244/255 blue:(CGFloat)219/255 alpha:1.0]

#define TEXT_COLOR_CYNA [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)202/255 blue:(CGFloat)251/255 alpha:1.0]

#define TEXT_COLOR_RED [UIColor colorWithRed:(CGFloat)254/255 green:(CGFloat)0/255 blue:(CGFloat)0/255 alpha:1.0]

#define TEXT_COLOR_GREEN [UIColor colorWithRed:(CGFloat)23/255 green:(CGFloat)153/255 blue:(CGFloat)65/255 alpha:1.0]

#define TEXT_COLOR_YELLOW [UIColor colorWithRed:(CGFloat)251/255 green:(CGFloat)185/255 blue:(CGFloat)2/255 alpha:1.0]

#define TEXT_COLOR_GRAY [UIColor lightGrayColor]

#define TEXT_COLOR_BLACK [UIColor blackColor]

#define TEXT_COLOR_LIGHT_GREEN [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)255/255 blue:(CGFloat)185/255 alpha:1.0]

#define TEXT_COLOR_LIGHT_YELLOW [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)183/255 blue:(CGFloat)58/255 alpha:1.0]

#define TEXT_COLOR_WHITE [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1.0]
#define SEPERATOR_COLOR [UIColor colorWithRed:(CGFloat)35/255 green:(CGFloat)102/255 blue:(CGFloat)127/255 alpha:1.0]

#define SEPERATOR_COLOR_WHITE [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1.0]
#define TEXT_COLOR_LIGHT_BLUE [UIColor colorWithRed:(CGFloat)51/255 green:(CGFloat)98/255 blue:(CGFloat)124/255 alpha:1.0]
#define TEXT_COLOR_LIGHT_CYNA [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)156/255 blue:(CGFloat)183/255 alpha:1.0]
#define TEXT_COLOR_DARK_BLUE [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)43/255 blue:(CGFloat)82/255 alpha:1.0]

#define TEXT_COLOR_LIGHT_GRAY [UIColor colorWithRed:(CGFloat)234/255 green:(CGFloat)234/255 blue:(CGFloat)234/255 alpha:1.0]

#define BOTTOM_BAR_COLOR_BLUE [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)39/255 blue:(CGFloat)74/255 alpha:1.0]

#define FONT_NAVIGATION_TITLE [UIFont fontWithName:@"Signika-Regular" size:18]
#define FONT_NAVIGATION_BACKBUTTON [UIFont fontWithName:@"Signika-Regular" size:13]

//BUTTON
#define FONT_BTN_TITLE_15  IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:25] : [UIFont fontWithName:@"Signika-Bold" size:15]
#define FONT_BTN_TITLE_17  IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:24] : [UIFont fontWithName:@"Signika-Bold" size:17]
#define FONT_BTN_TITLE_18  [UIFont fontWithName:@"Signika-Bold" size:18]


#define FONT_TBL_ROW_TITLE  [UIFont fontWithName:@"Signika-Bold" size:18]
#define FONT_TBL_ROW_DETAIL  [UIFont fontWithName:@"Signika-Regular" size:16]


#define FONT_10_REGULER         [UIFont fontWithName:@"Signika-Regular" size:10]
#define FONT_10_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:10]
#define FONT_10_LIGHT           [UIFont fontWithName:@"Signika-Light" size:10]
#define FONT_10_BOLD            [UIFont fontWithName:@"Signika-Bold" size:10]

#define FONT_12_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:22] : [UIFont fontWithName:@"Signika-Regular" size:12]
#define FONT_12_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:22] : [UIFont fontWithName:@"Signika-Semibold" size:12]
#define FONT_12_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:22] : [UIFont fontWithName:@"Signika-Light" size:12]
#define FONT_12_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:22] : [UIFont fontWithName:@"Signika-Bold" size:12]

#define FONT_14_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:24] : [UIFont fontWithName:@"Signika-Regular" size:14]
#define FONT_14_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:24] : [UIFont fontWithName:@"Signika-Semibold" size:14]
#define FONT_14_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:24] : [UIFont fontWithName:@"Signika-Light" size:14]
#define FONT_14_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:24] : [UIFont fontWithName:@"Signika-Bold" size:14]

#define FONT_13_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:23] : [UIFont fontWithName:@"Signika-Regular" size:13]
#define FONT_13_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:23] : [UIFont fontWithName:@"Signika-Semibold" size:13]
#define FONT_13_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:23] : [UIFont fontWithName:@"Signika-Light" size:13]
#define FONT_13_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:23] : [UIFont fontWithName:@"Signika-Bold" size:13]

//#if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
//#define FONT_16_REGULER         [UIFont fontWithName:@"Signika-Regular" size:26]
//#define FONT_16_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:26]
//#define FONT_16_LIGHT           [UIFont fontWithName:@"Signika-Light" size:26]
//#define FONT_16_BOLD            [UIFont fontWithName:@"Signika-Bold" size:26]
//#else
//#define FONT_16_REGULER         [UIFont fontWithName:@"Signika-Regular" size:16]
//#define FONT_16_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:16]
//#define FONT_16_LIGHT           [UIFont fontWithName:@"Signika-Light" size:16]
//#define FONT_16_BOLD            [UIFont fontWithName:@"Signika-Bold" size:16]
//#endif

#define FONT_16_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:26] : [UIFont fontWithName:@"Signika-Regular" size:16]
#define FONT_16_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:26] : [UIFont fontWithName:@"Signika-Semibold" size:16]
#define FONT_16_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:26] : [UIFont fontWithName:@"Signika-Light" size:16]
#define FONT_16_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:26] : [UIFont fontWithName:@"Signika-Bold" size:16]

#define FONT_17_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:27] : [UIFont fontWithName:@"Signika-Regular" size:17]
#define FONT_17_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:27] : [UIFont fontWithName:@"Signika-Regular" size:17]
#define FONT_17_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:27] : [UIFont fontWithName:@"Signika-Regular" size:17]
#define FONT_17_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:27] : [UIFont fontWithName:@"Signika-Bold" size:17]

#define FONT_18_REGULER         IS_IPAD ? [UIFont fontWithName:@"Signika-Regular" size:26] : [UIFont fontWithName:@"Signika-Regular" size:18]
#define FONT_18_SEMIBOLD        IS_IPAD ? [UIFont fontWithName:@"Signika-Semibold" size:26] : [UIFont fontWithName:@"Signika-Semibold" size:18]
#define FONT_18_LIGHT           IS_IPAD ? [UIFont fontWithName:@"Signika-Light" size:26] : [UIFont fontWithName:@"Signika-Light" size:18]
#define FONT_18_BOLD            IS_IPAD ? [UIFont fontWithName:@"Signika-Bold" size:26] : [UIFont fontWithName:@"Signika-Bold" size:18]

#define FONT_18_REGULER_FIX         [UIFont fontWithName:@"Signika-Regular" size:18]
#define FONT_18_SEMIBOLD_FIX        [UIFont fontWithName:@"Signika-Semibold" size:18]
#define FONT_18_LIGHT_FIX           [UIFont fontWithName:@"Signika-Light" size:18]
#define FONT_18_BOLD_FIX            [UIFont fontWithName:@"Signika-Bold" size:18]

#define FONT_30_REGULER         [UIFont fontWithName:@"Signika-Regular" size:30]
#define FONT_30_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:30]
#define FONT_30_LIGHT           [UIFont fontWithName:@"Signika-Light" size:30]
#define FONT_30_BOLD            [UIFont fontWithName:@"Signika-Bold" size:30]

#define FONT_35_REGULER         [UIFont fontWithName:@"Signika-Regular" size:35]
#define FONT_35_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:35]
#define FONT_35_LIGHT           [UIFont fontWithName:@"Signika-Light" size:35]
#define FONT_35_BOLD            [UIFont fontWithName:@"Signika-Bold" size:35]

#define FONT_40_REGULER         [UIFont fontWithName:@"Signika-Regular" size:40]
#define FONT_40_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:40]
#define FONT_40_LIGHT           [UIFont fontWithName:@"Signika-Light" size:40]
#define FONT_40_BOLD            [UIFont fontWithName:@"Signika-Bold" size:40]

#define FONT_50_REGULER         [UIFont fontWithName:@"Signika-Regular" size:50]
#define FONT_50_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:50]
#define FONT_50_LIGHT           [UIFont fontWithName:@"Signika-Light" size:50]
#define FONT_50_BOLD            [UIFont fontWithName:@"Signika-Bold" size:50]

#define FONT_20_REGULER         [UIFont fontWithName:@"Signika-Regular" size:20]
#define FONT_20_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:20]
#define FONT_20_LIGHT           [UIFont fontWithName:@"Signika-Light" size:20]
#define FONT_20_BOLD            [UIFont fontWithName:@"Signika-Bold" size:25]

#define FONT_22_REGULER         [UIFont fontWithName:@"Signika-Regular" size:22]
#define FONT_22_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:22]
#define FONT_22_LIGHT           [UIFont fontWithName:@"Signika-Light" size:22]
#define FONT_22_BOLD            [UIFont fontWithName:@"Signika-Bold" size:22]

#define FONT_25_REGULER         [UIFont fontWithName:@"Signika-Regular" size:25]
#define FONT_25_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:25]
#define FONT_25_LIGHT           [UIFont fontWithName:@"Signika-Light" size:25]
#define FONT_25_BOLD            [UIFont fontWithName:@"Signika-Bold" size:25]

#define FONT_27_REGULER         [UIFont fontWithName:@"Signika-Regular" size:27]
#define FONT_27_SEMIBOLD        [UIFont fontWithName:@"Signika-Semibold" size:27]
#define FONT_27_LIGHT           [UIFont fontWithName:@"Signika-Light" size:27]
#define FONT_27_BOLD            [UIFont fontWithName:@"Signika-Bold" size:27]

//Req paramater
#define TXT_REQ_OBJ                             @"res_object"
#define TXT_REQ_CODE                            @"res_code"
#define TXT_REQ_MSG                             @"res_msg"

#define PARA_DEBUG              @"0"

//RESPONSE
#define RES_CODE_00                             0
#define RES_CODE_01                             1
#define RES_CODE_02                             2
#define RES_CODE_03                             3
#define RES_CODE_04                             4
#define RES_CODE_INVALID_FORMAT                 11

//UserDefuilt ALL KEY
#define key_flag                            @"flag"
#define key_msg                             @"msg"
#define key_userpass                        @"user_pass"
#define key_phoneNumber                     @"phoneNumber"

#define LocalChildrenInfo                   @"LocalChildrenInfo"
#define key_allchilds                       @"All Childs"
#define key_parents                         @"parents"
#define key_childs                          @"childs"
#define key_parentid                        @"parentid"
#define key_parentemail                     @"parent email"
#define key_parentname                      @"parent name"

#define key_teacherId                       @"TeacherID"
#define key_schoolId                        @"SchoolId"
#define key_incharge                        @"incharge"

#define key_saveChild                       @"SaveChild"
#define key_verifyCode                      @"verifyCode"
#define key_parentIdSave                    @"ParentIdSave"
#define key_ParentEmail                     @"ParentEmail"
#define key_saveParentName                  @"SaveParentName"
#define key_islogin                         @"is_login"
#define key_isfromlogin                     @"is_fromlogin"
#define key_sucessLoginNow                  @"SucessLoginNow"
#define key_fromPintoSelect                 @"FromPincodeToSelChild"

#define key_isStudantSelected               @"isSelecteStudant"
#define key_selectedStudant                 @"SelecteStudant"

//#define key_selectedStudSubj                @"selectedStudSubj"

#define str_successLogin                    @"SuccessLogin"

//xue
#define key_myParentNo                      @"my_parentNo"
#define key_myParentPhone                   @"perentPhone"
#define key_myParentName                    @"perentName"
#define key_ParentStatus                    @"parent_status"
#define key_UserId                          @"UserId"

#define key_myParentNo2                      @"my_parentNo2"
#define key_myParentPhone2                   @"perentPhone2"
#define key_myParentName2                    @"perentName3"

#define key_myParentNo3                      @"my_parentNo3"
#define key_myParentPhone3                   @"perentPhone3"
#define key_myParentName3                    @"perentName3"


#define   key_device_tokan                  @"deviceTokan"

#define   key_emergancy_msg                  @"emergancy_msg"
#define   key_emg_msg_read                   @"emg_read"

#define key_selLang                             @"sel_lang"
#define value_LangEglish                        @"en"
#define value_LangNorwegian                     @"nb"

#define key_total_badge                         @"total_badge"
#define key_abi_badge                           @"abi_badge"
#define key_abn_badge                           @"abn_badge"
#define key_chat_badge                          @"chat_badge"

#define NOTIFICATION_LANGUAGE_CHANGE            @"LanguageChanged"

#define ACTION_PARENT_LOGIN                     @"get_verifycode"
#define ACTION_PARENT_VERIFY_CODE               @"verifycode"
#define ACTION_PARENT_REGISTER_DEVICE           @"device_reg"
#define ACTION_PARENT_VIRIFY_PINCODE            @"get_parent_login_by_phone"
#define ACTION_PARENT_FORGOT_PINCODE            @"forgot_pincode_sms"
#define ACTION_PARENT_GET_SCHOOL_LIST           @"get_all_classes_by_phone"
#define ACTION_PARENT_GET_STUDANT_LIST          @"get_new_student_by_phone"
#define ACTION_PARENT_GET_STUDENTS_LIST         @"get_students_by_parent"
#define ACTION_PARENT_ADD_STUDANT               @"add_new_child_by_phone"
#define ACTION_PARENT_REGISTER_PERENT           @"new_register_by_phone"
#define ACTION_PARENT_GET_ALL_CHIELD            @"get_childs_by_phone"
#define ACTION_PARENT_GET_CHIELD_DETAIL         @"get_child_details_id_by_phone"
#define ACTION_PARENT_UPDATE_CHIELD_DETAIL      @"update_child_details_by_phone"
#define ACTION_PARENT_GET_TEACHER_LIST          @"get_child_teachers"
#define ACTION_PARENT_GET_PERENT_LIST           @"get_parentlist"

#define ACTION_PARENT_GET_ABSENT_NOITCE_LIST    @"get_important_message_onid"
#define ACTION_PARENT_GET_PERIODS_LIST          @"get_child_notices_by_phone_1"

#define ACTION_PARENT_CAHNGE_PINCODE            @"change_pin_by_phone"

#define ACTION_CONTECT_US                       @"contact_us"

#define ACTION_PARENT_SEND_ABSENT               @"set_child_notices_by_phone"

#define ACTION_PARENT_GET_STATISTICS_OF_STUD    @"statistics_by_phone"

#define ACTION_UPLOAD_PDF                       @"uploadpdf_by_phone_1"
#define ACTION_UPLOAD_MARKS_PDF                 @"uploadpdf_by_phone_1"

#define ACTION_PARENT_GET_ALL_SEM_SUBJ          @"get_subject_by_class"

#define ACTION_PARENT_GET_MARK_DEATIL           @"view_marks_by_parent"
#define ACTION_PARENT_GET_DESCIPINE_AND_BEHAV   @"view_descipline_by_parent"
#define ACTION_PARENT_GET_CHERACTER_DEATIL      @"view_character_by_parent"

#define ACTION_PARENT_GET_EMG_MESSAGE           @"message_alert_list"

#define ACTION_PARENT_GET_ACTIVITIES            @"get_activities_by_parent"
#define ACTION_PARENT_CHECK_IN                  @"check_in_by_parent"
#define ACTION_PARENT_CHECK_OUT                 @"check_out_by_parent"

#define ACTION_DOWNLOAD_PDF                     @"generateReport"

#if DEBUG
#include <libgen.h>
#define ZDebug(fmt, args...)  NSLog(@"[%s:%d] %@\n", basename(__FILE__), __LINE__, [NSString stringWithFormat:fmt, ##args])
#else
#define ZDebug(fmt, args...)  ((void)0)
#endif

enum ACTIVITY_STATUS{
    ACTIVITY_ADD = 0,
    ACTIVITY_DETAIL = 1,
    ACTIVITY_CHECKED = 2
};
