/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "ApplicationListItem.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// this is a rather simple class with 
// only a label, an image, and a button.
// nothing too interesting

@implementation ApplicationListItem

-(id)initWithBundle:(id)app delegate:(id)d frame:(CGRect)frame index:(int)index{
	[super initWithFrame:frame];
	
	NSString *str = [app leafIdentifier];
	NSString *name = [app displayName];
	NSString *path = [[app application] path];
	
	UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
	background.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/Background.png"];
	[self addSubview:background];
	
	UIImageView *imgView = nil;
	if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/MiniTile.png", str]]){
		imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
		imgView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/MiniTile.png", str]];
		[self addSubview:imgView];
	}else{
		if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Icon.png", path]]){
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-5,-5, 49, 49)];
			imgView.image = [Tile maskImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon.png", path]] withMask:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconMask.png"]];
			[self addSubview:imgView];
		}else if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/icon.png", path]]){
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-5,-5, 49, 49)];
			imgView.image = [Tile maskImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/icon.png", path]] withMask:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconMask.png"]];
			[self addSubview:imgView];
		}else{
			imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
			imgView.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/NoIcon.png"];
			[self addSubview:imgView];
		}
	}
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50,10,204,20)];
	label.font = [UIFont systemFontOfSize:18];
	label.textColor = UIColorFromRGB(0xDDDDDD);
	label.text = name;
	label.backgroundColor = [UIColor clearColor];
	[self addSubview:label];
	
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
	[btn addTarget:d action:@selector(didTouchDown:) forControlEvents:UIControlEventTouchDown];
	[btn addTarget:d action:@selector(didTouchUp:) forControlEvents:UIControlEventTouchUpInside];
	[btn setTitle:str forState:UIControlStateNormal];
	btn.titleLabel.alpha = 0;
	btn.tag = index;
	
	[self addSubview:btn];
	self.bounds = CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame));
	self.clipsToBounds = YES;
	
	[background release];
	[label release];
	[btn release];
	[imgView release];
	
	return self;
}

@end
