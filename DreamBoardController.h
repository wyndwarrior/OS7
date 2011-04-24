/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import <UIKit/UIKit.h>

// dreamboard headers, we use these to hook 
// onto dreamboard's loading method

@interface DreamBoardController : NSObject {
    //SpringBoard's Window
	UIWindow *_window;
    
    //Array of SBApplications
	NSMutableArray *_apps;

	NSMutableDictionary *_prop;
	NSMutableDictionary *_views;
	NSMutableDictionary *_viewConfig;
	NSMutableDictionary *_toggledInter;
	NSMutableDictionary *_toggled;
	NSMutableDictionary *themePlist;
	NSMutableDictionary *_propDict;
	NSDictionary *_labelStyle;
	NSString *_themeName;
	NSString *_path;
	NSString *_orig;
	
	UIImage *_maskImage;
	UIImage *_shadowImage;
	UIImage *_overlayImage;
    UIImage *_editingImage;
	
	//DBSwitcherView *swticherView;
	
	UIView *mainView;
	
	int frameWidth;
	int frameHeight;
	
	BOOL isEditing;
}
@property (readonly) int frameWidth;
@property (readonly) int frameHeight;
@property (nonatomic) BOOL isEditing;
@property (readonly) UIImage *maskImage;
@property (readonly) UIImage *shadowImage;
@property (readonly) UIImage *overlayImage;
@property (readonly) UIImage *editingImage;
@property (readonly) NSMutableArray *apps;
@property (readonly) NSMutableDictionary *views;
@property (readonly) NSMutableDictionary *viewConfig;
@property (readonly) NSMutableDictionary *toggledInter;
@property (readonly) NSMutableDictionary *toggled;
@property (readonly) NSMutableDictionary *prop;
@property (readonly) NSDictionary *labelStyle;
@property (readonly) UIWindow *window;
@property (nonatomic, retain) NSString *themeName;

-(id)initWithWindow:(UIWindow *)window apps:(NSMutableArray *)apps;

-(void)loadSwitcher;
-(void)loadThemes:(NSString *)theme;
-(void)unloadTheme;
-(void)setViewDefaults:(UIView *)view withDict:(NSDictionary *)dict;
-(void)toggleSwitcher;
-(void)closeSwitcher;
-(void)showPopup;
-(void)stopEditing;
-(void)saveDict:(NSString *)theme;
-(void)cache:(NSString *)size theme:(NSString *)name;

-(UIView *)loadView:(NSMutableDictionary *)dict;
+(UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
@end
