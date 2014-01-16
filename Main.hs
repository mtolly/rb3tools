module Main where

import Paths_ogg2mogg
import System.Environment
import System.Info (os)
import System.FilePath
import System.Directory
  (copyFile, setCurrentDirectory, getCurrentDirectory, createDirectory)
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

copyDataTo :: FilePath -> FilePath -> IO FilePath
copyDataTo tmp f = do
  orig <- getDataFileName f
  let new = tmp </> f
  copyFile orig new
  return new

run :: FilePath -> FilePath -> IO ()
run oggRel moggRel = do
  pwd <- getCurrentDirectory
  let ogg  = pwd </> oggRel
      mogg = pwd </> moggRel
  withSystemTempDirectory "ogg2mogg" $ \tmp -> do
    setCurrentDirectory tmp
    magma <- copyDataTo tmp "MagmaCompiler.exe"
    let ogg' = tmp </> "audio.ogg"
    copyFile ogg ogg'
    rbproj <- copyDataTo tmp "hellskitchen.rbproj"
    createDirectory $ tmp </> "gen"
    mapM_ (copyDataTo tmp)
      [ "notes.mid", "cover.bmp", "silence.wav", "oggenc.exe"
      , "gen/main_pc.hdr", "gen/main_pc_0.ark" ]
    let rba = tmp </> "out.rba"
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
