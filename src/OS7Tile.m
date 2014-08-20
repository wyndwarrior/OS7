/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "OS7Tile.h"

@implementation OS7Tile

@synthesize leafIdentifier;

-(id)initWithFrame:(CGRect)frame appIndex:(int)index{
	self = [super initWithFrame:frame];
    if(self)
    {
        id app = [[[OS7 sharedInstance] applications] objectAtIndex:index];
        appIndex = index;
        self.leafIdentifier = [app leafIdentifier];
        
        
        //background image
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
        bgImageView.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/Background.png"];
        [self addSubview:bgImageView];
        [bgImageView release];
        
        //check if tile has an info.plist
        if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Info.plist", leafIdentifier]]){
            //load our plist
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Info.plist", leafIdentifier]];
            
            //check if uses html
            if([dict objectForKey:@"usesHTML"] && [[dict objectForKey:@"usesHTML"] isEqualToString:@"YES"]){
                if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/%@", leafIdentifier, [dict objectForKey:@"widgetFile"]]]){
                    
                    //load the html
                    UIWebDocumentView *webView = [[UIWebDocumentView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
                    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/%@", leafIdentifier, [dict objectForKey:@"widgetFile"]]]]];
                    [webView setBackgroundColor:[UIColor clearColor]];
                    [webView setDrawsBackground:NO];
                    [self addSubview:webView];
                    [webView release];
                }
            }
            else
            {
                //otherwise load the tile image
                tileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
                tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Tile.png", leafIdentifier]];
                [self addSubview:tileImageView];
                [tileImageView release];
            }

            //name label
            UILabel *appDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.5,98,105,14)];
            appDisplayLabel.font = [UIFont boldSystemFontOfSize:13];
            appDisplayLabel.textColor = [UIColor whiteColor];
            appDisplayLabel.text = [app displayName];
            appDisplayLabel.backgroundColor = [UIColor clearColor];

            //custom name
            if([dict objectForKey:@"displayName"])
                appDisplayLabel.text = [dict objectForKey:@"displayName"];
            
            [self addSubview:appDisplayLabel];
            [appDisplayLabel release];
            [dict release];
        }
        else
        {
            NSArray *splited = [[[app application] path] componentsSeparatedByString: @"/"];
            tileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.5,27.5, 60, 60)];
            
            //if this is an app store app, it will have a large itunesartwork
            if([[splited objectAtIndex:1] isEqualToString:@"private"]){
                tileImageView.frame = CGRectMake(-17.5,-17.5, 150, 150);
                tileImageView.image = [OS7 maskImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@iTunesArtwork", [[[app application] path] substringWithRange:NSMakeRange(0, 70)]]] withMask:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/BigIconMask.png"]];
                [self addSubview:tileImageView];
            }
            else{
                tileImageView.image = [OS7 maskImage:[app getIconImage:2] withMask:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconMask.png"]];
                [self addSubview:tileImageView];
                
                UIImageView *over = [[UIImageView alloc] initWithFrame:CGRectMake(27.5,27.5, 60, 60)];
                over.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconOverlay.png"];
                [self addSubview:over];
                [over release];
            }
            [tileImageView release];
            
            //name label
            UILabel *appDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.5,98,105,14)];
            appDisplayLabel.font = [UIFont boldSystemFontOfSize:13];
            appDisplayLabel.textColor = [UIColor whiteColor];
            appDisplayLabel.text = [app displayName];
            appDisplayLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:appDisplayLabel];
            [appDisplayLabel release];
        }
        
        UIButton *launchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [launchButton addTarget:self action:@selector(launch) forControlEvents:UIControlEventTouchUpInside];
        if(frame.size.width==115)
            [launchButton setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/TileOverlay.png"] forState:UIControlStateNormal];
        self.tag = index;
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didHold:)];    
        [launchButton addGestureRecognizer:recognizer];
        [recognizer release];
        [self addSubview:launchButton];
        [launchButton release];
        
        [self updateBadge];
        
        self.clipsToBounds = YES;
	}
	return self;
}

- (void)didHold:(UILongPressGestureRecognizer *)sender { 
    NSLog(@"Recieved Hold:%d", sender.state);
    if (sender.state == 1)[[OS7 sharedInstance] didHold:self];
}

-(void)dealloc{
    [leafIdentifier release];
	[super dealloc];
}

-(void)updateBadge{
    int num = (int)[[[[OS7 sharedInstance] applications] objectAtIndex:appIndex] badgeValue];
	if(num == 0 && !badgeLabel) return;
	if(!badgeLabel){
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Info.plist", leafIdentifier]];
		if(dict && [dict objectForKey:@"badgeX"]){
			badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake([[dict objectForKey:@"badgeX"] intValue],[[dict objectForKey:@"badgeY"] intValue],110,[[dict valueForKey:@"badgeHeight"] intValue])];
			badgeLabel.font = [UIFont systemFontOfSize:[[dict objectForKey:@"badgeFontSize"] intValue]];
			badgeLabel.textAlignment = UITextAlignmentLeft;
		}else{
			badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5,110,20)];
			badgeLabel.font = [UIFont boldSystemFontOfSize:20];
			badgeLabel.textAlignment = UITextAlignmentRight;
		}
		badgeLabel.textColor = [UIColor whiteColor];
		badgeLabel.text = [NSString stringWithFormat:@"%d", num];
		badgeLabel.backgroundColor = [UIColor clearColor];
		if(tileImageView && dict && [dict objectForKey:@"badgeX"])
			tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/TileWithBadge.png", leafIdentifier]];
		[self addSubview:badgeLabel];
        [dict release];
	}else if(num == 0){
		[badgeLabel removeFromSuperview];
		[badgeLabel release];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Info.plist", leafIdentifier]];
		if(tileImageView && dict && [dict objectForKey:@"badgeX"])
			tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Tile.png", leafIdentifier]];
		badgeLabel = nil;
        [dict release];
	}else badgeLabel.text = [NSString stringWithFormat:@"%d", num];
}

-(void)launch{
    [[[[OS7 sharedInstance] applications] objectAtIndex:appIndex] launch];
}

@end
