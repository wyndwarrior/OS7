#import "OS7Tile.h"
#import "OS7ListApp.h"
#import "DreamBoard.h"
#import <objc/runtime.h>

#define DREAMBOARD objc_getClass("DreamBoard")

@interface OS7 : NSObject <UIActionSheetDelegate, UIScrollViewDelegate>
{
	UIWindow *window;
	UIView *mainView;
	UIScrollView *tileScrollView;
	UIScrollView *appList;
	
	UIButton *toggleInterface;
	
	NSMutableArray *applications;
	
	BOOL toggled;
}
@property(nonatomic, readonly) NSMutableArray *applications;
@property(nonatomic, readonly) UIView *mainView;

+(OS7*)sharedInstance;
+(UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

-(id)initWithWindow:(UIWindow *)_window array:(NSMutableArray *)_apps;
-(void)toggle;
-(void)updateTiles;
-(void)updateBadge:(NSString *)leafId;
-(void)didHold:(id)sender;
@end