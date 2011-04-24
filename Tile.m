/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "Tile.h"

@implementation Tile

@synthesize _leafIdentifier;

-(id)initWithAppBundle:(id)app delegate:(id)delegate frame:(CGRect)frame appIndex:(int)index{
	[super initWithFrame:frame];
	_delegate = delegate;
	[self updateTileWithAppBundle:app frame:frame appIndex:index];
	
	self.bounds = CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame));
	self.clipsToBounds = YES;
	
	return self;
}


// I had originally planned tiles to be reuseable, but
// unforutnately that didn't go too well so I didn't 
// bother to change the prewritten methods I already
// had


-(void)updateTileWithAppBundle:(id)app frame:(CGRect)frame appIndex:(int)index{
    
	_leafIdentifier = [app leafIdentifier];
	_path = [[app application] path];
	_displayIdentifier = [app displayName];
	_appIndex = index;
	
	for(UIView *subView in self.subviews){
		[subView removeFromSuperview];
	}
	
	if(_tileInfo){
		[_tileInfo release];
		_tileInfo = nil;
	}
	
	if(_backgroundImageView){
		[_backgroundImageView release];
		_backgroundImageView = nil;
	}
	
	if(_tileImageView){
		[_tileImageView release];
		_tileImageView = nil;
	}
	
	if(_badgeLabel){
		[_badgeLabel release];
		_badgeLabel = nil;
	}
	
	if(_appDisplayLabel){
		[_appDisplayLabel release];
		_appDisplayLabel = nil;
	}
	
	if(_launchButton){
		[_launchButton release];
		_launchButton = nil;
	}
	
	_backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
	_backgroundImageView.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/Background.png"];
	[self addSubview:_backgroundImageView];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Info.plist", _leafIdentifier]]){
		_tileInfo = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Info.plist", _leafIdentifier]];
		
		if([[_tileInfo allKeys] containsObject:@"usesHTML"] && [[_tileInfo valueForKey:@"usesHTML"] isEqualToString:@"YES"]){
			NSString *widgetString = [_tileInfo valueForKey:@"widgetFile"];
			if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/%@", _leafIdentifier, widgetString]]){
				_liveTileWebView = [[[UIWebDocumentView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(frame), CGRectGetHeight(frame))] autorelease];
				[_liveTileWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/%@", _leafIdentifier, widgetString]]]];
				[_liveTileWebView setBackgroundColor:[UIColor clearColor]];
				[_liveTileWebView setDrawsBackground:NO];
				[self addSubview:_liveTileWebView];
			}
		}
		else
		{
			_tileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
			_tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Tile.png", _leafIdentifier]];
			[self addSubview:_tileImageView];
		}
		
		[self updateTileWithBadgeNumber:(int)[app badgeValue]];
		
		_appDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.5,98,105,14)];
		_appDisplayLabel.font = [UIFont boldSystemFontOfSize:13];
		_appDisplayLabel.textColor = [UIColor whiteColor];
		_appDisplayLabel.text = _displayIdentifier;
		_appDisplayLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_appDisplayLabel];
		
		if([[_tileInfo allKeys] containsObject:@"displayName"])
			_appDisplayLabel.text = [_tileInfo valueForKey:@"displayName"];
		
		_launchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
		[_launchButton addTarget:_delegate action:@selector(didTouchDown:) forControlEvents:UIControlEventTouchDown];
		[_launchButton addTarget:_delegate action:@selector(didTouchUp:) forControlEvents:UIControlEventTouchUpInside];
		if(CGRectGetWidth(frame)==115)
			[_launchButton setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/TileOverlay.png"] forState:UIControlStateNormal];
		[_launchButton setTitle:_leafIdentifier forState:UIControlStateNormal];
		_launchButton.titleLabel.alpha = 0;
		_launchButton.tag = index;
		[self addSubview:_launchButton];
		
	}else{
		NSArray *splited = [_path componentsSeparatedByString: @"/"];
		_tileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.5,27.5, 60, 60)];
		
		if([[splited objectAtIndex:1] isEqualToString:@"private"]){
			
			_tileImageView.frame = CGRectMake(-17.5,-17.5, 150, 150);
			_tileImageView.image = [Tile maskImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@iTunesArtwork", [_path substringWithRange:NSMakeRange(0, 70)]]] withMask:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/BigIconMask.png"]];
			[self addSubview: _tileImageView];
			
		}
		else if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Icon.png", _path]])
		{
			_tileImageView.image = [Tile maskImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon.png", _path]] withMask:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconMask.png"]];
			[self addSubview: _tileImageView];
			
			UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(27.5,27.5, 60, 60)];
			shadow.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconOverlay.png"];
			[self addSubview:shadow];
			[shadow release];
			
		}
		else if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/icon.png", _path]])
		{
            
			_tileImageView.image = [Tile maskImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/icon.png", _path]] withMask:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconMask.png"]];
			[self addSubview:_tileImageView];
			
			UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(27.5,27.5, 60, 60)];
			shadow.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/IconOverlay.png"];
			[self addSubview:shadow];
			[shadow release];
			
		}
		else
		{
			NSDictionary *tempInfo = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Info.plist", _path]];
			
			if([[tempInfo allKeys] containsObject:@"CFBundleIconFile"]){
				_tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", _path, [tempInfo objectForKey:@"CFBundleIconFile"]]];
				[self addSubview:_tileImageView];
			}else{		
				_tileImageView.image = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/NoIcon.png"];
				[self addSubview:_tileImageView];
			}
			
			[tempInfo release];
		}
		
		_appDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.5,98,105,14)];
		_appDisplayLabel.font = [UIFont boldSystemFontOfSize:13];
		_appDisplayLabel.textColor = [UIColor whiteColor];
		_appDisplayLabel.text = _displayIdentifier;
		_appDisplayLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_appDisplayLabel];
		
		[self updateTileWithBadgeNumber:(int)[app badgeValue]];
		
		_launchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
		[_launchButton addTarget:_delegate action:@selector(didTouchDown:) forControlEvents:UIControlEventTouchDown];
		[_launchButton addTarget:_delegate action:@selector(didTouchUp:) forControlEvents:UIControlEventTouchUpInside];
		[_launchButton setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/OS7/Images/TileOverlay.png"] forState:UIControlStateNormal];
		[_launchButton setTitle:_leafIdentifier forState:UIControlStateNormal];
		_launchButton.titleLabel.alpha = 0;
		_launchButton.tag = index;
		[self addSubview:_launchButton];
		
	}
	
	
	
	
}

