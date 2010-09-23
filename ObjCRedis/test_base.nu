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
  
  ; todo mget
  
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


