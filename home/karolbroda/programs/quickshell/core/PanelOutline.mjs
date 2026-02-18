import { bridgeGaps, rectilinearUnion } from "./outline/RectUnion.mjs"
import { roundCurve, filletCurve, earCurve } from "./outline/Curves.mjs"

/** @typedef {import("./outline/RectUnion.mjs").Rect} Rect */
/** @typedef {import("./outline/RectUnion.mjs").Point} Point */
/** @typedef {import("./outline/Curves.mjs").CurveData} CurveData */

/**
 * @typedef {Object} OutlineConfig
 * @property {number} r - corner radius
 * @property {number} k - bezier curvature factor (0.552 is roughly circular, don't ask where that number comes from)
 * @property {number} [gapThreshold] - max gap to bridge between rects
 * @property {number|null} [frameTop] - y coordinate of the top frame edge
 * @property {number|null} [frameLeft] - x coordinate of the left frame edge
 * @property {number|null} [frameRight] - x coordinate of the right frame edge
 * @property {number|null} [frameBottom] - y coordinate of the bottom frame edge
 */

/**
 * @typedef {Object} PathSegment
 * @property {"M"|"L"|"C"} type
 * @property {number} x
 * @property {number} y
 * @property {number} [cp1x]
 * @property {number} [cp1y]
 * @property {number} [cp2x]
 * @property {number} [cp2y]
 */

/**
 * @typedef {Object} Bounds
 * @property {number} x0
 * @property {number} y0
 * @property {number} x1
 * @property {number} y1
 */

/** @typedef {"square"|"ear"|"fillet"|"round"} CornerType */

/**
 * @typedef {Object} ClassifiedCorner
 * @property {CornerType} type
 * @property {CurveData|null} curve
 * @property {Point} pos
 */


/**
 * @param {Point} pointA
 * @param {Point} pointB
 * @param {OutlineConfig} config
 * @returns {boolean}
 */
function isEdgeOnFrame(pointA, pointB, config) {
    // frame edges are nullable, null means that side has no frame
    return matchesFrameEdge(pointA.y, pointB.y, config.frameTop)
        || matchesFrameEdge(pointA.y, pointB.y, config.frameBottom)
        || matchesFrameEdge(pointA.x, pointB.x, config.frameLeft)
        || matchesFrameEdge(pointA.x, pointB.x, config.frameRight)
}

/** @param {number} coordA  @param {number} coordB  @param {number|null|undefined} frameCoord  @returns {boolean} */
function matchesFrameEdge(coordA, coordB, frameCoord) {
    if (frameCoord === null || frameCoord === undefined) return false
    return coordA === frameCoord && coordB === frameCoord
}

/**
 * @param {Point} from
 * @param {Point} to
 * @returns {{ dir: Point, length: number }}
 */
function edgeDirection(from, to) {
    const length = Math.max(Math.abs(to.x - from.x), Math.abs(to.y - from.y))
    if (length === 0) return { dir: { x: 0, y: 0 }, length: 0 }

    return {
        dir: { x: (to.x - from.x) / length, y: (to.y - from.y) / length },
        length: length
    }
}

/**
 * cross product of two 2d vectors. positive means convex turn,
 * negative means concave. but only because the polygon winds clockwise.
 * if someone changes the winding order this breaks silently. good luck
 *
 * @param {Point} dirA
 * @param {Point} dirB
 * @returns {number}
 */
function cross2d(dirA, dirB) {
    return dirA.x * dirB.y - dirA.y * dirB.x
}

/**
 * @param {Point} prev
 * @param {Point} curr
 * @param {Point} next
 * @param {OutlineConfig} config
 * @param {number} radius
 * @param {number} curvature
 * @returns {ClassifiedCorner}
 */
function classifyCorner(prev, curr, next, config, radius, curvature) {
    const incoming = edgeDirection(prev, curr)
    const outgoing = edgeDirection(curr, next)

    const turn = cross2d(incoming.dir, outgoing.dir)
    const isConvex = turn > 0
    const isConcave = turn < 0

    const incomingOnFrame = isEdgeOnFrame(prev, curr, config)
    const outgoingOnFrame = isEdgeOnFrame(curr, next, config)

    const effectiveRadius = Math.min(radius, incoming.length / 2, outgoing.length / 2)

    let type
    if (incomingOnFrame && outgoingOnFrame) {
        type = "square"
    } else if (isConvex && (incomingOnFrame || outgoingOnFrame)) {
        type = "ear"
    } else if (isConcave) {
        type = "fillet"
    } else {
        type = "round"
    }

    let curve = null
    if (type === "round") {
        curve = roundCurve(curr, incoming.dir, outgoing.dir, effectiveRadius, curvature)
    } else if (type === "fillet") {
        curve = filletCurve(curr, incoming.dir, outgoing.dir, effectiveRadius, curvature)
    } else if (type === "ear") {
        curve = earCurve(curr, incoming.dir, outgoing.dir, incomingOnFrame, effectiveRadius, curvature)
    }

    return { type: type, curve: curve, pos: curr }
}


