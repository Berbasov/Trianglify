//
//  DelaunayTriangulation.m
//  Trianglify
//
//  Created by Alex Art on 08.05.2015.
//  Copyright (c) 2015 Alex Art. All rights reserved.
//

#import "DelaunayTriangulation.h"

#define EPSILON (1.0 / 1048576.0)

typedef struct {
    int p1, p2, p3;     // vertex indexes
} TRIANGLE;

typedef struct {
    int p1, p2;         // vertex indexes
} EDGE;

typedef struct {
    double x, y, z;
} XYZ;

int Triangulate(XYZ *vertexList, int vertexCount, TRIANGLE *triangleList, int *triangleCount);
int CircumCircle(double xp,double yp,
                 double x1,double y1,double x2,double y2,double x3,double y3,
                 double *xc,double *yc,double *rsqr);


@implementation DelaunayTriangulation

+ (NSArray *)triangularFacesWithPoints:(NSArray *)points {
    // convert to XYZ-array
    NSUInteger count = points.count;
    XYZ *points3 = malloc((count + 3) * sizeof(XYZ));
    NSUInteger iterator = 0;
    for (NSValue *value in points) {
        CGPoint point = [value CGPointValue];
        points3[iterator].x = point.x;
        points3[iterator].y = point.y;
        points3[iterator].z = 0;
        iterator ++;
    }

    // call main function
    TRIANGLE *triangles = malloc((count * 3) * sizeof(TRIANGLE));
    int numberOfTriangles;
    int status = Triangulate(points3, (int)count, triangles, &numberOfTriangles);
    free(points3);

    NSArray *resultArray;
    if (status == 0) {
        // convert triangles to the array of NSNumber
        NSMutableArray *vertices = [NSMutableArray array];
        for (NSUInteger i = 0; i < numberOfTriangles; i ++) {
            NSUInteger v1 = triangles[i].p1;
            NSUInteger v2 = triangles[i].p2;
            NSUInteger v3 = triangles[i].p3;
            [vertices addObject:@(v1)];
            [vertices addObject:@(v2)];
            [vertices addObject:@(v3)];
        }
        resultArray = [vertices copy];
    }

    free(triangles);
    return resultArray;
}

@end


/// Source: http://paulbourke.net/papers/triangulate/triangulate.c

/*
 Triangulation subroutine
 Takes as input vertexCount vertices in array 'vertexList'
 Returned is a list of triangleCount triangular faces in the array triangleList
 These triangles are arranged in a consistent clockwise order.
 The triangle array 'triangleList' should be malloced to 3 * vertexCount.
 The vertex array 'vertexList' must be big enough to hold 3 more points.
 The vertex array must be sorted in increasing x values say:

 qsort(p,nv,sizeof(XYZ),XYZCompare);
 :
 int XYZCompare(void *v1,void *v2)
 {
 XYZ *p1,*p2;
 p1 = v1;
 p2 = v2;
 if (p1->x < p2->x)
 return(-1);
 else if (p1->x > p2->x)
 return(1);
 else
 return(0);
 }
 */
