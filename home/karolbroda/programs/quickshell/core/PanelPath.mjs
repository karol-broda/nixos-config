const Top = 1;
const Right = 2;
const Bottom = 4;
const Left = 8;
const Outward = 16;


function generatePath(w, h, r, k, edges) {
    const o = (edges & Outward) !== 0;
    const t = (edges & Top) !== 0;
    const R = (edges & Right) !== 0;
    const b = (edges & Bottom) !== 0;
    const l = (edges & Left) !== 0;
    const kr = k * r;
    const s = [];

    // flyout corner topologies: ears extend back toward the parent
    if (o && t && l && !R && !b) {
        // flyout from parent's bottom-right: body extends right+down, ears go up+left from TL
        s.push({ t: "M", x: 0, y: -r });
        s.push({ t: "C", c1x: 0, c1y: -r + kr, c2x: r - kr, c2y: 0, x: r, y: 0 });
        s.push({ t: "L", x: w - r, y: 0 });
        s.push({ t: "C", c1x: w - r + kr, c1y: 0, c2x: w, c2y: r - kr, x: w, y: r });
        s.push({ t: "L", x: w, y: h - r });
        s.push({ t: "C", c1x: w, c1y: h - r + kr, c2x: w - r + kr, c2y: h, x: w - r, y: h });
        s.push({ t: "L", x: r, y: h });
        s.push({ t: "C", c1x: r - kr, c1y: h, c2x: 0, c2y: h - r + kr, x: 0, y: h - r });
        s.push({ t: "L", x: 0, y: r });
        s.push({ t: "C", c1x: 0, c1y: r - kr, c2x: -r + kr, c2y: 0, x: -r, y: 0 });
        s.push({ t: "L", x: 0, y: 0 });
        return s;
    }
    if (o && t && R && !l && !b) {
        // flyout from parent's bottom-left: body extends left+down, ears go up+right from TR
        s.push({ t: "M", x: w, y: -r });
        s.push({ t: "C", c1x: w, c1y: -r + kr, c2x: w - r + kr, c2y: 0, x: w - r, y: 0 });
        s.push({ t: "L", x: r, y: 0 });
        s.push({ t: "C", c1x: r - kr, c1y: 0, c2x: 0, c2y: r - kr, x: 0, y: r });
        s.push({ t: "L", x: 0, y: h - r });
        s.push({ t: "C", c1x: 0, c1y: h - r + kr, c2x: r - kr, c2y: h, x: r, y: h });
        s.push({ t: "L", x: w - r, y: h });
        s.push({ t: "C", c1x: w - r + kr, c1y: h, c2x: w, c2y: h - r + kr, x: w, y: h - r });
        s.push({ t: "L", x: w, y: r });
        s.push({ t: "C", c1x: w, c1y: r - kr, c2x: w + r - kr, c2y: 0, x: w + r, y: 0 });
        s.push({ t: "L", x: w, y: 0 });
        return s;
    }
    if (o && b && l && !t && !R) {
        // flyout from parent's top-right: body extends right+up, ears go down+left from BL
        s.push({ t: "M", x: 0, y: h + r });
        s.push({ t: "C", c1x: 0, c1y: h + r - kr, c2x: r - kr, c2y: h, x: r, y: h });
        s.push({ t: "L", x: w - r, y: h });
        s.push({ t: "C", c1x: w - r + kr, c1y: h, c2x: w, c2y: h - r + kr, x: w, y: h - r });
        s.push({ t: "L", x: w, y: r });
        s.push({ t: "C", c1x: w, c1y: r - kr, c2x: w - r + kr, c2y: 0, x: w - r, y: 0 });
        s.push({ t: "L", x: r, y: 0 });
        s.push({ t: "C", c1x: r - kr, c1y: 0, c2x: 0, c2y: r - kr, x: 0, y: r });
        s.push({ t: "L", x: 0, y: h - r });
        s.push({ t: "C", c1x: 0, c1y: h - r + kr, c2x: -r + kr, c2y: h, x: -r, y: h });
        s.push({ t: "L", x: 0, y: h });
        return s;
    }
    if (o && b && R && !t && !l) {
        // flyout from parent's top-left: body extends left+up, ears go down+right from BR
        s.push({ t: "M", x: w, y: h + r });
        s.push({ t: "C", c1x: w, c1y: h + r - kr, c2x: w - r + kr, c2y: h, x: w - r, y: h });
        s.push({ t: "L", x: r, y: h });
        s.push({ t: "C", c1x: r - kr, c1y: h, c2x: 0, c2y: h - r + kr, x: 0, y: h - r });
        s.push({ t: "L", x: 0, y: r });
        s.push({ t: "C", c1x: 0, c1y: r - kr, c2x: r - kr, c2y: 0, x: r, y: 0 });
        s.push({ t: "L", x: w - r, y: 0 });
        s.push({ t: "C", c1x: w - r + kr, c1y: 0, c2x: w, c2y: r - kr, x: w, y: r });
        s.push({ t: "L", x: w, y: h - r });
        s.push({ t: "C", c1x: w, c1y: h - r + kr, c2x: w + r - kr, c2y: h, x: w + r, y: h });
        s.push({ t: "L", x: w, y: h });
        return s;
    }

    if (t && l && !R && !b) {
        // top-left corner: frame on top + left, free on right + bottom
        s.push({ t: "M", x: 0, y: 0 });
        s.push({ t: "L", x: 0, y: h + r });
        s.push({ t: "C", c1x: 0, c1y: h + r - kr, c2x: r - kr, c2y: h, x: r, y: h });
        s.push({ t: "L", x: w - r, y: h });
        s.push({ t: "C", c1x: w - r + kr, c1y: h, c2x: w, c2y: h - r + kr, x: w, y: h - r });
        s.push({ t: "L", x: w, y: r });
        s.push({ t: "C", c1x: w, c1y: r - kr, c2x: w + r - kr, c2y: 0, x: w + r, y: 0 });
        s.push({ t: "L", x: 0, y: 0 });
    }
    else if (t && R && !l && !b) {
        // top-right corner: frame on top + right, free on left + bottom
        s.push({ t: "M", x: w, y: 0 });
        s.push({ t: "L", x: w, y: h + r });
        s.push({ t: "C", c1x: w, c1y: h + r - kr, c2x: w - r + kr, c2y: h, x: w - r, y: h });
        s.push({ t: "L", x: r, y: h });
        s.push({ t: "C", c1x: r - kr, c1y: h, c2x: 0, c2y: h - r + kr, x: 0, y: h - r });
        s.push({ t: "L", x: 0, y: r });
        s.push({ t: "C", c1x: 0, c1y: r - kr, c2x: -r + kr, c2y: 0, x: -r, y: 0 });
        s.push({ t: "L", x: w, y: 0 });
    }
    else if (t && !R && !l && !b) {
        // top edge
        s.push({ t: "M", x: -r, y: 0 });
        s.push({ t: "C", c1x: -r + kr, c1y: 0, c2x: 0, c2y: r - kr, x: 0, y: r });
        s.push({ t: "L", x: 0, y: h - r });
        s.push({ t: "C", c1x: 0, c1y: h - r + kr, c2x: r - kr, c2y: h, x: r, y: h });
        s.push({ t: "L", x: w - r, y: h });
        s.push({ t: "C", c1x: w - r + kr, c1y: h, c2x: w, c2y: h - r + kr, x: w, y: h - r });
        s.push({ t: "L", x: w, y: r });
        s.push({ t: "C", c1x: w, c1y: r - kr, c2x: w + r - kr, c2y: 0, x: w + r, y: 0 });
        s.push({ t: "L", x: -r, y: 0 });
    }
    else if (b && l && !t && !R) {
        // bottom-left corner: frame on bottom + left, free on right + top
        s.push({ t: "M", x: 0, y: h });
        s.push({ t: "L", x: 0, y: -r });
        s.push({ t: "C", c1x: 0, c1y: -r + kr, c2x: r - kr, c2y: 0, x: r, y: 0 });
        s.push({ t: "L", x: w - r, y: 0 });
        s.push({ t: "C", c1x: w - r + kr, c1y: 0, c2x: w, c2y: r - kr, x: w, y: r });
        s.push({ t: "L", x: w, y: h - r });
        s.push({ t: "C", c1x: w, c1y: h - r + kr, c2x: w + r - kr, c2y: h, x: w + r, y: h });
        s.push({ t: "L", x: 0, y: h });
    }
    else if (b && R && !t && !l) {
        // bottom-right corner: frame on bottom + right, free on left + top
        s.push({ t: "M", x: w, y: h });
        s.push({ t: "L", x: w, y: -r });
        s.push({ t: "C", c1x: w, c1y: -r + kr, c2x: w - r + kr, c2y: 0, x: w - r, y: 0 });
        s.push({ t: "L", x: r, y: 0 });
        s.push({ t: "C", c1x: r - kr, c1y: 0, c2x: 0, c2y: r - kr, x: 0, y: r });
        s.push({ t: "L", x: 0, y: h - r });
        s.push({ t: "C", c1x: 0, c1y: h - r + kr, c2x: -r + kr, c2y: h, x: -r, y: h });
        s.push({ t: "L", x: w, y: h });
    }
    else if (b && !t && !l && !R) {
        // bottom edge
        s.push({ t: "M", x: -r, y: h });
        s.push({ t: "C", c1x: -r + kr, c1y: h, c2x: 0, c2y: h - r + kr, x: 0, y: h - r });
        s.push({ t: "L", x: 0, y: r });
        s.push({ t: "C", c1x: 0, c1y: r - kr, c2x: r - kr, c2y: 0, x: r, y: 0 });
        s.push({ t: "L", x: w - r, y: 0 });
        s.push({ t: "C", c1x: w - r + kr, c1y: 0, c2x: w, c2y: r - kr, x: w, y: r });
        s.push({ t: "L", x: w, y: h - r });
        s.push({ t: "C", c1x: w, c1y: h - r + kr, c2x: w + r - kr, c2y: h, x: w + r, y: h });
        s.push({ t: "L", x: -r, y: h });
    }
    else if (l && !t && !b && !R) {
        // left edge
        return [
            { t: "M", x: 0, y: -r },
            { t: "C", c1x: 0, c1y: -r + kr, c2x: r - kr, c2y: 0, x: r, y: 0 },
            { t: "L", x: w - r, y: 0 },
            { t: "C", c1x: w - r + kr, c1y: 0, c2x: w, c2y: r - kr, x: w, y: r },
            { t: "L", x: w, y: h - r },
            { t: "C", c1x: w, c1y: h - r + kr, c2x: w - r + kr, c2y: h, x: w - r, y: h },
            { t: "L", x: r, y: h },
            { t: "C", c1x: r - kr, c1y: h, c2x: 0, c2y: h + r - kr, x: 0, y: h + r },
            { t: "L", x: 0, y: -r }
        ];
    }
    else if (R && !t && !b && !l) {
        // right edge
        return [
            { t: "M", x: w, y: -r },
            { t: "C", c1x: w, c1y: -r + kr, c2x: w - r + kr, c2y: 0, x: w - r, y: 0 },
            { t: "L", x: r, y: 0 },
            { t: "C", c1x: r - kr, c1y: 0, c2x: 0, c2y: r - kr, x: 0, y: r },
            { t: "L", x: 0, y: h - r },
            { t: "C", c1x: 0, c1y: h - r + kr, c2x: r - kr, c2y: h, x: r, y: h },
            { t: "L", x: w - r, y: h },
            { t: "C", c1x: w - r + kr, c1y: h, c2x: w, c2y: h + r - kr, x: w, y: h + r },
            { t: "L", x: w, y: -r }
        ];
    }
    else if (t && R && b && l) {
        s.push({ t: "M", x: 0, y: 0 });
        s.push({ t: "L", x: w, y: 0 });
        s.push({ t: "L", x: w, y: h });
        s.push({ t: "L", x: 0, y: h });
        s.push({ t: "L", x: 0, y: 0 });
    }
    else {
        // no edges or unsupported: rounded rect
        s.push({ t: "M", x: r, y: 0 });
        s.push({ t: "L", x: w - r, y: 0 });
        s.push({ t: "C", c1x: w - r + kr, c1y: 0, c2x: w, c2y: r - kr, x: w, y: r });
        s.push({ t: "L", x: w, y: h - r });
        s.push({ t: "C", c1x: w, c1y: h - r + kr, c2x: w - r + kr, c2y: h, x: w - r, y: h });
        s.push({ t: "L", x: r, y: h });
        s.push({ t: "C", c1x: r - kr, c1y: h, c2x: 0, c2y: h - r + kr, x: 0, y: h - r });
        s.push({ t: "L", x: 0, y: r });
        s.push({ t: "C", c1x: 0, c1y: r - kr, c2x: r - kr, c2y: 0, x: r, y: 0 });
    }

    return s;
}

