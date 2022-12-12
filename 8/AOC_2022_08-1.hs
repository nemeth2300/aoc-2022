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

isVisibleFromAnyDirection :: [[Int]] -> Int -> Int -> Bool
isVisibleFromAnyDirection matrix i j = any firstElementIsAbsoluteMax $ getDirectionalVectors matrix i j

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

countVisibleElements :: [[Int]] -> Int
countVisibleElements matrix =
  length $
    filter
      (== True)
      [ isVisibleFromAnyDirection matrix i j
        | i <- [0 .. length matrix - 1],
          j <- [0 .. length (head matrix) - 1]
      ]

solvePuzzle :: IO ()
solvePuzzle = do
  inputFile <- openFile "input.txt" ReadMode
  input <- hGetContents inputFile
  let matrix = stringToIntMatrix input
  let result = countVisibleElements matrix
  print result
  hClose inputFile

main :: IO ()
main = do
  solvePuzzle

m2 :: [[Int]]
m2 =
  [ [3, 0, 3, 7, 3],
    [2, 5, 5, 1, 2],
    [6, 5, 3, 3, 2],
    [3, 3, 5, 4, 9],
    [3, 5, 3, 9, 0]
  ]
