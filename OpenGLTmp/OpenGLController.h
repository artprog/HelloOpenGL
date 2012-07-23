//
//  OpenGLController.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 10.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@class APOpenGLScene;
@class APOpenGLObject;

@interface OpenGLController : UIViewController
{
	@private
	APOpenGLScene *_scene;
	APOpenGLObject *_object;
}

@end