function edgeString(edges) {
    const t = (edges & Top) !== 0;
    const R = (edges & Right) !== 0;
    const b = (edges & Bottom) !== 0;
    const l = (edges & Left) !== 0;

    if (t && l) return "top-left";
    if (t && R) return "top-right";
    if (b && l) return "bottom-left";
    if (b && R) return "bottom-right";
    if (t) return "top";
    if (b) return "bottom";
    if (l) return "left";
    if (R) return "right";
    return "floating";
}

function calculateBounds(pathData) {
    let x0 = 0, y0 = 0, x1 = 0, y1 = 0;
    for (let i = 0; i < pathData.length; i++) {
        const seg = pathData[i];
        if (seg.x < x0) x0 = seg.x;
        if (seg.x > x1) x1 = seg.x;
        if (seg.y < y0) y0 = seg.y;
        if (seg.y > y1) y1 = seg.y;
        if (seg.c1x !== undefined) {
            if (seg.c1x < x0) x0 = seg.c1x;
            if (seg.c1x > x1) x1 = seg.c1x;
            if (seg.c2x < x0) x0 = seg.c2x;
            if (seg.c2x > x1) x1 = seg.c2x;
            if (seg.c1y < y0) y0 = seg.c1y;
            if (seg.c1y > y1) y1 = seg.c1y;
            if (seg.c2y < y0) y0 = seg.c2y;
            if (seg.c2y > y1) y1 = seg.c2y;
        }
    }
    return { x0: x0, y0: y0, x1: x1, y1: y1 };
}

function toSvgString(pathData) {
    if (pathData.length === 0) return "";
    const bounds = calculateBounds(pathData);
    const ox = -bounds.x0;
    const oy = -bounds.y0;
    let d = "";
    for (let i = 0; i < pathData.length; i++) {
        const seg = pathData[i];
        if (seg.t === "M") {
            d += "M" + (seg.x + ox) + " " + (seg.y + oy);
        } else if (seg.t === "L") {
            d += "L" + (seg.x + ox) + " " + (seg.y + oy);
        } else {
            d += "C" + (seg.c1x + ox) + " " + (seg.c1y + oy) + " "
                     + (seg.c2x + ox) + " " + (seg.c2y + oy) + " "
                     + (seg.x + ox) + " " + (seg.y + oy);
        }
    }
    return d + "Z";
}

export { generatePath, edgeString, calculateBounds, toSvgString, Top, Right, Bottom, Left, Outward };
