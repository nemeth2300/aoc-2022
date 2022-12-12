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

const getNextPosition = (head, tail) => {
  const diff = subtractPosition(head, tail);
  const adjustment = getAdjustment(diff);
  const newTail = addPosition(tail, adjustment);
  return newTail;
};

const moveRope = (rope, shift) => {
  rope[0] = addPosition(rope[0], shift);
  for (let i = 1; i < rope.length; i++) {
    rope[i] = getNextPosition(rope[i - 1], rope[i]);
  }
};

const solve = () => {
  const ropeLength = 10;
  const startPosition = [0, 0];
  const rope = new Array(ropeLength).fill(startPosition);
  const tailPositions = new Map([[positionToString(startPosition), true]]);

  instructions.forEach((e) => {
    const shiftPosition = instructionToPosition(e.direction);
    for (let i = 0; i < e.count; i++) {
      moveRope(rope, shiftPosition);
      tailPositions.set(positionToString(rope[rope.length - 1]), true);
    }
  });

  const result = tailPositions.size;
  console.log(result);
};

solve();
