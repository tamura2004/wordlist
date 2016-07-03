class Word < ActiveRecord::Base
  def self.upload(file,user)
    x = Roo::Excelx.new(file.path.to_s)

    x.each_row_streaming do |row|
      name,desc = *row
      Word.create(name:name, desc:desc, user:user, removed:false)
    end
  end

end
