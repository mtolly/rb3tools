#!/usr/bin/env runhaskell

> import Distribution.Simple
> import System.Process (readProcess)

Zip up the data directory into a .tar.gz which is then
embedded directly in the library/executable.

> main = defaultMainWithHooks simpleUserHooks
>   { preBuild = \args flags -> do
>     _ <- readProcess "tar" (words "-cvzf data.tar.gz data/") ""
>     preBuild simpleUserHooks args flags
>   }
