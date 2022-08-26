//
//  DS2DMath.h
//  DST1Curve
//
//  Created by Daniel Schroth on 24.06.22.
//

#import <Foundation/Foundation.h>

typedef struct
{
    CGPoint p1;
    CGPoint p2;
} DSLineSegment;

typedef struct
{
    float x;
    float y;
} DSVector2d;

float DSDotProduct(DSVector2d v1, DSVector2d v2);
float DSDeterminant(DSVector2d v1, DSVector2d v2);
float DSRadiansToDegree(float radians);
float DSDegreeToRadians(float degree);
CGPoint DSRotatePointClockwise(CGPoint point, CGPoint rotationCenter, float radians);

DSVector2d DSVector2dMake(float x, float y);
float DSVectorLength(DSVector2d v);
float DSVectorClockwiseAngleRadians(DSVector2d v1, DSVector2d v2);

DSLineSegment DSLineSegmentMake(CGPoint p1, CGPoint p2);
float DSLineSegmentLength(DSLineSegment segment);
DSVector2d DSLineSegmentGetOrientationVector(DSLineSegment segment);
float DSLineSegmentsClockwiseAngleRadians(DSLineSegment s1, DSLineSegment s2);
bool DSLineSegmentsIntersect(DSLineSegment segment1, DSLineSegment segment2, CGPoint *intersection);
CGPoint DSLineSegmentRelativePoint(DSLineSegment s, float rel); //returns the coordinates of a point on a given line segment. rel between 0 and 1.

bool DSPointInPolygon(CGPoint point, DSLineSegment *polygonEdges, int nEdges);
