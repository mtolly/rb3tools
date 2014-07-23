module Main (main) where

import System.Environment (getArgs, getProgName)
import qualified System.IO as IO

import Codec.Container.Ogg.Mogg (oggToMogg)

main :: IO ()
main = do
  argv <- getArgs
  case argv of
    [x, y] -> oggToMogg x y
    [x]    -> oggToMogg x $ x ++ ".mogg"
    _      -> do
      prog <- getProgName
      IO.hPutStrLn IO.stderr $ "Usage: " ++ prog ++ " in.ogg [out.mogg]"
