{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -ddump-splices #-}
{-# OPTIONS_GHC -ddump-to-file #-}

module Main where

import qualified Data.ByteString as BS
import PlutusExperiments.Hex (_0x)
import PlutusTx.Builtins.Internal (BuiltinByteString (BuiltinByteString))
import Test.Hspec

main :: IO ()
main = hspec $ do
    describe "ByteString Literal Limitations" $ do
        it "BuiltinByteString handles bytes correctly through character repr" $ do
            let bb = "ÿ" :: BuiltinByteString
                BuiltinByteString bs = bb
            bs `shouldBe` BS.pack [0xFF]

        it "BuiltinByteString handles bytes correctly through escape sequence" $ do
            let bb = "\xff" :: BuiltinByteString
                BuiltinByteString bs = bb
            bs `shouldBe` BS.pack [0xFF]

        it "ByteString handles bytes correctly" $ do
            let bs = "ÿ" :: BS.ByteString
            bs `shouldBe` BS.pack [0xFF]

        it "ByteString handles byte correclty through escape sequence" $ do
            let bs = "\xff" :: BS.ByteString
            bs `shouldBe` BS.pack [0xFF]

        it "Quasi quoter handles byte correctly" $ do
            let bb = [_0x|ff|]
                BuiltinByteString bs = bb
            bs `shouldBe` BS.pack [0xFF]
