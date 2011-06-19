/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import <SpringBoard/SpringBoard.h>
#import "DreamBoard.h"
#import "OS7.h"

OS7 *os7;

%hook SBApplicationIcon
-(void)setBadge:(NSString*)badge{
	%orig(badge);
    //update badges
	if(os7)[os7 updateBadge:[self leafIdentifier]];
}
%end

%hook DreamBoard
-(void)loadTheme:(NSString *)theme{
    if([theme isEqualToString:@"OS7"] && os7)return;
    
    
    //there are then two instances to check, switching to and from OS7
    //check switching from OS7
    if(os7!=nil && ![theme isEqualToString:@"OS7"])
    {
        //get rid of OS7
        [self unloadTheme];
        [self save:@"Default"];
        %orig(theme);
    }
    
    //check switching to OS7
    else if(os7==nil && [theme isEqualToString:@"OS7"])
    {
        if(![self.currentTheme isEqualToString:@"Default"])[self unloadTheme];
		os7 = [[OS7 alloc] initWithWindow:[self window] array:[self appsArray]];
		[self save:@"OS7"];
        [self showAllExcept:nil];
        [self window].userInteractionEnabled = YES;
	}
    
    //otherwise just do the original method
    else %orig(theme);
}

-(void)unloadTheme{
    //unload OS7 if it's loaded
	if(os7)
    {
		[os7 release];
		os7 = nil;
	}
    else %orig;
}

-(NSString*)currentTheme{
    if(os7)return @"OS7";
    return %orig;
}

- (void)toggleSwitcher{
    if(os7)
    {
        CGRect frame = os7.mainView.frame;
        
        //animate our mainview sliding up
        if(os7.mainView.frame.origin.y==0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.25];
            os7.mainView.frame = CGRectMake(frame.origin.x,-93,frame.size.width,frame.size.height);
            [UIView commitAnimations];
            [[objc_getClass("DreamBoard") sharedInstance] showAllExcept:nil];
        }
        
        //otherwise hide it
        else [self hideSwitcher];
    }
    else %orig;
}

-(void)hideSwitcher{
    if(os7)
    {
        CGRect frame = os7.mainView.frame;
        
        //animate our mainview sliding down
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.25];
        os7.mainView.frame = CGRectMake(frame.origin.x,0,frame.size.width,frame.size.height);
        [UIView commitAnimations];
        [[objc_getClass("DreamBoard") sharedInstance] hideAllExcept:os7.mainView];
    }
    else %orig;
}

%end