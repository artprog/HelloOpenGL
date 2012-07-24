//
//  APOpenGLObject.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@class APOpenGLParser;
@class APOpenGLProgram;

/**
 \class APOpenGLObject is an abstract class, which delivers a base interface
 that allow to create load and render single 3D model.
 
 \see APOpenGLDefaultModel
 */
@interface APOpenGLObject : NSObject
{
	@protected
	BOOL _isLoaded;
	APOpenGLProgram *_program;
}

/// Default initializer.
- (id)init;

/// Method used to create a GLSL program.
/// 
/// A default implemantation does
/// nothing. You should override this method to create, compile and link
/// your own program. The program should be a subclass of
/// \class APOpenGLProgram class.\n
/// After successfully linking the program you should also get the indices
/// of used attributes.
- (void)createProgram;

/// Returns an instance of \class APOpenGLParser class.
/// 
/// Default implementation returns nil.
- (APOpenGLParser*)createParser;

/// Informs if 3D model has been already loaded into memory.
- (BOOL)isLoaded;

/// Loads 3D model into memory.
/// 
/// If the model has been already loaded, this methods does nothing.
/// Otherwise it creates an instance of \class APOpenGLParser class using
/// \e createParser method and load the 3D model into memory.
- (void)load;

/// Unloads 3D model and frees memory.
///
/// If the model hasn't been loaded yet, this method does nothing.
- (void)unload;

/// Draws object.
///
/// This method is called by the \class APOpenGLRenderer class and you
/// shouldn't call this method directly.
- (void)render;

@end
