module RemainDay
    def remainDay(year, month, day)
        year = year < 100 ? year + 2000 : year
        yearNow, monthNow, dayNow = Time.now.strftime("%Y-%m-%d").split("-").map(&:to_i)
        limit = (Date.new(year, month, day) - Date.new(yearNow, monthNow, dayNow)).to_i
        limit >= 0 ? limit : nil
    end
end