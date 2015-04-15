class Pathfinder
  attr_accessor :matrix, :start, :origin_hash, :searched_coords, :finish, :solution_length
  def initialize(landscape)
    @matrix = landscape.matrix
    find_start
    find_finish
    @origin_hash = {}
    @searched_coords = []
    @searched_coords << start
  end

  def solve
    until finish_found?
      searched_coords.each { |coord| enqueue(coord) }
    end

    target_key = finish
    solution_path = []
    solution_path.unshift(finish)

    until target_key == start
      target_key = origin_hash[target_key]
      solution_path.unshift(target_key)
    end
    @solution_length = solution_path.length
    solution_path
  end

  def finish_found?
    searched_coords.include?(finish)
  end

  def find_start
    @matrix.each_with_index do |y_row, iy|
      y_row.each_with_index do |x_entry, ix|
        if x_entry == "S"
          @start = [ix, iy]
        end
      end
    end
  end

  def find_finish
    @matrix.each_with_index do |y_row, iy|
      y_row.each_with_index do |x_entry, ix|
        if x_entry == "F"
          @finish = [ix, iy]
        end
      end
    end
  end

  def enqueue(coords)
    x = coords[0]
    y = coords[1]
    surrounding = find_surrounding(x,y)
    neighbors = find_neighbors(surrounding)
    originize_neighbors(neighbors, coords)
    self.searched_coords = origin_hash.keys + origin_hash.values.uniq
    neighbors
  end

  def find_surrounding(x,y)
    xs = [x - 1, x, x + 1]
    ys = [y - 1, y, y + 1]
    surrounding = xs.map { |num| [num, num, num]}
      .flat_map { |array| array.zip(ys) }
    [8,6,4,2,0].each do |num|
      surrounding.delete_at(num)
    end
    surrounding
  end

  def find_neighbors(surrounding)
    neighbors = surrounding.map do |neighbor_coords|
      neighbor_coords if [" ", "F"].include?(matrix[neighbor_coords[1]][neighbor_coords[0]]) && !searched_coords.include?(neighbor_coords)
    end
    neighbors.delete(nil)
    neighbors
  end

  def originize_neighbors(neighbors, coords)
    neighbors.each { |n| @origin_hash[n] = coords }
  end
end
