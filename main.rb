module Enumerable
    def my_each
        for i in 0...self.size
            yield(self[i])
        end
    self
    end

    def my_each_with_index
        for i in 0...self.size
            yield(self[i], i)
        end
        self
    end
    def my_select
        arr = []
        self.my_each{|x| arr << x if yield(x) == true}
        arr
    end
    def my_all?
        self.my_each{|x| return false if yield(x) == false}
        return true
    end
end

a = [2, 4, 6, 8, 9].my_all?{|x| x.even?}

p a