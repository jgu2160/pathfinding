gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require_relative '../lib/landscape'
require_relative '../lib/pathfinder'

describe Pathfinder do
  before do
    @landscape  = Landscape.load(File.join(__dir__, "fixtures", "landscape1.txt"))
    @landscape2 = Landscape.load(File.join(__dir__, "fixtures", "landscape2.txt"))
    @easy = Landscape.load(File.join(__dir__, "fixtures", "easy.txt"))
  end

  it 'knows how to enqueue neighbors position' do
    pathfinder = Pathfinder.new(@easy)
    assert_equal [[1,2],[2,1]], pathfinder.enqueue([1,1])
  end

  it 'knows how to find the start' do
    pathfinder = Pathfinder.new(@easy)
    assert_equal [1,1], pathfinder.start
  end

  it 'knows how to find the finish' do
    pathfinder = Pathfinder.new(@easy)
    assert_equal [2,2], pathfinder.finish
  end

  it 'tracks the origin of a cell' do
    pathfinder = Pathfinder.new(@easy)
    pathfinder.enqueue([1,1])
    origin_hash = { [1,2] => [1,1], [2,1] => [1,1] }
    assert_equal origin_hash, pathfinder.origin_hash
  end

  it 'can solve a super easy grid' do
    pathfinder = Pathfinder.new(@easy)
    assert_equal [[1, 1], [1, 2], [2, 2]], pathfinder.solve
  end

  describe "#solve" do
    it "returns a path as an array of coordinates" do
      solution = [[3,1],[4,1],[5,1],[6,1],[7,1],[8,1],[9,1],
                  [9,2],[9,3],[9,4],[9,5],[8,5],[7,5],[7,6],
                  [7,7],[7,8],[7,9]].length + 2
      pathfinder = Pathfinder.new(@landscape)
      pathfinder.solve
      assert_equal solution, pathfinder.solution_length
    end

    it "Solves with grass" do
      solution = [[3,4],[3,5],[4,5],[5,5],[6,5],[7,5],[8,5],
                  [9,5],[10,5],[11,5],[12,5],[13,5],[14,5],
                  [15,5],[16,5],[16,4]].length + 2
      pathfinder = Pathfinder.new(@landscape2)
      pathfinder.solve
      assert_equal solution, pathfinder.solution_length
    end
  end
end

