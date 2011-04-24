/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "SpringBoard/SpringBoard.h"
#import "Tile.h"
#import "ApplicationListItem.h"

@interface OS7ViewController : NSObject <UIActionSheetDelegate>
{
	UIWindow *window;
	UIView *mainView;
	UIScrollView *tileScrollView;
	UIScrollView *appList;
	
	UIButton *toggleInterface;
	
	NSMutableArray *applications;
	
	BOOL toggled;
	BOOL p;
}

-(id)initWithWindow:(UIWindow *)w array:(NSMutableArray *)array;
-(void)launchWithBundle:(id)sender;
-(void)toggleLeft;
-(void)toggleRight;
-(void)toggle;
-(void)didTouchDown:(id)sender;
-(void)didTouchUp:(id)sender;
-(void)removeTarget:(UIButton*)sender;
-(void)addTarget:(UIButton*)sender;
-(void)pin:(UIButton *)sender;
-(void)unPin:(UIButton *)sender;
-(void)updateTiles;
-(void)updateBadgeWithString:(id)badgeNumber app:(NSString *)leafId;
-(UIView *)mainView;
@end