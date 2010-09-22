(load "ObjCRedis")

; Pre-init Reality check
(class Test_01_Reality is NuTestCase
  
  (imethod (id) testArray is
    (set a (NSMutableArray arrayWithList:'( 1 2)))
    (a << "three")
    (assert_equal 3 (a count))
    (assert_equal 2 (a 1))
    (assert_equal "three" (a 2))
  )
  
)

; Init Test
(class Test_02_Init is NuTestCase
  
  (imethod (id) testInitRedis is
    (set o (ObjCRedis redis))
    (assert_true (eq (o class) (ObjCRedis class)))
    ; not testing?
    (assert_false (eq o nil))
  )
  
)

(class Test_03_BasicActions is NuTestCase
  (ivar (id) redis)
  
  (imethod (id) setup is
    (set @redis (ObjCRedis redis))
  )
  
  (imethod (id) test_01_Set is
    (set success (@redis set:"name" to:"Salvador"))
    (assert_equal 0 success)
  )
  
  (imethod (id) test_02_Get is
    (assert_equal "Salvador" (@redis get:"name"))
  )
  
  (imethod (id) test_03_Exists is
    (assert_equal 0 (@redis exists:"name"))
  )
  
  (imethod (id) test_04_Del is
    (assert_equal 0 (@redis del:"name"))
    (assert_equal -1 (@redis del:"name"))
  )
  
)

(class Test_04_TestGeneralActions is NuTestCase
  (ivar (id) redis (id) testKey (id) testValue)
  
  (imethod (id) setup is
    (set @testKey "testKey")
    (set @testValue "testValue")
    
    (set @redis (ObjCRedis redis))
    (@redis set:@testKey to:@testValue)
  )
  
  (imethod (id) testExists is
    (assert_equal 0 (@redis exists:@testKey))
  )
  
  (imethod (id) testType is
    (assert_equal 2 (@redis type:@testKey))
  )
  
  (imethod (id) testRename is
    (set newKey "newKey")
    (assert_equal 0 (@redis rename:@testKey to:newKey))
    (assert_equal -1 (@redis exists:@testKey))
    (assert_equal 0 (@redis exists:newKey))
    (assert_equal 0 (@redis rename:newKey to:@testKey))
  )
  
  (imethod (id) testRenamenx is
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
  
  (imethod (id) testDBSize is
    (assert_true (> (@redis dbsize) 0))
  )
  
  (imethod (id) testExpire is
    (assert_equal -1 (@redis ttl:@testKey))
    (assert_equal 0 (@redis expire:@testKey in:10))
    (assert_equal 10 (@redis ttl:@testKey))
    (assert_equal -1 (@redis expire:"dummyKey" in:10))
  )
  
  (imethod (id) testSelect is
    (assert_equal 0 (@redis select:1))
    (assert_equal -1 (@redis exists:@testKey))
    (assert_equal 0 (@redis select:0))
    (assert_equal 0 (@redis exists:@testKey))
  )
  
  (imethod (id) testMove is
    (assert_equal 0 (@redis move:@testKey to:1))
    (assert_equal -1 (@redis exists:@testKey))
    (assert_equal 0 (@redis select:1))
    (assert_equal 0 (@redis exists:@testKey))
    (assert_equal 0 (@redis move:@testKey to:0))
    (assert_equal 0 (@redis select:0))
    (assert_equal 0 (@redis exists:@testKey))
  )
  
  (imethod (id) testFlushDB is
    (assert_equal 0 (@redis flushdb))
    (assert_equal 0 (@redis dbsize))
  )
  
  (imethod (id) teardown is
    (@redis del:@testKey)
  )
)


