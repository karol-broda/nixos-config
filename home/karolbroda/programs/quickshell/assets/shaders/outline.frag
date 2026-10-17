#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 bounds;
    vec4 hole;
    vec4 aperture;
    float apertureRadius;
    float radius;
    float clipTop;
    int mode;
    int count;
    vec4 fillColor;
    vec4 shadowColor;
    float shadowSize;
    float shadowOffset;
    float frameShadow;
    vec4 r0;
    vec4 r1;
    vec4 r2;
    vec4 r3;
    vec4 r4;
    vec4 r5;
    vec4 r6;
    vec4 r7;
    vec4 r8;
    vec4 r9;
    vec4 r10;
    vec4 r11;
    vec4 r12;
    vec4 r13;
    vec4 r14;
    vec4 r15;
};

const int MAX_RECTS = 16;
const float FAR_DISTANCE = 1e5;
const float EDGE_EPSILON = 0.01;
const float CORNER_OVERLAP = 2.0;

vec4 rects[MAX_RECTS];
bool includeFrame = false;
int activeRectCount = 0;
float cornerReach = 0.0;

float rectRight(vec4 r) {
    return r.x + r.z;
}
float rectBottom(vec4 r) {
    return r.y + r.w;
}

vec4 extendIntoFrame(vec4 r) {
    float extension = radius * 2.0 + 2.0;
    float l = r.x <= aperture.x + 0.5 ? r.x - extension : r.x;
    float t = r.y <= aperture.y + 0.5 ? r.y - extension : r.y;
    float rr = rectRight(r) >= rectRight(aperture) - 0.5 ? rectRight(r) + extension : rectRight(r);
    float b = rectBottom(r) >= rectBottom(aperture) - 0.5 ? rectBottom(r) + extension : rectBottom(r);
    return vec4(l, t, rr - l, b - t);
}

bool inRect(vec2 p, vec4 r) {
    return p.x > r.x && p.x < rectRight(r) && p.y > r.y && p.y < rectBottom(r);
}

bool inside(vec2 p) {
    if (includeFrame && !inRect(p, aperture)) return true;
    for (int i = 0; i < MAX_RECTS; i++) {
        if (i >= activeRectCount) break;
        if (inRect(p, rects[i])) return true;
    }
    return false;
}