/**
 * generates a smooth outline path around a set of panel rectangles.
 *
 * @param {Rect[]} rects
 * @param {OutlineConfig} config
 * @returns {PathSegment[]}
 */
function outlinePath(rects, config) {
    if (rects.length === 0) return []

    const gapThreshold = config.gapThreshold || 0

    const allRects = gapThreshold > 0 ? bridgeGaps(rects, gapThreshold) : rects.slice()
    const polygon = rectilinearUnion(allRects)

    if (polygon.length < 3) return []

    const vertexCount = polygon.length
    const corners = []

    for (let idx = 0; idx < vertexCount; idx++) {
        const prev = polygon[(idx - 1 + vertexCount) % vertexCount]
        const curr = polygon[idx]
        const next = polygon[(idx + 1) % vertexCount]
        corners.push(classifyCorner(prev, curr, next, config, config.r, config.k))
    }

    return emitPathSegments(corners)
}

/**
 * @param {ClassifiedCorner[]} corners
 * @returns {PathSegment[]}
 */
function emitPathSegments(corners) {
    const segments = []
    const count = corners.length

    for (let idx = 0; idx < count; idx++) {
        const corner = corners[idx]
        const nextCorner = corners[(idx + 1) % count]

        if (idx === 0) {
            const startX = corner.type === "square" ? corner.pos.x : corner.curve.startX
            const startY = corner.type === "square" ? corner.pos.y : corner.curve.startY
            segments.push({ type: "M", x: startX, y: startY })
        }

        if (corner.type !== "square") {
            segments.push({
                type: "C",
                cp1x: corner.curve.cp1x, cp1y: corner.curve.cp1y,
                cp2x: corner.curve.cp2x, cp2y: corner.curve.cp2y,
                x: corner.curve.endX, y: corner.curve.endY
            })
        }

        const fromX = corner.type === "square" ? corner.pos.x : corner.curve.endX
        const fromY = corner.type === "square" ? corner.pos.y : corner.curve.endY
        const toX = nextCorner.type === "square" ? nextCorner.pos.x : nextCorner.curve.startX
        const toY = nextCorner.type === "square" ? nextCorner.pos.y : nextCorner.curve.startY

        // 0.01 threshold because floating point is floating point
        const hasLineSegment = Math.abs(toX - fromX) > 0.01 || Math.abs(toY - fromY) > 0.01
        if (hasLineSegment) {
            segments.push({ type: "L", x: toX, y: toY })
        }
    }

    return segments
}


/**
 * @param {PathSegment[]} segments
 * @returns {Bounds}
 */
function calculateBounds(segments) {
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity

    for (let idx = 0; idx < segments.length; idx++) {
        const seg = segments[idx]

        if (seg.x < minX) minX = seg.x
        if (seg.x > maxX) maxX = seg.x
        if (seg.y < minY) minY = seg.y
        if (seg.y > maxY) maxY = seg.y

        if (seg.cp1x !== undefined) {
            if (seg.cp1x < minX) minX = seg.cp1x
            if (seg.cp1x > maxX) maxX = seg.cp1x
            if (seg.cp2x < minX) minX = seg.cp2x
            if (seg.cp2x > maxX) maxX = seg.cp2x
            if (seg.cp1y < minY) minY = seg.cp1y
            if (seg.cp1y > maxY) maxY = seg.cp1y
            if (seg.cp2y < minY) minY = seg.cp2y
            if (seg.cp2y > maxY) maxY = seg.cp2y
        }
    }

    if (minX === Infinity) return { x0: 0, y0: 0, x1: 0, y1: 0 }
    return { x0: minX, y0: minY, x1: maxX, y1: maxY }
}

/**
 * @param {PathSegment[]} segments
 * @returns {string}
 */
function toSvgString(segments) {
    if (segments.length === 0) return ""

    let path = ""

    for (let idx = 0; idx < segments.length; idx++) {
        const seg = segments[idx]

        if (seg.type === "M") {
            path += "M" + seg.x + " " + seg.y
        } else if (seg.type === "L") {
            path += "L" + seg.x + " " + seg.y
        } else if (seg.type === "C") {
            path += "C" + seg.cp1x + " " + seg.cp1y + " "
                + seg.cp2x + " " + seg.cp2y + " "
                + seg.x + " " + seg.y
        }
    }

    return path + "Z"
}


export { outlinePath, calculateBounds, toSvgString }
