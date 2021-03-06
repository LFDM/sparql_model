require 'test/unit'
require 'benchmark'
require 'sparql_test'
require_relative '../lib/image'

class SparqlModelTest < Test::Unit::TestCase
  
  def test_create
    #-------------------------------------------------------------
    #  Empty the triplestore
    #-------------------------------------------------------------
    SparqlTest.empty()
    #-------------------------------------------------------------
    #  Create a new image instance
    #-------------------------------------------------------------
    img = Image.new
    img.create({ :path => 'check' })
    assert_equal( 'check', img.path )
  end
  
  def test_inst
    SparqlTest.empty()
    img = Image.new
    img.create({ :path => 'check' })
    img.inst(1)
    assert_equal( '<urn:sparql_model:image.1>', img.urn )
  end
  
  def test_inst_error
    SparqlTest.empty()
    img = Image.new
    img.create({ :path => 'check' })
    check = false
    begin
      img.inst(2)
    rescue
      check = true
    end
    assert_equal( true, check )
  end
  
  def test_new_get
    #-------------------------------------------------------------
    #  Empty the triplestore
    #-------------------------------------------------------------
    SparqlTest.empty()
    #-------------------------------------------------------------
    #  Create some image instances
    #-------------------------------------------------------------
    img = Image.new
    img.create({ :path => 'check' })
    img.create({ :path => 'dog' })
    #-------------------------------------------------------------
    #  Retrieve the instance with the right path
    #-------------------------------------------------------------
    img = Image.new( 'check' )
    assert_equal( 'check', img.path )
  end
  
  def test_multi_assignment_error
    #-------------------------------------------------------------
    #  Empty the triplestore
    #-------------------------------------------------------------
    SparqlTest.empty()
    #-------------------------------------------------------------
    #  Create a new image instance
    #-------------------------------------------------------------
    img = Image.new
    img.create({ :path => 'check' })
    check = false
    begin
      img.keywords = 'blah blah blah'
    rescue
      img.add( :keywords, 'blah blah blah' )
      check = true
    end
    assert_equal( true, check )
  end
  
  def test_fixnum
    SparqlTest.empty()
    img = Image.new
    img.create({ :path => 'check' })
    check = false
    begin
      img.x_resolution = "123"
    rescue
      img.x_resolution = 123
      check = img.x_resolution.class
    end
    assert_equal( ::Fixnum, check )
  end
  
  def test_unique
    SparqlTest.empty()
    img = Image.new
    img.create({ :path => 'test_unique' })
    check = false
    begin
      img.create({ :path => 'test_unique' })
    rescue
      check = true
    end
    assert_equal( true, check )
  end
  
  def test_add_single?
    SparqlTest.empty()
    img = Image.new
    img.create({ :path => 'test_add_single?--1' })
    img.create({ :path => 'test_add_single?--2' })
    check = false
    begin
      img.add( :path, 'test_add_single?--1' )
    rescue
      check = true
    end
    assert_equal( true, check )
  end
  
  def test_thousand_creates
    SparqlTest.empty()
    img = Image.new
    time = Benchmark.measure do
      (1..1000).each do |i|
        img.create({ :path => 'path'+i.to_s })
      end
    end
    puts time
  end
  
end