float roundedRectDistance(vec2 p, vec4 rect, float r) {
    vec2 halfSize = rect.zw * 0.5;
    r = min(r, min(halfSize.x, halfSize.y));
    vec2 q = abs(p - (rect.xy + halfSize)) - halfSize + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

bool onBoundary(vec2 corner, vec2 dir, vec2 normal, float t) {
    vec2 q = corner + dir * t;
    return inside(q - normal * EDGE_EPSILON) && !inside(q + normal * EDGE_EPSILON);
}

float boundaryRun(vec2 corner, vec2 dir, vec2 normal, float maxRun, out bool endsAtConvexCorner) {
    float runLength = maxRun;
    for (int i = -1; i < MAX_RECTS; i++) {
        if (i >= activeRectCount) break;
        vec4 r = i < 0 ? aperture : rects[i];
        if (i < 0 && !includeFrame) continue;
        vec2 lo = dir.x != 0.0 ? vec2(r.x, rectRight(r)) : vec2(r.y, rectBottom(r));
        float origin = dir.x != 0.0 ? corner.x : corner.y;
        float sgn = dir.x + dir.y;
        for (int k = 0; k < 2; k++) {
            float t = (lo[k] - origin) * sgn;
            if (t <= EDGE_EPSILON || t >= runLength) continue;
            if (!onBoundary(corner, dir, normal, t + EDGE_EPSILON)) runLength = t;
        }
    }
    vec2 end = corner + dir * runLength;
    endsAtConvexCorner = runLength < maxRun && !inside(end + dir * EDGE_EPSILON - normal * EDGE_EPSILON);
    return runLength;
}

float convexCornerRadius(vec2 c, vec2 directionA, vec2 normalA, vec2 directionB, vec2 normalB, float maxRadius) {
    bool endA;
    bool endB;
    float firstBoundaryLength = boundaryRun(c, directionA, normalA, cornerReach * 2.0, endA);
    float secondBoundaryLength = boundaryRun(c, directionB, normalB, cornerReach * 2.0, endB);
    float r = maxRadius;
    if (endA) r = min(r, firstBoundaryLength * 0.5);
    if (endB) r = min(r, secondBoundaryLength * 0.5);
    return r;
}

float concaveCorner(vec2 p, vec2 c, float maxRadius) {
    vec2 s = vec2(0.0);
    int openQuadrantCount = 0;
    vec2 quadrants[4] = vec2[4](vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(1.0, 1.0), vec2(-1.0, 1.0));
    for (int q = 0; q < 4; q++) {
        if (!inside(c + quadrants[q] * EDGE_EPSILON)) {
            s = quadrants[q];
            openQuadrantCount++;
        }
    }
    if (openQuadrantCount != 1) return FAR_DISTANCE;

    vec2 directionA = vec2(s.x, 0.0);
    vec2 normalA = vec2(0.0, s.y);
    vec2 directionB = vec2(0.0, s.y);
    vec2 normalB = vec2(s.x, 0.0);
    bool firstRunEndsConvex;
    bool secondRunEndsConvex;
    float firstBoundaryLength = boundaryRun(c, directionA, normalA, cornerReach * 2.0, firstRunEndsConvex);
    float secondBoundaryLength = boundaryRun(c, directionB, normalB, cornerReach * 2.0, secondRunEndsConvex);

    bool useSecondRun = secondRunEndsConvex && (!firstRunEndsConvex || secondBoundaryLength <= firstBoundaryLength);
    bool useFirstRun = firstRunEndsConvex && !useSecondRun;

    if (!useFirstRun && !useSecondRun) {
        float r = min(maxRadius, min(firstBoundaryLength, secondBoundaryLength) * 0.5);
        if (r <= 0.0) return FAR_DISTANCE;
        vec2 local = (p - c) * s;
        if (local.x < -CORNER_OVERLAP || local.y < -CORNER_OVERLAP || local.x > r || local.y > r) return FAR_DISTANCE;
        return r - length(p - (c + s * r));
    }

    vec2 l = useSecondRun ? directionB : directionA;
    vec2 nl = useSecondRun ? normalB : normalA;
    vec2 b = useSecondRun ? directionA : directionB;
    float h = useSecondRun ? secondBoundaryLength : firstBoundaryLength;
    float oppositeBoundaryLength = useSecondRun ? firstBoundaryLength : secondBoundaryLength;

    float filletRadius = min(maxRadius, oppositeBoundaryLength * 0.5);
    vec2 e = c + l * h;
    float convexRadius = convexCornerRadius(e, -nl, l, -l, nl, radius);
    if (filletRadius <= 0.0) return FAR_DISTANCE;

    vec2 uv = vec2(dot(p - c, b), dot(p - c, l));

    float dy = max(0.0, filletRadius + convexRadius - h);
    float dx = sqrt(max(0.0, (filletRadius + convexRadius) * (filletRadius + convexRadius) - dy * dy));
    vec2 cc = vec2(-convexRadius, h - convexRadius);
    vec2 cf = dy > 0.0 ? vec2(-convexRadius + dx, filletRadius) : vec2(filletRadius, filletRadius);

    vec2 tm = dy > 0.0 ? cf + (cc - cf) * (filletRadius / (filletRadius + convexRadius)) : vec2(0.0, filletRadius);

    float u0 = dy > 0.0 ? cc.x : -CORNER_OVERLAP;
    float u1 = cf.x;
    vec4 piece = vec4(u0, -CORNER_OVERLAP, u1 - u0, tm.y + CORNER_OVERLAP);
    float square = roundedRectDistance(uv, piece, 0.0);
    float fillet = square > 0.0 || u1 <= u0 ? FAR_DISTANCE : max(square, filletRadius - length(uv - cf));

    float cornerFill = h < convexRadius ? roundedRectDistance(uv, vec4(-convexRadius, h - convexRadius, convexRadius, convexRadius - h), 0.0) : FAR_DISTANCE;
    return min(fillet, cornerFill);
}

float convexCornerRadiusAt(vec2 p, vec4 r, float maxRadius) {
    vec2 c = vec2(p.x < r.x + r.z * 0.5 ? r.x : rectRight(r), p.y < r.y + r.w * 0.5 ? r.y : rectBottom(r));
    vec2 away = vec2(c.x == r.x ? -1.0 : 1.0, c.y == r.y ? -1.0 : 1.0);
    if (abs(p.x - c.x) > cornerReach * 2.0 || abs(p.y - c.y) > cornerReach * 2.0) return 0.0;

    bool sideX = inside(c + vec2(away.x, -away.y) * EDGE_EPSILON);
    bool sideY = inside(c + vec2(-away.x, away.y) * EDGE_EPSILON);
    if (sideX || sideY) return 0.0;

    float limit = min(maxRadius, min(r.z, r.w) * 0.5);
    return convexCornerRadius(c, vec2(-away.x, 0.0), vec2(0.0, away.y), vec2(0.0, -away.y), vec2(away.x, 0.0), limit);
}

float outlineDistance(vec2 p) {
    float d = includeFrame ? -roundedRectDistance(p, aperture, 0.0) : FAR_DISTANCE;

    for (int i = 0; i < MAX_RECTS; i++) {
        if (i >= activeRectCount) break;
        d = min(d, roundedRectDistance(p, rects[i], convexCornerRadiusAt(p, rects[i], radius)));
    }

    for (int i = -1; i < MAX_RECTS; i++) {
        if (i >= activeRectCount) break;
        if (i < 0 && !includeFrame) continue;
        vec4 a = i < 0 ? aperture : rects[i];
        for (int ki = 0; ki < 2; ki++) {
            float x = ki == 0 ? a.x : rectRight(a);
            if (abs(p.x - x) > cornerReach) continue;
            for (int j = -1; j < MAX_RECTS; j++) {
                if (j >= activeRectCount) break;
                if (j < 0 && !includeFrame) continue;
                vec4 b = j < 0 ? aperture : rects[j];
                for (int kj = 0; kj < 2; kj++) {
                    float y = kj == 0 ? b.y : rectBottom(b);
                    if (abs(p.y - y) > cornerReach) continue;
                    if (x < b.x - EDGE_EPSILON || x > rectRight(b) + EDGE_EPSILON || y < a.y - EDGE_EPSILON || y > rectBottom(a) + EDGE_EPSILON) continue;
                    float ri = i < 0 ? apertureRadius : radius;
                    float rj = j < 0 ? apertureRadius : radius;
                    d = min(d, concaveCorner(p, vec2(x, y), min(ri, rj)));
                }
            }
        }
    }

    if (includeFrame) {
        vec4 ap = aperture;
        vec2 corners[4] = vec2[4](ap.xy, vec2(rectRight(ap), ap.y), vec2(rectRight(ap), rectBottom(ap)), vec2(ap.x, rectBottom(ap)));
        for (int k = 0; k < 4; k++) {
            vec2 c = corners[k];
            vec2 s = vec2(k == 0 || k == 3 ? 1.0 : -1.0, k < 2 ? 1.0 : -1.0);
            if (abs(p.x - c.x) > apertureRadius || abs(p.y - c.y) > apertureRadius) continue;
            if (!inside(c + s * EDGE_EPSILON)) continue;
            vec2 local = (p - c) * s;
            if (local.x < -CORNER_OVERLAP || local.y < -CORNER_OVERLAP || local.x > apertureRadius || local.y > apertureRadius) continue;
            d = min(d, apertureRadius - length(p - (c + s * apertureRadius)));
        }
    }
    return d;
}

float coverage(float d, float pixel) {
    return clamp(0.5 - d / pixel, 0.0, 1.0);
}

float shadowFalloff(float d) {
    float t = 1.0 - clamp(d / max(shadowSize, 1e-4), 0.0, 1.0);
    return t * t;
}

vec4 render(float d, float shadowAmount, float pixel) {
    float c = coverage(d, pixel);
    return fillColor * c + shadowColor * shadowAmount * (1.0 - c);
}

void main() {
    vec2 p = bounds.xy + qt_TexCoord0 * bounds.zw;
    float pixel = max(length(fwidth(p)) * 0.7071, 1e-4);
    if (p.y < clipTop) {
        fragColor = vec4(0.0);
        return;
    }

    vec4 given[MAX_RECTS] = vec4[MAX_RECTS](r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);
    for (int i = 0; i < MAX_RECTS; i++) rects[i] = extendIntoFrame(given[i]);

    cornerReach = max(radius, apertureRadius);
    vec2 shadowP = p - vec2(0.0, shadowOffset);

    includeFrame = true;
    activeRectCount = 0;
    float frameCast = shadowFalloff(outlineDistance(shadowP));
    if (mode == 0) {
        fragColor = inRect(p, hole) ? vec4(0.0) : render(outlineDistance(p), frameShadow * frameCast, pixel) * qt_Opacity;
        return;
    }

    includeFrame = mode == 1;
    activeRectCount = count;
    float d = outlineDistance(p);
    float shapeCast = shadowFalloff(outlineDistance(shadowP));
    float shadowAmt = includeFrame ? frameShadow * frameCast + max(0.0, shapeCast - frameCast) : shapeCast;
    vec4 full = render(d, shadowAmt, pixel);

    fragColor = full * qt_Opacity;
}
