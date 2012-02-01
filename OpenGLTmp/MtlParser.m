//
//  MtlParser.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 26.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "MtlParser.h"

Material MaterialMakeZero(void)
{
	Material material;
	
	material.Ns = -1.f;
	material.ambient = ColorMake(0, 0, 0, 1);
	material.diffuse = material.ambient;
	material.specular = material.ambient;
	material.Ni = material.Ns;
	material.d = material.Ns;
	material.illum = -1;
	memset(material.map_Kd, 0, sizeof(material.map_Kd));
	memset(material.name, 0, sizeof(material.name));
	
	return material;
}

@interface MtlParser ()
- (void)readNewMtl:(const char*)name file:(FILE*)file;
@end

@implementation MtlParser

@synthesize materials = _materials;

- (id)initWithFile:(NSString*)path
{
	if ( (self = [super init]) )
	{
		_filePath = [path copy];
		_materials = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_filePath release];
	[_materials release];
	
	[super dealloc];
}

- (void)parse
{
	[_materials removeAllObjects];
	
	FILE *file = fopen([_filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
	char line[256];
	char identifier[256];
	char name[256];
	while ( fgets(line, sizeof(line), file) )
	{
		sscanf(line, "%s", identifier);
		if ( strcmp(identifier, "newmtl") == 0 )
		{
			sscanf(line, "newmtl %s", name);
			[self readNewMtl:name file:file];
			continue;
		}
	}
	fclose(file);
}

#pragma mark -
#pragma mark MtlParser ()

- (void)readNewMtl:(const char*)name file:(FILE*)file
{
	Material material = MaterialMakeZero();
	strcpy(material.name, name);
	
	char line[256];
	char identifier[256];
	BOOL firstEmptyLine = NO;
	while ( fgets(line, sizeof(line), file) )
	{
		if ( strcmp(line, "\n") == 0 || strcmp(line, "\r\n") == 0 )
		{
			if ( firstEmptyLine )
			{
				break;
			}
			firstEmptyLine = YES;
			continue;
		}
		else
		{
			firstEmptyLine = NO;
		}
		sscanf(line, "%s", identifier);
		if ( strcmp(identifier, "Ns") == 0 )
		{
			sscanf(line, "Ns %f", &material.Ns);
			continue;
		}
		if ( strcmp(identifier, "Ka") == 0 )
		{
			sscanf(line, "Ka %f %f %f", &material.ambient.red, &material.ambient.green, &material.ambient.blue);
			continue;
		}
		if ( strcmp(identifier, "Kd") == 0 )
		{
			sscanf(line, "Kd %f %f %f", &material.diffuse.red, &material.diffuse.green, &material.diffuse.blue);
			continue;
		}
		if ( strcmp(identifier, "Ks") == 0 )
		{
			sscanf(line, "Ks %f %f %f", &material.specular.red, &material.specular.green, &material.specular.blue);
			continue;
		}
		if ( strcmp(identifier, "Ni") == 0 )
		{
			sscanf(line, "Ni %f", &material.Ni);
			continue;
		}
		if ( strcmp(identifier, "d") == 0 )
		{
			sscanf(line, "d %f", &material.d);
			continue;
		}
		if ( strcmp(identifier, "illum") == 0 )
		{
			sscanf(line, "illum %f", &material.illum);
			continue;
		}
		if ( strcmp(identifier, "map_Kd") == 0 )
		{
			sscanf(line, "map_Kd %s", material.map_Kd);
			continue;
		}
	}
	if ( strlen(material.name) > 0 )
	{
		[_materials setObject:[NSValue valueWithBytes:&material objCType:@encode(Material)] forKey:[NSString stringWithCString:material.name encoding:NSUTF8StringEncoding]];
	}
}

@end
