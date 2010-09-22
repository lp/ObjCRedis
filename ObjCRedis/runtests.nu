#! /usr/local/bin/nush

(system "rm -d -R ObjCRedis.framework/")
(system "cp -R build/Debug/ObjCRedis.framework/ ObjCRedis.framework/")

(system "nutest test_*.nu")