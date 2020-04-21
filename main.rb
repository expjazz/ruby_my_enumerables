module Enumerable
  # rubocop:disable Metrics/PerceivedComplexity

  def my_each
    if block_given?
      (0...size).each do |i|
        yield(self[i])
      end
      return self
    end
    to_enum
  end

  def my_each_with_index
    if block_given?
      (0...size).each do |i|
        yield(self[i], i)
      end
      return self
    end
    to_enum
  end

  def my_select
    return to_enum if block_given? == false

    arr = []
    my_each { |x| arr << x if yield(x) == true }
    arr
  end

  def my_all?
    return to_enum unless block_given?

    my_each { |x| return false if yield(x) == false }
    true
  end

  def my_any?(&prc)
    return to_enum unless block_given?

    my_each { |x| return true if prc.call(x) }
    false
  end

  def my_none?
    return to_enum if block_given? == false

    my_each { |x| return false if yield(x) == true }
    true
  end

  def my_count(&prc)
    return to_enum unless block_given?

    count = 0
    my_each { |x| count += 1 if prc.call(x) == true }
    count
  end

  def my_map(prc = nil)
    arr = []
    if block_given? && prc.nil?
      my_each { |x| arr << yield(x) }
    else
      my_each { |x| arr << prc.call(x) }
    end
    arr
  end

  def my_inject(num_1 = nil, &prc)
    return to_enum unless block_given?

    if num_1.nil?
      my_each_with_index do |_ele, ind|
        self[0] = prc.call(self[0], self[ind + 1]) if ind < size - 1
      end
    else
      my_each_with_index do |_ele, ind|
        if ind.zero?
          self[0] = prc.call(num_1, self[0])
        elsif ind.positive?
          self[0] = prc.call(self[0], self[ind])
        end
      end
    end
    self[0]
  end
end

# rubocop:enable Metrics/PerceivedComplexity
def multiply_els(array)
  array.my_inject { |acc, x| acc * x }
end
