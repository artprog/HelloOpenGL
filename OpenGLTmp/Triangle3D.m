//
//  Triangle3D.m
//  OpenGLTmp
//
//  Created by SMT Software on 12.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "Triangle3D.h"

Triangle3D Triangle3DMake(Vertex3D v1, Vertex3D v2, Vertex3D v3)
{
	Triangle3D triangle;
	triangle.v1 = v1;
	triangle.v2 = v2;
	triangle.v3 = v3;
	return triangle;
}
