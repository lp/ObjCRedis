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


