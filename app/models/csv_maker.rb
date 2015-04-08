module CSVMaker
  def gen_csv(subset, column_methods)
  	CSV.generate do |csv|
      columns = column_methods.map{|m| m.to_s.humanize.capitalize}
      csv << columns

      subset.each do |item|
        row = column_methods.map{|m| item.send(m)}
        csv << row
      end
    end
  end
end

