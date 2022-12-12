import Debug.Trace (trace)
import System.IO

stringToIntVector :: String -> [Int]
stringToIntVector vector = [read [c] | c <- vector]

stringToIntMatrix :: String -> [[Int]]
stringToIntMatrix input = [stringToIntVector line | line <- lines input]

firstElementIsAbsoluteMax :: [Int] -> Bool
firstElementIsAbsoluteMax [first] = True
firstElementIsAbsoluteMax [first, second] = first > second
firstElementIsAbsoluteMax (first : second : rest)
  | first <= second = False
  | otherwise = firstElementIsAbsoluteMax $ first : rest

getColumn :: [[Int]] -> Int -> [Int]
getColumn matrix index = map head $ [drop index line | line <- matrix]

getRow :: [[Int]] -> Int -> [Int]
getRow matrix index = matrix !! index

getDirectionalVectors :: [[Int]] -> Int -> Int -> [[Int]]
getDirectionalVectors matrix i j =
  [ reverse $ take (j + 1) $ getRow matrix i,
    drop j $ getRow matrix i,
    reverse $ take (i + 1) $ getColumn matrix j,
    drop i $ getColumn matrix j
  ]

takeWhileSmallerThanHead :: [Int] -> [Int]
takeWhileSmallerThanHead [] = []
takeWhileSmallerThanHead [x] = [x]
takeWhileSmallerThanHead vector = first : takeWhile (< first) rest
  where
    (first : rest) = vector

visibilityLength :: [Int] -> Int
visibilityLength vector
  | length visibleVector == length vector = length visibleVector - 1
  | otherwise = length visibleVector
  where
    visibleVector = takeWhileSmallerThanHead vector

getVisibilityScore :: [[Int]] -> Int -> Int -> Int
getVisibilityScore matrix i j = product [visibilityLength vector | vector <- getDirectionalVectors matrix i j]

maxrec :: (Ord a) => [a] -> a
maxrec [x] = x
maxrec (x : xs)
  | x > maxTail = x
  | otherwise = maxTail
  where
    maxTail = maxrec xs

getMaxVisibilityScore :: [[Int]] -> Int
getMaxVisibilityScore matrix =
  maxrec
    [ getVisibilityScore matrix i j
      | i <- [0 .. length matrix - 1],
        j <- [0 .. length (head matrix) - 1]
    ]

solvePuzzle :: IO ()
solvePuzzle = do
  inputFile <- openFile "input.txt" ReadMode
  input <- hGetContents inputFile
  let matrix = stringToIntMatrix input
  let result = getMaxVisibilityScore matrix
  print result
  hClose inputFile

main :: IO ()
main = do
  solvePuzzle