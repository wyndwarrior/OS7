/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "OS7.h"

@implementation OS7
@synthesize applications, mainView;
static OS7* sharedInstance;

-(void)updateBadge:(NSString *)leafId{
	for(id subView in tileScrollView.subviews)
        if([subView isKindOfClass:[OS7Tile class]] && [[subView leafIdentifier] isEqualToString:leafId])
            [subView updateBadge];
}

-(id)initWithWindow:(UIWindow *)_window array:(NSMutableArray *)_apps{
    
    self = [super init];
    sharedInstance = self;
    if(self)
    {
        [[objc_getClass("DreamBoard") sharedInstance] hideAllExcept:nil];
        window =            _window;
        applications =      _apps;
        
        //create views
        tileScrollView =    [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,480)];
        mainView =          [[UIView alloc] initWithFrame:CGRectMake(0,0,574,480)];
        mainView.opaque = YES;
        mainView.backgroundColor = [UIColor blackColor];
        appList =           [[UIScrollView alloc] initWithFrame:CGRectMake(320,0,254,480)];
        [mainView addSubview:appList];
        [mainView addSubview:tileScrollView];
        
        //add background
        if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/OS7/Background.png"])
        {
            UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
            bgView.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Background.png"];
            [mainView insertSubview:bgView atIndex:0];
            [bgView release];
        }
        
        //add listapps to the applist
        for(int i = 0; i<(int)applications.count; i++){
            OS7ListApp *listApp = [[OS7ListApp alloc] initWithFrame:CGRectMake(0,46*i+75,254,40) index:i];
            [appList addSubview:listApp];
            [listApp release];
            [appList setContentSize:CGSizeMake(254, 46*(i+1)+75)];
        }
        
        
        //add the arrow
        toggleInterface = [[UIButton alloc] initWithFrame:CGRectMake(254,60,66,66)];
        [toggleInterface addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        [toggleInterface setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/Arrow.png"] forState:UIControlStateNormal];
        [mainView addSubview:toggleInterface];
        [toggleInterface release];
        toggled = YES;
	
        //make sure there are no scrollbars
        appList.showsVerticalScrollIndicator = NO;
        tileScrollView.showsVerticalScrollIndicator = NO;
        
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        swipe.direction = 1;
        [mainView addGestureRecognizer:swipe];
        [swipe release];
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        swipe.direction = 2;
        [mainView addGestureRecognizer:swipe];
        [swipe release];
        
        [self updateTiles];
        [window addSubview:mainView];
    }
	return self;
}

-(void)updateTiles{
    
    NSArray *tilesArray = [[NSArray alloc] initWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
    
    //remove old tiles
    for(id app in tileScrollView.subviews)
        if([app isKindOfClass:[OS7Tile class]] && ![tilesArray containsObject:[app leafIdentifier]])
            [app removeFromSuperview];
    
    int i = 0, j = 0;
    for(; i<(int)tilesArray.count; i++){
        NSString *bundleId = [tilesArray objectAtIndex:i];
        
        //see if this tile is large
        BOOL isLarge = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Info.plist", bundleId]]){
            NSDictionary *info = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Info.plist", bundleId]];
            if([[info allKeys] containsObject:@"isLargeTile"])
                isLarge = [[info valueForKey:@"isLargeTile"] isEqualToString:@"YES"];
            [info release];
        }
        
        //find our tile, if it's there
        for (id app in tileScrollView.subviews)
            if([app isKindOfClass:[OS7Tile class]] && [[app leafIdentifier] isEqualToString:bundleId]){
                
                if(isLarge && j%2!=0)j++;
                
                //if we find our tiles, update it's positioning.
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:.5];
                [app setFrame:CGRectMake(j%2==0?13:136,123*(j/2)+75,isLarge?238:115,115)];
                [UIView commitAnimations];
                
                if(isLarge)j+=2;
                else j++;
                
                goto end;
            }
        
        //we didn't find our tile, so let's add it.
        OS7Tile *tile = nil;
        
        //find the corresponding SBApplication
        for(int i = 0; i<(int)applications.count; i++)
            if([[[applications objectAtIndex:i] leafIdentifier] isEqualToString:bundleId]){
                if(isLarge && j%2!=0)j++;
                tile = [[OS7Tile alloc] initWithFrame:CGRectMake(j%2==0?13:136,123*(j/2)+75,isLarge?238:115,115) appIndex:i];
                break;
            }
        
        if(!tile)continue;
        
        [tileScrollView addSubview:tile];
        [tile release];
        
        if(isLarge)j+=2;
        else j++;
        
    end:
        // this is here so that the compiler doesn't yell at me for
        // having a label at the end
        j = j;
    }
    [tileScrollView setContentSize:CGSizeMake(320, 123*((j+1)/2)+75)];
}


-(void)dealloc{
	[tileScrollView release];
	[appList release];
	[mainView removeFromSuperview];
	[mainView release];
    [[objc_getClass("DreamBoard") sharedInstance] showAllExcept:nil];
	[super dealloc];
}

-(void)didSwipe:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction==1 && !toggled)[self toggle];
    else if(recognizer.direction==2 && toggled)[self toggle];
}

-(void)toggle{
    [[objc_getClass("DreamBoard") sharedInstance] hideAllExcept:mainView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    if(toggled){
        mainView.frame = CGRectMake(-254,0,574,480);
        toggleInterface.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        mainView.frame = CGRectMake(0,0,574,480);
        toggleInterface.transform = CGAffineTransformMakeRotation(0);
    }
    [UIView commitAnimations];
    toggled^=1;
}

-(void)didHold:(id)sender{
    if([sender isKindOfClass:[OS7Tile class]]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[[applications objectAtIndex:[sender tag]] leafIdentifier] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Unpin", @"Move Up", @"Move Down",nil];
        [actionSheet showInView:window];
        [actionSheet release];
    }else if([sender isKindOfClass:[OS7ListApp class]]){
        NSArray *tilesArray = [[NSArray alloc] initWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
        if(![tilesArray containsObject:[[applications objectAtIndex:[sender tag]] leafIdentifier]]){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[[applications objectAtIndex:[sender tag]] leafIdentifier] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Pin to Start Menu",nil];
            [actionSheet showInView:window];
            [actionSheet release];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSString *leafIdentifier = [actionSheet title];
    NSMutableArray *ray = [[NSMutableArray alloc] initWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
    if([title isEqualToString:@"Unpin"])[ray removeObject:leafIdentifier];
    else if([title isEqualToString:@"Move Up"]){
        int i = [ray indexOfObject:leafIdentifier];
        i = i==0?0:i-1;
        [ray removeObject:leafIdentifier];
        [ray insertObject:actionSheet.title atIndex:i];
    }else if([title isEqualToString:@"Move Down"]){
        int i = [ray indexOfObject:leafIdentifier];
        i = i==(int)ray.count-1?(int)ray.count-1:i+1;
        [ray removeObject:leafIdentifier];
        [ray insertObject:actionSheet.title atIndex:i];
    }else if([title isEqualToString:@"Pin to Start Menu"])
        [ray addObject:leafIdentifier];

    [ray writeToFile:@"/var/mobile/Library/OS7/Tiles.plist" atomically:YES];
    [ray release];
    
    [self updateTiles];
    
    if([title isEqualToString:@"Pin to Start Menu"] && !toggled)[self toggle];
}


+(OS7*)sharedInstance{
    return sharedInstance;
}

+(UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage{
    
	CGImageRef maskRef = maskImage.CGImage; 
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
	return [UIImage imageWithCGImage:masked];
    
}

@end