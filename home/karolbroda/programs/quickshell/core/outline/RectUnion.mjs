/**
 * @typedef {Object} Rect
 * @property {number} x
 * @property {number} y
 * @property {number} w
 * @property {number} h
 */

/**
 * @typedef {Object} Point
 * @property {number} x
 * @property {number} y
 */


/**
 * finds pairs of rects with a horizontal or vertical gap smaller than
 * threshold, then fills that gap with a new rect so the union stays connected.
 *
 * @param {Rect[]} rects
 * @param {number} threshold - max gap distance to bridge
 * @returns {Rect[]} original rects plus any bridge rects
 */
function bridgeGaps(rects, threshold) {
    if (threshold <= 0) return rects.slice()

    const result = rects.slice()

    for (let first = 0; first < rects.length; first++) {
        for (let second = first + 1; second < rects.length; second++) {
            const rectA = rects[first]
            const rectB = rects[second]

            tryBridgeHorizontal(result, rectA, rectB, threshold)
            tryBridgeVertical(result, rectA, rectB, threshold)
        }
    }

    return result
}

/**
 * @param {Rect[]} output
 * @param {Rect} rectA
 * @param {Rect} rectB
 * @param {number} threshold
 */
function tryBridgeHorizontal(output, rectA, rectB, threshold) {
    const overlapTop = Math.max(rectA.y, rectB.y)
    const overlapBottom = Math.min(rectA.y + rectA.h, rectB.y + rectB.h)

    if (overlapBottom <= overlapTop) return

    const overlapHeight = overlapBottom - overlapTop

    // gap where rectA is left of rectB
    const rightGap = rectB.x - (rectA.x + rectA.w)
    if (rightGap > 0 && rightGap <= threshold) {
        output.push({ x: rectA.x + rectA.w, y: overlapTop, w: rightGap, h: overlapHeight })
    }

    // gap where rectB is left of rectA
    const leftGap = rectA.x - (rectB.x + rectB.w)
    if (leftGap > 0 && leftGap <= threshold) {
        output.push({ x: rectB.x + rectB.w, y: overlapTop, w: leftGap, h: overlapHeight })
    }
}

/**
 * @param {Rect[]} output
 * @param {Rect} rectA
 * @param {Rect} rectB
 * @param {number} threshold
 */
function tryBridgeVertical(output, rectA, rectB, threshold) {
    const overlapLeft = Math.max(rectA.x, rectB.x)
    const overlapRight = Math.min(rectA.x + rectA.w, rectB.x + rectB.w)

    if (overlapRight <= overlapLeft) return

    const overlapWidth = overlapRight - overlapLeft

    const bottomGap = rectB.y - (rectA.y + rectA.h)
    if (bottomGap > 0 && bottomGap <= threshold) {
        output.push({ x: overlapLeft, y: rectA.y + rectA.h, w: overlapWidth, h: bottomGap })
    }

    const topGap = rectA.y - (rectB.y + rectB.h)
    if (topGap > 0 && topGap <= threshold) {
        output.push({ x: overlapLeft, y: rectB.y + rectB.h, w: overlapWidth, h: topGap })
    }
}


/**
 * computes the clockwise boundary polygons of the union of axis-aligned rects.
 *
 * builds a grid from the unique x/y edges of all rects, marks cells as inside
 * if they fall within any rect, then traces the boundary between inside and
 * outside cells as directed edges and chains them into simplified polygons.
 *
 * returns multiple polygons when the rects form disjoint groups.
 *
 * @param {Rect[]} rects
 * @returns {Point[][]} array of clockwise polygon vertex arrays
 */
function rectilinearUnion(rects) {
    if (rects.length === 0) return []

    if (rects.length === 1) {
        const rect = rects[0]
        return [[
            { x: rect.x, y: rect.y },
            { x: rect.x + rect.w, y: rect.y },
            { x: rect.x + rect.w, y: rect.y + rect.h },
            { x: rect.x, y: rect.y + rect.h }
        ]]
    }

    const grid = buildOccupancyGrid(rects)
    const boundaryEdges = collectBoundaryEdges(grid)

    if (boundaryEdges.length === 0) return []

    const rawPolygons = chainEdgesIntoPolygons(boundaryEdges)
    const result = []
    for (let i = 0; i < rawPolygons.length; i++) {
        const simplified = removeCollinearVertices(rawPolygons[i])
        if (simplified.length >= 3) {
            result.push(simplified)
        }
    }
    return result
}


/**
 * @typedef {Object} OccupancyGrid
 * @property {number[]} xEdges - sorted unique x coordinates
 * @property {number[]} yEdges - sorted unique y coordinates
 * @property {boolean[][]} cells - cells[col][row], true if inside any rect
 * @property {number} colCount
 * @property {number} rowCount
 */

/**
 * @param {Rect[]} rects
 * @returns {OccupancyGrid}
 */
