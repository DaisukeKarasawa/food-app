module DateConverter
    include RemainDay

    def changeToDate(deadline)
        return nil unless deadline.to_s.length == 6
        
        year = deadline / 10000
        month = (deadline % 10000) / 100
        day = deadline % 100
        return "#{year}/#{month}/#{day}", remainDay(year, month, day)
    end
end
