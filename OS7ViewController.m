/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "OS7ViewController.h"

@implementation OS7ViewController

-(UIView *)mainView{
	return mainView;
}

-(void)updateBadgeWithString:(id)badgeNumber app:(NSString *)leafId{
	for(id subView in tileScrollView.subviews)
		if([subView class] == [Tile class])
			if([[subView _leafIdentifier] isEqualToString:leafId])
				[subView updateTileWithBadgeNumber:[badgeNumber intValue]]; 
}

-(id)initWithWindow:(UIWindow *)w array:(NSMutableArray *)array{
	window = w;
	applications =array;
    
	tileScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    
	mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0,566,480)];
    mainView.opaque = YES;
	mainView.backgroundColor = [UIColor blackColor];
    appList = [[UIScrollView alloc] initWithFrame:CGRectMake(320,0,254,480)];
	appList.backgroundColor = [UIColor blackColor];
	[mainView addSubview:appList];
    [mainView addSubview:tileScrollView];
    
	if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/OS7/Background.png"]){
		UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
		bgView.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Background.png"];
		[mainView addSubview:bgView];
		[bgView release];
	}else
		[tileScrollView setBackgroundColor:[UIColor blackColor]];

    
	NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/LibHide/hidden.plist"];
	NSArray *hiddenArray = [plist valueForKey:@"Hidden"];

    int j = 0, i = 0;
	for(id app = [array objectAtIndex:0]; i<(int)array.count-1; i++, app = [array objectAtIndex:i])
		if(![hiddenArray containsObject:[app leafIdentifier]]){
			ApplicationListItem *listItem = [[ApplicationListItem alloc] initWithBundle:app delegate:self frame:CGRectMake(0,46*j+75,254,40) index:i];
			[appList addSubview:listItem];
			[listItem release];
            j++;
		}
	[plist release];
	[appList setContentSize:CGSizeMake(254, 46*j+75)];
	[window addSubview: mainView];
	
	toggleInterface = [[UIButton alloc] initWithFrame:CGRectMake(254,60,66,66)];
	[toggleInterface addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
	[toggleInterface setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/Arrow.png"] forState:UIControlStateNormal];
	[mainView addSubview:toggleInterface];
	[toggleInterface release];
	toggled = YES;
	
	appList.showsVerticalScrollIndicator = NO;
	
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLeft)];
    
    swipeLeft.direction = 2;
    [mainView addGestureRecognizer:swipeLeft];
    [swipeLeft release];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRight)];
    
    swipeRight.direction = 1;
    [mainView addGestureRecognizer:swipeRight];
    [swipeRight release];
    
    tileScrollView.showsHorizontalScrollIndicator = NO;
    tileScrollView.showsVerticalScrollIndicator = NO;
    
	[self updateTiles];
	
	return self;
}

-(void)launchWithBundle:(id)sender{
	[[applications objectAtIndex:[sender tag]] launch];
}

