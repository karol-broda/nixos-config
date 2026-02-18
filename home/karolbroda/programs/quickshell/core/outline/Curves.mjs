/** @typedef {import("./RectUnion.mjs").Point} Point */

/**
 * @typedef {Object} CurveData
 * @property {number} startX
 * @property {number} startY
 * @property {number} cp1x - first bezier control point
 * @property {number} cp1y
 * @property {number} cp2x - second bezier control point
 * @property {number} cp2y
 * @property {number} endX
 * @property {number} endY
 */


/**
 * cubic bezier that inscribes a convex corner with a smooth arc.
 * also used for concave fillets, the geometry naturally produces
 * an inward curve at concave angles.
 *
 * @param {Point} corner
 * @param {Point} incomingDir - unit vector of the incoming edge
 * @param {Point} outgoingDir - unit vector of the outgoing edge
 * @param {number} radius
 * @param {number} curvature - bezier approximation factor (0.552 for circular)
 * @returns {CurveData}
 */
function roundCurve(corner, incomingDir, outgoingDir, radius, curvature) {
    const controlOffset = curvature * radius

    const startX = corner.x - incomingDir.x * radius
    const startY = corner.y - incomingDir.y * radius
    const endX = corner.x + outgoingDir.x * radius
    const endY = corner.y + outgoingDir.y * radius

    return {
        startX: startX,
        startY: startY,
        cp1x: startX + incomingDir.x * controlOffset,
        cp1y: startY + incomingDir.y * controlOffset,
        cp2x: endX - outgoingDir.x * controlOffset,
        cp2y: endY - outgoingDir.y * controlOffset,
        endX: endX,
        endY: endY
    }
}

/**
 * concave fillet. turns out the exact same bezier math produces the
 * correct inward curve at concave corners. i don't mass why this works
 * but it does. something something the direction vectors flip naturally.
 *
 * @param {Point} corner
 * @param {Point} incomingDir
 * @param {Point} outgoingDir
 * @param {number} radius
 * @param {number} curvature
 * @returns {CurveData}
 */
function filletCurve(corner, incomingDir, outgoingDir, radius, curvature) {
    return roundCurve(corner, incomingDir, outgoingDir, radius, curvature)
}

/**
 * ear curve at a frame-adjacent corner. extends the path along the frame
 * past the polygon vertex, then curves back to the body edge.
 * control points pull toward the corner, creating a concave scoop.
 *
 * @param {Point} corner
 * @param {Point} incomingDir
 * @param {Point} outgoingDir
 * @param {boolean} incomingIsFrame - whether the incoming edge is a frame edge
 * @param {number} radius
 * @param {number} curvature
 * @returns {CurveData}
 */
function earCurve(corner, incomingDir, outgoingDir, incomingIsFrame, radius, curvature) {
    const controlOffset = curvature * radius

    // figuring out which direction is "into the body" vs "along the frame"
    // requires negating vectors depending on which edge is the frame one.
    // took a mass of tries to get this right, please don't touch it
    let bodyDir, frameExtensionDir

    if (incomingIsFrame) {
        frameExtensionDir = { x: incomingDir.x, y: incomingDir.y }
        bodyDir = { x: outgoingDir.x, y: outgoingDir.y }
    } else {
        frameExtensionDir = { x: -outgoingDir.x, y: -outgoingDir.y }
        bodyDir = { x: -incomingDir.x, y: -incomingDir.y }
    }

    const bodyX = corner.x + bodyDir.x * radius
    const bodyY = corner.y + bodyDir.y * radius
    const frameX = corner.x + frameExtensionDir.x * radius
    const frameY = corner.y + frameExtensionDir.y * radius

    // walk order: frame→body when incoming is frame, body→frame otherwise
    let startX, startY, endX, endY, cp1Dir, cp2Dir
    if (incomingIsFrame) {
        startX = frameX; startY = frameY
        endX = bodyX; endY = bodyY
        cp1Dir = frameExtensionDir
        cp2Dir = bodyDir
    } else {
        startX = bodyX; startY = bodyY
        endX = frameX; endY = frameY
        cp1Dir = bodyDir
        cp2Dir = frameExtensionDir
    }

    return {
        startX: startX,
        startY: startY,
        cp1x: startX - cp1Dir.x * controlOffset,
        cp1y: startY - cp1Dir.y * controlOffset,
        cp2x: endX - cp2Dir.x * controlOffset,
        cp2y: endY - cp2Dir.y * controlOffset,
        endX: endX,
        endY: endY
    }
}


export { roundCurve, filletCurve, earCurve }
