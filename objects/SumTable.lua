function createSumTable(a, b, c)
    return {
        value = 0,
        sum = function(self)
            self.value = a + b + c
        end,
        add = function (self)
            self.value = self.value + 1
        end
    }
end