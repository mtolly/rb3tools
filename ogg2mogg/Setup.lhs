#!/usr/bin/env runhaskell

> import Distribution.Simple
> import System.Process (readProcess)

> main = defaultMainWithHooks simpleUserHooks
>   { preBuild = \args flags -> do
>     _ <- readProcess "tar" (words "-cvzf data.tar.gz data/") ""
>     preBuild simpleUserHooks args flags
>   }
