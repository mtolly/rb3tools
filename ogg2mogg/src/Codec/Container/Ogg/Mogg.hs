{-# LANGUAGE TemplateHaskell #-}
module Codec.Container.Ogg.Mogg (oggToMogg) where

import Control.Monad (forM_)
import Data.Bits (shiftL)
import Data.Word (Word32)
import System.Info (os)
import qualified System.IO as IO

import qualified Data.ByteString as B
import qualified System.Directory as Dir
import System.FilePath ((</>))
import System.IO.Temp (withSystemTempDirectory)
import System.Process (readProcess)

import Data.FileEmbed (embedDir)

dataFiles :: [(FilePath, B.ByteString)]
dataFiles = $(embedDir "data/")

oggToMogg :: FilePath -> FilePath -> IO ()
oggToMogg oggRel moggRel = do
  pwd <- Dir.getCurrentDirectory
  let ogg  = pwd </> oggRel
      mogg = pwd </> moggRel
  withSystemTempDirectory "ogg2mogg" $ \tmp -> do

    Dir.setCurrentDirectory tmp
    Dir.createDirectory "gen"
    forM_ dataFiles $ uncurry B.writeFile

    let ogg' = tmp </> "audio.ogg"
        rbproj = tmp </> "hellskitchen.rbproj"
        rba = tmp </> "out.rba"
        magma = tmp </> "MagmaCompiler.exe"
    Dir.copyFile ogg ogg'
    _ <- if os `elem` ["mingw", "mingw32"]
      then readProcess magma [rbproj, rba] ""
      else readProcess "wine" [magma, rbproj, rba] ""
    
    IO.withBinaryFile rba IO.ReadMode $ \hrba -> do
      IO.hSeek hrba IO.AbsoluteSeek $ 4 + (4 * 3)
      moggOffset <- hReadWord32le hrba
      IO.hSeek hrba IO.AbsoluteSeek $ 4 + (4 * 10)
      moggLength <- hReadWord32le hrba
      IO.hSeek hrba IO.AbsoluteSeek $ fromIntegral moggOffset
      moggData <- B.hGet hrba $ fromIntegral moggLength
      B.writeFile mogg moggData

  Dir.setCurrentDirectory pwd

hReadWord32le :: IO.Handle -> IO Word32
hReadWord32le h = do
  [a, b, c, d] <- fmap (map fromIntegral . B.unpack) $ B.hGet h 4
  return $ a + (b `shiftL` 8) + (c `shiftL` 16) + (d `shiftL` 24)
