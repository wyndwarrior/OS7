#import "OS7ListApp.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation OS7ListApp

-(id)initWithFrame:(CGRect)frame index:(int)index{
	self = [super initWithFrame:frame];
	
    if(self){
        id app = [[[OS7 sharedInstance] applications] objectAtIndex:index];
        NSString *leafIdentifier = [app leafIdentifier];
        NSString *name = [app displayName];
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
        background.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/Background.png"];
        [self addSubview:background];
        [background release];
        
        UIImageView *imgView;
        if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/MiniTile.png", leafIdentifier]]){
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
            imgView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/MiniTile.png", leafIdentifier]];
        }else{
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-5,-5, 49, 49)];
            imgView.image = [OS7 maskImage:[app getIconImage:2] withMask:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconMask.png"]];
        }
        [self addSubview:imgView];
        [imgView release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50,10,204,20)];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = UIColorFromRGB(0xDDDDDD);
        label.text = name;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        [label release];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [btn addTarget:self action:@selector(launch:) forControlEvents:UIControlEventTouchUpInside];
        self.tag = index;
        btn.tag = index;
        UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didHold:)];    
        [btn addGestureRecognizer:recognizer];
        [recognizer release];
        [self addSubview:btn];
        self.clipsToBounds = YES;
        [btn release];
    }
	
	return self;
}

- (void)didHold:(UILongPressGestureRecognizer *)sender { 
    if (sender.state ==1)[[OS7 sharedInstance] didHold:self];
}

-(void)launch:(id)sender{
    [[[[OS7 sharedInstance] applications] objectAtIndex:[sender tag]] launch];
}

@end
