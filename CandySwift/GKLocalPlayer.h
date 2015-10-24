//
//  GKLocalPlayer.h
//  CandySwift
//
//  Created by Max on 29/07/14.
//  Copyright (c) 2014 MaxHype. All rights reserved.
//

#import <GameKit/GameKit.h>

//must use ObjC function to get local player cause Apple bug in Swift localplayer, see: http://stackoverflow.com/questions/24045244/game-center-not-authenticating-using-swift

GKLocalPlayer *getLocalPlayer(void);