-(void)updateTiles{
    
    NSArray *tilesArray = [[NSArray alloc] initWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
    
    //remove old tiles
    for(id app in tileScrollView.subviews)
        if(![tilesArray containsObject:[app _leafIdentifier]]){
            [app removeFromSuperview];
            [app release];
        }
    
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
            if([[app _leafIdentifier] isEqualToString:bundleId]){
                
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
        Tile *tile = nil;
        
        //find the corresponding SBApplication
        for(int i = 0; i<(int)applications.count; i++)
            if([[[applications objectAtIndex:i] leafIdentifier] isEqualToString:bundleId]){
                if(isLarge && j%2!=0)j++;
                tile = [[Tile alloc] initWithAppBundle:[applications objectAtIndex:i] delegate:self 
                                                 frame:CGRectMake(j%2==0?13:136,123*(j/2)+75,isLarge?238:115,115) appIndex:i];
                break;
            }
        
        if(!tile)continue;
        
        [tileScrollView addSubview:tile];
        
        if(isLarge)j+=2;
        else j++;
        
    end:
        // this is here so that the compiler doesn't yell at me for
        // having a label at the end
        j = j;
    }
    [tileScrollView setContentSize:CGSizeMake(320, 123*((j+1)/2)+75)];
}

// the following lines of code are horribly written
// please excuse them, I was probably half asleep while
// I was writing them

- (void)pin:(UIButton *)sender{
	NSArray *ray = [NSArray arrayWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
	for(NSString* str in ray){
		if([[sender titleForState:UIControlStateNormal] isEqualToString:str]){
			[self unPin:sender];
			return;
		}
	}
	p=YES;
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:[sender titleForState:UIControlStateNormal]
                                  delegate:self 
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil 
                                  otherButtonTitles:@"Pin to Start Menu",nil];
    [actionSheet showInView:window];
    [actionSheet release];
}

-(void)unPin:(UIButton *)sender{
	p=NO;
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:[sender titleForState:UIControlStateNormal]
                                  delegate:self 
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil 
                                  otherButtonTitles:@"Unpin",@"Move up", @"Move down",nil];
    [actionSheet showInView:window];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
		switch(buttonIndex){
			case 0:{
				if(p){
					NSMutableArray *ray = [[NSMutableArray alloc] initWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
					[ray addObject:actionSheet.title];
					[ray writeToFile:@"/var/mobile/Library/OS7/Tiles.plist" atomically:YES];
					[ray release];
					[self updateTiles];
					[self toggle];
				}else{
					NSMutableArray *ray = [[NSMutableArray alloc] initWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
					[ray removeObject:actionSheet.title];
					[ray writeToFile:@"/var/mobile/Library/OS7/Tiles.plist" atomically:YES];
					[ray release];
					[self updateTiles];
				}
				break;
			}
			case 1:{
				NSMutableArray *ray = [[NSMutableArray alloc] initWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
				int i = [ray indexOfObject:actionSheet.title];
				if(i>0)
					i = i-1;
				[ray removeObjectAtIndex:[ray indexOfObject:actionSheet.title]];
				[ray insertObject:actionSheet.title atIndex:i];
				[ray writeToFile:@"/var/mobile/Library/OS7/Tiles.plist" atomically:YES];
				[ray release];
				[self updateTiles];
				break;
			}
			case 2:{
				NSMutableArray *ray = [[NSMutableArray alloc] initWithContentsOfFile:@"/var/mobile/Library/OS7/Tiles.plist"];
				int i = [ray indexOfObject:actionSheet.title];
				if(i>=0 && i<(int)[ray count]-1)
					i = i+1;
				[ray removeObjectAtIndex:[ray indexOfObject:actionSheet.title]];
				[ray insertObject:actionSheet.title atIndex:i];
				[ray writeToFile:@"/var/mobile/Library/OS7/Tiles.plist" atomically:YES];
				[ray release];
				[self updateTiles];
				break;
			}
		}
	}	
}

// End of horrible code

-(void)dealloc{
	for(Tile* subView in tileScrollView.subviews){
		[subView removeFromSuperview];[subView release];}
	[tileScrollView release];
	[appList release];
	[mainView removeFromSuperview];
	[mainView release];
	[super dealloc];
}

- (void)didTouchDown:(id)sender{
    [self performSelector:@selector(removeTarget:) withObject:sender afterDelay:0.5];
}

- (void)removeTarget:(UIButton*) sender {
	[sender removeTarget:self action:@selector(didTouchUp:) forControlEvents:UIControlEventTouchUpInside];
	[self pin:sender];
	[self performSelector:@selector(addTarget:) withObject:sender afterDelay:1.];
}

- (void) addTarget:(UIButton*)sender {
	[sender addTarget:self action:@selector(didTouchUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTouchUp:(id)sender{
	[[self class] cancelPreviousPerformRequestsWithTarget:self];
	[self launchWithBundle:sender];
}

-(void)toggleLeft{
	[[self class] cancelPreviousPerformRequestsWithTarget:self];
	if(toggled){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:.5];
		mainView.frame = CGRectMake(-254,0,574,480);
		CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
		toggleInterface.transform = transform;
		[UIView commitAnimations];
		toggled = NO;
		tileScrollView.userInteractionEnabled=NO;
	}
}

-(void)toggleRight{
	[[self class] cancelPreviousPerformRequestsWithTarget:self];
	if(!toggled){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:.5];
		mainView.frame = CGRectMake(0,0,574,480);
		CGAffineTransform transform = CGAffineTransformMakeRotation(0);
		toggleInterface.transform = transform;
		[UIView commitAnimations];
		toggled = YES;
		tileScrollView.userInteractionEnabled=YES;
	}
}
-(void)toggle{
	[[self class] cancelPreviousPerformRequestsWithTarget:self];
	if(toggled){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:.5];
		mainView.frame = CGRectMake(-254,0,574,480);
		CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
		toggleInterface.transform = transform;
		[UIView commitAnimations];
		toggled = NO;
		tileScrollView.userInteractionEnabled=NO;
	}else{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:.5];
		mainView.frame = CGRectMake(0,0,574,480);
		CGAffineTransform transform = CGAffineTransformMakeRotation(0);
		toggleInterface.transform = transform;
		[UIView commitAnimations];
		toggled = YES;
		tileScrollView.userInteractionEnabled=YES;
	}
}

@end