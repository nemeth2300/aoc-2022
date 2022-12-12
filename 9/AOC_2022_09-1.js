const fs = require("fs");
const input = fs.readFileSync("input.txt", { encoding: "utf-8" });
const instructions = input
  .trim()
  .split("\n")
  .map((e) => e.split(" "))
  .map(([direction, count]) => ({
    direction,
    count,
  }));

const instructionPositions = {
  U: [1, 0],
  D: [-1, 0],
  R: [0, 1],
  L: [0, -1],
};

// Position :: [n,m]
const chopToOne = (n) => (n < 0 && -1) || (n > 0 && 1) || 0;
const instructionToPosition = (position) => instructionPositions[position];
const positionToString = (position) => `${position[0]}|${position[1]}}`;
const addPosition = (p1, p2) => p1.map((_, i) => p1[i] + p2[i]);
const subtractPosition = (p1, p2) => p1.map((_, i) => p1[i] - p2[i]);
const getAdjustment = (p) => {
  const [horizontal, vertical] = p;
  const absHorizontal = Math.abs(horizontal);
  const absVertical = Math.abs(vertical);

  if (absHorizontal <= 1 && absVertical <= 1) {
    return [0, 0];
  }
  if (absHorizontal <= 2 || absVertical <= 2) {
    return [chopToOne(horizontal), chopToOne(vertical)];
  }
  return p;
};

let head = [0, 0];
let tail = [0, 0];
const tailPositions = new Map([[positionToString(tail), true]]);

instructions.forEach((e) => {
  const shiftPosition = instructionToPosition(e.direction);
  Array.from({ length: e.count }, () => {
    head = addPosition(head, shiftPosition);
    diff = subtractPosition(head, tail);
    adjustment = getAdjustment(diff);
    tail = addPosition(tail, adjustment);
    tailPositions.set(positionToString(tail), true);
  });
});

const result = tailPositions.size;
console.log(result);