function buildOccupancyGrid(rects) {
    const uniqueX = new Set()
    const uniqueY = new Set()

    for (let idx = 0; idx < rects.length; idx++) {
        uniqueX.add(rects[idx].x)
        uniqueX.add(rects[idx].x + rects[idx].w)
        uniqueY.add(rects[idx].y)
        uniqueY.add(rects[idx].y + rects[idx].h)
    }

    const xEdges = Array.from(uniqueX).sort((a, b) => a - b)
    const yEdges = Array.from(uniqueY).sort((a, b) => a - b)
    const colCount = xEdges.length - 1
    const rowCount = yEdges.length - 1

    // build index maps for fast coordinate → grid index lookup
    const xIndex = new Map()
    for (let i = 0; i < xEdges.length; i++) xIndex.set(xEdges[i], i)
    const yIndex = new Map()
    for (let i = 0; i < yEdges.length; i++) yIndex.set(yEdges[i], i)

    // paint each rect's cells directly instead of testing every cell against every rect
    const cells = []
    for (let col = 0; col < colCount; col++) {
        cells[col] = new Array(rowCount).fill(false)
    }

    for (let idx = 0; idx < rects.length; idx++) {
        const rect = rects[idx]
        const colStart = xIndex.get(rect.x)
        const colEnd = xIndex.get(rect.x + rect.w)
        const rowStart = yIndex.get(rect.y)
        const rowEnd = yIndex.get(rect.y + rect.h)

        for (let col = colStart; col < colEnd; col++) {
            for (let row = rowStart; row < rowEnd; row++) {
                cells[col][row] = true
            }
        }
    }

    return { xEdges, yEdges, cells, colCount, rowCount }
}


/**
 * @typedef {Object} DirectedEdge
 * @property {number} startX
 * @property {number} startY
 * @property {number} endX
 * @property {number} endY
 */

/**
 * walks the grid and emits a directed edge wherever an inside cell
 * borders an outside cell. edge direction ensures clockwise winding.
 *
 * @param {OccupancyGrid} grid
 * @returns {DirectedEdge[]}
 */
function collectBoundaryEdges(grid) {
    const { xEdges, yEdges, cells, colCount, rowCount } = grid
    const edges = []

    function isCellInside(col, row) {
        if (col < 0 || col >= colCount || row < 0 || row >= rowCount) return false
        return cells[col][row]
    }

    // the edge direction flips depending on which side is inside. this
    // is what makes the final polygon wind clockwise. if you swap them
    // everything renders inside-out and it is not a fun time to debug
    for (let row = 0; row <= rowCount; row++) {
        for (let col = 0; col < colCount; col++) {
            const aboveInside = isCellInside(col, row - 1)
            const belowInside = isCellInside(col, row)

            if (aboveInside === belowInside) continue

            if (belowInside) {
                edges.push({ startX: xEdges[col], startY: yEdges[row], endX: xEdges[col + 1], endY: yEdges[row] })
            } else {
                edges.push({ startX: xEdges[col + 1], startY: yEdges[row], endX: xEdges[col], endY: yEdges[row] })
            }
        }
    }

    for (let col = 0; col <= colCount; col++) {
        for (let row = 0; row < rowCount; row++) {
            const leftInside = isCellInside(col - 1, row)
            const rightInside = isCellInside(col, row)

            if (leftInside === rightInside) continue

            if (rightInside) {
                edges.push({ startX: xEdges[col], startY: yEdges[row + 1], endX: xEdges[col], endY: yEdges[row] })
            } else {
                edges.push({ startX: xEdges[col], startY: yEdges[row], endX: xEdges[col], endY: yEdges[row + 1] })
            }
        }
    }

    return edges
}

/**
 * traces all closed loops from the directed boundary edges.
 * returns multiple polygons when the union has disjoint regions.
 *
 * @param {DirectedEdge[]} edges
 * @returns {Point[][]}
 */
function chainEdgesIntoPolygons(edges) {
    const edgeByStart = new Map()
    for (let idx = 0; idx < edges.length; idx++) {
        const edge = edges[idx]
        edgeByStart.set(edge.startX + "," + edge.startY, edge)
    }

    const visited = new Set()
    const polygons = []

    for (let idx = 0; idx < edges.length; idx++) {
        const startKey = edges[idx].startX + "," + edges[idx].startY
        if (visited.has(startKey)) continue

        const polygon = []
        let currentKey = startKey
        let steps = 0
        const maxSteps = edges.length + 1

        do {
            if (visited.has(currentKey)) break
            const edge = edgeByStart.get(currentKey)
            if (edge === undefined) break

            visited.add(currentKey)
            polygon.push({ x: edge.startX, y: edge.startY })
            currentKey = edge.endX + "," + edge.endY
            steps++
        } while (currentKey !== startKey && steps < maxSteps)

        if (polygon.length >= 3) {
            polygons.push(polygon)
        }
    }

    return polygons
}

/**
 * drops vertices where the incoming and outgoing edge share the same direction.
 *
 * @param {Point[]} polygon
 * @returns {Point[]}
 */
function removeCollinearVertices(polygon) {
    if (polygon.length < 3) return polygon

    const result = []
    const count = polygon.length

    for (let idx = 0; idx < count; idx++) {
        const prev = polygon[(idx - 1 + count) % count]
        const curr = polygon[idx]
        const next = polygon[(idx + 1) % count]

        const inDirX = Math.sign(curr.x - prev.x)
        const inDirY = Math.sign(curr.y - prev.y)
        const outDirX = Math.sign(next.x - curr.x)
        const outDirY = Math.sign(next.y - curr.y)

        const directionChanges = inDirX !== outDirX || inDirY !== outDirY
        if (directionChanges) {
            result.push(curr)
        }
    }

    return result
}


export { bridgeGaps, rectilinearUnion }
