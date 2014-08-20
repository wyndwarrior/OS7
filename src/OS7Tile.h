#import "OS7.h"
#import "Headers/UIWebDocumentView.h"
#import "Headers/SBApplicationIcon.h"

@interface OS7Tile : UIView
{
	NSString *leafIdentifier;
    int appIndex;
    
	UILabel *badgeLabel;
    UIImageView *tileImageView;
}

@property (nonatomic, retain) NSString *leafIdentifier;

-(id)initWithFrame:(CGRect)frame appIndex:(int)index;
-(void)updateBadge;
-(void)launch;

@end