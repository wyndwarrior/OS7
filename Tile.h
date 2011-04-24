/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "SpringBoard/SpringBoard.h"

@interface Tile : UIView
{
	NSString *_leafIdentifier;
	NSString *_path;
	NSString *_displayIdentifier;
	
	NSDictionary *_tileInfo;
	
	UIImageView *_backgroundImageView;
	UIImageView *_tileImageView;
	UIWebDocumentView *_liveTileWebView;
	
	UILabel *_badgeLabel;
	UILabel *_appDisplayLabel;
	UIButton *_launchButton;
	
	id _delegate;
	int _appIndex;
}

@property (nonatomic, retain) NSString *_leafIdentifier;

-(id)initWithAppBundle:(id)app delegate:(id)delegate frame:(CGRect)frame appIndex:(int)index;
-(void)updateTileWithAppBundle:(id)app frame:(CGRect)frame appIndex:(int)index;
-(void)updateTileWithBadgeNumber:(int)num;
+(UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

@end