int Triangulate(XYZ *vertexList, int vertexCount, TRIANGLE *triangleList, int *triangleCount) {
    int *complete = NULL;
    EDGE *edges = NULL;
    int nedge = 0;
    int emax = 200;
    int status = 0;

    int inside;
    double xp,yp,x1,y1,x2,y2,x3,y3,xc,yc,r;
    double xmin,xmax,ymin,ymax,xmid,ymid;
    double dx,dy,dmax;

    /* Allocate memory for the completeness list, flag for each triangle */
    int trimax = 4 * vertexCount;
    if ((complete = malloc(trimax*sizeof(int))) == NULL) {
        status = 1;
        goto skip;
    }

    /* Allocate memory for the edge list */
    if ((edges = malloc(emax*(long)sizeof(EDGE))) == NULL) {
        status = 2;
        goto skip;
    }

    /*
     Find the maximum and minimum vertex bounds.
     This is to allow calculation of the bounding triangle
     */
    xmin = vertexList[0].x;
    ymin = vertexList[0].y;
    xmax = xmin;
    ymax = ymin;
    for (int i = 1; i < vertexCount; i ++) {
        if (vertexList[i].x < xmin) xmin = vertexList[i].x;
        if (vertexList[i].x > xmax) xmax = vertexList[i].x;
        if (vertexList[i].y < ymin) ymin = vertexList[i].y;
        if (vertexList[i].y > ymax) ymax = vertexList[i].y;
    }
    dx = xmax - xmin;
    dy = ymax - ymin;
    dmax = (dx > dy) ? dx : dy;
    xmid = (xmax + xmin) / 2.0;
    ymid = (ymax + ymin) / 2.0;

    /*
     Set up the supertriangle
     This is a triangle which encompasses all the sample points.
     The supertriangle coordinates are added to the end of the vertex list.
     The supertriangle is the first triangle in the triangle list.
     */
    vertexList[vertexCount+0].x = xmid - 20 * dmax;
    vertexList[vertexCount+0].y = ymid - dmax;
    vertexList[vertexCount+0].z = 0.0;

    vertexList[vertexCount+1].x = xmid;
    vertexList[vertexCount+1].y = ymid + 20 * dmax;
    vertexList[vertexCount+1].z = 0.0;

    vertexList[vertexCount+2].x = xmid + 20 * dmax;
    vertexList[vertexCount+2].y = ymid - dmax;
    vertexList[vertexCount+2].z = 0.0;

    triangleList[0].p1 = vertexCount;
    triangleList[0].p2 = vertexCount+1;
    triangleList[0].p3 = vertexCount+2;
    complete[0] = FALSE;
    *triangleCount = 1;

    /*
     Include each point one at a time into the existing mesh
     */
    for (int i=0; i < vertexCount; i ++) {
        xp = vertexList[i].x;
        yp = vertexList[i].y;
        nedge = 0;

        /*
         Set up the edge buffer.
         If the point (xp,yp) lies inside the circumcircle then the
         three edges of that triangle are added to the edge buffer
         and that triangle is removed.
         */
        for (int j=0; j < (*triangleCount); j ++) {
            if (complete[j])
                continue;
            x1 = vertexList[triangleList[j].p1].x;
            y1 = vertexList[triangleList[j].p1].y;
            x2 = vertexList[triangleList[j].p2].x;
            y2 = vertexList[triangleList[j].p2].y;
            x3 = vertexList[triangleList[j].p3].x;
            y3 = vertexList[triangleList[j].p3].y;
            inside = CircumCircle(xp,yp,x1,y1,x2,y2,x3,y3,&xc,&yc,&r);
            if (xc < xp && ((xp-xc)*(xp-xc)) > r)
                complete[j] = TRUE;
            if (inside) {
                /* Check that we haven't exceeded the edge list size */
                if (nedge+3 >= emax) {
                    emax += 100;
                    if ((edges = realloc(edges,emax*(long)sizeof(EDGE))) == NULL) {
                        status = 3;
                        goto skip;
                    }
                }
                edges[nedge+0].p1 = triangleList[j].p1;
                edges[nedge+0].p2 = triangleList[j].p2;
                edges[nedge+1].p1 = triangleList[j].p2;
                edges[nedge+1].p2 = triangleList[j].p3;
                edges[nedge+2].p1 = triangleList[j].p3;
                edges[nedge+2].p2 = triangleList[j].p1;
                nedge += 3;
                triangleList[j] = triangleList[(*triangleCount)-1];
                complete[j] = complete[(*triangleCount)-1];
                (*triangleCount)--;
                j--;
            }
        }

        /*
         Tag multiple edges
         Note: if all triangles are specified anticlockwise then all
         interior edges are opposite pointing in direction.
         */
        for (int j = 0; j < nedge-1; j ++) {
            for (int k = j+1; k < nedge; k ++) {
                if ((edges[j].p1 == edges[k].p2) && (edges[j].p2 == edges[k].p1)) {
                    edges[j].p1 = -1;
                    edges[j].p2 = -1;
                    edges[k].p1 = -1;
                    edges[k].p2 = -1;
                }
                /* Shouldn't need the following, see note above */
                if ((edges[j].p1 == edges[k].p1) && (edges[j].p2 == edges[k].p2)) {
                    edges[j].p1 = -1;
                    edges[j].p2 = -1;
                    edges[k].p1 = -1;
                    edges[k].p2 = -1;
                }
            }
        }

        /*
         Form new triangles for the current point
         Skipping over any tagged edges.
         All edges are arranged in clockwise order.
         */
        for (int j = 0; j< nedge; j ++) {
            if (edges[j].p1 < 0 || edges[j].p2 < 0)
                continue;
            if ((*triangleCount) >= trimax) {
                status = 4;
                goto skip;
            }
            triangleList[*triangleCount].p1 = edges[j].p1;
            triangleList[*triangleCount].p2 = edges[j].p2;
            triangleList[*triangleCount].p3 = i;
            complete[*triangleCount] = FALSE;
            (*triangleCount)++;
        }
    }

    /*
     Remove triangles with supertriangle vertices
     These are triangles which have a vertex number greater than nv
     */
    for (int i = 0; i < (*triangleCount); i ++) {
        if (triangleList[i].p1 >= vertexCount || triangleList[i].p2 >= vertexCount || triangleList[i].p3 >= vertexCount) {
            triangleList[i] = triangleList[(*triangleCount)-1];
            (*triangleCount)--;
            i--;
        }
    }

skip:
    free(edges);
    free(complete);
    return(status);
}