-(void)dealloc{
	if(_tileInfo){
		[_tileInfo release];
		_tileInfo = nil;
	}
	
	if(_backgroundImageView){
		[_backgroundImageView release];
		_backgroundImageView = nil;
	}
	
	if(_tileImageView){
		[_tileImageView release];
		_tileImageView = nil;
	}
	
	if(_badgeLabel){
		[_badgeLabel release];
		_badgeLabel = nil;
	}
	
	if(_appDisplayLabel){
		[_appDisplayLabel release];
		_appDisplayLabel = nil;
	}
	
	if(_launchButton){
		[_launchButton release];
		_launchButton = nil;
	}
	[super dealloc];
}

-(void)updateTileWithBadgeNumber:(int)num{
	if(num == 0 && !_badgeLabel)
		return;
	else if(!_badgeLabel){
		if(_tileInfo && [[_tileInfo allKeys] containsObject:@"badgeX"]){
			_badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake([[_tileInfo valueForKey:@"badgeX"] intValue],[[_tileInfo valueForKey:@"badgeY"] intValue],110,[[_tileInfo valueForKey:@"badgeHeight"] intValue])];
			_badgeLabel.font = [UIFont systemFontOfSize:[[_tileInfo valueForKey:@"badgeFontSize"] intValue]];
			_badgeLabel.textAlignment = UITextAlignmentLeft;
		}else{
			_badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5,110,20)];
			_badgeLabel.font = [UIFont boldSystemFontOfSize:20];
			_badgeLabel.textAlignment = UITextAlignmentRight;
		}
		_badgeLabel.textColor = [UIColor whiteColor];
		_badgeLabel.text = [NSString stringWithFormat:@"%d", num];
		_badgeLabel.backgroundColor = [UIColor clearColor];
		if(_tileImageView && _tileInfo && [[_tileInfo allKeys] containsObject:@"badgeX"])
			_tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/TileWithBadge.png", _leafIdentifier]];
		[self addSubview:_badgeLabel];
	}else if(num == 0){
		[_badgeLabel removeFromSuperview];
		[_badgeLabel release];
		if(_tileImageView && _tileInfo && [[_tileInfo allKeys] containsObject:@"badgeX"])
			_tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/OS7/Tiles/%@/Tile.png", _leafIdentifier]];
		_badgeLabel = nil;
	}else{
		_badgeLabel.text = [NSString stringWithFormat:@"%d", num];
	}
}


// mask method thanks to stackoverflow

+(UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage{
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
