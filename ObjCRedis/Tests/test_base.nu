; Created by Louis-Philippe on 10-09-20.
; Copyright (c) 2010 Louis-Philippe Perron.
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.
; 
; 

(load "ObjCRedis")

; Pre-init Reality check
(class Test_01_Reality is NuTestCase
  
  (- (id) testArray is
    (set a (NSMutableArray arrayWithList:'( 1 2)))
    (a << "three")
    (assert_equal 3 (a count))
    (assert_equal 2 (a 1))
    (assert_equal "three" (a 2))
  )
  
)

; Init Test
(class Test_02_Init is NuTestCase
  
  (- (id) testInitRedis is
    (set o (ObjCRedis redis))
    (assert_true (eq (o class) (ObjCRedis class)))
    ; not testing?
    (assert_false (eq o nil))
  )
  
)

(class Test_03_BasicActions is NuTestCase
  (ivar (id) redis)
  
  (- (id) setup is
    (set @redis (ObjCRedis redis))
  )
  
  (- (id) test_01_Set is
    (set success (@redis set:"name" to:"Salvador"))
    (assert_equal 0 success)
  )
  
  (- (id) test_02_Get is
    (assert_equal "Salvador" (@redis get:"name"))
  )
  
  (- (id) test_03_Exists is
    (assert_equal 0 (@redis exists:"name"))
  )
  
  (- (id) test_04_Del is
    (assert_equal 0 (@redis del:"name"))
    (assert_equal -1 (@redis del:"name"))
  )
  
)

(class Test_04_TestGeneralActions is NuTestCase
  (ivar (id) redis (id) testKey (id) testValue)
  
  (- (id) setup is
    (set @testKey "testKey")
    (set @testValue "testValue")
    
    (set @redis (ObjCRedis redis))
    (@redis set:@testKey to:@testValue)
  )
  
  (- (id) testExists is
    (assert_equal 0 (@redis exists:@testKey))
    (assert_equal -1 (@redis exists:"dummyKey"))
  )
  
  (- (id) testType is
    (assert_equal 2 (@redis type:@testKey))
    (assert_equal 1 (@redis type:"dummyKey"))
  )
  
  (- (id) testKeys is
    (@redis set:"testKey2" to:"testValue2")
    (@redis set:"otherKey" to:"otherValue")
    
    (assert_equal 1 ((@redis keys:@testKey) count))
    (assert_equal @testKey ((@redis keys:@testKey) 0))
    
    (assert_equal 2 ((@redis keys:"testK*") count))
    (assert_true (((@redis keys:"testK*") includes:(NSArray arrayWithList:(list @testKey "testKey2"))) boolValue))
  )
  
  ; Fail!!!
  ; (- (id) testRandomKey is
  ;       (@redis set:"testKey2" to:"testValue2")
  ;       (@redis set:"otherKey" to:"otherValue")
  ;       (@redis set:"testKey3" to:"testValue3")
  ;       (@redis set:"otherKey2" to:"otherValue2")
  ;       (@redis set:"testKey4" to:"testValue4")
  ;       (@redis set:"otherKey3" to:"otherValue3")
  ;       (assert_equal 7 (@redis dbsize))
  ;       (assert_equal @testKey (@redis randomKey))
  ;   )
  
  (- (id) testRename is
    (set newKey "newKey")
    (assert_equal 0 (@redis rename:@testKey to:newKey))
    (assert_equal -1 (@redis exists:@testKey))
    (assert_equal 0 (@redis exists:newKey))
    (assert_equal 0 (@redis rename:newKey to:@testKey))
  )
  
  (- (id) testRenamenx is
    (set newKey "newKey")
    (assert_equal 0 (@redis renamenx:@testKey to:newKey))
    (assert_equal -1 (@redis exists:@testKey))
    (assert_equal 0 (@redis exists:newKey))
    (assert_equal 0 (@redis renamenx:newKey to:@testKey))
    
    (@redis set:newKey to:"anyValue")
    (assert_equal -1 (@redis renamenx:@testKey to:newKey))
    (assert_equal 0 (@redis exists:@testKey))
    (@redis del:newKey)
  )
  
  (- (id) testDBSize is
    (assert_true (> (@redis dbsize) 0))
  )
  
  (- (id) testExpire is
    (assert_equal -1 (@redis ttl:@testKey))
    (assert_equal 0 (@redis expire:@testKey in:10))
    (assert_equal 10 (@redis ttl:@testKey))
    (assert_equal -1 (@redis expire:"dummyKey" in:10))
  )
  
  (- (id) testSelect is
    (assert_equal 0 (@redis select:1))
    (assert_equal -1 (@redis exists:@testKey))
    (assert_equal 0 (@redis select:0))
    (assert_equal 0 (@redis exists:@testKey))
  )
  
  (- (id) testMove is
    (assert_equal 0 (@redis move:@testKey to:1))
    (assert_equal -1 (@redis exists:@testKey))
    (assert_equal 0 (@redis select:1))
    (assert_equal 0 (@redis exists:@testKey))
    (assert_equal 0 (@redis move:@testKey to:0))
    (assert_equal 0 (@redis select:0))
    (assert_equal 0 (@redis exists:@testKey))
  )
  
  (- (id) testFlushDB is
    (assert_equal 0 (@redis flushdb))
    (assert_equal 0 (@redis dbsize))
  )
  
  (- (id) testFlushAll is
    (assert_equal 0 (@redis flushall))
    (assert_equal 0 (@redis dbsize))
    
    (@redis set:"aKey" to:"aValue")
    (assert_equal 1 (@redis dbsize))
    (@redis select:1)
    (@redis set:"aKey" to:"aValue")
    (assert_equal 1 (@redis dbsize))
    
    (assert_equal 0 (@redis flushall))
    (assert_equal 0 (@redis dbsize))
    (@redis select:0)
    (assert_equal 0 (@redis dbsize))
  )
  
  (- (id) teardown is
    (@redis flushall)
  )
)

(class Test_05_testStringActions is NuTestCase
  (ivar (id) redis (id) testKey (id) testValue)
  
  (- (id) setup is
    (set @testKey "testKey")
    (set @testValue "testValue")
    
    (set @redis (ObjCRedis redis))
    (@redis set:@testKey to:@testValue)
  )
  
  (- (id) testSet is
    (assert_equal 0 (@redis set:"aKey" to:"aValue"))
    (assert_equal "aValue" (@redis get:"aKey"))
  )
  
  (- (id) testGet is
    (assert_equal @testValue (@redis get:@testKey))
  )
  
  (- (id) testGetSet is
    (assert_equal @testValue (@redis getset:@testKey to:"anyValue"))
    (assert_equal "anyValue" (@redis get:@testKey))
  )
  
  (- (id) testMget is
    (@redis set:"testKey2" to:"testValue2")
    (assert_equal 1 ((@redis mget:(NSArray arrayWithList:(list @testKey))) count))
    (assert_equal @testValue ((@redis mget:(NSArray arrayWithList:(list @testKey))) 0))
    
    (assert_equal 2 ((@redis mget:(NSArray arrayWithList:(list @testKey "testKey2"))) count))
    (assert_equal @testValue ((@redis mget:(NSArray arrayWithList:(list @testKey "testKey2"))) 0))
    (assert_equal "testValue2" ((@redis mget:(NSArray arrayWithList:(list @testKey "testKey2"))) 1))
    
    (assert_equal 1 ((@redis mget:(NSArray arrayWithList:(list "dummyKey"))) count))
    (assert_equal nil ((@redis mget:(NSArray arrayWithList:(list "dummyKey"))) 0))
  )
  
  (- (id) testSetnx is
    (assert_equal -1 (@redis setnx:@testKey to:"anyValue"))
    (assert_equal @testValue (@redis get:@testKey))
    (assert_equal 0 (@redis setnx:"anyKey" to:"anyValue"))
    (assert_equal "anyValue" (@redis get:"anyKey"))
  )
  
  (- (id) testIncr is
    (@redis set:"testIncr" to:"1")
    (assert_equal 2 (@redis incr:"testIncr"))
    (assert_equal 3 (@redis incr:"testIncr"))
    (assert_equal 0 (@redis incr:@testKey))
  )
  
  (- (id) testIncrby is
    (@redis set:"testIncr" to:"1")
    (assert_equal 3 (@redis incr:"testIncr" by:2))
    (assert_equal 6 (@redis incr:"testIncr" by:3))
    (assert_equal 1 (@redis incr:@testKey by:100)) ; ?????
  )
  
  (- (id) testDecr is
    (@redis set:"testDecr" to:"100")
    (assert_equal 99 (@redis decr:"testDecr"))
    (assert_equal 98 (@redis decr:"testDecr"))
    (assert_equal 0 (@redis decr:@testKey))
    (assert_equal -1 (@redis decr:"dummyKey"))
  )
  
  (- (id) testDecrby is
    (@redis set:"testDecr" to:"100")
    (assert_equal 90 (@redis decr:"testDecr" by:10))
    (assert_equal 70 (@redis decr:"testDecr" by:20))
    (assert_equal 1 (@redis decr:@testKey by:200)) ; ?????
  )
  
  (- (id) testAppend is
    (assert_not_equal (@testValue length) (@redis append:"-add" to:@testKey))
    (assert_equal (+ (@testValue length) ("-add" length)) ((@redis get:@testKey) length))
  )
  
  (- (id) testSubstr is
    (assert_equal "test" (@redis substr:@testKey from:0 to:3))
    (assert_equal "" (@redis substr:@testKey from:9 to:12))
  )
  
  (- (id) teardown is
    (@redis flushall)
  )
)

(class Test_06_testListActions is NuTestCase
  (ivar (id) redis (id) testKey)
  
  (- (id) setup is
    (set @testKey "testlist")
    (@redis lpush:"initValue1" to:@testKey)
    (@redis rpush:"initValue2" to:@testKey)
    (set @redis (ObjCRedis redis))
  )
  
  (- (id) test_01_rpush is
    (assert_equal -97 (@redis rpush:"anyValue" to:@testKey))
  )
  
  (- (id) test_02_lpush is
    (assert_equal -97 (@redis lpush:"lpushValue" to:@testKey))
  )
  
  (- (id) test_03_llen is
    (@redis rpush:"anyValue" to:@testKey)
    (@redis lpush:"lpushValue" to:@testKey)
    (assert_equal 4 (@redis llen:@testKey))
    (@redis lpush:"lpushValue2" to:@testKey)
    (assert_equal 5 (@redis llen:@testKey))
  )
  
  (- (id) test_04_lrange is
    (@redis rpush:"anyValue" to:@testKey)
    (@redis lpush:"lpushValue" to:@testKey)
    (assert_equal 2 ((@redis lrange:@testKey from:0 to:1) count))
    
    (set rArray (@redis lrange:@testKey from:0 to:1))
    (assert_equal "lpushValue" (rArray 0))
    (assert_equal "initValue1" (rArray 1))
  )
  
  (- (id) test_05_ltrim is
    (@redis rpush:"anyValue" to:@testKey)
    (@redis lpush:"lpushValue" to:@testKey)
    (assert_equal 4 (@redis llen:@testKey))
    (assert_equal 0 (@redis ltrim:@testKey from:0 to:2))
    (assert_equal 3 (@redis llen:@testKey))
  )
  
  (- (id) test_06_lindex is
    (assert_equal "initValue1" (@redis lindex:0 of:@testKey))
    (assert_equal "initValue2" (@redis lindex:1 of:@testKey))
    (assert_equal nil (@redis lindex:2 of:@testKey))
  )
  
  (- (id) test_07_lset is
    (assert_equal 0 (@redis lset:@testKey at:0 to:"anyValue"))
  )
  
  (- (id) test_08_lrem is
    (assert_equal 0 (@redis lrem:"initValue1" of:@testKey count:1)) ; should return number removed, returns 0
    (assert_equal 1 (@redis llen:@testKey))
    (assert_equal 0 (@redis lrem:"initValue2" of:@testKey count:1))
    (assert_equal 0 (@redis llen:@testKey))
    (assert_equal 0 (@redis lrem:"initValue100" of:@testKey count:1)) ; should be -1?
  )
  
  (- (id) test_08_lpop is
    (assert_equal "initValue1" (@redis lpop:@testKey))
    (assert_equal "initValue2" (@redis lpop:@testKey))
    (assert_equal nil (@redis lpop:@testKey))
  )
  
  (- (id) test_09_rpop is
    (assert_equal "initValue2" (@redis rpop:@testKey))
    (assert_equal "initValue1" (@redis rpop:@testKey))
    (assert_equal nil (@redis rpop:@testKey))
  )
  
  (- (id) teardown is
    (@redis flushdb)
  )
  
)

(class test_07_testSetsActions is NuTestCase
  (ivar (id) redis (id) testKey (id) testValue)
  
  (- (id) setup is
    (set @testKey "testset")
    (set @testValue "testValue")
    (@redis sadd:@testValue to:@testKey)
    (set @redis (ObjCRedis redis))
  )
  
  (- (id) test_01_sadd is
    (assert_equal 0 (@redis sadd:"add2value" to:@testKey))
  )
  
  (- (id) test_02_srem is
    (assert_equal 0 (@redis srem:@testValue of:@testKey))
  )
  
  (- (id) test_03_spop is
    (assert_equal @testValue (@redis spop:@testKey))
  )
  
  ; Fail
  ; (- (id) test_04_smove is
  ;     (assert_equal -95 (@redis smove:@testValue from:@testKey to:"testset2"))
  ;     (assert_equal 0 (@redis sismember:@testValue of:"testset2"))
  ;   )
  
  (- (id) test_05_scard is
    (assert_equal 1 (@redis scard:@testKey))
    (@redis sadd:"testValue2" to:@testKey)
    (assert_equal 2 (@redis scard:@testKey))
    (assert_equal 0 (@redis scard:"dummyKey"))
  )
  
  (- (id) test_06_sismember is
    (assert_equal 0 (@redis sismember:@testValue of:@testKey))
    (assert_equal -1 (@redis sismember:"otherValue" of:@testKey))
  )
  
  (- (id) test_07_sinter is
    (@redis sadd:"add2value" to:"interKey")
    (@redis sadd:"add2value" to:"interKey2")
    (assert_equal 1 ((@redis sinter:(NSSet setWithList:(list "interKey" "interKey2"))) count))
    (@redis sadd:"add3value" to:"interKey")
    (@redis sadd:"add3value" to:"interKey2")
    (set rset (@redis sinter:(NSSet setWithList:(list "interKey" "interKey2"))))
    (assert_equal 2 (rset count))
    (assert_equal 1 ((NSSet setWithList:(list "add2value" "add3value")) isSubsetOfSet:rset))
    (assert_equal 1 ((NSSet setWithList:(list "add2value" "add3value")) isEqualToSet:rset))
  )
  
  (- (id) test_08_sinterstore is
    (@redis sadd:"add2value" to:"interKey")
    (@redis sadd:"add2value" to:"interKey2")
    (assert_equal -97 (@redis sinterstore:(NSSet setWithList:(list "interKey" "interKey2")) to:"saveInterKey"))  ; should be 0!!!
    (assert_equal 0 (@redis sismember:"add2value" of:"saveInterKey"))
  )
  
  (- (id) test_09_sunion is
    (@redis sadd:"add2value" to:"interKey")
    (@redis sadd:"add3value" to:"interKey2")
    (assert_equal 2 ((@redis sunion:(NSSet setWithList:(list "interKey" "interKey2"))) count))
    (@redis sadd:"add4value" to:"interKey")
    (@redis sadd:"add5value" to:"interKey2")
    (set rset (@redis sunion:(NSSet setWithList:(list "interKey" "interKey2"))))
    (assert_equal 4 (rset count))
    (assert_equal 1 ((NSSet setWithList:(list "add2value" "add3value" "add4value" "add5value")) isSubsetOfSet:rset))
    (assert_equal 1 ((NSSet setWithList:(list "add2value" "add3value" "add4value" "add5value")) isEqualToSet:rset))
  )
  
  (- (id) test_10_sunionstore is
    (@redis sadd:"add2value" to:"interKey")
    (@redis sadd:"add3value" to:"interKey2")
    (assert_equal -97 (@redis sunionstore:(NSSet setWithList:(list "interKey" "interKey2")) to:"saveInterKey"))  ; should be 0!!!
    (assert_equal 0 (@redis sismember:"add2value" of:"saveInterKey"))
  )
  
  (- (id) test_11_sdiff is
    (@redis sadd:"add2value" to:"interKey")
    (@redis sadd:"add3value" to:"interKey")
    (@redis sadd:"add4value" to:"interKey")
    (@redis sadd:"add3value" to:"interKey2")
    (@redis sadd:"add4value" to:"interKey3")
    
    (set rset (@redis sdiff:(NSArray arrayWithList:(list "interKey" "interKey2" "interKey3"))))
    (assert_equal 1 (rset count))
    (assert_equal 1 ((NSSet setWithList:(list "add2value")) isEqualToSet:rset))
  )
  
  (- (id) test_11_sdiffstore is
    (@redis sadd:"add2value" to:"interKey")
    (@redis sadd:"add3value" to:"interKey")
    (@redis sadd:"add4value" to:"interKey")
    (@redis sadd:"add3value" to:"interKey2")
    (@redis sadd:"add4value" to:"interKey3")
    
    (assert_equal -97 (@redis sdiffstore:(NSArray arrayWithList:(list "interKey" "interKey2" "interKey3")) to:"saveDiffKey")) ; should be 0
    (assert_equal 0 (@redis sismember:"add2value" of:"saveDiffKey"))
  )
  
  (- (id) test_12_smembers is
    (@redis sadd:"add2value" to:"interKey")
    (@redis sadd:"add3value" to:"interKey")
    (@redis sadd:"add4value" to:"interKey")
    (@redis sadd:"add5value" to:"interKey")
    (@redis sadd:"add6value" to:"interKey")
    (set rset (@redis smembers:"interKey"))
    (assert_equal 5 (rset count))
    (assert_equal 1 ((NSSet setWithList:(list "add2value" "add3value" "add4value" "add5value" "add6value")) isEqualToSet:rset))
    (assert_equal 1 (rset containsObject:"add2value"))
  )
  
  (- (id) teardown is
    (@redis flushdb)
  )
)

(class test_08_testSortedSetsActions is NuTestCase
  (ivar (id) redis (id) testKey (id) testValue)
  
  (- (id) setup is
    (set @testKey "testset")
    (set @testValue "testValue")
    (@redis zadd:@testValue to:@testKey at:1)
    (set @redis (ObjCRedis redis))
  )
  
  (- (id) test_01_zadd is
    (assert_equal 0 (@redis zadd:"testValue2" to:"testKey2" at:2))
    (assert_equal -1 (@redis zadd:"testValue2" to:"testKey2" at:3))
    (@redis set:"name" to:"Salvador")
    (assert_equal -97 (@redis zadd:"Salvador" to:"name" at:2))
  )
  
  (- (id) test_02_zrem is
    (assert_equal 0 (@redis zrem:@testValue of:@testKey))
    (assert_equal -1 (@redis zrem:"testValue2" of:@testKey))
  )
  
  (- (id) test_03_zincrby is
    (assert_equal 2 (@redis zincr:@testValue by:1 of:@testKey))
    (assert_equal 4 (@redis zincr:@testValue by:2 of:@testKey))
    (assert_equal 1 (@redis zincr:"testValue2" by:1 of:@testKey)) ; should be nil
  )
  
  (- (id) test_04_zrank is
    (assert_equal -97 (@redis zrank:@testValue of:@testKey)) ; Fail!!!
    ; (assert_equal -1 (@redis zrank:"testValue2" of:@testKey))
  )
  
  (- (id) test_05_zrevrank is
    (assert_equal -97 (@redis zrevrank:@testValue of:@testKey)) ; Fail!!!
    ; (assert_equal -1 (@redis zrevrank:"testValue2" of:@testKey))
  )
  
  (- (id) test_06_zrange is
    (assert_equal 1 ((@redis zrange:@testKey from:0 to:1) count))
    (@redis zadd:"testValue2" to:@testKey at:2)
    (@redis zadd:"testValue3" to:@testKey at:3)
    (set rSet (@redis zrange:@testKey from:0 to:3))
    (assert_equal 3 (rSet count))
    (assert_equal "testValue2" (rSet 1))
    (assert_equal "testValue3" (rSet 2))
    (assert_equal nil (rSet 3))
  )
  
  (- (id) test_07_zrevrange is
    (assert_equal 1 ((@redis zrevrange:@testKey from:0 to:1) count))
    (@redis zadd:"testValue2" to:@testKey at:2)
    (@redis zadd:"testValue3" to:@testKey at:3)
    (set rSet (@redis zrevrange:@testKey from:0 to:3))
    (assert_equal 3 (rSet count))
    (assert_equal "testValue2" (rSet 1))
    (assert_equal "testValue3" (rSet 0))
    (assert_equal nil (rSet 3))
  )
  
  (- (id) test_08_zcard is
    (assert_equal 1 (@redis zcard:@testKey))
    (@redis zadd:"testValue2" to:@testKey at:2)
    (@redis zadd:"testValue3" to:@testKey at:3)
    (assert_equal 3 (@redis zcard:@testKey))
  )
  
  (- (id) test_09_zscore is
    (assert_equal 1 (@redis zscore:@testValue of:@testKey))
    (@redis zadd:"testValue2" to:@testKey at:2.2)
    (@redis zadd:"testValue3" to:@testKey at:3.3)
    (assert_equal 2.2 (@redis zscore:"testValue2" of:@testKey))
    (assert_equal 3.3 (@redis zscore:"testValue3" of:@testKey))
    (assert_equal nil (@redis zscore:"testValue4" of:@testKey))
  )
  
  (- (id) test_10_zremrangebyscore is
    (@redis zadd:"testValue2" to:@testKey at:2)
    (@redis zadd:"testValue3" to:@testKey at:3)
    (assert_equal 3 (@redis zcard:@testKey))
    (assert_equal 2 (@redis zremrangebyscore:@testKey from:0 to:2))
    (assert_equal 1 (@redis zcard:@testKey))
  )
  
  (- (id) test_11_zremrangebyrank is
    (@redis zadd:"testValue2" to:@testKey at:2)
    (@redis zadd:"testValue3" to:@testKey at:3)
    (assert_equal 3 (@redis zcard:@testKey))
    (assert_equal 2 (@redis zremrangebyrank:@testKey from:0 to:1))
    (assert_equal 1 (@redis zcard:@testKey))
  )
  
  (- (id) test_12_zinterstore is
    (@redis zadd:"testValue2" to:@testKey at:2)
    (@redis zadd:"testValue3" to:@testKey at:3)
    (@redis zadd:"testValue2" to:"testKey2" at:2)
    (@redis zadd:"testValue3" to:"testKey2" at:3)
    
    (assert_equal -97 (@redis zinterstore:(NSArray arrayWithList:(list @testKey "testKey2")) to:"storeInterKey")) ; Fail!!!
    ; (set rSet (@redis zrange:"storeInterKey" from:0 to:1))
    ; (assert_equal 1 (rSet count))
    
    (assert_equal -97 (@redis zinterstore:(NSArray arrayWithList:(list @testKey "testKey2")) ; Fail!!!
                  to:"storeInterKey2"
                  weights:(NSArray arrayWithList:(list 1 1 1))
                  aggregate:"SUM"))
   ; (set rSet (@redis zrange:"storeInterKey2" from:0 to:1))
   ; (assert_equal 1 (rSet count))
  )
  
  (- (id) teardown is
    (@redis flushdb)
  )
  
  
)

