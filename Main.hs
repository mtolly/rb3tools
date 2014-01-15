module Main where

import Paths_ogg2mogg
import System.Environment
import System.Info (os)
import System.FilePath
import System.Directory (copyFile, setCurrentDirectory, getCurrentDirectory)
import System.IO
import System.IO.Temp (withSystemTempDirectory)
import System.Process (readProcess)
import Data.Bits (shiftL)
import qualified Data.ByteString as B
import Data.Word (Word32)

main :: IO ()
main = do
  argv <- getArgs
  case argv of
    [x, y] -> run x y
    [x] -> run x $ x ++ ".mogg"
    _ -> do
      prog <- getProgName
      hPutStrLn stderr $ "Usage: " ++ prog ++ " in.ogg out.mogg"

run :: FilePath -> FilePath -> IO ()
run oggRel moggRel = do
  pwd <- getCurrentDirectory
  let ogg  = pwd </> oggRel
      mogg = pwd </> moggRel
  oggenc <- getDataFileName "oggenc.exe"
  let ogg' = takeDirectory oggenc </> "audio.ogg"
  copyFile ogg ogg'
  magma <- getDataFileName "MagmaCompiler.exe"
  rbproj <- getDataFileName "hellskitchen.rbproj"
  setCurrentDirectory $ takeDirectory magma
  withSystemTempDirectory "ogg2mogg" $ \temp -> do
    let rba = temp </> "out.rba"
    _ <- if os == "mingw"
      then readProcess magma [rbproj, rba] ""
      else readProcess "wine" [magma, rbproj, rba] ""
    withBinaryFile rba ReadMode $ \hrba -> do
      hSeek hrba AbsoluteSeek $ 4 + (4 * 3)
      moggOffset <- hReadWord32le hrba
      hSeek hrba AbsoluteSeek $ 4 + (4 * 10)
      moggLength <- hReadWord32le hrba
      hSeek hrba AbsoluteSeek $ fromIntegral moggOffset
      moggData <- B.hGet hrba $ fromIntegral moggLength
      B.writeFile mogg moggData

hReadWord32le :: Handle -> IO Word32
hReadWord32le h = do
  [a, b, c, d] <- fmap (map fromIntegral . B.unpack) $ B.hGet h 4
  return $ a + (b `shiftL` 8) + (c `shiftL` 16) + (d `shiftL` 24)
