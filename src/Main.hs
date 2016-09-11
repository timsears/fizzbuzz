-- | fizzbuzz

module Main where
import Control.Monad (join)
import Text.Printf (printf)

data FB = Fizz | Buzz | FizzBuzz deriving Show

-- lazy infinite lists
threes :: [Maybe FB]
threes = join $ repeat [Nothing, Nothing, Just Fizz]
fives :: [Maybe FB]
fives = join $ repeat [ Nothing, Nothing, Nothing, Nothing, Just Buzz]

fbplus :: Maybe FB -> Maybe FB -> Maybe FB
Nothing     `fbplus` Nothing     = Nothing
(Just Fizz) `fbplus` Nothing     = Just Fizz
Nothing     `fbplus` (Just Buzz) = Just Buzz
(Just Fizz) `fbplus` (Just Buzz) = Just FizzBuzz
_           `fbplus` _           = error "Bad use case for fbplus"

tags :: [Maybe FB]
tags = zipWith fbplus threes fives


combined :: [(Int, Maybe FB)]
combined = zip [1..] tags

prettify :: (Int, Maybe FB) -> String
prettify (i, t) =
  case t of
    Nothing -> show i
    Just fb -> show fb

main :: IO ()
main = mapM_ (printf "%s\n") . (take 100) $ (map prettify combined)

       
{-- in ghci, invoke with `main`
{
λ> main
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
16
17
Fizz
19
Buzz
Fizz
22
23
Fizz
Buzz
26
Fizz
28
29
FizzBuzz
31
32
Fizz
34
Buzz
Fizz
37
38
Fizz
Buzz
41
Fizz
43
44
FizzBuzz
46
47
Fizz
49
Buzz
Fizz
52
53
Fizz
Buzz
56
Fizz
58
59
FizzBuzz
61
62
Fizz
64
Buzz
Fizz
67
68
Fizz
Buzz
71
Fizz
73
74
FizzBuzz
76
77
Fizz
79
Buzz
Fizz
82
83
Fizz
Buzz
86
Fizz
88
89
FizzBuzz
91
92
Fizz
94
Buzz
Fizz
97
98
Fizz
Buzz
λ>

--}