/*
 Return TRUE if a point (xp,yp) is inside the circumcircle made up
 of the points (x1,y1), (x2,y2), (x3,y3)
 The circumcircle centre is returned in (xc,yc) and the radius r
 NOTE: A point on the edge is inside the circumcircle
 */
int CircumCircle(double xp,double yp,
                 double x1,double y1,double x2,double y2,double x3,double y3,
                 double *xc,double *yc,double *rsqr)
{
    double m1,m2,mx1,mx2,my1,my2;
    double dx,dy,drsqr;
    double fabsy1y2 = fabs(y1-y2);
    double fabsy2y3 = fabs(y2-y3);

    /* Check for coincident points */
    if (fabsy1y2 < EPSILON && fabsy2y3 < EPSILON)
        return(FALSE);

    if (fabsy1y2 < EPSILON) {
        m2 = - (x3-x2) / (y3-y2);
        mx2 = (x2 + x3) / 2.0;
        my2 = (y2 + y3) / 2.0;
        *xc = (x2 + x1) / 2.0;
        *yc = m2 * (*xc - mx2) + my2;
    } else if (fabsy2y3 < EPSILON) {
        m1 = - (x2-x1) / (y2-y1);
        mx1 = (x1 + x2) / 2.0;
        my1 = (y1 + y2) / 2.0;
        *xc = (x3 + x2) / 2.0;
        *yc = m1 * (*xc - mx1) + my1;
    } else {
        m1 = - (x2-x1) / (y2-y1);
        m2 = - (x3-x2) / (y3-y2);
        mx1 = (x1 + x2) / 2.0;
        mx2 = (x2 + x3) / 2.0;
        my1 = (y1 + y2) / 2.0;
        my2 = (y2 + y3) / 2.0;
        *xc = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2);
        if (fabsy1y2 > fabsy2y3) {
            *yc = m1 * (*xc - mx1) + my1;
        } else {
            *yc = m2 * (*xc - mx2) + my2;
        }
    }
    
    dx = x2 - *xc;
    dy = y2 - *yc;
    *rsqr = dx*dx + dy*dy;
    
    dx = xp - *xc;
    dy = yp - *yc;
    drsqr = dx*dx + dy*dy;
    
    // Original
    //return((drsqr <= *rsqr) ? TRUE : FALSE);
    // Proposed by Chuck Morris
    return((drsqr - *rsqr) <= EPSILON ? TRUE : FALSE);
}
