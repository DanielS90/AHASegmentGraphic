//
//  DS2DMath.m
//  DST1Curve
//
//  Created by Daniel Schroth on 24.06.22.
//

#import <Cocoa/Cocoa.h>

#import "DS2DMath.h"

DSLineSegment DSLineSegmentMake(CGPoint p1, CGPoint p2)
{
    DSLineSegment result;
    result.p1 = p1;
    result.p2 = p2;
    return result;
}

DSVector2d DSVector2dMake(float x, float y)
{
    DSVector2d result;
    result.x = x;
    result.y = y;
    return result;
}

float DSLineSegmentLength(DSLineSegment segment)
{
    return sqrtf(powf((segment.p2.x - segment.p1.x), 2) + powf((segment.p2.y - segment.p1.y), 2));
}

DSVector2d DSLineSegmentGetOrientationVector(DSLineSegment segment)
{
    DSVector2d result;
    result.x = segment.p2.x - segment.p1.x;
    result.y = segment.p2.y - segment.p1.y;
    return result;
}

float DSDotProduct(DSVector2d v1, DSVector2d v2)
{
    return v1.x * v2.x + v1.y * v2.y;
}

float DSDeterminant(DSVector2d v1, DSVector2d v2)
{
    return v1.x * v2.y - v1.y * v2.x;
}

float DSRadiansToDegree(float radians)
{
    return radians * 180.0 / M_PI;
}

float DSDegreeToRadians(float degree)
{
    return degree * M_PI / 180.0;
}

CGPoint DSRotatePointClockwise(CGPoint point, CGPoint rotationCenter, float radians)
{
    return CGPointMake(cosf(radians) * (point.x - rotationCenter.x) - sinf(radians) * (point.y - rotationCenter.y) + rotationCenter.x,
                       sinf(radians) * (point.x - rotationCenter.x) + cosf(radians) * (point.y - rotationCenter.y) + rotationCenter.y);
}

float DSVectorLength(DSVector2d v)
{
    return sqrtf(powf(v.x, 2) + powf(v.y, 2));
}

float DSVectorClockwiseAngleRadians(DSVector2d v1, DSVector2d v2)
{
    return atan2f(DSDeterminant(v1, v2),
                  DSDotProduct(v1, v2));
}

float DSLineSegmentsClockwiseAngleRadians(DSLineSegment s1, DSLineSegment s2)
{
    return DSVectorClockwiseAngleRadians(DSLineSegmentGetOrientationVector(s1), DSLineSegmentGetOrientationVector(s2));
}

bool DSLineSegmentsIntersect(DSLineSegment segment1, DSLineSegment segment2, CGPoint *intersection)
{
    float s1_x, s1_y, s2_x, s2_y;
    s1_x = segment1.p2.x - segment1.p1.x;     s1_y = segment1.p2.y - segment1.p1.y;
    s2_x = segment2.p2.x - segment2.p1.x;     s2_y = segment2.p2.y - segment2.p1.y;

    float s, t;
    s = (-s1_y * (segment1.p1.x - segment2.p1.x) + s1_x * (segment1.p1.y - segment2.p1.y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (segment1.p1.y - segment2.p1.y) - s2_y * (segment1.p1.x - segment2.p1.x)) / (-s2_x * s1_y + s1_x * s2_y);

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
    {
        // Collision detected
        if (intersection != NULL)
        {
            intersection->x = segment1.p1.x + (t * s1_x);
            intersection->y = segment1.p1.y + (t * s1_y);
        }
        
        return true;
    }

    return false;
}

CGPoint DSLineSegmentRelativePoint(DSLineSegment s, float rel)
{
    DSVector2d vec = DSLineSegmentGetOrientationVector(s);
    CGPoint result;
    result.x = s.p1.x + rel * vec.x;
    result.y = s.p1.y + rel * vec.y;
    return result;
}

//algorithm source: https://stackoverflow.com/a/43896965
bool DSPointInPolygon(CGPoint point, DSLineSegment *polygonEdges, int nEdges)
{
    bool result = false;
    
    for (int i = 0; i < nEdges; i++)
    {
        DSLineSegment s = polygonEdges[i];
        
        float xp0 = s.p1.x;
        float yp0 = s.p1.y;
        float xp1 = s.p2.x;
        float yp1 = s.p2.y;
        
        if (((yp0 <= point.y) && (yp1 > point.y)) || ((yp1 <= point.y) && (yp0 > point.y)))
        {
            double cross = (xp1 - xp0) * (point.y - yp0) / (yp1 - yp0) + xp0;
            if (cross < point.x)
                result = !result;
        }
    }
    
    return result;
}
