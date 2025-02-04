﻿module wavefront.obj;

import utga;
import std.conv;
import std.stdio;
import std.array;
import std.algorithm;

public import wavefront.geometry;

struct Face
{
	int v;
	int t;
	int n;
}

class Model
{
private:
	Vec2f[] textures_;
	Vec3f[] verts_;
	Face[][] faces_;

public:

	this(string filename)
	{
		auto f = File(filename, "r");
		foreach (line; f.byLine) {
			if (line.startsWith("v ")) {
				Vec3f v;
				v.raw = line[2..$].splitter.map!(to!float).array;
				verts_ ~= v;
			}
			else if (line.startsWith("vt ")){
				Vec2f t;
				t.raw = line[2..$].splitter.map!(to!float).array;
				textures_ ~= t;
			}
			else if (line.startsWith("f ")) {
				Face tmp;
				Face[] face;
				foreach (pol; line[2..$].splitter)
				{
					tmp.v = to!int(pol.splitter("/").array[0]) - 1;
					tmp.t = to!int(pol.splitter("/").array[1]) - 1;
					tmp.n = to!int(pol.splitter("/").array[2]) - 1;
					face ~= tmp;
				}
				faces_ ~= face;
			}
		}
		stderr.writefln("# v# %d t# %d f# %d", verts_.length, textures_.length, faces_.length);
	}

	@property
	auto nverts()
	{
		return verts_.length;
	}

	@property
	auto nfaces()
	{
		return faces_.length;
	}

	@property
	auto ntextures()
	{
		return textures_.length;
	}

	auto face(int idx)
	{
		return faces_[idx];
	}

	auto vert(int idx)
	{
		return verts_[idx];
	}

	auto texture(int idx)
	{
		return textures_[idx];
	}

	@property
	auto faces()
	{
		return faces_;
	}

	@property
	auto textures()
	{
		return textures_;
	}
}