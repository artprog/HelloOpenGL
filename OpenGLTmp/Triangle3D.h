//
//  Triangle3D.h
//  OpenGLTmp
//
//  Created by SMT Software on 12.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "Vertex3D.h"

typedef struct
{
	Vertex3D v1;
	Vertex3D v2;
	Vertex3D v3;
} Triangle3D;

Triangle3D Triangle3DMake(Vertex3D v1, Vertex3D v2, Vertex3D v3);
